From: Dave Chinner <david@fromorbit.com>
Subject: Re: [LSF/MM TOPIC] Drop ext2/ext3 codebase? When?
Date: Tue, 15 Feb 2011 15:28:37 +1100
Message-ID: <20110215042837.GD13052@dastard>
References: <20110203144011.GA28409@quack.suse.cz>
 <4D4AC4E2.701@redhat.com>
 <AANLkTi=YxSpgm9vYHBKdASpLOaY_U3=ggsE8yTg_G0Bc@mail.gmail.com>
 <20110204131739.GC4104@quack.suse.cz>
 <AANLkTin=6wY6y0LZCDtMGiy8vmdok=UUj-7rmsTPAVuh@mail.gmail.com>
 <20110214172504.GC3018@quack.suse.cz>
 <AANLkTimdApPPK6FkH+CPrXdNpND6_twE2voRiNhgQOOE@mail.gmail.com>
 <20110214195845.GD4255@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Amir Goldstein <amir73il@gmail.com>, Jan Kara <jack@suse.cz>,
	Michael Rubin <mrubin@google.com>,
	Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:28967 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751231Ab1BOEdq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 14 Feb 2011 23:33:46 -0500
Content-Disposition: inline
In-Reply-To: <20110214195845.GD4255@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Feb 14, 2011 at 02:58:45PM -0500, Ted Ts'o wrote:
> -lsf-pc, -linux-fsdevel
> 
> On Mon, Feb 14, 2011 at 09:00:58PM +0200, Amir Goldstein wrote:
> > Yes, of course. Upgraders won't be the ones using snapshots.
> > My intension was to state that those people installing new systems to test
> > snapshots would be functioning as testers for "ext3 mode", because:
> > 1. when no snapshots exists it boils down to testing "ext3 mode".
> > 2. it is unlikely that snapshots will mask "ext3 mode" bugs.
> > 
> > So my claim is that "ext3 mode" would benefit from a transition
> > period in which snapshots and (extens,delalloc) are mutually
> > exclusive in ext4.
> 
> Here are the requirements that I think are critical before we do this:
> 
> 1) We need to solve the testing matrix problem.  Right now "ext3 mode"
> in ext4 doesn't get enough testing as it is.  Part of the solution is
> (a) deciding on the modes that need testing, and (b) writing some
> shell scripts so that xfstests can be automatically run in all of the
> right modes.  And then it will be having some number of people
> (hopefully not just me) running said tests and reporting failures.

What scripts are needed? xfstests has the $MKFS_OPTIONS and
$MOUNT_OPTIONS environment variables for customising your mkfs and
mount parameters for each test run, so isn't testing ext3
filesystems with the ext4 code should just be a matter of setting
these appropriately?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
