From: Chen Gang <gang.chen@asianux.com>
Subject: Re: [Suggestion] fs/ext3: memory leak by calling set_qf_name or clear_qf_name,
 many times.
Date: Thu, 27 Dec 2012 16:06:02 +0800
Message-ID: <50DC016A.9070801@asianux.com>
References: <50DA857B.1050808@asianux.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: akpm@linux-foundation.org, jack@suse.cz, linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>, adilger.kernel@dilger.ca
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from intranet.asianux.com ([58.214.24.6]:5866 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751633Ab2L0IZj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 27 Dec 2012 03:25:39 -0500
In-Reply-To: <50DA857B.1050808@asianux.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


  Really (just as Theodore Ts'o said), for ext4 is the same thing as ex=
t3 !

  so please help check it by ext4 maintainers, or ext3 maintainers

  if want to let me to send relative patch, please tell me, I will try.

  :-)

  thanks.

gchen

=D3=DA 2012=C4=EA12=D4=C226=C8=D5 13:04, Chen Gang =D0=B4=B5=C0:
> Hello Theodore Ts'o
>=20
> in fs/ext3/supper.c
>   for function set_qf_name:
>     sbi->s_qf_names[qtype] may already have owned a memory (line 919.=
=2E925)
>     we set sbi->s_qf_names[qtype] =3D qname directly without checking=
 (line 926)
>=20
>   for function clear_qf_name:
>     we set sbi->s_qf_names[qtype] =3D NULL (line 942..952)
>=20
>=20
>   for function parse_options:
>     we can call set_qf_name or clear_qf_name with USR or GRP many tim=
es.
>       we find parameters not mind whether they are repeated. (line 97=
5..985)=20
>       so we may call set_qf_name or clear_qf_name several times.
>         also may first call set_qf_name, then call clear_qf_name.
>=20
>   in this situation, we will get memory leak.
>=20
>   please help check this suggestion whether valid (I find it by code =
review).
>=20
>=20
>   regards.
>   =20
> gchen.
>=20
>  901 static int set_qf_name(struct super_block *sb, int qtype, substr=
ing_t *args)
>  902 {
>  903         struct ext3_sb_info *sbi =3D EXT3_SB(sb);
>  904         char *qname;
>  905=20
>  906         if (sb_any_quota_loaded(sb) &&
>  907                 !sbi->s_qf_names[qtype]) {
>  908                 ext3_msg(sb, KERN_ERR,
>  909                         "Cannot change journaled "
>  910                         "quota options when quota turned on");
>  911                 return 0;
>  912         }
>  913         qname =3D match_strdup(args);
>  914         if (!qname) {
>  915                 ext3_msg(sb, KERN_ERR,
>  916                         "Not enough memory for storing quotafile=
 name");
>  917                 return 0;
>  918         }
>  919         if (sbi->s_qf_names[qtype] &&
>  920                 strcmp(sbi->s_qf_names[qtype], qname)) {
>  921                 ext3_msg(sb, KERN_ERR,
>  922                         "%s quota file already specified", QTYPE=
2NAME(qtype));
>  923                 kfree(qname);
>  924                 return 0;
>  925         }
>  926         sbi->s_qf_names[qtype] =3D qname;
>  927         if (strchr(sbi->s_qf_names[qtype], '/')) {
>  928                 ext3_msg(sb, KERN_ERR,
>  929                         "quotafile must be on filesystem root");
>  930                 kfree(sbi->s_qf_names[qtype]);
>  931                 sbi->s_qf_names[qtype] =3D NULL;
>  932                 return 0;
>  933         }
>  934         set_opt(sbi->s_mount_opt, QUOTA);
>  935         return 1;
>  936 }
>  937
>  938 static int clear_qf_name(struct super_block *sb, int qtype) {
>  939=20
>  940         struct ext3_sb_info *sbi =3D EXT3_SB(sb);
>  941=20
>  942         if (sb_any_quota_loaded(sb) &&
>  943                 sbi->s_qf_names[qtype]) {
>  944                 ext3_msg(sb, KERN_ERR, "Cannot change journaled =
quota options"
>  945                         " when quota turned on");
>  946                 return 0;
>  947         }
>  948         /*
>  949          * The space will be released later when all options are=
 confirmed
>  950          * to be correct
>  951          */
>  952         sbi->s_qf_names[qtype] =3D NULL;
>  953         return 1;
>  954 }
>  955 #endif
>  956=20
>  957 static int parse_options (char *options, struct super_block *sb,
>  958                           unsigned int *inum, unsigned long *jou=
rnal_devnum,
>  959                           ext3_fsblk_t *n_blocks_count, int is_r=
emount)
>  960 {
>  961         struct ext3_sb_info *sbi =3D EXT3_SB(sb);
>  962         char * p;
>  963         substring_t args[MAX_OPT_ARGS];
>  964         int data_opt =3D 0;
>  965         int option;
>  966         kuid_t uid;
>  967         kgid_t gid;
>  968 #ifdef CONFIG_QUOTA
>  969         int qfmt;
>  970 #endif
>  971=20
>  972         if (!options)
>  973                 return 1;
>  974=20
>  975         while ((p =3D strsep (&options, ",")) !=3D NULL) {
>  976                 int token;
>  977                 if (!*p)
>  978                         continue;
>  979                 /*
>  980                  * Initialize args struct so we know whether arg=
 was
>  981                  * found; some options take optional arguments.
>  982                  */
>  983                 args[0].to =3D args[0].from =3D NULL;
>  984                 token =3D match_token(p, tokens, args);
>  985                 switch (token) {
>  986                 case Opt_bsd_df:
>  987                         clear_opt (sbi->s_mount_opt, MINIX_DF);
>  988                         break;
>  989                 case Opt_minix_df:
>  990                         set_opt (sbi->s_mount_opt, MINIX_DF);
>  991                         break;
>  992                 case Opt_grpid:
>  993                         set_opt (sbi->s_mount_opt, GRPID);
>  955 #endif
>  956=20
>  957 static int parse_options (char *options, struct super_block *sb,
>  958                           unsigned int *inum, unsigned long *jou=
rnal_devnum,
>  959                           ext3_fsblk_t *n_blocks_count, int is_r=
emount)
>  960 {
>  961         struct ext3_sb_info *sbi =3D EXT3_SB(sb);
>  962         char * p;
>  963         substring_t args[MAX_OPT_ARGS];
>  964         int data_opt =3D 0;
>  965         int option;
>  966         kuid_t uid;
>  967         kgid_t gid;
>  968 #ifdef CONFIG_QUOTA
>  969         int qfmt;
>  970 #endif
>  971=20
>  972         if (!options)
>  973                 return 1;
>  974=20
>  975         while ((p =3D strsep (&options, ",")) !=3D NULL) {
>  976                 int token;
>  977                 if (!*p)
>  978                         continue;
>  979                 /*
>  980                  * Initialize args struct so we know whether arg=
 was
>  981                  * found; some options take optional arguments.
>  982                  */
>  983                 args[0].to =3D args[0].from =3D NULL;
>  984                 token =3D match_token(p, tokens, args);
>  985                 switch (token) {
>  986                 case Opt_bsd_df:
>  987                         clear_opt (sbi->s_mount_opt, MINIX_DF);
>  988                         break;
>  989                 case Opt_minix_df:
>  990                         set_opt (sbi->s_mount_opt, MINIX_DF);
>  991                         break;
>  992                 case Opt_grpid:
>  993                         set_opt (sbi->s_mount_opt, GRPID);
>  994                         break;
>  995                 case Opt_nogrpid:
>  996                         clear_opt (sbi->s_mount_opt, GRPID);
>  997                         break;
>  998                 case Opt_resuid:
>  999                         if (match_int(&args[0], &option))
> 1000                                 return 0;
> 1001                         uid =3D make_kuid(current_user_ns(), opt=
ion);
> 1002                         if (!uid_valid(uid)) {
> 1003                                 ext3_msg(sb, KERN_ERR, "Invalid =
uid value %d", option);
> 1004                                 return 0;
> 1005=20
> 1006                         }
> 1007                         sbi->s_resuid =3D uid;
> 1008                         break;
> 1009                 case Opt_resgid:
> 1010                         if (match_int(&args[0], &option))
> 1011                                 return 0;
> 1012                         gid =3D make_kgid(current_user_ns(), opt=
ion);
> 1013                         if (!gid_valid(gid)) {
> 1014                                 ext3_msg(sb, KERN_ERR, "Invalid =
gid value %d", option);
> 1015                                 return 0;
> 1016                         }
> 1017                         sbi->s_resgid =3D gid;
> 1018                         break;
> 1019                 case Opt_sb:
> 1020                         /* handled by get_sb_block() instead of =
here */
> 1021                         /* *sb_block =3D match_int(&args[0]); */
> 1022                         break;
> 1023                 case Opt_err_panic:
> 1024                         clear_opt (sbi->s_mount_opt, ERRORS_CONT=
);
> 1025                         clear_opt (sbi->s_mount_opt, ERRORS_RO);
> 1026                         set_opt (sbi->s_mount_opt, ERRORS_PANIC)=
;
> 1027                         break;
> 1028                 case Opt_err_ro:
> 1029                         clear_opt (sbi->s_mount_opt, ERRORS_CONT=
);
> 1030                         clear_opt (sbi->s_mount_opt, ERRORS_PANI=
C);
> 1031                         set_opt (sbi->s_mount_opt, ERRORS_RO);
> 1032                         break;
> 1033                 case Opt_err_cont:
> 1034                         clear_opt (sbi->s_mount_opt, ERRORS_RO);
> 1035                         clear_opt (sbi->s_mount_opt, ERRORS_PANI=
C);
> 1036                         set_opt (sbi->s_mount_opt, ERRORS_CONT);
> 1037                         break;
> 1038                 case Opt_nouid32:
> 1039                         set_opt (sbi->s_mount_opt, NO_UID32);
> 1040                         break;
> 1041                 case Opt_nocheck:
> 1042                         clear_opt (sbi->s_mount_opt, CHECK);
> 1043                         break;
> 1044                 case Opt_debug:
> 1045                         set_opt (sbi->s_mount_opt, DEBUG);
> 1046                         break;
> 1047                 case Opt_oldalloc:
> 1048                         ext3_msg(sb, KERN_WARNING,
> 1049                                 "Ignoring deprecated oldalloc op=
tion");
> 1050                         break;
> 1051                 case Opt_orlov:
> 1052                         ext3_msg(sb, KERN_WARNING,
> 1053                                 "Ignoring deprecated orlov optio=
n");
> 1054                         break;
> 1055 #ifdef CONFIG_EXT3_FS_XATTR
> 1056                 case Opt_user_xattr:
> 1057                         set_opt (sbi->s_mount_opt, XATTR_USER);
> 1058                         break;
> 1059                 case Opt_nouser_xattr:
> 1060                         clear_opt (sbi->s_mount_opt, XATTR_USER)=
;
> 1061                         break;
> 1062 #else
> 1063                 case Opt_user_xattr:
> 1064                 case Opt_nouser_xattr:
> 1065                         ext3_msg(sb, KERN_INFO,
> 1066                                 "(no)user_xattr options not supp=
orted");
> 1067                         break;
> 1068 #endif
> 1069 #ifdef CONFIG_EXT3_FS_POSIX_ACL
> 1070                 case Opt_acl:
> 1071                         set_opt(sbi->s_mount_opt, POSIX_ACL);
> 1072                         break;
> 1073                 case Opt_noacl:
> 1074                         clear_opt(sbi->s_mount_opt, POSIX_ACL);
> 1075                         break;
> 1076 #else
> 1077                 case Opt_acl:
> 1078                 case Opt_noacl:
> 1079                         ext3_msg(sb, KERN_INFO,
> 1080                                 "(no)acl options not supported")=
;
> 1081                         break;
> 1082 #endif
> 1083                 case Opt_reservation:
> 1084                         set_opt(sbi->s_mount_opt, RESERVATION);
> 1085                         break;
> 1086                 case Opt_noreservation:
> 1087                         clear_opt(sbi->s_mount_opt, RESERVATION)=
;
> 1088                         break;
> 1089                 case Opt_journal_update:
> 1090                         /* @@@ FIXME */
> 1091                         /* Eventually we will want to be able to=
 create
> 1092                            a journal file here.  For now, only a=
llow the
> 1093                            user to specify an existing inode to =
be the
> 1094                            journal file. */
> 1095                         if (is_remount) {
> 1096                                 ext3_msg(sb, KERN_ERR, "error: c=
annot specify "
> 1097                                         "journal on remount");
> 1098                                 return 0;
> 1099                         }
> 1100                         set_opt (sbi->s_mount_opt, UPDATE_JOURNA=
L);
> 1101                         break;
> 1102                 case Opt_journal_inum:
> 1103                         if (is_remount) {
> 1104                                 ext3_msg(sb, KERN_ERR, "error: c=
annot specify "
> 1105                                        "journal on remount");
> 1106                                 return 0;
> 1107                         }
> 1108                         if (match_int(&args[0], &option))
> 1109                                 return 0;
> 1110                         *inum =3D option;
> 1111                         break;
> 1112                 case Opt_journal_dev:
> 1113                         if (is_remount) {
> 1114                                 ext3_msg(sb, KERN_ERR, "error: c=
annot specify "
> 1115                                        "journal on remount");
> 1116                                 return 0;
> 1117                         }
> 1118                         if (match_int(&args[0], &option))
> 1119                                 return 0;
> 1120                         *journal_devnum =3D option;
> 1121                         break;
> 1122                 case Opt_noload:
> 1123                         set_opt (sbi->s_mount_opt, NOLOAD);
> 1124                         break;
> 1125                 case Opt_commit:
> 1126                         if (match_int(&args[0], &option))
> 1127                                 return 0;
> 1128                         if (option < 0)
> 1129                                 return 0;
> 1130                         if (option =3D=3D 0)
> 1131                                 option =3D JBD_DEFAULT_MAX_COMMI=
T_AGE;
> 1132                         sbi->s_commit_interval =3D HZ * option;
> 1133                         break;
> 1134                 case Opt_data_journal:
> 1135                         data_opt =3D EXT3_MOUNT_JOURNAL_DATA;
> 1136                         goto datacheck;
> 1137                 case Opt_data_ordered:
> 1138                         data_opt =3D EXT3_MOUNT_ORDERED_DATA;
> 1139                         goto datacheck;
> 1140                 case Opt_data_writeback:
> 1141                         data_opt =3D EXT3_MOUNT_WRITEBACK_DATA;
> 1142                 datacheck:
> 1143                         if (is_remount) {
> 1144                                 if (test_opt(sb, DATA_FLAGS) =3D=
=3D data_opt)
> 1145                                         break;
> 1146                                 ext3_msg(sb, KERN_ERR,
> 1147                                         "error: cannot change "
> 1148                                         "data mode on remount. T=
he filesystem "
> 1149                                         "is mounted in data=3D%s=
 mode and you "
> 1150                                         "try to remount it in da=
ta=3D%s mode.",
> 1151                                         data_mode_string(test_op=
t(sb,
> 1152                                                         DATA_FLA=
GS)),
> 1153                                         data_mode_string(data_op=
t));
> 1154                                 return 0;
> 1155                         } else {
> 1156                                 clear_opt(sbi->s_mount_opt, DATA=
_FLAGS);
> 1157                                 sbi->s_mount_opt |=3D data_opt;
> 1158                         }
> 1159                         break;
> 1160                 case Opt_data_err_abort:
> 1161                         set_opt(sbi->s_mount_opt, DATA_ERR_ABORT=
);
> 1162                         break;
> 1163                 case Opt_data_err_ignore:
> 1164                         clear_opt(sbi->s_mount_opt, DATA_ERR_ABO=
RT);
> 1165                         break;
> 1166 #ifdef CONFIG_QUOTA
> 1167                 case Opt_usrjquota:
> 1168                         if (!set_qf_name(sb, USRQUOTA, &args[0])=
)
> 1169                                 return 0;
> 1170                         break;
> 1171                 case Opt_grpjquota:
> 1172                         if (!set_qf_name(sb, GRPQUOTA, &args[0])=
)
> 1173                                 return 0;
> 1174                         break;
> 1175                 case Opt_offusrjquota:
> 1176                         if (!clear_qf_name(sb, USRQUOTA))
> 1177                                 return 0;
> 1178                         break;
> 1179                 case Opt_offgrpjquota:
> 1180                         if (!clear_qf_name(sb, GRPQUOTA))
> 1181                                 return 0;
> 1182                         break;
>=20


--=20
Chen Gang

Asianux Corporation
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
