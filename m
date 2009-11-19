From: tytso@mit.edu
Subject: Re: [PATCH 2/2] ext4: journal superblock modifications in
 ext4_statfs()
Date: Thu, 19 Nov 2009 14:08:46 -0500
Message-ID: <20091119190846.GB2099@thunk.org>
References: <4AF4A429.7090507@redhat.com>
 <6BDA2C94-6FA5-48EE-9E68-56BDFC4B558A@sun.com>
 <20091108214804.GC7592@mit.edu>
 <AB457F38-7E3A-43CE-B334-AE363BAE040C@sun.com>
 <20091115032941.GB4323@mit.edu>
 <F64B29C1-A90E-42F5-80CF-5704283D9A1B@sun.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Eric Sandeen <sandeen@redhat.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Andreas Dilger <andreas.dilger@lustre.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:37217 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755032AbZKSUc5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 19 Nov 2009 15:32:57 -0500
Content-Disposition: inline
In-Reply-To: <F64B29C1-A90E-42F5-80CF-5704283D9A1B@sun.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Nov 16, 2009 at 03:38:16PM -0800, Andreas Dilger wrote:
> 
> The problem is that if you do "e2fsck -fn" it will still report this
> as an error in the filesystem, even though "e2fsck -fp" will
> silently fix it.  I just repeated this test and still see errors,
> even 30 minutes after a file was modified, even after multiple
> syncs.

Sure, but running e2fsck -fn on a mounted file system will always
potentially show problems.   In fact, in your demonstration:

> [adilger@webber ~]$ sync; sleep 10; sync
> [adilger@webber ~]$ e2fsck -fn /dev/dm-0
> e2fsck 1.41.6.sun1 (30-May-2009)
> Warning!  /dev/dm-0 is mounted.
> Warning: skipping journal recovery because doing a read-only
> filesystem check.
	...
> Pass 1: Checking inodes, blocks, and sizes
> Deleted inode 884739 has zero dtime.  Fix? no
	...
> Pass 5: Checking group summary information
> Block bitmap differences:  -1784645
> Fix? no
> 
> Inode bitmap differences:  -884739
> Fix? no

.... neither of these errors would be fixed by the hacking of updating
the summary free blocks and inode counts.

If the concern is what happens when someone runs e2fsck -fn on a
mountd file system, I have a very hard time getting excited about
that....

> The other thing that comes to mind is that we don't recover the journal
> for a read-only e2fsck, but we DO recover it on a read-only mount
> seems inconsistent.  It wouldn't be hard to have e2fsck -n read the
> journal and
> persistently cache the journal blocks in its internal cache (i.e. flag
> them so they can't be discarded from cache) before it runs the rest
> of the
> e2fsck.

Eventually it would be nice if we did the same thing in both kernel
and userspace when doing a read-only mount/check: build a redirection
table that maps specific physical blocks to the block in the journal,
and whenever the system tries to access a specific physical block, we
look up the proper block to use instead in the redirection block.

The one tricky bit about doing this in the kernel is that we would
still have to replay the journal in the case of the read-only root.
Why?  Because otherwise older e2fsck's would get confused and replay
the journal, and that would lead to some potentially serious
confusion.  Even if we fix this in future versions of e2fsck, we still
need to be careful dealing with remounting a r/o filesystem to be
read/write, especially in the journal=data mode.

The simple way of handling journaled data blocks is to hack the
bmap() function to use the redirection block, but the problem with
doing that is the journal block will be left in the buffer heads in
the page cache.  If the file system is remounted r/w without first
flushing these buffer heads, future attempts to modify these pages in
the page cache could result in a random block in the journalling
getting corrupted by an update, instead of updating the proper final
location on disk for that data block.

If we have someone who is at least some basic experience in kernel
coding, but and an entry-level project getting involved with ext4,
this would be an ideal, self-contained thing to try doing.  I'd
suggest implementing it in userspace first, using the userspace/kernel
API framework that allows e2fsck/recovery.c to be roughly kept in sync
with fs/jbd[2]/recovery.c, and avoiding the hair of r/o roots by
always replaying the journal in the case of the root file system.
Anyone interested?  If so, let me know...

    			    	   		       - Ted
