From: Jan Kara <jack@suse.cz>
Subject: Re: Still about ext2/ext3 mount options while using ext4.ko driver
Date: Tue, 7 Jan 2014 14:34:18 +0100
Message-ID: <20140107133418.GE16640@quack.suse.cz>
References: <20131209212531.GB4296@orion.maiolino.org>
 <20131210001353.GA19933@thunk.org>
 <20140106182847.GA27709@orion.maiolino.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Carlos Maiolino <cmaiolino@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59854 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750910AbaAGNeV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 7 Jan 2014 08:34:21 -0500
Content-Disposition: inline
In-Reply-To: <20140106182847.GA27709@orion.maiolino.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 06-01-14 16:28:47, Carlos Maiolino wrote:
> Hi Ted, and, happy new year for you and everybody :)
> 
> 
> On Mon, Dec 09, 2013 at 07:13:53PM -0500, Theodore Ts'o wrote:
> > On Mon, Dec 09, 2013 at 07:25:31PM -0200, Carlos Maiolino wrote:
> > > 
> > > But, there are still some mount options that IMHO needs a review of what should
> > > and shouldn't be allowed while using ext4 to mount ex2/3 filesystems.
> > > 
> > > max_batch_time=5 #I'm not sure ir this has any gain for ext2 and if it might
> > > 		  work well with ext3, any comments?
> > > min_batch_time=5 #same as above
> > > 
> > > journal_ioprio=5 #doesn't make sense for ext2, but might be useful for ext3 FS?!
> > > 
> > > journal=11 #doesn't make sense for ext2
> > > 
> > > barrier=1 #doesn't make sense for ext2
> > > 
> > > barrier #doesn't make sense for ext2
> > > 
> > > nobarrier #doesn't make sense for ext2
> > > 
> > > commit=5  #doesn't make sense for ext2
> > > 
> > > abort  #call ext4_abort(), devel usage only, and it fails to put ext2 FS on RO,
> > >        if this should be kept enabled, I can look why ext2 keep RW after its use
> > > 
> > 
> > These are all journal-related options, so they simply have no effect
> > for ext2 file systems.  (The abort mount option is a test facility
> > which was introduced in the ext3 days to test whether or not the
> > journal abort feature worked correctly.)  They don't make sense for
> > ext4 file systems that don't have a journal enabled, so maybe the
> > right thing to do is to either refuse the mount or print a warning
> > message indicating that the mount option is going to be ignored since
> > no journal is present.
> > 
> 
> IMHO, refusing to mount looks a better option to me, although these options have
> no effect over ext2, refusing to mount them might save us from some possible
> future regressions and less options to test for each filesystem.
  So I agree we can disallow mount options which are obviously non-sensical
(e.g. commit=5 for ext2). OTOH I don't agree with 'less options to test'
part - you can always create a filesystem with the set of features
corresponding to ext3 and mount it as ext4 with appropriate set of options.
And if we don't prohibit that, there is an expectation it should work (and
frankly this is what a sysadmin is going to do if he wants to use his ext3
filesystem with some mount option we will allow only for ext4 mounts)... So
by forbidding some options with ext3 we aren't removing any functionality
needing testing. We are only making it a tad bit harder to run some
combinations of features / mount options.

And as a side note 'barrier' mount option isn't strictly journal related
and it is useful for ext2 for a reliable fsync(2) implementation. So that
is an example of a mount option I would object to removing from ext2
compatibility mode.

> > > auto_da_alloc    #ext4 only
> > > 
> > > noauto_da_alloc  #same as above
> > 
> > In Ext2 and ext3 mode, nodelalloc is the default, but in theory a user
> > could explicitly request delayed allocation using the delalloc mount
> > option.  There's a bit of a philosophical question hiding here about
> > whether you want to prohibit users who might want to use ext2/ext3 but
> > still want to enable delalloc.
> > 
> >
> #See my last comment
> 
> > > discard		 #ex2 shouldn't be allowed to use it ?!
> > > 
> > > nodiscard	 #same as above
> > 
> > Meh; if you use discard, and you crash in the middle of the unlink you
> > could lose data.  But you use ext2 and you crash in the middle of
> > something, you're likely to lose data anyway.  This just amplifies it
> > a bit more.
> > 
> > 
> > > block_validity   #ext4 and debugging purposes only, should be off for ext2/3 too
> > > 
> > > noblock_validity #same as above
> > 
> > I don't see any harm in allowing block_validity; it's a debugging
> > feature that can be useful in ext2 and ext3 modes.
> > 
> 
> > > 
> > > i_version  # I believe this is only valid for Ext4 
> > 
> > Well, you can have a file system with a larger (> 128 bytes) inode
> > with ext2 or ext3.  So in theory you could make i_version work.  I'm
> > not sure it matters a whole lot in either direction.
> > 
> #See my last comment
> 
> The goal of my discussion regarding these options is exactly to address
> problems that these philosophical questions and the non-well tested
> 'theories' might trigger and reduce the amount of corner cases we need to
> test for regressions and other things, once, IMHO, if we allow an option
> to be used, unless specified in the Documentation as a devel-only feature
> (or something like that), we need to have it tested.
> 
> From one point, would be nice to have ext2/ext3 filesystems taking
> advantage of features like delayed allocation and others
> features/options, but, from another, it just means more things we need to
> keep testing for regressions, etc.
> 
> My question here is: are we willing to support and maintain these kind of
> features for ext2/ext3 or should we just prohibit it? Maybe we should
> just leave it as-is and explicitly describe in the Documentation that
> some features are not well tested on ext2/ext3 and leave the decision of
> supporting or not for enterprise distros.
  See my comment above - I don't think you can reduce amount of testing by
disallowing some mount options for ext2/ext3 mounts. You could do that by
disallowing some feature x 'mount option' combinations but that would be a
hell for sysadmins unless done in a very systematic way.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
