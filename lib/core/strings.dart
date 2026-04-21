/// All user-visible strings for StitchMate.
///
/// Centralised for future localisation (l10n) readiness.
/// Never hardcode string literals in UI widgets.
class AppStrings {
  AppStrings._();

  // ── App ──
  static const String appName = 'StitchMate';
  static const String appTagline =
      'Do fewer things, but do them exceptionally well.';

  // ── Navigation Tabs ──
  static const String tabHome = 'Home';
  static const String tabProjects = 'Projects';
  static const String tabDictionary = 'Dictionary';
  static const String tabStash = 'Stash';
  static const String tabTools = 'Tools';

  // ── Home / Dashboard ──
  static const String homeTitle = 'Dashboard';
  static const String quickCounterTitle = 'Quick Counter';
  static const String activeProjectsTitle = 'Active Projects';
  static const String todaysSession = "Today's Session";
  static const String noActiveProjects = 'No active projects';
  static const String createProjectPrompt =
      'Create your first project to get started';

  // ── Counter ──
  static const String counterTitle = 'Counter';
  static const String counterIncrement = 'Increment';
  static const String counterDecrement = 'Decrement';
  static const String counterReset = 'Reset';
  static const String counterLock = 'Lock';
  static const String counterUnlock = 'Unlock';
  static const String counterLockedMessage =
      'Counter is locked. Unlock to make changes.';
  static const String counterSetValue = 'Set Value';
  static const String counterEnterValue = 'Enter row number';
  static const String counterReminder = 'Reminder';
  static const String counterReminderEvery = 'Every';
  static const String counterRows = 'rows';
  static const String counterResetConfirm =
      'Are you sure you want to reset the counter to 0?';
  static const String counterCurrentValue = 'Current value';
  static const String counterSwipeHint = 'Swipe down on button';
  static const String counterHapticsOn = 'Haptics On';
  static const String counterHapticsOff = 'Haptics Off';
  static const String counterSoundOn = 'Sound On';
  static const String counterSoundOff = 'Sound Off';

  // ── Projects ──
  static const String projectsTitle = 'Projects';
  static const String newProject = 'New Project';
  static const String editProject = 'Edit Project';
  static const String projectName = 'Project Name';
  static const String projectNameHint = 'e.g., Cozy Winter Scarf';
  static const String craftType = 'Craft Type';
  static const String craftKnitting = 'Knitting';
  static const String craftCrochet = 'Crochet';
  static const String craftBoth = 'Both';
  static const String projectStatus = 'Status';
  static const String statusActive = 'Active';
  static const String statusPaused = 'Paused';
  static const String statusCompleted = 'Completed';
  static const String statusFrogged = 'Frogged';
  static const String startDate = 'Start Date';
  static const String endDate = 'End Date';
  static const String projectNotes = 'Notes';
  static const String projectNotesHint =
      'Pattern source, modifications, ideas...';
  static const String needleSize = 'Needle / Hook Size';
  static const String needleSizeHint = 'e.g., 4.0mm / US 6';
  static const String projectPhotos = 'Photos';
  static const String addPhoto = 'Add Photo';
  static const String deleteProject = 'Delete Project';
  static const String deleteProjectConfirm =
      'Are you sure you want to delete this project? This cannot be undone.';
  static const String archiveProject = 'Archive Project';

  // ── Stitch Dictionary ──
  static const String dictionaryTitle = 'Stitch Dictionary';
  static const String dictionarySearchHint = 'Search abbreviations or names...';
  static const String dictionaryKnitting = 'Knitting';
  static const String dictionaryCrochet = 'Crochet';
  static const String dictionaryBoth = 'Both';
  static const String dictionaryFavourites = 'Favourites';
  static const String dictionaryBrowse = 'Browse';
  static const String categoryBasic = 'Basic';
  static const String categoryIncrease = 'Increases';
  static const String categoryDecrease = 'Decreases';
  static const String categoryCable = 'Cables';
  static const String categoryLace = 'Lace';
  static const String categorySpecial = 'Special Techniques';
  static const String difficultyBeginner = 'Beginner';
  static const String difficultyIntermediate = 'Intermediate';
  static const String difficultyAdvanced = 'Advanced';
  static const String noResults = 'No results found';
  static const String steps = 'Steps';
  static const String alsoKnownAs = 'Also known as';

  // ── Yarn Stash ──
  static const String stashTitle = 'Yarn Stash';
  static const String addYarn = 'Add Yarn';
  static const String editYarn = 'Edit Yarn';
  static const String yarnBrand = 'Brand';
  static const String yarnBrandHint = 'e.g., Malabrigo';
  static const String yarnColourName = 'Colour Name';
  static const String yarnColourNameHint = 'e.g., Sunset Glow';
  static const String yarnWeight = 'Weight';
  static const String yarnFibre = 'Fibre Content';
  static const String yarnFibreHint = 'e.g., 100% Merino Wool';
  static const String yarnYardage = 'Yards per Skein';
  static const String yarnMetreage = 'Metres per Skein';
  static const String yarnGrams = 'Grams per Skein';
  static const String yarnSkeinCount = 'Number of Skeins';
  static const String yarnStatus = 'Status';
  static const String yarnStatusAvailable = 'Available';
  static const String yarnStatusInUse = 'In Use';
  static const String yarnStatusUsedUp = 'Used Up';
  static const String yarnPurchaseLocation = 'Purchased At';
  static const String yarnNotes = 'Notes';
  static const String deleteYarn = 'Delete Yarn';
  static const String deleteYarnConfirm =
      'Are you sure you want to delete this yarn entry?';
  static const String enoughYarnTitle = 'Do I Have Enough?';
  static const String enoughYarnNeeded = 'Yardage Needed';
  static const String enoughYarnResult = 'Result';
  static const String enoughYarnYes = 'You have enough yarn!';
  static const String enoughYarnNo = 'You may not have enough yarn.';

  // ── Yarn Weights ──
  static const String weightLace = 'Lace';
  static const String weightFingering = 'Fingering';
  static const String weightSport = 'Sport';
  static const String weightDK = 'DK';
  static const String weightWorsted = 'Worsted';
  static const String weightAran = 'Aran';
  static const String weightBulky = 'Bulky';
  static const String weightSuperBulky = 'Super Bulky';

  // ── Timer ──
  static const String timerTitle = 'Timer';
  static const String timerStart = 'Start';
  static const String timerPause = 'Pause';
  static const String timerStop = 'Stop';
  static const String timerReset = 'Reset Timer';
  static const String timerSessionHistory = 'Session History';
  static const String timerNoSessions = 'No sessions recorded yet';
  static const String timerTotalTime = 'Total Time';

  // ── Calculator / Tools ──
  static const String toolsTitle = 'Tools';
  static const String gaugeCalculator = 'Gauge Calculator';
  static const String gaugeStitches = 'Stitches per 10cm';
  static const String gaugeRows = 'Rows per 10cm';
  static const String gaugeTargetWidth = 'Target Width';
  static const String gaugeTargetHeight = 'Target Height';
  static const String gaugeResult = 'You will need';
  static const String wpiCalculator = 'WPI Calculator';
  static const String wpiInput = 'Wraps Per Inch';
  static const String wpiResult = 'Yarn Weight';
  static const String needleChart = 'Needle & Hook Chart';
  static const String yarnWeightGuide = 'Yarn Weight Guide';
  static const String unitMetric = 'Metric (cm)';
  static const String unitImperial = 'Imperial (inches)';

  // ── Settings ──
  static const String settingsTitle = 'Settings';
  static const String themeMode = 'Theme';
  static const String themeLight = 'Light';
  static const String themeDark = 'Dark';
  static const String themeSystem = 'System';
  static const String accentColour = 'Accent Colour';
  static const String defaultCraftType = 'Default Craft Type';
  static const String units = 'Units';
  static const String counterHaptics = 'Counter Haptics';
  static const String counterSound = 'Counter Sound';
  static const String keepScreenAwake = 'Keep Screen Awake';
  static const String dataExport = 'Export Data';
  static const String dataImport = 'Import Data';
  static const String about = 'About';
  static const String acknowledgements = 'Acknowledgements';
  static const String version = 'Version';

  // ── Pro / Monetisation ──
  static const String proTitle = 'StitchMate Pro';
  static const String proPrice = '\$4.99 one-time purchase';
  static const String proDescription =
      'Unlock unlimited projects, multiple counters, yarn stash, timer, gauge calculator, favourites, colour themes, and data export.';
  static const String proUpgrade = 'Upgrade to Pro';
  static const String proRestore = 'Restore Purchases';
  static const String proFeatureLocked = 'Pro Feature';
  static const String proFeatureLockedMessage =
      'This feature is available with StitchMate Pro.';

  // ── Common Actions ──
  static const String save = 'Save';
  static const String cancel = 'Cancel';
  static const String delete = 'Delete';
  static const String edit = 'Edit';
  static const String done = 'Done';
  static const String confirm = 'Confirm';
  static const String close = 'Close';
  static const String back = 'Back';
  static const String next = 'Next';
  static const String skip = 'Skip';
  static const String gotIt = 'Got it';
  static const String yes = 'Yes';
  static const String no = 'No';
  static const String ok = 'OK';
  static const String retry = 'Retry';
  static const String loading = 'Loading...';
  static const String error = 'Something went wrong';
  static const String empty = 'Nothing here yet';

  // ── Onboarding ──
  static const String onboardingWelcome = 'Welcome to StitchMate';
  static const String onboardingCounter = 'Never Lose Your Place';
  static const String onboardingProjects = 'Organise Your Projects';
  static const String onboardingTools = 'Everything You Need';

  // ── Errors / Validation ──
  static const String requiredField = 'This field is required';
  static const String invalidNumber = 'Please enter a valid number';
  static const String invalidDate = 'Please enter a valid date';
  static const String nameTooLong = 'Name must be 50 characters or less';
  static const String notesTooLong = 'Notes must be 1000 characters or less';
}
