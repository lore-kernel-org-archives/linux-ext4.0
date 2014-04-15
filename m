From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] ext4: add fallocate mode blocking for debugging purposes
Date: Wed, 16 Apr 2014 09:25:56 +1000
Message-ID: <20140415232556.GS15995@dastard>
References: <1397420518-29218-1-git-send-email-tytso@mit.edu>
 <20140413220016.GD8122@thunk.org>
 <alpine.LFD.2.00.1404151749490.2146@localhost.localdomain>
 <534D5B2D.70408@redhat.com>
 <20140415184442.GC4456@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>,
	=?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Namjae Jeon <linkinjeon@gmail.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:11874 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751278AbaDOX0P (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 15 Apr 2014 19:26:15 -0400
Content-Disposition: inline
In-Reply-To: <20140415184442.GC4456@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Apr 15, 2014 at 02:44:42PM -0400, Theodore Ts'o wrote:
> On Tue, Apr 15, 2014 at 11:15:41AM -0500, Eric Sandeen wrote:
> > 
> > I tend to agree, better to fix the kernel than to add a knob to turn it
> > off.  And fsx changes can happen a lot quicker than kernel changes.  [1]
> > 
> > And if it's really unsafe, and you really want to add a knob, I'd at least
> > default it to off until it's non-corrupting, and add a message that
> > this tunable will go away as soon as it's stable, so you'll have no
> > qualms about quickly deprecating it...
> 
> Yeah, I went back and forth on this.  One of there reasons why I added
> a kernel knob is that *I* can make the kernel change a lot faster than
> it would be to tweak all of the various xfstests program to globally
> disable certain operations in fsx, fstress, etc.

Actually, we shouldn't be changing xfstests or adding workarounds in
the kernel to avoid certain operations. We should be fixing the damn
bugs that are being exposed.

Yes, the addition of zero range and collapse range to fsx and
fsstress has exposed bugs in the XFS code as well, and that causes
assert failures all over the place. But that's a *good thing* - now
those bugs are all fixed and ready to be sent to Linus:

http://oss.sgi.com/cgi-bin/gitweb.cgi?p=xfs/xfs.git;a=shortlog;h=refs/heads/xfs-fixes-for-3.15-rc2

And so in a couple of days the problem goes away for everyone using
XFS. Do the same (i.e. fix the bugs) for ext4, and the problem goes
away.

> I also had a sneaking suspicion that we might have a similar issue
> with the INSERT RANGE patches which are coming down the pike, and so
> having a general way of also being able INSERT RANGE if to be able to
> quickly determine whether a potential bug was caused by INSERT RANGE
> or some other pending changes might also be useful.

Well, only if you ignore the lesson we've just learnt.

i.e. that we have to add the FALLOC_FL_INSERT_RANGE to fsx and
fsstress as well as having corner case tests and it needs to pass
those tests before XFS support is ready for upstream inclusion. At
least, that's the lesson I learnt from as the xfstests and XFS
Maintainer - we didn't put the QA bar for inclusion high enough, and
so problems slipped through.

If you want to add more strict testing requirements for ext4
inclusion, then you're welcome to request them for the ext4
implementation of that functionality. You don't have to accept the
code until you're happy with it....

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com
