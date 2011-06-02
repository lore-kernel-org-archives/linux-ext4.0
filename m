From: "Amir G." <amir73il@users.sourceforge.net>
Subject: Re: [PATCH v2] xfstests: add support for ext4dev FSTYP
Date: Thu, 2 Jun 2011 10:11:43 +0300
Message-ID: <BANLkTinJcvvv2pfXBt7EZ9TXONb9jRe0uQ@mail.gmail.com>
References: <1306933012-8666-1-git-send-email-amir73il@users.sourceforge.net>
	<20110601232804.GL32466@dastard>
	<BANLkTi=sV5=PyZvNSd=DGNW-V84=27d7Yw@mail.gmail.com>
	<BANLkTimbPWfOJKq6er4mnSYNPcx6VHLcrw@mail.gmail.com>
	<20110602030802.GR561@dastard>
	<BANLkTi=sPM_AYB4w=N5pWHfws9R3WnfJVw@mail.gmail.com>
	<20110602064040.GS561@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: xfs@oss.sgi.com, sandeen@redhat.com, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, sergey57@gmail.com,
	Amir Goldstein <amir73il@users.sf.net>
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:44872 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757542Ab1FBHLo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 2 Jun 2011 03:11:44 -0400
In-Reply-To: <20110602064040.GS561@dastard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jun 2, 2011 at 9:40 AM, Dave Chinner <david@fromorbit.com> wrot=
e:
> On Thu, Jun 02, 2011 at 06:49:20AM +0300, Amir G. wrote:
>> On Thu, Jun 2, 2011 at 6:08 AM, Dave Chinner <david@fromorbit.com> w=
rote:
>> > On Thu, Jun 02, 2011 at 05:33:34AM +0300, Amir G. wrote:
>> >> On Thu, Jun 2, 2011 at 5:16 AM, Amir G. <amir73il@users.sourcefor=
ge.net> wrote:
>> >> > On Thu, Jun 2, 2011 at 2:28 AM, Dave Chinner <david@fromorbit.c=
om> wrote:
>> > Personally I think that ext4dev shouldn't be supported at all. A
>> > special fstyp iwhile ext4 was being developed was, IMO, a stupid
>> > thing to do in the first place, and I was happy when it died. It
>> > should not be resurrected and propagated.
>> >
>> > xfstests assumes that you are using a userspace that is current wi=
th
>> > the version of the filesystem the kernel supports. If you are
>> > running a development/special branch of ext4, then you need to be
>> > running a userspace that understands it completely. If all you are
>> > doing with the ext4dev fstyp is trying to vector to a different fs=
ck
>> > program that supports a new set of feature bits, then IMO you are
>> > doing it all wrong.
>> >
>> > Fundamentally, the filesystem is either ext4 or it isn't. If the
>> > features are never going to make it into mainline ext4, then you
>> > need a completely different fstype and full userspace support for
>> > that fstype. Once you have that, you can add the fstype support to
>> > xfstests. However, just using a different fstyp just to set a
>> > certain set of feature flags is, again IMO, a pretty stupid way of
>> > going about this.
>> >
>>
>> The features are going into mainline, but are not there yet.
>
> So using feature bits as they were intended is the right thing to
> do, isn't it?

I am not sure what you mean by that.
The fact that to this day fsck.ext2/3/4 have always been the same
file (hence support the same feature set) does not mean that they have
to be that way by design.

on my test system fsck.ext4dev must be used to test ext4dev, which has
newer features than ext4.
I fail to see the problem with that.

>
>> I did not invent the ext4dev standard, which is pretty well supporte=
d
>> by all relevant tools, but I find it very convenient for the testing=
=2E
>
> As I understand it, ext4dev is deprecated and should not be used for
> any new filesystems. When did that status change?
>
> Or did you just start using it because it's convenient for your
> purposes? =A0What happens when someone else decides to use ext4dev fo=
r
> testing incompatible development features because it is convenient
> for them?
>

The way I see it, ext4dev is a tool for ext4 developers (and testers).
Anyone can use it for their own needs and it would be convenient for ev=
eryone.
I never suggested that Fedora push my ext4dev utils as a standard packa=
ge.
But me and my group can use it to test the snapshots feature and Ted
and his group can use it to test the allocation clusters feature.


>> Especially, when I expect my testers to be running a stable
>> distro release (i.e. F15 or Ubuntu 11.4) and be able to install
>> my experimental ext4dev module and utils, without it affecting
>> their (most likely) root ext4/ext3 fs.
>
> So get them to use an ext3, XFS, reiser or JFS root filesystem if
> that's your major concern. That's long been a best practice for
> configuring a filesystem test box - don't use the same filesystem
> for your root/stable filesystems as the filesytsem you are testing.
>
> e.g. If you pick ext3 for the root filesystem, then you can test
> ext4, btrfs, xfs, etc changes without having to worry about whether
> the development module being tested is going to affect your root
> filesystem....

You make it sound as if I have a flock of testers out there waiting for
me to feed them with use cases to test and who abide to my setup
instructions.

Wake up call! this is not the case for me and for most developers.
If I'm lucky, I can get a e few testers who will say:
OK, if all I have to do is download this package and run 'make test'
I can spare an hour to play with it.

So, yes, it's true. There are other ways to accomplish what I am doing,
but I am going out of my way to try to make the life of developers and =
testers
easier and you are doing the exact opposite by raising objections to a =
rather
trivial and harmless patch.

Let me ask you this: which FSTYP will be useful to more developers
ext4dev or reiserfs?

>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
