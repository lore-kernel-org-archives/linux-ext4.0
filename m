From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH 2/2] ext4: journal superblock modifications in	ext4_statfs()
Date: Mon, 09 Nov 2009 10:55:23 -0700
Message-ID: <9E4901D7-A01C-42A5-A48B-B47C37B6843E@sun.com>
References: <4AF4A429.7090507@redhat.com>
 <6BDA2C94-6FA5-48EE-9E68-56BDFC4B558A@sun.com> <20091108214804.GC7592@mit.edu>
 <4AF741A4.9060907@redhat.com> <20091109125336.GF7592@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7BIT
Cc: Eric Sandeen <sandeen@redhat.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:42514 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752393AbZKIRzX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 9 Nov 2009 12:55:23 -0500
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id nA9HtShb000859
	for <linux-ext4@vger.kernel.org>; Mon, 9 Nov 2009 09:55:28 -0800 (PST)
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.04 64bit (built Jul  2 2009))
 id <0KSU00800P98MO00@fe-sfbay-09.sun.com> for linux-ext4@vger.kernel.org; Mon,
 09 Nov 2009 09:55:28 -0800 (PST)
In-reply-to: <20091109125336.GF7592@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2009-11-09, at 05:53, Theodore Tso wrote:
> On Sun, Nov 08, 2009 at 04:09:40PM -0600, Eric Sandeen wrote:
>> But don't we journal the superblock sometimes, not others ... for
>> example write_super -> ext4_write_super -> ext4_commit_super does no
>> journaling of superblock modifications. ext4_orphan_add, however,  
>> does.
>> This would likely lead to trouble w/ the debugging patch ... though I
>> didn't see it ... ?
>
> Ah, I had forgotten about ext4_orphan_add(); that is indeed the one
> place where we would be updating the super block under normal
> operations, besides online-resize.
>
> I've been looking at the write_super() paths, and from what I can tell
> it's only used in two places.  The generic fsync() handler,
> file_fsync(), which we do't use, and sync_supers(), which will indeed
> call write_super() -> ext4_write_super() if sb->s_dirt is set.  That
> led me to examine the places where we set s_dirt, and it's in a lot of
> places where we're no longer modifying the superblock any more, but
> we're still setting sb->s_dirt.  I don't know why you didn't see
> problems with the debugging patch; the only thing I can think of is
> that since the actual superblock update is deferred to a
> timer-triggered callback, you were getting consistently lucky ---
> which is hard for me to believe, but I don't have a better suggestion.

I suspect this is because the only thing that changes in the superblock
these days is the orphan list, so out-of-order writes to the superblock
will at worst result in a few entries added/missing from the orphan  
list.
I do recall that there are "inodes from a corrupt orphan list found"
messages seen occasionally during full e2fsck runs, but it has never
been important enough to investigate.

> What I think we do need to do is eliminate all of the places where we
> set sb->s_dirt, and if we need to update the superblock, we do it
> ourselves, under journaling control.

We have to ensure that writeout of the superblock is still being done
correctly during non-journal mode operation.

> That leaves places which call ext4_commit_super() directly, which is
> at mount and unmount time (which should be OK, as long as it's before
> or after journalling is active) and when we freeze the filesystem,
> which might be OK, but we need to take a careful look at it.


We also write out the superblock directly in ext4_error(), so that the
EXT4_ERROR_FS flag is written to disk (if at all possible) rather than
putting the superblock into a journal transaction that will not be
replayed (due to the transaction never committing after the journal is
aborted or the node panics).  Since that will be in the last transaction
anyways (unless errors=continue is used) I don't see it as a major  
problem.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

