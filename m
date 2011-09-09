From: Aditya Kali <adityakali@google.com>
Subject: Re: [PATCH 4/5] tune2fs: Add support for turning on quota feature
Date: Fri, 9 Sep 2011 16:41:39 -0700
Message-ID: <CAGr1F2GW6D6BpnsN2hqkNTSP-eYd7GtQ9SezvW+pNW4M+A61ag@mail.gmail.com>
References: <1311187206-30553-1-git-send-email-adityakali@google.com>
 <1311187206-30553-5-git-send-email-adityakali@google.com> <A8E4523A-14F7-42F3-87F5-BA945DF8FBF3@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:26842 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751844Ab1IIXmH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 9 Sep 2011 19:42:07 -0400
Received: from wpaz29.hot.corp.google.com (wpaz29.hot.corp.google.com [172.24.198.93])
	by smtp-out.google.com with ESMTP id p89Ng123001252
	for <linux-ext4@vger.kernel.org>; Fri, 9 Sep 2011 16:42:01 -0700
Received: from pzk33 (pzk33.prod.google.com [10.243.19.161])
	by wpaz29.hot.corp.google.com with ESMTP id p89Nfuhm004369
	(version=TLSv1/SSLv3 cipher=RC4-SHA bits=128 verify=NOT)
	for <linux-ext4@vger.kernel.org>; Fri, 9 Sep 2011 16:42:00 -0700
Received: by pzk33 with SMTP id 33so11076924pzk.18
        for <linux-ext4@vger.kernel.org>; Fri, 09 Sep 2011 16:42:00 -0700 (PDT)
In-Reply-To: <A8E4523A-14F7-42F3-87F5-BA945DF8FBF3@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Sep 9, 2011 at 3:39 PM, Andreas Dilger <adilger@dilger.ca> wrot=
e:
> On 2011-07-20, at 12:40 PM, Aditya Kali wrote:
>> This patch adds support for setting the quota feature in superblock
>> and allows selectively creating quota inodes (user or group or both)
>> in the superblock. Currently, modifying the quota feature is only
>> supported when the filesystem is unmounted.
>> Also, when setting the quota feature, tune2fs will use aquota.user o=
r
>> aquota.group file inode number in superblock if these files exist.
>> Otherwise it will initialize empty quota inodes #3 and #4 and use th=
em.
>>
>> Here is how it works:
>> # Set quota feature and initialize both (user and group) quota inode=
s
>> $ tune2fs -O quota /dev/ram1
>>
>> # Enable only one type of quota
>> $ tune2fs -Q usrquota /dev/ram1
>
> I was looking at this patch, and would like some clarification. =C2=A0=
Does
> enabling quota also update the quota files from the filesystem, or
> does that need a full e2fsck? =C2=A0On large filesystems, it would be=
 very
> desirable to allow enabling the quota by having tune2fs do a fast ino=
de
> table scan (which can complete in a couple of minutes even for a larg=
e
> filesystem) instead of potentially hours.
>
Currently, if there are no existing aquota.user and aquota.group
files, then tune2fs will create empty quota files and it will need an
e2fsck to update the quota information.

> It looks like it would be enough to call compute_quota() after the qu=
ota
> files are opened, before release_quota_context() is called. =C2=A0In =
our past
> experience, scanning just the inode table for quotas on large filesys=
tems
> only takes a few minutes. =C2=A0Also, this avoids the need to exit fr=
om tune2fs
> with the RO_COMPAT_QUOTA feature enabled, but the filesystem is not v=
alid
> because the quota file is empty, and in fact the below code doesn't e=
ven
> warn that e2fsck needs to be run.
>
Yes. Calling compute_quota() is all that is needed. I thought that the
few minutes of time for doing full inode scan would be considered "too
expensive" for tune2fs (compared to tune2fs's other operations which
simply do the minimum needed to turn features on/off). Also, the
workflow I was assuming that the user will first run tune2fs to set
the feature and then run e2fsck to soon after to update quotas. I will
add computing the quotas during tune2fs since it doesn't seem to be a
problem.

>> # Enable grpquota, disable usrquota
>> $ tune2fs -Q ^usrquota,grpquota /dev/ram1
>>
>> # Clear quota feature and remove quota inodes
>> $ tune2fs -O ^quota /dev/ram1
>>
>> Signed-off-by: Aditya Kali <adityakali@google.com>
>> ---
>> misc/Makefile.in =C2=A0| =C2=A0 14 +++--
>> misc/tune2fs.8.in | =C2=A0 15 +++++
>> misc/tune2fs.c =C2=A0 =C2=A0| =C2=A0148 ++++++++++++++++++++++++++++=
+++++++++++++++++++++++--
>> 3 files changed, 167 insertions(+), 10 deletions(-)
>>
>> diff --git a/misc/Makefile.in b/misc/Makefile.in
>> index 2f7908c..a23adcd 100644
>> --- a/misc/Makefile.in
>> +++ b/misc/Makefile.in
>> @@ -143,24 +143,26 @@ e2initrd_helper: e2initrd_helper.o $(DEPLIBS) =
$(DEPLIBBLKID) $(LIBEXT2FS)
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 $(LIBBLKID) $(LIBEX=
T2FS) $(LIBINTL)
>>
>> tune2fs: $(TUNE2FS_OBJS) $(DEPLIBS) $(DEPLIBS_E2P) $(DEPLIBBLKID) \
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 $(DEPLIBUUID) $(LIBEXT2F=
S)
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 $(DEPLIBUUID) $(DEPLIBQU=
OTA) $(LIBEXT2FS)
>> =C2=A0 =C2=A0 =C2=A0 $(E) " =C2=A0LD $@"
>> =C2=A0 =C2=A0 =C2=A0 $(Q) $(CC) $(ALL_LDFLAGS) -o tune2fs $(TUNE2FS_=
OBJS) $(LIBS) \
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 $(LIBBLKID) $(LIBUUID) $=
(LIBEXT2FS) $(LIBS_E2P) $(LIBINTL)
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 $(LIBBLKID) $(LIBUUID) $=
(LIBQUOTA) $(LIBEXT2FS) $(LIBS_E2P) \
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 $(LIBINTL)
>>
>> tune2fs.static: $(TUNE2FS_OBJS) $(STATIC_DEPLIBS) $(STATIC_LIBE2P) $=
(DEPSTATIC_LIBBLKID)
>> =C2=A0 =C2=A0 =C2=A0 $(E) " =C2=A0LD $@"
>> =C2=A0 =C2=A0 =C2=A0 $(Q) $(CC) $(LDFLAGS_STATIC) -o tune2fs.static =
$(TUNE2FS_OBJS) \
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 $(STATIC_LIBS) $(ST=
ATIC_LIBBLKID) $(STATIC_LIBUUID) \
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 $(STATIC_LIBE2P) $(LIBIN=
TL)
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 $(STATIC_LIBQUOTA) $(STA=
TIC_LIBE2P) $(LIBINTL)
>>
>> tune2fs.profiled: $(PROFILED_TUNE2FS_OBJS) $(PROFILED_DEPLIBS) \
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 $(PROFILED_E2P) $(DEPPRO=
=46ILED_LIBBLKID) $(DEPPROFILED_LIBUUID)
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 $(PROFILED_E2P) $(DEPPRO=
=46ILED_LIBBLKID) $(DEPPROFILED_LIBUUID) \
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 $(DEPPROFILED_LIBQUOTA)
>> =C2=A0 =C2=A0 =C2=A0 $(E) " =C2=A0LD $@"
>> =C2=A0 =C2=A0 =C2=A0 $(Q) $(CC) $(ALL_LDFLAGS) -g -pg -o tune2fs.pro=
filed \
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 $(PROFILED_TUNE2FS_=
OBJS) $(PROFILED_LIBBLKID) \
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 $(PROFILED_LIBUUID) $(PR=
OFILED_LIBE2P) $(LIBINTL) \
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 $(PROFILED_LIBS)
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 $(PROFILED_LIBUUID) $(PR=
OFILED_LIBQUOTA) $(PROFILED_LIBE2P) \
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 $(LIBINTL) $(PROFILED_LI=
BS)
>>
>> blkid: $(BLKID_OBJS) $(DEPLIBBLKID) $(LIBEXT2FS)
>> =C2=A0 =C2=A0 =C2=A0 $(E) " =C2=A0LD $@"
>> diff --git a/misc/tune2fs.8.in b/misc/tune2fs.8.in
>> index 233f85a..89bc1d9 100644
>> --- a/misc/tune2fs.8.in
>> +++ b/misc/tune2fs.8.in
>> @@ -77,6 +77,11 @@ tune2fs \- adjust tunable filesystem parameters o=
n ext2/ext3/ext4 filesystems
>> .RI [^] feature [,...]
>> ]
>> [
>> +.B \-Q
>> +.I quota-options
>> +]
>> +[
>> +[
>> .B \-T
>> .I time-last-checked
>> ]
>> @@ -561,6 +566,16 @@ features are only supported by the ext4 filesys=
tem.
>> .BI \-r " reserved-blocks-count"
>> Set the number of reserved filesystem blocks.
>> .TP
>> +.BI \-Q " quota-options"
>> +Sets 'quota' feature on the superblock and works on the quota files=
 for the
>> +given quota type. Quota options could be one or more of the followi=
ng:
>> +.RS 1.2i
>> +.TP
>> +.BR [^]usrquota
>> +Sets/clears user quota inode in the superblock.
>> +.BR [^]usrquota
>> +Sets/clears group quota inode in the superblock.
>> +.TP
>> .BI \-T " time-last-checked"
>> Set the time the filesystem was last checked using
>> .BR =C2=A0e2fsck .
>> diff --git a/misc/tune2fs.c b/misc/tune2fs.c
>> index 5bf5187..3c81898 100644
>> --- a/misc/tune2fs.c
>> +++ b/misc/tune2fs.c
>> @@ -55,16 +55,22 @@ extern int optind;
>> #include "jfs_user.h"
>> #include "util.h"
>> #include "blkid/blkid.h"
>> +#include "quota/mkquota.h"
>>
>> #include "../version.h"
>> #include "nls-enable.h"
>>
>> +#define QOPT_ENABLE =C2=A0(1)
>> +#define QOPT_DISABLE (-1)
>> +
>> +extern int ask_yn(const char *string, int def);
>> +
>> const char *program_name =3D "tune2fs";
>> char *device_name;
>> char *new_label, *new_last_mounted, *new_UUID;
>> char *io_options;
>> static int c_flag, C_flag, e_flag, f_flag, g_flag, i_flag, l_flag, L=
_flag;
>> -static int m_flag, M_flag, r_flag, s_flag =3D -1, u_flag, U_flag, T=
_flag;
>> +static int m_flag, M_flag, Q_flag, r_flag, s_flag =3D -1, u_flag, U=
_flag, T_flag;
>> static int I_flag;
>> static time_t last_check_time;
>> static int print_label;
>> @@ -82,6 +88,7 @@ static int stride_set, stripe_width_set;
>> static char *extended_cmd;
>> static unsigned long new_inode_size;
>> static char *ext_mount_opts;
>> +static int usrquota, grpquota;
>>
>> int journal_size, journal_flags;
>> char *journal_device;
>> @@ -131,7 +138,8 @@ static __u32 ok_features[3] =3D {
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 EXT4_FEATURE_RO_COM=
PAT_DIR_NLINK|
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 EXT4_FEATURE_RO_COM=
PAT_EXTRA_ISIZE|
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 EXT4_FEATURE_RO_COM=
PAT_GDT_CSUM |
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 EXT2_FEATURE_RO_COMPAT_S=
PARSE_SUPER
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 EXT2_FEATURE_RO_COMPAT_S=
PARSE_SUPER |
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 EXT4_FEATURE_RO_COMPAT_Q=
UOTA
>> };
>>
>> static __u32 clear_ok_features[3] =3D {
>> @@ -147,7 +155,8 @@ static __u32 clear_ok_features[3] =3D {
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 EXT4_FEATURE_RO_COM=
PAT_HUGE_FILE|
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 EXT4_FEATURE_RO_COM=
PAT_DIR_NLINK|
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 EXT4_FEATURE_RO_COM=
PAT_EXTRA_ISIZE|
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 EXT4_FEATURE_RO_COMPAT_G=
DT_CSUM
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 EXT4_FEATURE_RO_COMPAT_G=
DT_CSUM |
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 EXT4_FEATURE_RO_COMPAT_Q=
UOTA
>> };
>>
>> /*
>> @@ -477,6 +486,36 @@ static void update_feature_set(ext2_filsys fs, =
char *features)
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 fs->flags &=3D ~EXT=
2_FLAG_SUPER_ONLY;
>> =C2=A0 =C2=A0 =C2=A0 }
>>
>> + =C2=A0 =C2=A0 if (FEATURE_ON(E2P_FEATURE_RO_INCOMPAT,
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 EXT4_FEATURE_RO_COMPAT_QUOTA)) {
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /*
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* Set the Q_flag h=
ere and handle the quota options in the code
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* below.
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*/
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!Q_flag) {
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 Q_flag =3D 1;
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 /* Enable both user quota and group quota by default */
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 usrquota =3D QOPT_ENABLE;
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 grpquota =3D QOPT_ENABLE;
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sb->s_feature_ro_compat =
&=3D ~EXT4_FEATURE_RO_COMPAT_QUOTA;
>> + =C2=A0 =C2=A0 }
>> +
>> + =C2=A0 =C2=A0 if (FEATURE_OFF(E2P_FEATURE_RO_INCOMPAT,
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 EXT4_FEATURE_RO_COMPAT_QUOTA)) {
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /*
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* Set the Q_flag h=
ere and handle the quota options in the code
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* below.
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*/
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (Q_flag)
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 fputs(_("\nWarning: '^quota' option overrides '-Q'"
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 "arguments.\n"), stderr);
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 Q_flag =3D 1;
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* Disable both user quo=
ta and group quota by default */
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 usrquota =3D QOPT_DISABL=
E;
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 grpquota =3D QOPT_DISABL=
E;
>> + =C2=A0 =C2=A0 }
>> +
>> =C2=A0 =C2=A0 =C2=A0 if (sb->s_rev_level =3D=3D EXT2_GOOD_OLD_REV &&
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 (sb->s_feature_compat || sb->s_fe=
ature_ro_compat ||
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0sb->s_feature_incompat))
>> @@ -576,6 +615,93 @@ err:
>> =C2=A0 =C2=A0 =C2=A0 exit(1);
>> }
>>
>> +void handle_quota_options(ext2_filsys fs)
>> +{
>> + =C2=A0 =C2=A0 quota_ctx_t qctx;
>> + =C2=A0 =C2=A0 errcode_t retval;
>> + =C2=A0 =C2=A0 ext2_ino_t qf_ino;
>> +
>> + =C2=A0 =C2=A0 if (!usrquota && !grpquota)
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* Nothing to do. */
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return;
>> +
>> + =C2=A0 =C2=A0 init_quota_context(&qctx, fs, -1);
>> +
>> + =C2=A0 =C2=A0 if (usrquota =3D=3D QOPT_ENABLE && !fs->super->s_usr=
_quota_inum) {
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if ((qf_ino =3D quota_fi=
le_exists(fs, USRQUOTA, QFMT_VFS_V1)) > 0)
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 set_sb_quota_inum(fs, qf_ino, USRQUOTA);
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 else
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 write_quota_inode(qctx, USRQUOTA);
>> + =C2=A0 =C2=A0 } else if (usrquota =3D=3D QOPT_DISABLE) {
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 remove_quota_inode(fs, U=
SRQUOTA);
>> + =C2=A0 =C2=A0 }
>> +
>> + =C2=A0 =C2=A0 if (grpquota =3D=3D QOPT_ENABLE && !fs->super->s_grp=
_quota_inum) {
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if ((qf_ino =3D quota_fi=
le_exists(fs, GRPQUOTA, QFMT_VFS_V1)) > 0)
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 set_sb_quota_inum(fs, qf_ino, GRPQUOTA);
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 else
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 write_quota_inode(qctx, GRPQUOTA);
>> + =C2=A0 =C2=A0 } else if (grpquota =3D=3D QOPT_DISABLE) {
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 remove_quota_inode(fs, G=
RPQUOTA);
>> + =C2=A0 =C2=A0 }
>> +
>> + =C2=A0 =C2=A0 release_quota_context(&qctx);
>> +
>> + =C2=A0 =C2=A0 if ((usrquota =3D=3D QOPT_ENABLE) || (grpquota =3D=3D=
 QOPT_ENABLE)) {
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 fs->super->s_feature_ro_=
compat |=3D EXT4_FEATURE_RO_COMPAT_QUOTA;
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ext2fs_mark_super_dirty(=
fs);
>> + =C2=A0 =C2=A0 } else if ((usrquota =3D=3D QOPT_DISABLE) && (grpquo=
ta =3D=3D QOPT_DISABLE)) {
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 fs->super->s_feature_ro_=
compat &=3D ~EXT4_FEATURE_RO_COMPAT_QUOTA;
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ext2fs_mark_super_dirty(=
fs);
>> + =C2=A0 =C2=A0 }
>> +
>> + =C2=A0 =C2=A0 return;
>> +}
>> +
>> +void parse_quota_opts(const char *opts)
>> +{
>> + =C2=A0 =C2=A0 char =C2=A0 =C2=A0*buf, *token, *next, *p, *arg;
>> + =C2=A0 =C2=A0 int =C2=A0 =C2=A0 len;
>> +
>> + =C2=A0 =C2=A0 len =3D strlen(opts);
>> + =C2=A0 =C2=A0 buf =3D malloc(len+1);
>> + =C2=A0 =C2=A0 if (!buf) {
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 fputs(_("Couldn't alloca=
te memory to parse quota "
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 "options!\n"), stderr);
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 exit(1);
>> + =C2=A0 =C2=A0 }
>> + =C2=A0 =C2=A0 strcpy(buf, opts);
>> + =C2=A0 =C2=A0 for (token =3D buf; token && *token; token =3D next)=
 {
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 p =3D strchr(token, ',')=
;
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 next =3D 0;
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (p) {
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 *p =3D 0;
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 next =3D p+1;
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
>> +
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (strcmp(token, "usrqu=
ota") =3D=3D 0) {
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 usrquota =3D QOPT_ENABLE;
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 } else if (strcmp(token,=
 "^usrquota") =3D=3D 0) {
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 usrquota =3D QOPT_DISABLE;
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 } else if (strcmp(token,=
 "grpquota") =3D=3D 0) {
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 grpquota =3D QOPT_ENABLE;
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 } else if (strcmp(token,=
 "^grpquota") =3D=3D 0) {
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 grpquota =3D QOPT_DISABLE;
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 } else {
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 fputs(_("\nBad quota options specified.\n\n"
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 "Following valid quota options are avai=
lable "
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 "(pass by separating with comma):\n"
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 "\t[^]usrquota\n"
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 "\t[^]grpquota\n"
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 "\n\n"), stderr);
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 free(buf);
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 exit(1);
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
>> + =C2=A0 =C2=A0 }
>> + =C2=A0 =C2=A0 free(buf);
>> +}
>> +
>> +
>>
>> static void parse_e2label_options(int argc, char ** argv)
>> {
>> @@ -641,7 +767,7 @@ static void parse_tune2fs_options(int argc, char=
 **argv)
>> =C2=A0 =C2=A0 =C2=A0 open_flag =3D 0;
>>
>> =C2=A0 =C2=A0 =C2=A0 printf("tune2fs %s (%s)\n", E2FSPROGS_VERSION, =
E2FSPROGS_DATE);
>> - =C2=A0 =C2=A0 while ((c =3D getopt(argc, argv, "c:e:fg:i:jlm:o:r:s=
:u:C:E:I:J:L:M:O:T:U:")) !=3D EOF)
>> + =C2=A0 =C2=A0 while ((c =3D getopt(argc, argv, "c:e:fg:i:jlm:o:r:s=
:u:C:E:I:J:L:M:O:Q:T:U:")) !=3D EOF)
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 switch (c) {
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 case 'c':
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 max_mount_count =3D strtol(optarg, &tmp, 0);
>> @@ -796,6 +922,11 @@ static void parse_tune2fs_options(int argc, cha=
r **argv)
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 features_cmd =3D optarg;
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 open_flag =3D EXT2_FLAG_RW;
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 break;
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 case 'Q':
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 Q_flag =3D 1;
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 parse_quota_opts(optarg);
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 open_flag =3D EXT2_FLAG_RW;
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 break;
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 case 'r':
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 reserved_blocks =3D strtoul(optarg, &tmp, 0);
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 if (*tmp) {
>> @@ -1790,6 +1921,15 @@ retry_open:
>> =C2=A0 =C2=A0 =C2=A0 if (journal_size || journal_device)
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 add_journal(fs);
>>
>> + =C2=A0 =C2=A0 if (Q_flag) {
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (mount_flags & EXT2_M=
=46_MOUNTED) {
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 fputs(_("The quota feature may only be changed when "
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 "the filesystem is unmounted.\n"), stde=
rr);
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 exit(1);
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 handle_quota_options(fs)=
;
>> + =C2=A0 =C2=A0 }
>> +
>> =C2=A0 =C2=A0 =C2=A0 if (U_flag) {
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 int set_csum =3D 0;
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 dgrp_t i;
>> --
>> 1.7.3.1
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.h=
tml
>
>
> Cheers, Andreas
>
>
>
>
>
>

Thanks,
--
Aditya
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
