// Generated by using Rcpp::compileAttributes() -> do not edit by hand
// Generator token: 10BE3573-1514-4C36-9D1C-5A225CD40393

#include <Rcpp.h>

using namespace Rcpp;

// toUnitScale
double toUnitScale(double x, double min, double max);
RcppExport SEXP zikaProj_toUnitScale(SEXP xSEXP, SEXP minSEXP, SEXP maxSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< double >::type x(xSEXP);
    Rcpp::traits::input_parameter< double >::type min(minSEXP);
    Rcpp::traits::input_parameter< double >::type max(maxSEXP);
    rcpp_result_gen = Rcpp::wrap(toUnitScale(x, min, max));
    return rcpp_result_gen;
END_RCPP
}
// fromUnitScale
double fromUnitScale(double x, double min, double max);
RcppExport SEXP zikaProj_fromUnitScale(SEXP xSEXP, SEXP minSEXP, SEXP maxSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< double >::type x(xSEXP);
    Rcpp::traits::input_parameter< double >::type min(minSEXP);
    Rcpp::traits::input_parameter< double >::type max(maxSEXP);
    rcpp_result_gen = Rcpp::wrap(fromUnitScale(x, min, max));
    return rcpp_result_gen;
END_RCPP
}
// generate_foi
NumericVector generate_foi(NumericVector IM, double NH, double b, double pMH, double tstep);
RcppExport SEXP zikaProj_generate_foi(SEXP IMSEXP, SEXP NHSEXP, SEXP bSEXP, SEXP pMHSEXP, SEXP tstepSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< NumericVector >::type IM(IMSEXP);
    Rcpp::traits::input_parameter< double >::type NH(NHSEXP);
    Rcpp::traits::input_parameter< double >::type b(bSEXP);
    Rcpp::traits::input_parameter< double >::type pMH(pMHSEXP);
    Rcpp::traits::input_parameter< double >::type tstep(tstepSEXP);
    rcpp_result_gen = Rcpp::wrap(generate_foi(IM, NH, b, pMH, tstep));
    return rcpp_result_gen;
END_RCPP
}
// generate_riskS
NumericVector generate_riskS(NumericVector foi, double tstep);
RcppExport SEXP zikaProj_generate_riskS(SEXP foiSEXP, SEXP tstepSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< NumericVector >::type foi(foiSEXP);
    Rcpp::traits::input_parameter< double >::type tstep(tstepSEXP);
    rcpp_result_gen = Rcpp::wrap(generate_riskS(foi, tstep));
    return rcpp_result_gen;
END_RCPP
}
// generate_riskI
NumericVector generate_riskI(NumericVector foi, NumericVector riskS, double tstep);
RcppExport SEXP zikaProj_generate_riskI(SEXP foiSEXP, SEXP riskSSEXP, SEXP tstepSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< NumericVector >::type foi(foiSEXP);
    Rcpp::traits::input_parameter< NumericVector >::type riskS(riskSSEXP);
    Rcpp::traits::input_parameter< double >::type tstep(tstepSEXP);
    rcpp_result_gen = Rcpp::wrap(generate_riskI(foi, riskS, tstep));
    return rcpp_result_gen;
END_RCPP
}
// generate_probM_aux
NumericVector generate_probM_aux(NumericVector riskI, NumericVector probM, double bp);
RcppExport SEXP zikaProj_generate_probM_aux(SEXP riskISEXP, SEXP probMSEXP, SEXP bpSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< NumericVector >::type riskI(riskISEXP);
    Rcpp::traits::input_parameter< NumericVector >::type probM(probMSEXP);
    Rcpp::traits::input_parameter< double >::type bp(bpSEXP);
    rcpp_result_gen = Rcpp::wrap(generate_probM_aux(riskI, probM, bp));
    return rcpp_result_gen;
END_RCPP
}
// generate_probM
NumericVector generate_probM(NumericVector IM, double NH, NumericVector probM, double b, double pMH, double bp, double tstep);
RcppExport SEXP zikaProj_generate_probM(SEXP IMSEXP, SEXP NHSEXP, SEXP probMSEXP, SEXP bSEXP, SEXP pMHSEXP, SEXP bpSEXP, SEXP tstepSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< NumericVector >::type IM(IMSEXP);
    Rcpp::traits::input_parameter< double >::type NH(NHSEXP);
    Rcpp::traits::input_parameter< NumericVector >::type probM(probMSEXP);
    Rcpp::traits::input_parameter< double >::type b(bSEXP);
    Rcpp::traits::input_parameter< double >::type pMH(pMHSEXP);
    Rcpp::traits::input_parameter< double >::type bp(bpSEXP);
    Rcpp::traits::input_parameter< double >::type tstep(tstepSEXP);
    rcpp_result_gen = Rcpp::wrap(generate_probM(IM, NH, probM, b, pMH, bp, tstep));
    return rcpp_result_gen;
END_RCPP
}
// likelihood_probM
double likelihood_probM(NumericVector microBirths, NumericVector allBirths, NumericVector probM);
RcppExport SEXP zikaProj_likelihood_probM(SEXP microBirthsSEXP, SEXP allBirthsSEXP, SEXP probMSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< NumericVector >::type microBirths(microBirthsSEXP);
    Rcpp::traits::input_parameter< NumericVector >::type allBirths(allBirthsSEXP);
    Rcpp::traits::input_parameter< NumericVector >::type probM(probMSEXP);
    rcpp_result_gen = Rcpp::wrap(likelihood_probM(microBirths, allBirths, probM));
    return rcpp_result_gen;
END_RCPP
}
// average_buckets
NumericVector average_buckets(NumericVector a, NumericVector buckets);
RcppExport SEXP zikaProj_average_buckets(SEXP aSEXP, SEXP bucketsSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< NumericVector >::type a(aSEXP);
    Rcpp::traits::input_parameter< NumericVector >::type buckets(bucketsSEXP);
    rcpp_result_gen = Rcpp::wrap(average_buckets(a, buckets));
    return rcpp_result_gen;
END_RCPP
}
// sum_buckets
NumericVector sum_buckets(NumericVector a, NumericVector buckets);
RcppExport SEXP zikaProj_sum_buckets(SEXP aSEXP, SEXP bucketsSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< NumericVector >::type a(aSEXP);
    Rcpp::traits::input_parameter< NumericVector >::type buckets(bucketsSEXP);
    rcpp_result_gen = Rcpp::wrap(sum_buckets(a, buckets));
    return rcpp_result_gen;
END_RCPP
}
