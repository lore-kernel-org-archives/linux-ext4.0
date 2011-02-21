From: Dave Chinner <david@fromorbit.com>
Subject: Re: [LSF/MM TOPIC] Drop ext2/ext3 codebase? When?
Date: Tue, 22 Feb 2011 10:48:43 +1100
Message-ID: <20110221234843.GE3166@dastard>
References: <20110203144011.GA28409@quack.suse.cz>
 <4D4AC4E2.701@redhat.com>
 <AANLkTi=YxSpgm9vYHBKdASpLOaY_U3=ggsE8yTg_G0Bc@mail.gmail.com>
 <20110204131739.GC4104@quack.suse.cz>
 <AANLkTin=6wY6y0LZCDtMGiy8vmdok=UUj-7rmsTPAVuh@mail.gmail.com>
 <20110214172504.GC3018@quack.suse.cz>
 <AANLkTimdApPPK6FkH+CPrXdNpND6_twE2voRiNhgQOOE@mail.gmail.com>
 <20110214195845.GD4255@thunk.org>
 <20110215042837.GD13052@dastard>
 <20110215172922.GG4255@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Amir Goldstein <amir73il@gmail.com>, Jan Kara <jack@suse.cz>,
	Michael Rubin <mrubin@google.com>,
	Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:50971 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751331Ab1BUXsr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 21 Feb 2011 18:48:47 -0500
Content-Disposition: inline
In-Reply-To: <20110215172922.GG4255@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Feb 15, 2011 at 12:29:22PM -0500, Ted Ts'o wrote:
> On Tue, Feb 15, 2011 at 03:28:37PM +1100, Dave Chinner wrote:
> > 
> > What scripts are needed? xfstests has the $MKFS_OPTIONS and
> > $MOUNT_OPTIONS environment variables for customising your mkfs and
> > mount parameters for each test run, so isn't testing ext3
> > filesystems with the ext4 code should just be a matter of setting
> > these appropriately?
> 
> Correct, this doesn't require changes to xfstests.
> 
> What is needed for this ext4/ext3-using-ext4 testing is a wrapper
> script *around* xfstests that sets up the enviornment variables
> correctly, and uses different devices for the "common case"
> combinations of mkfs and mount options (where we would keep an aged
> file system around), and for those devices which we don't think are
> valuable enough to dedicate a reserved file system image, we'd have to
> mkfs a special version of that filesystem for TEST_DEV.

Every developer has their own set of wrapper scripts for doing just
this. Every test environment is different, so I'm not sure there is
a one-size-fits-all script waiting here.

In the past I've considered extending this sort of test
configuration to the configuration files and adding a command line
parameter to select the config file that defines the test setup. I
think you can specify the config file via the HOST_OPTIONS env
variable right now, but I haven't looked any further than that.

FWIW, I keep all my config files in a patch I apply to my xfstests
git repo before I rsync it to all my test machines, so this approach
would work for me, too. ;)

> (I'm not sure why xfstests doesn't use freshly created file in the
> case where SCRATCH_DEV is defined by TEST_DEV is not, but it doesn't;

I'm not sure what you are asking for here...

> as far as I know there are no tests where it uses both TEST_DEV and
> SCRATCH_DEV, is there?)

There are tests that do this (e.g. 073) - maybe none of the
generic tests do right now, but there are XFS specific tests that
do.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
