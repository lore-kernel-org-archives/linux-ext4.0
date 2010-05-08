From: "Amir G." <amir73il@users.sourceforge.net>
Subject: Re: Introducing Next3 - built-in snapshots support for Ext3
Date: Sat, 8 May 2010 18:07:40 +0200
Message-ID: <AANLkTin0kirxWJR1jfKdX8AtWJbAjBiQNR3WsTmr5z8U@mail.gmail.com>
References: <g2j18730dc51004180841obb1171bbwa1822d6fe0856429@mail.gmail.com>
	 <s2s18730dc51005030247u5ef2fddfz269b57d97714db8f@mail.gmail.com>
	 <20100504224226.GE6344@thunk.org>
	 <p2h18730dc51005041905ma9e3733uc944bdb58af9f10@mail.gmail.com>
	 <87vdaz21b0.fsf@basil.nowhere.org>
	 <q2i18730dc51005071222q7d97ab67p968072fa6fdceb28@mail.gmail.com>
	 <4BE4855E.40808@redhat.com>
	 <AANLkTinbzARSNHOvMbRq7iKSZENKhnKYdKSq5IHvX_xs@mail.gmail.com>
	 <8D8944AA-9368-4E4F-B91D-5CEEE6E2EE2A@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Ric Wheeler <rwheeler@redhat.com>, Andi Kleen <andi@halobates.de>,
	linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:60420 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347Ab0EHQHm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 8 May 2010 12:07:42 -0400
Received: by bwz19 with SMTP id 19so1055496bwz.21
        for <linux-ext4@vger.kernel.org>; Sat, 08 May 2010 09:07:40 -0700 (PDT)
In-Reply-To: <8D8944AA-9368-4E4F-B91D-5CEEE6E2EE2A@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, May 8, 2010 at 1:48 PM, Theodore Tso wrote:
>
> On May 8, 2010, at 1:43 AM, Amir G. wrote:
>
>> 1. No features are added to Ext3, so there is no concern for the
>> stability of Ext3.
>> The feature is added as a new f/s, with the slight overhead of
>> duplicate code in the
>> kernel tree and an extra loadable module in the system.
>
> This is where it's important to understand exactly what is meant by a=
 ***file system***. =A0 Are you referring to the format, or the impleme=
ntation? =A0 The way I've always treated it, and it's the way I believe=
 most of the ext234 developers have treated it is, that what users call=
 ext2, ext3, and ext4 are different _implementations_ of the same _file=
_ _system_ [format]. =A0 =A0That is to say, ext4 simply happens to be a=
 fuller, more complete implementation =A0of the same file system as ext=
2 and ext3. =A0 Ext2 doesn't support certain features such as journalin=
g and directory indexing; ext3 doesn't support some advanced features s=
uch as delayed allocation and extents, and requires that the journal al=
ways be present. =A0 Ext4 is a superset of ext2 plus ext3 plus delayed =
allocation, extents, a multi-block allocator, and a few other new featu=
res. =A0 But they are all the same file system.
>

Next3 is another implementation of the extended f/s format.
Next3 is a superset of ext3 plus snapshots.

>
> The "ext" in ext2 stands for "extended", as in the "the second extend=
ed file system" for Linux. =A0 It perhaps would be better if we had use=
d the term "extensible", since that's the main thing about ext2/3/4 tha=
t has given it so much staying power. =A0We've been able to add, in ver=
y carefully backwards and forwards compatible way, new features to the =
file system format. =A0This is why I object to why Next3 uses some fiel=
ds that overlaps with ext4. =A0 It means that e2fsprogs, which supports=
 _one_ and _only_ _one_ file system format, will now need to support tw=
o file system formats. =A0And that's not something I want to do.

Next3 is backward and forward compatible with ext3.
Next3 path to e2fsprogs doesn't treat it as a different file system for=
mat.
All overlapping field issues can be resolved.

>
> Put another away, it should be possible to add your "Next3" snapshots=
 to ext4. =A0 Even if today, no one has the time and energy to do the w=
ork, it is something that should be _theoretically_ possible.

It is _practically_ possible to support the snapshot features/fields
in e2fsprogs today
and to add the support for the same snapshot features/fields to Ext4 la=
ter.

> In another e-mail message, you've made the claim: "Unfortunately, mer=
ging Next3 snapshots feature into Ext4 is not an easy task, because ext=
ent mapped files break the design concepts of Next3 snapshots."
> But aside from stealing fields already assigned to various features s=
upported by ext4, this isn't true! =A0I don't see anything that fundame=
ntally incompatible with Next3 and extent-mapped files. =A0 =A0(Unless =
you mean that the snapshot file might not be as efficiently stored usin=
g extent-mapped files, but [a] it's not clear the lack of efficiency wi=
ll matter, since most files are contiguously stored, and there can be o=
ver 380 extents in a extent tree leaf block, and [b] we could always us=
e an indirect block mapped file for the snapshot file --- ext4 is fully=
 backwards compatible with ext2, so you can use an old-style direct/ind=
irect block mapped file for the snapshot if you really wanted.)
>

It makes me very happy that you've studied Next3 enough to be able to
make this almost correct observation.
I do plan to use indirect mapped snapshot files when I merge them to Ex=
t4.
The only place that extent mapped files break the snapshots design is
when doing move-on-write
when writing in-place to extent mapped file.
Should the extent be broken into 2 extents + single block and then
move the block to snapshot?
Should the block be copied-on-write instead of moved-on-write and pay
the performance penalty?
There is an important design decision to make here.

Amir.
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
