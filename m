From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2] xfstests: add support for ext4dev FSTYP
Date: Thu, 2 Jun 2011 16:40:40 +1000
Message-ID: <20110602064040.GS561@dastard>
References: <1306933012-8666-1-git-send-email-amir73il@users.sourceforge.net>
 <20110601232804.GL32466@dastard>
 <BANLkTi=sV5=PyZvNSd=DGNW-V84=27d7Yw@mail.gmail.com>
 <BANLkTimbPWfOJKq6er4mnSYNPcx6VHLcrw@mail.gmail.com>
 <20110602030802.GR561@dastard>
 <BANLkTi=sPM_AYB4w=N5pWHfws9R3WnfJVw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: xfs@oss.sgi.com, sandeen@redhat.com, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, sergey57@gmail.com,
	Amir Goldstein <amir73il@users.sf.net>
To: "Amir G." <amir73il@users.sourceforge.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:35518 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751361Ab1FBGkq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 2 Jun 2011 02:40:46 -0400
Content-Disposition: inline
In-Reply-To: <BANLkTi=sPM_AYB4w=N5pWHfws9R3WnfJVw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jun 02, 2011 at 06:49:20AM +0300, Amir G. wrote:
> On Thu, Jun 2, 2011 at 6:08 AM, Dave Chinner <david@fromorbit.com> wrote:
> > On Thu, Jun 02, 2011 at 05:33:34AM +0300, Amir G. wrote:
> >> On Thu, Jun 2, 2011 at 5:16 AM, Amir G. <amir73il@users.sourceforge.net> wrote:
> >> > On Thu, Jun 2, 2011 at 2:28 AM, Dave Chinner <david@fromorbit.com> wrote:
> > Personally I think that ext4dev shouldn't be supported at all. A
> > special fstyp iwhile ext4 was being developed was, IMO, a stupid
> > thing to do in the first place, and I was happy when it died. It
> > should not be resurrected and propagated.
> >
> > xfstests assumes that you are using a userspace that is current with
> > the version of the filesystem the kernel supports. If you are
> > running a development/special branch of ext4, then you need to be
> > running a userspace that understands it completely. If all you are
> > doing with the ext4dev fstyp is trying to vector to a different fsck
> > program that supports a new set of feature bits, then IMO you are
> > doing it all wrong.
> >
> > Fundamentally, the filesystem is either ext4 or it isn't. If the
> > features are never going to make it into mainline ext4, then you
> > need a completely different fstype and full userspace support for
> > that fstype. Once you have that, you can add the fstype support to
> > xfstests. However, just using a different fstyp just to set a
> > certain set of feature flags is, again IMO, a pretty stupid way of
> > going about this.
> >
> 
> The features are going into mainline, but are not there yet.

So using feature bits as they were intended is the right thing to
do, isn't it?

> I did not invent the ext4dev standard, which is pretty well supported
> by all relevant tools, but I find it very convenient for the testing.

As I understand it, ext4dev is deprecated and should not be used for
any new filesystems. When did that status change?

Or did you just start using it because it's convenient for your
purposes?  What happens when someone else decides to use ext4dev for
testing incompatible development features because it is convenient
for them?

> Especially, when I expect my testers to be running a stable
> distro release (i.e. F15 or Ubuntu 11.4) and be able to install
> my experimental ext4dev module and utils, without it affecting
> their (most likely) root ext4/ext3 fs.

So get them to use an ext3, XFS, reiser or JFS root filesystem if
that's your major concern. That's long been a best practice for
configuring a filesystem test box - don't use the same filesystem
for your root/stable filesystems as the filesytsem you are testing.

e.g. If you pick ext3 for the root filesystem, then you can test
ext4, btrfs, xfs, etc changes without having to worry about whether
the development module being tested is going to affect your root
filesystem....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
