From: Aditya Kali <adityakali@google.com>
Subject: Re: [PATCH] mke2fs: Support floating point values in mke2fs.conf
Date: Tue, 10 May 2011 14:47:19 -0700
Message-ID: <BANLkTik8Vz+5EnQh3y+XTkiqwaQDWv5ULQ@mail.gmail.com>
References: <1305045441-2411-1-git-send-email-adityakali@google.com>
 <alpine.LFD.2.00.1105101955140.4184@dhcp-27-109.brq.redhat.com> <alpine.LFD.2.00.1105102007430.4184@dhcp-27-109.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:30200 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882Ab1EJVrn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 10 May 2011 17:47:43 -0400
Received: from wpaz21.hot.corp.google.com (wpaz21.hot.corp.google.com [172.24.198.85])
	by smtp-out.google.com with ESMTP id p4ALlgq7002668
	for <linux-ext4@vger.kernel.org>; Tue, 10 May 2011 14:47:42 -0700
Received: from pxi17 (pxi17.prod.google.com [10.243.27.17])
	by wpaz21.hot.corp.google.com with ESMTP id p4ALl41F006336
	(version=TLSv1/SSLv3 cipher=RC4-SHA bits=128 verify=NOT)
	for <linux-ext4@vger.kernel.org>; Tue, 10 May 2011 14:47:41 -0700
Received: by pxi17 with SMTP id 17so4601169pxi.34
        for <linux-ext4@vger.kernel.org>; Tue, 10 May 2011 14:47:40 -0700 (PDT)
In-Reply-To: <alpine.LFD.2.00.1105102007430.4184@dhcp-27-109.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Thanks for the feedback Lukas. I will send out another patch with
updated description and man page.

--
Aditya



On Tue, May 10, 2011 at 11:08 AM, Lukas Czerner <lczerner@redhat.com> w=
rote:
> On Tue, 10 May 2011, Lukas Czerner wrote:
>
>> On Tue, 10 May 2011, Aditya Kali wrote:
>>
>> > This patch adds profile_get_double function in profile.c that allo=
ws reading
>> > floating point values from profile files. The floating point suppo=
rt is used
>> > to read reserved_ratio (reserved for super user block percentage) =
from
>> > mke2fs.conf.
>>
>> Hi Aditya,
>>
>> thanks for the patch, however I have couple of comments. First of al=
l
>> the commit subject does not really reflect the change, because the p=
oint
>> of this commit is not to teach e2fsprogs to be able to read double f=
rom
>> profile but rather add new option to mke2fs.conf for specifying
>> super-user reservation ratio. I am sorry it this seems like nitpicki=
ng,
>> but it is really useful to be able to at least guess what the commit
>> does from its subject.
>>
>> Also it would be nice to have this option described in the mke2fs
>> manual page as well.
>
> Sorry, I meant mke2fs.conf man page. Other than that the patch looks
> good and works as expected.
>
>>
>> Thanks!
>> -Lukas
>>
>> >
>> > Signed-off-by: Aditya Kali <adityakali@google.com>
>> > ---
>> > =C2=A0e2fsck/profile.c =C2=A0 =C2=A0 | =C2=A0 37 +++++++++++++++++=
++++++++++++++++++++
>> > =C2=A0e2fsck/profile.h =C2=A0 =C2=A0 | =C2=A0 =C2=A05 +++++
>> > =C2=A0misc/mke2fs.c =C2=A0 =C2=A0 =C2=A0 =C2=A0| =C2=A0 26 +++++++=
++++++++++++++++++-
>> > =C2=A0tests/mke2fs.conf.in | =C2=A0 =C2=A01 +
>> > =C2=A04 files changed, 68 insertions(+), 1 deletions(-)
>> >
>> > diff --git a/e2fsck/profile.c b/e2fsck/profile.c
>> > index 5e9dc53..327bfb4 100644
>> > --- a/e2fsck/profile.c
>> > +++ b/e2fsck/profile.c
>> > @@ -1596,6 +1596,43 @@ profile_get_uint(profile_t profile, const c=
har *name, const char *subname,
>> > =C2=A0 =C2=A0 return 0;
>> > =C2=A0}
>> >
>> > +errcode_t
>> > +profile_get_double(profile_t profile, const char *name, const cha=
r *subname,
>> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0const char *subs=
ubname, double def_val, double *ret_double)
>> > +{
>> > + =C2=A0 const char =C2=A0 =C2=A0 =C2=A0*value;
>> > + =C2=A0 errcode_t =C2=A0 =C2=A0 =C2=A0 =C2=A0 retval;
>> > + =C2=A0 char =C2=A0 =C2=A0 =C2=A0 =C2=A0*end_value;
>> > + =C2=A0 double =C2=A0 =C2=A0 =C2=A0double_val;
>> > +
>> > + =C2=A0 *ret_double =3D def_val;
>> > + =C2=A0 if (profile =3D=3D 0)
>> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return 0;
>> > +
>> > + =C2=A0 retval =3D profile_get_value(profile, name, subname, subs=
ubname, &value);
>> > + =C2=A0 if (retval =3D=3D PROF_NO_SECTION || retval =3D=3D PROF_N=
O_RELATION) {
>> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 *ret_double =3D def_val;
>> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return 0;
>> > + =C2=A0 } else if (retval)
>> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return retval;
>> > +
>> > + =C2=A0 if (value[0] =3D=3D 0)
>> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* Empty string is no good. =C2=
=A0*/
>> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return PROF_BAD_INTEGER;
>> > + =C2=A0 errno =3D 0;
>> > + =C2=A0 double_val =3D strtod(value, &end_value);
>> > +
>> > + =C2=A0 /* Overflow or underflow. =C2=A0*/
>> > + =C2=A0 if (errno !=3D 0)
>> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return PROF_BAD_INTEGER;
>> > + =C2=A0 /* Garbage in string. =C2=A0*/
>> > + =C2=A0 if (end_value !=3D value + strlen(value))
>> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return PROF_BAD_INTEGER;
>> > +
>> > + =C2=A0 *ret_double =3D double_val;
>> > + =C2=A0 return 0;
>> > +}
>> > +
>> > =C2=A0static const char *const conf_yes[] =3D {
>> > =C2=A0 =C2=A0 =C2=A0"y", "yes", "true", "t", "1", "on",
>> > =C2=A0 =C2=A0 =C2=A00,
>> > diff --git a/e2fsck/profile.h b/e2fsck/profile.h
>> > index 0c17732..4cc10eb 100644
>> > --- a/e2fsck/profile.h
>> > +++ b/e2fsck/profile.h
>> > @@ -78,6 +78,11 @@ long profile_get_uint
>> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 const char *subsubname, =
unsigned int def_val,
>> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 unsigned int *ret_int);
>> >
>> > +long profile_get_double
>> > + =C2=A0 (profile_t profile, const char *name, const char *subname=
,
>> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 const char *subsubname, doubl=
e def_val,
>> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 double *ret_float);
>> > +
>> > =C2=A0long profile_get_boolean
>> > =C2=A0 =C2=A0 (profile_t profile, const char *name, const char *su=
bname,
>> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 const char *subsubname, int def_val,
>> > diff --git a/misc/mke2fs.c b/misc/mke2fs.c
>> > index 23f8c10..313423b 100644
>> > --- a/misc/mke2fs.c
>> > +++ b/misc/mke2fs.c
>> > @@ -1072,6 +1072,18 @@ static int get_int_from_profile(char **fs_t=
ypes, const char *opt, int def_val)
>> > =C2=A0 =C2=A0 return ret;
>> > =C2=A0}
>> >
>> > +static double get_double_from_profile(char **fs_types, const char=
 *opt,
>> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 double def_val)
>> > +{
>> > + =C2=A0 double ret;
>> > + =C2=A0 char **cpp;
>> > +
>> > + =C2=A0 profile_get_double(profile, "defaults", opt, 0, def_val, =
&ret);
>> > + =C2=A0 for (cpp =3D fs_types; *cpp; cpp++)
>> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 profile_get_double(profile, "=
fs_types", *cpp, opt, ret, &ret);
>> > + =C2=A0 return ret;
>> > +}
>> > +
>> > =C2=A0static int get_bool_from_profile(char **fs_types, const char=
 *opt, int def_val)
>> > =C2=A0{
>> > =C2=A0 =C2=A0 int ret;
>> > @@ -1144,7 +1156,7 @@ static void PRS(int argc, char *argv[])
>> > =C2=A0 =C2=A0 int =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 inode_=
ratio =3D 0;
>> > =C2=A0 =C2=A0 int =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 inode_=
size =3D 0;
>> > =C2=A0 =C2=A0 unsigned long =C2=A0 flex_bg_size =3D 0;
>> > - =C2=A0 double =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0reserved_ratio =3D=
 5.0;
>> > + =C2=A0 double =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0reserved_ratio =3D=
 -1.0;
>> > =C2=A0 =C2=A0 int =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 lsecto=
r_size =3D 0, psector_size =3D 0;
>> > =C2=A0 =C2=A0 int =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 show_v=
ersion_only =3D 0;
>> > =C2=A0 =C2=A0 unsigned long long num_inodes =3D 0; /* unsigned lon=
g long to catch too-large input */
>> > @@ -1667,6 +1679,18 @@ profile_error:
>> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 EXT3_FEATURE_COMPAT_HAS_JOURNAL;
>> > =C2=A0 =C2=A0 }
>> >
>> > + =C2=A0 /* Get reserved_ratio from profile if not specified on cm=
d line. */
>> > + =C2=A0 if (reserved_ratio < 0.0) {
>> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 reserved_ratio =3D get_double=
_from_profile(
>> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 fs_types, "reserve=
d_ratio", 5.0);
>> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (reserved_ratio > 50 || re=
served_ratio < 0) {
>> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 c=
om_err(program_name, 0,
>> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 _("invalid reserved blocks percent - %lf"),
>> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 reserved_ratio);
>> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 e=
xit(1);
>> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
>> > + =C2=A0 }
>> > +
>> > =C2=A0 =C2=A0 if (fs_param.s_feature_incompat &
>> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 EXT3_FEATURE_INCOMPAT_JOURNAL_DEV) {
>> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 reserved_ratio =3D 0;
>> > diff --git a/tests/mke2fs.conf.in b/tests/mke2fs.conf.in
>> > index 070d5d5..fbe2e2a 100644
>> > --- a/tests/mke2fs.conf.in
>> > +++ b/tests/mke2fs.conf.in
>> > @@ -3,6 +3,7 @@
>> > =C2=A0 =C2=A0 blocksize =3D 4096
>> > =C2=A0 =C2=A0 inode_size =3D 256
>> > =C2=A0 =C2=A0 inode_ratio =3D 16384
>> > + =C2=A0 reserved_ratio =3D 5.0
>> > =C2=A0 =C2=A0 enable_periodic_fsck =3D true
>> > =C2=A0 =C2=A0 lazy_itable_init =3D false
>> > =C2=A0 =C2=A0 default_mntopts =3D ^acl
>> >
>>
>>
>
> --
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
