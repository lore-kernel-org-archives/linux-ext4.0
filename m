From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/5] jbd: strictly check for write errors on data
 buffers
Date: Wed, 4 Jun 2008 14:58:48 -0700
Message-ID: <20080604145848.e3da6f20.akpm@linux-foundation.org>
References: <4843CE15.6080506@hitachi.com>
	<4843CEED.9080002@hitachi.com>
	<20080603153050.fb99ac8a.akpm@linux-foundation.org>
	<20080604101925.GB16572@duck.suse.cz>
	<20080604111911.c1fe09c6.akpm@linux-foundation.org>
	<20080604212202.GA8727@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: jack@suse.cz, hidehiro.kawai.ez@hitachi.com, sct@redhat.com,
	adilger@sun.com, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, jbacik@redhat.com, cmm@us.ibm.com,
	yumiko.sugita.yf@hitachi.com, satoshi.oshima.fk@hitachi.com
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51013 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758194AbYFDV7p (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 4 Jun 2008 17:59:45 -0400
In-Reply-To: <20080604212202.GA8727@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 4 Jun 2008 17:22:02 -0400
Theodore Tso <tytso@mit.edu> wrote:

> On Wed, Jun 04, 2008 at 11:19:11AM -0700, Andrew Morton wrote:
> > Does any other filesystem driver turn the fs read-only on the first
> > write-IO-error?

^^ this?

> > It seems like a big policy change to me.  For a lot of applications
> > it's effectively a complete outage and people might get a bit upset if
> > this happens on the first blip from their NAS.
> 
> As I told Kawai-san when I met with him and his colleagues in Tokyo
> last week, it is the responsibility of the storage stack to retry
> errors as appropriate.  From the filesystem perspective, a read or a
> write operation succeeds, or fails.  A read or write operation could
> take a long time before returning, but the storage stack doesn't get
> to return a "fail, but try again at some point; maybe we'll succeed
> later, or if you try writing to a different block".  The only sane
> thing for a filesystem to do is to treat any failure as a hard
> failure.
> 
> It is similarly insane to ask a filesystem to figure out that a newly
> plugged in USB stick is the same one that the user had accidentally
> unplugged 30 seconds ago.  We don't want to put that kind of low-level
> knowlede about storage details in each different filesystem.
> 
> A much better place to put that kind of smarts is in a multipath
> module which sits in between the device and the filesystem.  It can
> retry writes from a transient failure, if a path goes down or if a
> iSCSI device temporarily drops off the network.

That's fine in theory, but we don't do any if that right now, do we?

>  But if a filesystem
> gets a write failure, it has to assume that the write failure is
> permanent.

To that sector, yes.  But to the entire partition?

(Well, if the entire partition became unwriteable then we don't have a
problem.  It's "parts are writeable" or "it became writeable again
later which is the problem).


> The question though is what should you do if you have a write failure
> in various different parts of the disk?  If you have a write failure
> in a data block, you can return -EIO to the user.

Absolutely.

But afaict this patch changes things so that if we get a write failure
in a data block we make the entire fs read-only.  Which, as I said, is
often "dead box".

This seems like a quite major policy change to me.

>  You could try
> reallocating to find another block, and try writing to that alternate
> location (although with modern filesystems that do block remapping,
> this is largely pointless, since an EIO failure on write probably
> means you've lost connectivity to the disk or the disk as run out of
> spare blocks).  But for a failure to write to the a critical part of
> the filesystem, like the inode table, or failure to write to the
> journal, what the heck can you do?  Remounting read-only is probably
> the best thing you can do.

Ah, yes, I agree, a write error to the journal or to metadata is a
quite different thing.  An unwriteable journal block is surely
terminal.  And a write error during metadata checkpointing is pretty
horrid ebcause we've (potentially) already told userspace that the
write was successful.

But should we treat plain old data blocks in the same way?

> In theory, if it is a failure to write to the journal, you could fall
> back to no-journaled operation, and if ext3 could support running w/o
> a journal, that is possibly an option --- but again, it's very likely
> that the disk is totally gone (i.e., the user pulled the USB stick
> without unmounting), or the disk is out of spare blocks in its bad
> block remapping pool, and the system is probably going to be in deep
> trouble --- and the next failure to write some data might be critical
> application data.  You probably *are* better off failing the system
> hard, and letting the HA system swap in the hot spare backup, if this
> is some critical service.
> 
> That being said, ext3 can be tuned (and it is the default today,
> although I should probably change the default to be remount-ro), so
> that its behaviour on write errors is, "don't worry, be happy", and
> just leave the filesystem mounted read/write.  That's actually quite
> dangerous for a critical production server, however.....
> 


