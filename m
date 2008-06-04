From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 1/5] jbd: strictly check for write errors on data
	buffers
Date: Wed, 4 Jun 2008 18:51:55 -0400
Message-ID: <20080604225155.GB8727@mit.edu>
References: <4843CE15.6080506@hitachi.com> <4843CEED.9080002@hitachi.com> <20080603153050.fb99ac8a.akpm@linux-foundation.org> <20080604101925.GB16572@duck.suse.cz> <20080604111911.c1fe09c6.akpm@linux-foundation.org> <20080604212202.GA8727@mit.edu> <20080604145848.e3da6f20.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: jack@suse.cz, hidehiro.kawai.ez@hitachi.com, sct@redhat.com,
	adilger@sun.com, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, jbacik@redhat.com, cmm@us.ibm.com,
	yumiko.sugita.yf@hitachi.com, satoshi.oshima.fk@hitachi.com
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:51316 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752903AbYFDWwK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 4 Jun 2008 18:52:10 -0400
Content-Disposition: inline
In-Reply-To: <20080604145848.e3da6f20.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jun 04, 2008 at 02:58:48PM -0700, Andrew Morton wrote:
> On Wed, 4 Jun 2008 17:22:02 -0400
> Theodore Tso <tytso@mit.edu> wrote:
> 
> > On Wed, Jun 04, 2008 at 11:19:11AM -0700, Andrew Morton wrote:
> > > Does any other filesystem driver turn the fs read-only on the first
> > > write-IO-error?
> 

For failures to write to data blocks, I don't think any other
filesystems turn the filesystem read-only.  Not that many other
filesystems do the remount on read-only thing in general; remounting
read/only is something that might be unique to ext2/3/4.

> > It is similarly insane to ask a filesystem to figure out that a newly
> > plugged in USB stick is the same one that the user had accidentally
> > unplugged 30 seconds ago.  We don't want to put that kind of low-level
> > knowlede about storage details in each different filesystem.
> > 
> > A much better place to put that kind of smarts is in a multipath
> > module which sits in between the device and the filesystem.  It can
> > retry writes from a transient failure, if a path goes down or if a
> > iSCSI device temporarily drops off the network.
> 
> That's fine in theory, but we don't do any if that right now, do we?

No, but I think it's insane to put any of this into the filesystem.  I
don't want to put words in other people's mouths, but Mingming and I
were chatting with Chris Mason the last two days at a BTRFS workshop
(which is why we've been a bit slow on responding), and when discussed
this thread informally, he agreed that it was really bad idea to try
to put this kind of retry logic in an individual filesystem.

> >  But if a filesystem
> > gets a write failure, it has to assume that the write failure is
> > permanent.
> 
> To that sector, yes.  But to the entire partition?

I agree it's a bad idea.  OTOH, we really need a good way of notifying
a system daemon or administrator, and not just rely on the application
to DTRT when it receives an -EIO.  Probably what we should do is (1)
return -EIO, (2) send a uevent that includes as much information as
possible.  At the minimum, the block that had the write (or read)
error, and if available the file name involved, and application and/or
pid involved.  That way, the policy of what should happen in case of a
data I/O error can be informed by what write just failed.  It might be
that if the failure is to some critical application data, the right
thing to do is to kill of the application server and let the HA system
bring up the hotbackup.  Or if the failure is writing to a log file,
some other recovery procedure is the right thing.   

But forcing the entire filesystem read-only just because of a write
failure to a data block is probably not the best way to go.

> But afaict this patch changes things so that if we get a write failure
> in a data block we make the entire fs read-only.  Which, as I said, is
> often "dead box".
> 
> This seems like a quite major policy change to me.

Agreed, and it's not appropriate.  I could imagine that for some
setups it is the right policy, but the kernel should not be setting
policy like this.  Maybe as a new tunable in the superblock, or maybe
via a round-trip to userspace via a uevent, but certainly not as the
new default behavior.

Apologies, I'm still catching up on patches sent in the past few days,
so I haven't had a chance to do a detailed review on Kawai-san's
patches yet.  I do agree that if this patch is forcing the entire
filesystem read-only on a write-failure to a data block, it's probably
not appropriate.

							- Ted
