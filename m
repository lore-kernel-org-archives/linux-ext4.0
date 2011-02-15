From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [LSF/MM TOPIC] Drop ext2/ext3 codebase? When?
Date: Tue, 15 Feb 2011 12:29:22 -0500
Message-ID: <20110215172922.GG4255@thunk.org>
References: <20110203144011.GA28409@quack.suse.cz>
 <4D4AC4E2.701@redhat.com>
 <AANLkTi=YxSpgm9vYHBKdASpLOaY_U3=ggsE8yTg_G0Bc@mail.gmail.com>
 <20110204131739.GC4104@quack.suse.cz>
 <AANLkTin=6wY6y0LZCDtMGiy8vmdok=UUj-7rmsTPAVuh@mail.gmail.com>
 <20110214172504.GC3018@quack.suse.cz>
 <AANLkTimdApPPK6FkH+CPrXdNpND6_twE2voRiNhgQOOE@mail.gmail.com>
 <20110214195845.GD4255@thunk.org>
 <20110215042837.GD13052@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Amir Goldstein <amir73il@gmail.com>, Jan Kara <jack@suse.cz>,
	Michael Rubin <mrubin@google.com>,
	Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:42939 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755728Ab1BOR3l (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 15 Feb 2011 12:29:41 -0500
Content-Disposition: inline
In-Reply-To: <20110215042837.GD13052@dastard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Feb 15, 2011 at 03:28:37PM +1100, Dave Chinner wrote:
> 
> What scripts are needed? xfstests has the $MKFS_OPTIONS and
> $MOUNT_OPTIONS environment variables for customising your mkfs and
> mount parameters for each test run, so isn't testing ext3
> filesystems with the ext4 code should just be a matter of setting
> these appropriately?

Correct, this doesn't require changes to xfstests.

What is needed for this ext4/ext3-using-ext4 testing is a wrapper
script *around* xfstests that sets up the enviornment variables
correctly, and uses different devices for the "common case"
combinations of mkfs and mount options (where we would keep an aged
file system around), and for those devices which we don't think are
valuable enough to dedicate a reserved file system image, we'd have to
mkfs a special version of that filesystem for TEST_DEV.

(I'm not sure why xfstests doesn't use freshly created file in the
case where SCRATCH_DEV is defined by TEST_DEV is not, but it doesn't;
as far as I know there are no tests where it uses both TEST_DEV and
SCRATCH_DEV, is there?)

							- Ted
