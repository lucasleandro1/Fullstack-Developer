require "rails_helper"

RSpec.describe "Admin::DashboardController", type: :request do
  let(:admin) { create(:user, :admin) }
  let(:user)  { create(:user) }

  before do
    sign_in admin
  end

  describe "GET /admin/dashboard" do
    context "when service returns success" do
      let(:service_result) do
        double(
          success?: true,
          data: {
            users: { total: 5, recent: [] },
            imports: { total: 10 },
            activity: { logins: 20 },
            growth: { weekly: 3 }
          }
        )
      end

      before do
        allow(DashboardStatsService).to receive(:call).and_return(service_result)
      end

      it "returns http success" do
        get admin_dashboard_path
        expect(response).to have_http_status(:success)
      end

      it "assigns dashboard instance variables" do
        get admin_dashboard_path

        expect(assigns(:user_stats)).to eq(service_result.data[:users])
        expect(assigns(:import_stats)).to eq(service_result.data[:imports])
        expect(assigns(:activity_stats)).to eq(service_result.data[:activity])
        expect(assigns(:growth_stats)).to eq(service_result.data[:growth])
        expect(assigns(:recent_users)).to eq(service_result.data[:users][:recent])
      end
    end

    context "when service returns error" do
      let(:error_result) do
        double(success?: false, error_messages: [ "Something went wrong" ])
      end

      before do
        allow(DashboardStatsService).to receive(:call).and_return(error_result)
      end

      it "redirects to root with an alert" do
        get admin_dashboard_path
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq("Something went wrong")
      end
    end
  end

  context "when not admin" do
    before do
      sign_out admin
      sign_in user
    end

    it "redirects to root" do
      get admin_dashboard_path
      expect(response).to redirect_to(root_path)
    end
  end
end
