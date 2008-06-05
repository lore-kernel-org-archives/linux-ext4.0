From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/5] jbd: strictly check for write errors on data
	buffers
Date: Thu, 5 Jun 2008 11:35:37 +0200
Message-ID: <20080605093536.GE27370@duck.suse.cz>
References: <4843CE15.6080506@hitachi.com> <4843CEED.9080002@hitachi.com> <20080603153050.fb99ac8a.akpm@linux-foundation.org> <20080604101925.GB16572@duck.suse.cz> <20080604111911.c1fe09c6.akpm@linux-foundation.org> <20080604212202.GA8727@mit.edu> <20080604145848.e3da6f20.akpm@linux-foundation.org> <20080604225155.GB8727@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Theodore Tso <tytso@mit.edu>,
	Andrew Morton <akpm@linux-foundation.org>,
	hidehiro.kawai.ez@hitachi.com, sct@redhat.com, adilger@sun.com,
	linux-kernel@vger.kernel.org, linux-ext4@vger.
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:48712 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751551AbYFEJfj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 5 Jun 2008 05:35:39 -0400
Content-Disposition: inline
In-Reply-To: <20080604225155.GB8727@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed 04-06-08 18:51:55, Theodore Tso wrote:
> On Wed, Jun 04, 2008 at 02:58:48PM -0700, Andrew Morton wrote:
> > On Wed, 4 Jun 2008 17:22:02 -0400
> > Theodore Tso <tytso@mit.edu> wrote:
> > 
> > > On Wed, Jun 04, 2008 at 11:19:11AM -0700, Andrew Morton wrote:
> > > > Does any other filesystem driver turn the fs read-only on the first
> > > > write-IO-error?
> > 
> 
> For failures to write to data blocks, I don't think any other
> filesystems turn the filesystem read-only.  Not that many other
> filesystems do the remount on read-only thing in general; remounting
> read/only is something that might be unique to ext2/3/4.
> 
> > > It is similarly insane to ask a filesystem to figure out that a newly
> > > plugged in USB stick is the same one that the user had accidentally
> > > unplugged 30 seconds ago.  We don't want to put that kind of low-level
> > > knowlede about storage details in each different filesystem.
> > > 
> > > A much better place to put that kind of smarts is in a multipath
> > > module which sits in between the device and the filesystem.  It can
> > > retry writes from a transient failure, if a path goes down or if a
> > > iSCSI device temporarily drops off the network.
> > 
> > That's fine in theory, but we don't do any if that right now, do we?
> 
> No, but I think it's insane to put any of this into the filesystem.  I
> don't want to put words in other people's mouths, but Mingming and I
> were chatting with Chris Mason the last two days at a BTRFS workshop
> (which is why we've been a bit slow on responding), and when discussed
> this thread informally, he agreed that it was really bad idea to try
> to put this kind of retry logic in an individual filesystem.
> 
> > >  But if a filesystem
> > > gets a write failure, it has to assume that the write failure is
> > > permanent.
> > 
> > To that sector, yes.  But to the entire partition?
> 
> I agree it's a bad idea.  OTOH, we really need a good way of notifying
> a system daemon or administrator, and not just rely on the application
> to DTRT when it receives an -EIO.  Probably what we should do is (1)
> return -EIO, (2) send a uevent that includes as much information as
> possible.  At the minimum, the block that had the write (or read)
> error, and if available the file name involved, and application and/or
> pid involved.  That way, the policy of what should happen in case of a
> data I/O error can be informed by what write just failed.  It might be
> that if the failure is to some critical application data, the right
> thing to do is to kill of the application server and let the HA system
> bring up the hotbackup.  Or if the failure is writing to a log file,
> some other recovery procedure is the right thing.   
> 
> But forcing the entire filesystem read-only just because of a write
> failure to a data block is probably not the best way to go.
  OK, you've convinced me that aborting journal because of EIO on data
block isn't the best thing to do. But it is a bit problematic to return EIO
to userspace - we usually find this in commit code so we work on behalf of
kjournald and user already thinks the write has succeeded (which is
basically problem of any cached write). So the best thing we can do is set
AS_EIO on the mapping and hope userspace will notice (we report such error
when user does fsync/sync/sync_file_range).
  Sending some event to userspace is certainly possible but can hardly be
more specific than "IO error at block %lu of file %s".

> > But afaict this patch changes things so that if we get a write failure
> > in a data block we make the entire fs read-only.  Which, as I said, is
> > often "dead box".
> > 
> > This seems like a quite major policy change to me.
> 
> Agreed, and it's not appropriate.  I could imagine that for some
> setups it is the right policy, but the kernel should not be setting
> policy like this.  Maybe as a new tunable in the superblock, or maybe
> via a round-trip to userspace via a uevent, but certainly not as the
> new default behavior.
  Yes, I believe a tunable in superblock controlling how do we behave on
EIO error in data block would be the best solution.

> Apologies, I'm still catching up on patches sent in the past few days,
> so I haven't had a chance to do a detailed review on Kawai-san's
> patches yet.  I do agree that if this patch is forcing the entire
> filesystem read-only on a write-failure to a data block, it's probably
> not appropriate.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
