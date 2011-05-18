From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: xfstests: device busy when umount
Date: Wed, 18 May 2011 11:19:03 +0300
Message-ID: <BANLkTin_POPtikx-4zaVsW181bnXKP6k1Q@mail.gmail.com>
References: <BANLkTimQW+kyqjmzpAHH_W5x2v1EWW2AZA@mail.gmail.com>
	<4DD286E5.8090105@redhat.com>
	<BANLkTi=pZS6sTjS61UmpbOsj+vF+ithVvw@mail.gmail.com>
	<20110518063153.GZ19446@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Eric Sandeen <sandeen@redhat.com>,
	Yongqiang Yang <xiaoqiangnk@gmail.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	xfs-oss <xfs@oss.sgi.com>
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:48903 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754316Ab1ERITF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 18 May 2011 04:19:05 -0400
Received: by eyx24 with SMTP id 24so367264eyx.19
        for <linux-ext4@vger.kernel.org>; Wed, 18 May 2011 01:19:04 -0700 (PDT)
In-Reply-To: <20110518063153.GZ19446@dastard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, May 18, 2011 at 9:31 AM, Dave Chinner <david@fromorbit.com> wro=
te:
> On Tue, May 17, 2011 at 06:01:14PM +0300, Amir Goldstein wrote:
>> On Tue, May 17, 2011 at 5:32 PM, Eric Sandeen <sandeen@redhat.com> w=
rote:
>> > On 5/17/11 4:03 AM, Yongqiang Yang wrote:
>> >> Hi,
>> >>
>> >> I noticed that all tests which contain 'device busy' errors have
>> >> falloc operations. =A0Does the error have something to do with fa=
lloc?
>
> <shrug>
>
> Perhaps a bit more detail about what you are testing, how you've set
> up xfstests, etc, and some analysis of the problem is in order first?

<shrug>^2

Let me make it simple:

amir@qalab:~/xfstests$ uname -a
Linux qalab 2.6.39-rc7+ #11 SMP Mon May 16 12:08:52 IDT 2011 x86_64
x86_64 x86_64 GNU/Linux
amir@qalab:~/xfstests$ mount -t ext4
/dev/sdb1 on / type ext4 (rw,errors=3Dremount-ro,commit=3D0)
/dev/sda5 on /mnt/test/ext4 type ext4 (rw,acl,user_xattr)
amir@qalab:~/xfstests$ cat local.config
export DISABLE_UDF_TEST=3D1
export TEST_DEV=3D/dev/sda5
export TEST_DIR=3D/mnt/test/ext4
export SCRATCH_DEV=3D/dev/sda8
export SCRATCH_MNT=3D/mnt/test/scratch
amir@qalab:~/xfstests$ sudo ./check 124
=46STYP         -- ext4
PLATFORM      -- Linux/x86_64 qalab 2.6.39-rc7+
MKFS_OPTIONS  -- /dev/sda8
MOUNT_OPTIONS -- -o acl,user_xattr /dev/sda8 /mnt/test/scratch

124 9s ... - output mismatch (see 124.out.bad)
--- 124.out     2011-03-01 18:00:49.808338003 +0200
+++ 124.out.bad 2011-05-18 10:47:01.830998615 +0300
@@ -1 +1,4 @@
 QA output created by 124
+umount: /mnt/test/scratch: device is busy.
+        (In some cases useful info about processes that use
+         the device is found by lsof(8) or fuser(1))
Ran: 124
=46ailures: 124
=46ailed 1 of 1 tests
amir@qalab:~/xfstests$ mount -t ext4
/dev/sdb1 on / type ext4 (rw,errors=3Dremount-ro,commit=3D0)
/dev/sda8 on /mnt/test/scratch type ext4 (rw,acl,user_xattr)
/dev/sda5 on /mnt/test/ext4 type ext4 (rw,acl,user_xattr)
amir@qalab:~/xfstests$ sudo umount /mnt/test/scratch/
amir@qalab:~/xfstests$ mount -t ext4
/dev/sdb1 on / type ext4 (rw,errors=3Dremount-ro,commit=3D0)
/dev/sda5 on /mnt/test/ext4 type ext4 (rw,acl,user_xattr)

I am not trying anything special.
Running umount from command line after the test succeeds, so it must
be some kind of race.
As I said, I tried running lsof before umount in common.rc, but it
detected nothing.
Do you have any suggestions for further analysis?

>
>> > cc'ing xfs list since xfs devs maintain xfstests.
>> >
>> > What tests have "device busy" errors? =A0What do the usual investi=
gative
>> > steps such as "lsof" and "fuser" tell you when this happens?
>>
>> I tried running lsof | grep $TEST_DIR before umount
>> and I tried sleep 1 before umount and it didn't yield anything.
>
> Which usually indicates that you've got some kind of reference
> counting problem preventing the filesystem from being unmounted.

As I demonstrated, the filesystem *can* be unmounted.

>
>> > Are there loop devices that didn't get cleaned up, or processes th=
at
>> > have not terminated?
>> >
>> > What tests have these problems?
>>
>> for me 124 always fails to umount, and 198 and 213 sometimes fails t=
o umount.
>
> What, exactly, are you testing on? test 124 uses XFS_IOC_RESVSP
> directly, not fallocate(), so all it is doing on a non-XFS
> filesystem is iterating a loop that writes a 1MB file, reads it back
> then unlinks it....
>

Tell me about it...

The machine was a clean install of Ubuntu 10.10,
which was recently upgraded to Ubuntu 11.4, but this problem
existed since the beginning.

It is used for nothing but running tests and I only
installed packages required (to my understanding) by xfstests.
I just build xfstests from git (HEAD 30456902).

The kernel is latest 2.6.39-rc7 with ext4 dev branch changed,
but again, the problem existed with any previous/release kernel I tried=
=2E

Cheers,
Amir.
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
