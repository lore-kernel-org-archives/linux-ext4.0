From: "Amir G." <amir73il@users.sourceforge.net>
Subject: Re: [PATCH v2] xfstests: add support for ext4dev FSTYP
Date: Thu, 2 Jun 2011 10:16:48 +0300
Message-ID: <BANLkTimKV3LxugkW6_cE5vutjcmatESXuw@mail.gmail.com>
References: <1306933012-8666-1-git-send-email-amir73il@users.sourceforge.net>
	<20110601232804.GL32466@dastard>
	<BANLkTi=sV5=PyZvNSd=DGNW-V84=27d7Yw@mail.gmail.com>
	<BANLkTimbPWfOJKq6er4mnSYNPcx6VHLcrw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: xfs@oss.sgi.com, sandeen@redhat.com, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, sergey57@gmail.com,
	Amir Goldstein <amir73il@users.sf.net>
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <BANLkTimbPWfOJKq6er4mnSYNPcx6VHLcrw@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Jun 2, 2011 at 5:33 AM, Amir G. <amir73il@users.sourceforge.net=
> wrote:
> On Thu, Jun 2, 2011 at 5:16 AM, Amir G. <amir73il@users.sourceforge.n=
et> wrote:
>> On Thu, Jun 2, 2011 at 2:28 AM, Dave Chinner <david@fromorbit.com> w=
rote:
>>> On Wed, Jun 01, 2011 at 03:56:52PM +0300, amir73il@users.sourceforg=
e.net wrote:
>>>> From: Amir Goldstein <amir73il@users.sf.net>
>>>>
>>>> From: Amir Goldstein <amir73il@users.sf.net>
>>>>
>>>> blkid knows to identify the ext4dev FSTYP of a partition that was
>>>> formatted with mkfs.ext4dev.
>>>> quota tools and various util-linux utils are also aware of ext4dev=
,
>>>> so ext4dev shares the same capabilities as ext4.
>>>>
>>>> Signed-off-by: Amir Goldstein <amir73il@users.sf.net>
>>>> Tested-by: Sergey Ivanov <sergey57@gmail.com>
>>>> ---
>>>> ext4dev is used to test experimental ext4 code in mutual existance
>>>> with production ext4 code on the same system.
>>>>
>>>> Specifically, ext4 snapshots code is available for testing as a
>>>> stand-alone ext4dev module for Fedora 15 and Ubuntu 11.4
>>>> (see http://next3.sf.net).
>>>>
>>>> v1 -> v2:
>>>> - undo change of fsck -t $FSTYP to fsck.$FSTYP
>>>>
>>>> =A0common.defrag | =A0 =A02 +-
>>>> =A0common.quota =A0| =A0 =A04 ++--
>>>> =A0common.rc =A0 =A0 | =A0 10 +++++-----
>>>> =A03 files changed, 8 insertions(+), 8 deletions(-)
>>>>
>>>> diff --git a/common.defrag b/common.defrag
>>>> index 1bcf01d..4850803 100644
>>>> --- a/common.defrag
>>>> +++ b/common.defrag
>>>> @@ -26,7 +26,7 @@ _require_defrag()
>>>> =A0 =A0 =A0xfs)
>>>> =A0 =A0 =A0 =A0 =A0DEFRAG_PROG=3D/usr/sbin/xfs_fsr
>>>> =A0 =A0 =A0 ;;
>>>> - =A0 =A0ext4)
>>>> + =A0 =A0ext4|ext4dev)
>>>> =A0 =A0 =A0 =A0 =A0DEFRAG_PROG=3D/usr/bin/e4defrag
>>>> =A0 =A0 =A0 ;;
>>>> =A0 =A0 =A0*)
>>>> diff --git a/common.quota b/common.quota
>>>> index 3c87ce1..b6d5f16 100644
>>>> --- a/common.quota
>>>> +++ b/common.quota
>>>> @@ -29,7 +29,7 @@ _require_quota()
>>>> =A0 =A0 =A0[ -n $QUOTA_PROG ] || _notrun "Quota user tools not ins=
talled"
>>>>
>>>> =A0 =A0 =A0case $FSTYP in
>>>> - =A0 =A0ext2|ext3|ext4|reiserfs)
>>>> + =A0 =A0ext2|ext3|ext4|ext4dev|reiserfs)
>>>> =A0 =A0 =A0 if [ ! -d /proc/sys/fs/quota ]; then
>>>> =A0 =A0 =A0 =A0 =A0 _notrun "Installed kernel does not support quo=
tas"
>>>> =A0 =A0 =A0 fi
>>>> @@ -237,7 +237,7 @@ _check_quota_usage()
>>>> =A0 =A0 =A0 # Sync to get delalloc to disk
>>>> =A0 =A0 =A0 sync
>>>> =A0 =A0 =A0 VFS_QUOTA=3D0
>>>> - =A0 =A0 if [ $FSTYP =3D "ext2" -o $FSTYP =3D "ext3" -o $FSTYP =3D=
 "ext4" -o $FSTYP =3D "reiserfs" ]; then
>>>> + =A0 =A0 if [ $FSTYP =3D "ext2" -o $FSTYP =3D "ext3" -o $FSTYP =3D=
 "ext4" -o $FSTYP =3D "ext4dev" -o $FSTYP =3D "reiserfs" ]; then
>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 VFS_QUOTA=3D1
>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 quotaon -f -u -g $SCRATCH_MNT 2>/dev/n=
ull
>>>> =A0 =A0 =A0 fi
>>>
>>> Perhaps this should be changes to a case statement?
>>>
>>
>> you're making me go to v3 in such a trivial patch, but ok, I'll do i=
t ;-)
>>
>
> I rechecked the fsck -t ext4dev vs. fsck.ext4dev.
> fsck -t ext4dev doesn't work for me :-(
> Sergey has a newer version of =A0util-linux-ng
> see:
>
> amir@qalab:~/xfstests$ sudo fsck -t ext4dev -nf /dev/sda5
> fsck from util-linux-ng 2.17.2
> e2fsck 1.41.14 (22-Dec-2010)
> /dev/sda5 has unsupported feature(s): FEATURE_C7 FEATURE_C8 FEATURE_R=
7
> e2fsck: Get a newer version of e2fsck!

OK, after upgrading to newer util-linux and building it from git,
which also didn't help, I finally found who to blame - me.
I had an old (noauto) entry in /etc/fstab which claimed that /dev/sda5 =
is ext4.
fsck was picking up that entry and insisting that /dev/sda5 is ext4
(regardless of what it really is)
blkid isn't doing that silly thing.

Amir
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
