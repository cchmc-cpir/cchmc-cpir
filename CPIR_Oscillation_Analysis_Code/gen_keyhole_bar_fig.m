function BarFig = gen_keyhole_bar_fig(MeanBinMap,Binned_RBC,Binned_Bar)

%RBC:
RBC_bin1_osc_bins = (MeanBinMap(Binned_RBC==1));
RBC_bin2_osc_bins = (MeanBinMap(Binned_RBC==2));
RBC_bin3_osc_bins = (MeanBinMap(Binned_RBC==3));
RBC_bin4_osc_bins = (MeanBinMap(Binned_RBC==4));
RBC_bin5_osc_bins = (MeanBinMap(Binned_RBC==5));
RBC_bin6_osc_bins = (MeanBinMap(Binned_RBC==6));
%Barrier
Bar_bin1_osc_bins = (MeanBinMap(Binned_Bar==1));
Bar_bin2_osc_bins = (MeanBinMap(Binned_Bar==2));
Bar_bin3_osc_bins = (MeanBinMap(Binned_Bar==3));
Bar_bin4_osc_bins = (MeanBinMap(Binned_Bar==4));
Bar_bin5_osc_bins = (MeanBinMap(Binned_Bar==5));
Bar_bin6_osc_bins = (MeanBinMap(Binned_Bar==6));
Bar_bin7_osc_bins = (MeanBinMap(Binned_Bar==7));
Bar_bin8_osc_bins = (MeanBinMap(Binned_Bar==8));

RBC_1_Osc1 = nnz(RBC_bin1_osc_bins==1);
RBC_1_Osc2 = nnz(RBC_bin1_osc_bins==2);
RBC_1_Osc3 = nnz(RBC_bin1_osc_bins==3);
RBC_1_Osc4 = nnz(RBC_bin1_osc_bins==4);
RBC_1_Osc5 = nnz(RBC_bin1_osc_bins==5);
RBC_1_Osc6 = nnz(RBC_bin1_osc_bins==6);
RBC_1_Osc7 = nnz(RBC_bin1_osc_bins==7);
RBC_1_Osc8 = nnz(RBC_bin1_osc_bins==8);
RBC_1_Osc9 = nnz(RBC_bin1_osc_bins==9);

RBC_2_Osc1 = nnz(RBC_bin2_osc_bins==1);
RBC_2_Osc2 = nnz(RBC_bin2_osc_bins==2);
RBC_2_Osc3 = nnz(RBC_bin2_osc_bins==3);
RBC_2_Osc4 = nnz(RBC_bin2_osc_bins==4);
RBC_2_Osc5 = nnz(RBC_bin2_osc_bins==5);
RBC_2_Osc6 = nnz(RBC_bin2_osc_bins==6);
RBC_2_Osc7 = nnz(RBC_bin2_osc_bins==7);
RBC_2_Osc8 = nnz(RBC_bin2_osc_bins==8);
RBC_2_Osc9 = nnz(RBC_bin2_osc_bins==9);

RBC_3_Osc1 = nnz(RBC_bin3_osc_bins==1);
RBC_3_Osc2 = nnz(RBC_bin3_osc_bins==2);
RBC_3_Osc3 = nnz(RBC_bin3_osc_bins==3);
RBC_3_Osc4 = nnz(RBC_bin3_osc_bins==4);
RBC_3_Osc5 = nnz(RBC_bin3_osc_bins==5);
RBC_3_Osc6 = nnz(RBC_bin3_osc_bins==6);
RBC_3_Osc7 = nnz(RBC_bin3_osc_bins==7);
RBC_3_Osc8 = nnz(RBC_bin3_osc_bins==8);
RBC_3_Osc9 = nnz(RBC_bin3_osc_bins==9);

RBC_4_Osc1 = nnz(RBC_bin4_osc_bins==1);
RBC_4_Osc2 = nnz(RBC_bin4_osc_bins==2);
RBC_4_Osc3 = nnz(RBC_bin4_osc_bins==3);
RBC_4_Osc4 = nnz(RBC_bin4_osc_bins==4);
RBC_4_Osc5 = nnz(RBC_bin4_osc_bins==5);
RBC_4_Osc6 = nnz(RBC_bin4_osc_bins==6);
RBC_4_Osc7 = nnz(RBC_bin4_osc_bins==7);
RBC_4_Osc8 = nnz(RBC_bin4_osc_bins==8);
RBC_4_Osc9 = nnz(RBC_bin4_osc_bins==9);

RBC_5_Osc1 = nnz(RBC_bin5_osc_bins==1);
RBC_5_Osc2 = nnz(RBC_bin5_osc_bins==2);
RBC_5_Osc3 = nnz(RBC_bin5_osc_bins==3);
RBC_5_Osc4 = nnz(RBC_bin5_osc_bins==4);
RBC_5_Osc5 = nnz(RBC_bin5_osc_bins==5);
RBC_5_Osc6 = nnz(RBC_bin5_osc_bins==6);
RBC_5_Osc7 = nnz(RBC_bin5_osc_bins==7);
RBC_5_Osc8 = nnz(RBC_bin5_osc_bins==8);
RBC_5_Osc9 = nnz(RBC_bin5_osc_bins==9);

RBC_6_Osc1 = nnz(RBC_bin6_osc_bins==1);
RBC_6_Osc2 = nnz(RBC_bin6_osc_bins==2);
RBC_6_Osc3 = nnz(RBC_bin6_osc_bins==3);
RBC_6_Osc4 = nnz(RBC_bin6_osc_bins==4);
RBC_6_Osc5 = nnz(RBC_bin6_osc_bins==5);
RBC_6_Osc6 = nnz(RBC_bin6_osc_bins==6);
RBC_6_Osc7 = nnz(RBC_bin6_osc_bins==7);
RBC_6_Osc8 = nnz(RBC_bin6_osc_bins==8);
RBC_6_Osc9 = nnz(RBC_bin6_osc_bins==9);

Bar_1_Osc1 = nnz(Bar_bin1_osc_bins==1);
Bar_1_Osc2 = nnz(Bar_bin1_osc_bins==2);
Bar_1_Osc3 = nnz(Bar_bin1_osc_bins==3);
Bar_1_Osc4 = nnz(Bar_bin1_osc_bins==4);
Bar_1_Osc5 = nnz(Bar_bin1_osc_bins==5);
Bar_1_Osc6 = nnz(Bar_bin1_osc_bins==6);
Bar_1_Osc7 = nnz(Bar_bin1_osc_bins==7);
Bar_1_Osc8 = nnz(Bar_bin1_osc_bins==8);
Bar_1_Osc9 = nnz(Bar_bin1_osc_bins==9);

Bar_2_Osc1 = nnz(Bar_bin2_osc_bins==1);
Bar_2_Osc2 = nnz(Bar_bin2_osc_bins==2);
Bar_2_Osc3 = nnz(Bar_bin2_osc_bins==3);
Bar_2_Osc4 = nnz(Bar_bin2_osc_bins==4);
Bar_2_Osc5 = nnz(Bar_bin2_osc_bins==5);
Bar_2_Osc6 = nnz(Bar_bin2_osc_bins==6);
Bar_2_Osc7 = nnz(Bar_bin2_osc_bins==7);
Bar_2_Osc8 = nnz(Bar_bin2_osc_bins==8);
Bar_2_Osc9 = nnz(Bar_bin2_osc_bins==9);

Bar_3_Osc1 = nnz(Bar_bin3_osc_bins==1);
Bar_3_Osc2 = nnz(Bar_bin3_osc_bins==2);
Bar_3_Osc3 = nnz(Bar_bin3_osc_bins==3);
Bar_3_Osc4 = nnz(Bar_bin3_osc_bins==4);
Bar_3_Osc5 = nnz(Bar_bin3_osc_bins==5);
Bar_3_Osc6 = nnz(Bar_bin3_osc_bins==6);
Bar_3_Osc7 = nnz(Bar_bin3_osc_bins==7);
Bar_3_Osc8 = nnz(Bar_bin3_osc_bins==8);
Bar_3_Osc9 = nnz(Bar_bin3_osc_bins==9);

Bar_4_Osc1 = nnz(Bar_bin4_osc_bins==1);
Bar_4_Osc2 = nnz(Bar_bin4_osc_bins==2);
Bar_4_Osc3 = nnz(Bar_bin4_osc_bins==3);
Bar_4_Osc4 = nnz(Bar_bin4_osc_bins==4);
Bar_4_Osc5 = nnz(Bar_bin4_osc_bins==5);
Bar_4_Osc6 = nnz(Bar_bin4_osc_bins==6);
Bar_4_Osc7 = nnz(Bar_bin4_osc_bins==7);
Bar_4_Osc8 = nnz(Bar_bin4_osc_bins==8);
Bar_4_Osc9 = nnz(Bar_bin4_osc_bins==9);

Bar_5_Osc1 = nnz(Bar_bin5_osc_bins==1);
Bar_5_Osc2 = nnz(Bar_bin5_osc_bins==2);
Bar_5_Osc3 = nnz(Bar_bin5_osc_bins==3);
Bar_5_Osc4 = nnz(Bar_bin5_osc_bins==4);
Bar_5_Osc5 = nnz(Bar_bin5_osc_bins==5);
Bar_5_Osc6 = nnz(Bar_bin5_osc_bins==6);
Bar_5_Osc7 = nnz(Bar_bin5_osc_bins==7);
Bar_5_Osc8 = nnz(Bar_bin5_osc_bins==8);
Bar_5_Osc9 = nnz(Bar_bin5_osc_bins==9);

Bar_6_Osc1 = nnz(Bar_bin6_osc_bins==1);
Bar_6_Osc2 = nnz(Bar_bin6_osc_bins==2);
Bar_6_Osc3 = nnz(Bar_bin6_osc_bins==3);
Bar_6_Osc4 = nnz(Bar_bin6_osc_bins==4);
Bar_6_Osc5 = nnz(Bar_bin6_osc_bins==5);
Bar_6_Osc6 = nnz(Bar_bin6_osc_bins==6);
Bar_6_Osc7 = nnz(Bar_bin6_osc_bins==7);
Bar_6_Osc8 = nnz(Bar_bin6_osc_bins==8);
Bar_6_Osc9 = nnz(Bar_bin6_osc_bins==9);

Bar_7_Osc1 = nnz(Bar_bin7_osc_bins==1);
Bar_7_Osc2 = nnz(Bar_bin7_osc_bins==2);
Bar_7_Osc3 = nnz(Bar_bin7_osc_bins==3);
Bar_7_Osc4 = nnz(Bar_bin7_osc_bins==4);
Bar_7_Osc5 = nnz(Bar_bin7_osc_bins==5);
Bar_7_Osc6 = nnz(Bar_bin7_osc_bins==6);
Bar_7_Osc7 = nnz(Bar_bin7_osc_bins==7);
Bar_7_Osc8 = nnz(Bar_bin7_osc_bins==8);
Bar_7_Osc9 = nnz(Bar_bin7_osc_bins==9);

Bar_8_Osc1 = nnz(Bar_bin8_osc_bins==1);
Bar_8_Osc2 = nnz(Bar_bin8_osc_bins==2);
Bar_8_Osc3 = nnz(Bar_bin8_osc_bins==3);
Bar_8_Osc4 = nnz(Bar_bin8_osc_bins==4);
Bar_8_Osc5 = nnz(Bar_bin8_osc_bins==5);
Bar_8_Osc6 = nnz(Bar_bin8_osc_bins==6);
Bar_8_Osc7 = nnz(Bar_bin8_osc_bins==7);
Bar_8_Osc8 = nnz(Bar_bin8_osc_bins==8);
Bar_8_Osc9 = nnz(Bar_bin8_osc_bins==9);

RBC_1_Osc = [RBC_1_Osc1 RBC_1_Osc2 RBC_1_Osc3 RBC_1_Osc4 RBC_1_Osc5 RBC_1_Osc6 RBC_1_Osc7 RBC_1_Osc8 RBC_1_Osc9];
RBC_2_Osc = [RBC_2_Osc1 RBC_2_Osc2 RBC_2_Osc3 RBC_2_Osc4 RBC_2_Osc5 RBC_2_Osc6 RBC_2_Osc7 RBC_2_Osc8 RBC_2_Osc9];
RBC_3_Osc = [RBC_3_Osc1 RBC_3_Osc2 RBC_3_Osc3 RBC_3_Osc4 RBC_3_Osc5 RBC_3_Osc6 RBC_3_Osc7 RBC_3_Osc8 RBC_3_Osc9];
RBC_4_Osc = [RBC_4_Osc1 RBC_4_Osc2 RBC_4_Osc3 RBC_4_Osc4 RBC_4_Osc5 RBC_4_Osc6 RBC_4_Osc7 RBC_4_Osc8 RBC_4_Osc9];
RBC_5_Osc = [RBC_5_Osc1 RBC_5_Osc2 RBC_5_Osc3 RBC_5_Osc4 RBC_5_Osc5 RBC_5_Osc6 RBC_5_Osc7 RBC_5_Osc8 RBC_5_Osc9];
RBC_6_Osc = [RBC_6_Osc1 RBC_6_Osc2 RBC_6_Osc3 RBC_6_Osc4 RBC_6_Osc5 RBC_6_Osc6 RBC_6_Osc7 RBC_6_Osc8 RBC_6_Osc9];

Bar_1_Osc = [Bar_1_Osc1 Bar_1_Osc2 Bar_1_Osc3 Bar_1_Osc4 Bar_1_Osc5 Bar_1_Osc6 Bar_1_Osc7 Bar_1_Osc8 Bar_1_Osc9];
Bar_2_Osc = [Bar_2_Osc1 Bar_2_Osc2 Bar_2_Osc3 Bar_2_Osc4 Bar_2_Osc5 Bar_2_Osc6 Bar_2_Osc7 Bar_2_Osc8 Bar_2_Osc9];
Bar_3_Osc = [Bar_3_Osc1 Bar_3_Osc2 Bar_3_Osc3 Bar_3_Osc4 Bar_3_Osc5 Bar_3_Osc6 Bar_3_Osc7 Bar_3_Osc8 Bar_3_Osc9];
Bar_4_Osc = [Bar_4_Osc1 Bar_4_Osc2 Bar_4_Osc3 Bar_4_Osc4 Bar_4_Osc5 Bar_4_Osc6 Bar_4_Osc7 Bar_4_Osc8 Bar_4_Osc9];
Bar_5_Osc = [Bar_5_Osc1 Bar_5_Osc2 Bar_5_Osc3 Bar_5_Osc4 Bar_5_Osc5 Bar_5_Osc6 Bar_5_Osc7 Bar_5_Osc8 Bar_5_Osc9];
Bar_6_Osc = [Bar_6_Osc1 Bar_6_Osc2 Bar_6_Osc3 Bar_6_Osc4 Bar_6_Osc5 Bar_6_Osc6 Bar_6_Osc7 Bar_6_Osc8 Bar_6_Osc9];
Bar_7_Osc = [Bar_7_Osc1 Bar_7_Osc2 Bar_7_Osc3 Bar_7_Osc4 Bar_7_Osc5 Bar_7_Osc6 Bar_7_Osc7 Bar_7_Osc8 Bar_7_Osc9];
Bar_8_Osc = [Bar_8_Osc1 Bar_8_Osc2 Bar_8_Osc3 Bar_8_Osc4 Bar_8_Osc5 Bar_8_Osc6 Bar_8_Osc7 Bar_8_Osc8 Bar_8_Osc9];

RBC_BarPlot = [RBC_1_Osc;RBC_2_Osc;RBC_3_Osc;RBC_4_Osc;RBC_5_Osc;RBC_6_Osc];
RBC_BarPlot_Norm = [RBC_1_Osc/sum(RBC_1_Osc);RBC_2_Osc/sum(RBC_2_Osc);RBC_3_Osc/sum(RBC_3_Osc);RBC_4_Osc/sum(RBC_4_Osc);RBC_5_Osc/sum(RBC_5_Osc);RBC_6_Osc/sum(RBC_6_Osc)]*100;

Bar_BarPlot = [Bar_1_Osc;Bar_2_Osc;Bar_3_Osc;Bar_4_Osc;Bar_5_Osc;Bar_6_Osc;Bar_7_Osc;Bar_8_Osc];
Bar_BarPlot_Norm = [Bar_1_Osc/sum(Bar_1_Osc);Bar_2_Osc/sum(Bar_2_Osc);Bar_3_Osc/sum(Bar_3_Osc);Bar_4_Osc/sum(Bar_4_Osc);Bar_5_Osc/sum(Bar_5_Osc);Bar_6_Osc/sum(Bar_6_Osc);Bar_7_Osc/sum(Bar_7_Osc);Bar_8_Osc/sum(Bar_8_Osc)]*100;

BarFig = figure('Name','Bar Plots Showing Percentage Oscillation in each RBC and Barrier Bin');
subplot(2,2,1)
RBC_BarPlot_Plot = bar(RBC_BarPlot);
RBC_BarPlot_Plot(1).FaceColor = [1 0 0];
RBC_BarPlot_Plot(2).FaceColor = [1 0.7143 0];
RBC_BarPlot_Plot(3).FaceColor = [0.4 0.7 0.4];
RBC_BarPlot_Plot(4).FaceColor = [0 1 0];
RBC_BarPlot_Plot(5).FaceColor = [184/255 226/255 145/255];
RBC_BarPlot_Plot(6).FaceColor = [243/255 205/255 213/255];
RBC_BarPlot_Plot(7).FaceColor = [225/255 129/255 162/255];
RBC_BarPlot_Plot(8).FaceColor = [197/255 27/255 125/255];
RBC_BarPlot_Plot(9).FaceColor = [1 1 1];
title('Oscillation Make-up of each RBC bin')

subplot(2,2,2)
Bar_BarPlot_Plot = bar(Bar_BarPlot);
Bar_BarPlot_Plot(1).FaceColor = [1 0 0];
Bar_BarPlot_Plot(2).FaceColor = [1 0.7143 0];
Bar_BarPlot_Plot(3).FaceColor = [0.4 0.7 0.4];
Bar_BarPlot_Plot(4).FaceColor = [0 1 0];
Bar_BarPlot_Plot(5).FaceColor = [184/255 226/255 145/255];
Bar_BarPlot_Plot(6).FaceColor = [243/255 205/255 213/255];
Bar_BarPlot_Plot(7).FaceColor = [225/255 129/255 162/255];
Bar_BarPlot_Plot(8).FaceColor = [197/255 27/255 125/255];
Bar_BarPlot_Plot(9).FaceColor = [1 1 1];
title('Oscillation Make-up of each Barrier bin')

subplot(2,2,3)
RBC_BarPlot_Plot_Norm = bar(RBC_BarPlot_Norm);
RBC_BarPlot_Plot_Norm(1).FaceColor = [1 0 0];
RBC_BarPlot_Plot_Norm(2).FaceColor = [1 0.7143 0];
RBC_BarPlot_Plot_Norm(3).FaceColor = [0.4 0.7 0.4];
RBC_BarPlot_Plot_Norm(4).FaceColor = [0 1 0];
RBC_BarPlot_Plot_Norm(5).FaceColor = [184/255 226/255 145/255];
RBC_BarPlot_Plot_Norm(6).FaceColor = [243/255 205/255 213/255];
RBC_BarPlot_Plot_Norm(7).FaceColor = [225/255 129/255 162/255];
RBC_BarPlot_Plot_Norm(8).FaceColor = [197/255 27/255 125/255];
RBC_BarPlot_Plot_Norm(9).FaceColor = [1 1 1];
title('Oscillation Make-up of each RBC bin (Normalized)')

subplot(2,2,4)
Bar_BarPlot_Plot_Norm = bar(Bar_BarPlot_Norm);
Bar_BarPlot_Plot_Norm(1).FaceColor = [1 0 0];
Bar_BarPlot_Plot_Norm(2).FaceColor = [1 0.7143 0];
Bar_BarPlot_Plot_Norm(3).FaceColor = [0.4 0.7 0.4];
Bar_BarPlot_Plot_Norm(4).FaceColor = [0 1 0];
Bar_BarPlot_Plot_Norm(5).FaceColor = [184/255 226/255 145/255];
Bar_BarPlot_Plot_Norm(6).FaceColor = [243/255 205/255 213/255];
Bar_BarPlot_Plot_Norm(7).FaceColor = [225/255 129/255 162/255];
Bar_BarPlot_Plot_Norm(8).FaceColor = [197/255 27/255 125/255];
Bar_BarPlot_Plot_Norm(9).FaceColor = [1 1 1];
title('Oscillation Make-up of each Barrier bin (Normalized)')
set(BarFig,'color','white','Units','inches','Position',[0.25 0.25 12 7])
