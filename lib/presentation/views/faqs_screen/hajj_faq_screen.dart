import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ziarat_app/configurations/frontend_config.dart';
import 'package:ziarat_app/presentation/constants/app_constant.dart';
import 'package:ziarat_app/presentation/elements/app_bar.dart';
import '../../../infrastructure/models/umrah_masail.dart';
import '../../../infrastructure/services/json_loader_service.dart';
import '../../constants/asset_constant.dart';
import '../../constants/app_strings.dart';
import '../../elements/listTile.dart';
import 'FAQ_Screen.dart';

class HajjFaqScreen extends StatefulWidget {
  const HajjFaqScreen({super.key});

  @override
  State<HajjFaqScreen> createState() => _HajjFaqScreenState();
}

class _HajjFaqScreenState extends State<HajjFaqScreen> {
  List<UmrahMasailModel> _faqs = [];
  bool _isLoading = true;

  List<UmrahMasailModel> _fallbackFaqs() {
    return [
      UmrahMasailModel(
        index: 1,
        questionEn: "Who must perform Hajj?",
        questionAr: "من يجب عليه أداء الحج؟",
        questionUr: "حج کن پر فرض ہے؟",
        answerEn:
            "Hajj is obligatory once in a lifetime for every adult Muslim who is physically and financially able.",
        answerAr:
            "الحج فريضة مرة واحدة في العمر على كل مسلم بالغ قادر بدنيًا وماليًا.",
        answerUr:
            "حج زندگی میں ایک بار ہر بالغ مسلمان پر فرض ہے جو جسمانی اور مالی طور پر استطاعت رکھتا ہو۔",
      ),
      UmrahMasailModel(
        index: 2,
        questionEn: "What are the main rituals of Hajj?",
        questionAr: "ما هي المناسك الأساسية للحج؟",
        questionUr: "حج کے بنیادی ارکان کیا ہیں؟",
        answerEn:
            "The main rituals include Ihram, Tawaf, Sa'i, standing at Arafat, staying in Muzdalifah, and stoning at Mina.",
        answerAr:
            "تشمل المناسك الأساسية الإحرام، والطواف، والسعي، والوقوف بعرفة، والمبيت بمزدلفة، ورمي الجمرات في منى.",
        answerUr:
            "بنیادی اعمال میں احرام، طواف، سعی، وقوفِ عرفات، مزدلفہ میں قیام، اور منیٰ میں رمی شامل ہیں۔",
      ),
      UmrahMasailModel(
        index: 3,
        questionEn: "How many days does Hajj usually take?",
        questionAr: "كم يومًا يستغرق الحج عادة؟",
        questionUr: "حج عام طور پر کتنے دن کا ہوتا ہے؟",
        answerEn:
            "Hajj rituals are generally performed over five to six days in Dhul Hijjah.",
        answerAr: "تؤدى مناسك الحج عادة خلال خمسة إلى ستة أيام في شهر ذي الحجة.",
        answerUr:
            "حج کے اعمال عموماً ذوالحجہ میں پانچ سے چھ دن میں ادا کیے جاتے ہیں۔",
      ),
      UmrahMasailModel(
        index: 4,
        questionEn: "Can someone perform Hajj on behalf of another person?",
        questionAr: "هل يمكن أداء الحج نيابةً عن شخص آخر؟",
        questionUr: "کیا کسی دوسرے شخص کی طرف سے حج کیا جا سکتا ہے؟",
        answerEn:
            "Yes, in specific cases a person may perform Hajj on behalf of someone who is permanently unable, according to Islamic rulings.",
        answerAr:
            "نعم، في حالات معينة يمكن أداء الحج عن شخص غير قادر دائمًا، وفق الأحكام الشرعية.",
        answerUr:
            "جی ہاں، مخصوص صورتوں میں مستقل معذور شخص کی طرف سے شرعی احکام کے مطابق حج کیا جا سکتا ہے۔",
      ),
    ];
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final data = await JsonLoaderService.loadHajjMasail();
      setState(() {
        _faqs = data.isNotEmpty ? data : _fallbackFaqs();
        _isLoading = false;
      });
    } catch (_) {
      setState(() {
        _faqs = _fallbackFaqs();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(color: FrontEndConfig.backgroundColor),
          Positioned.fill(
            child: Image.asset(AssetConstant.backgroundimage, fit: BoxFit.cover),
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonAppBar(
                  title: AppStrings.hajjFaqAppBarTitleTxt.tr,
                  icon: Icons.arrow_back,
                  color: FrontEndConfig.iconColor,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 17.0, vertical: 10),
                  child: Text(
                    AppStrings.hajjFaqIntroTxt.tr,
                    style: FrontEndConfig.bodyTextStyle,
                  ),
                ),
                Expanded(
                  child: _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : ListView.separated(
                          padding: const EdgeInsets.symmetric(horizontal: 17.0),
                          itemCount: _faqs.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final faq = _faqs[index];
                            return CommonListTile(
                              tileColor: FrontEndConfig.listTileColor,
                              borderGradient: FrontEndConfig.listTileBorder,
                              leading: CircleAvatar(
                                backgroundColor:
                                    const Color(0xffC89C18).withOpacity(0.3),
                                radius: 13,
                                child: Text(
                                  "${index + 1}",
                                  style: FrontEndConfig.headingTextStyle
                                      .copyWith(
                                        fontSize: FrontEndConfig.fontSize(14),
                                      ),
                                ),
                              ),
                              title: faq.localizedQuestion,
                              trailing: Image.asset(
                                AssetConstant.arrowDownIcon,
                                width: 10,
                                height: 10,
                              ),
                              onTap: () =>
                                  FaqBottomSheet.show(context, index + 1, faq),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
