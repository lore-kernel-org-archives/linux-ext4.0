From: Theodore Tso <tytso@mit.edu>
Subject: Re: fsck errors encountered when applying patch "ext4: fix BUG
	when calling ext4_error with locked block group"
Date: Fri, 20 Feb 2009 20:29:08 -0500
Message-ID: <20090221012908.GC12966@mini-me.lan>
References: <d5ca277e0902201531g6e32691cweda3fd8f6d1dbbff@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, aneesh.kumar@linux.vnet.ibm.com,
	Michael Rubin <mrubin@google.com>,
	Curt Wohlgemuth <curtw@google.com>,
	Chad Talbott <ctalbott@google.com>,
	Frank Mayhar <fmayhar@google.com>
To: Xiang Wang <xiangw@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:59161 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754397AbZBUBaB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 20 Feb 2009 20:30:01 -0500
Content-Disposition: inline
In-Reply-To: <d5ca277e0902201531g6e32691cweda3fd8f6d1dbbff@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Feb 20, 2009 at 03:31:36PM -0800, Xiang Wang wrote:
> We hit filesystem errors reported by fsck after we run dbench, an
> example of the error is as follows:
> // run dbench
> dbench complete!
> starting fsck...
> e2fsck 1.41.3 (12-Oct-2008)
> /dev/hdk3 contains a file system with errors, check forced.

Hmm, that's interesting.  Can you check the system logs and see what
sort of errors were flagged by ext4?  There may have been some sort of
issue which caused the filesystem to set the ERROR_FS flag.  It would
be useful to see what the filesystem complained about.

> This problem seems to be the number of free inodes stored in the ext4
> super block does not match the number counted by reading the inode
> bitmaps.
> 
> Then I looked into the patch, especially the diff in the
> ext4_commit_super in fs/ext4/super.c
> http://git.kernel.org/?p=linux/kernel/git/tytso/ext4.git;a=blobdiff;f=fs/ext4/super.c;h=c53cab1e0a7fca1d9406f9bbb7c9cb661bae0567;hp=ed0406de6cae7379df9f72f272ade1a18df3966b;hb=be8f3df12cddeb352dd624fba9bf46a2de5711f3;hpb=e8470671cf71ec6361b71b3c95a1a1392c5cfa75
> 
> @@ -2868,8 +2906,11 @@ static void ext4_commit_super(struct super_block *sb,
>                 set_buffer_uptodate(sbh);
>         }
>         es->s_wtime = cpu_to_le32(get_seconds());
> -       ext4_free_blocks_count_set(es, ext4_count_free_blocks(sb));
> -       es->s_free_inodes_count = cpu_to_le32(ext4_count_free_inodes(sb));
> +       ext4_free_blocks_count_set(es, percpu_counter_sum_positive(
> +                                       &EXT4_SB(sb)->s_freeblocks_counter));
> +       es->s_free_inodes_count = cpu_to_le32(percpu_counter_sum_positive(
> +                                       &EXT4_SB(sb)->s_freeinodes_counter));
> +
>         BUFFER_TRACE(sbh, "marking dirty");
>         mark_buffer_dirty(sbh);
>         if (sync) {
> 
> seems like the new code only looks into the s_freeinodes_counter field
> while the old code calls ext4_count_free_inodes(sb) and calculates the
> count by adding up the free inode number from each block group.

I'm guessing the problem here is that you didn't take these commits:

	02d211688727ad02bb4555b1aa8ae2de16b21b39
	71c5576fbd809f2015f4eddf72e501e298720cf3

... which fixes a problem which would cause inaccuracies in the percpu
counters due to races that would be tend to show up under a workload
such as dbench.  Read the commit description of these two commits very
carefully, since there are potentially other users of the percpu
counters, and this changes the semantics of percpu_counter_sum().

Note that the percpu_counter race conditions can lead to problems
where the delayed allocation code might not notice that the disk has
filled, leading to data being lost without the application getting an
ENOSPC return from a write() system call.

One of the downsides of trying to backport a lot of changes to a
kernel version as old as 2.6.26 is that you miss changes like this.
You might want to think about leapfrogging to a newer kernel at some
point....

						- Ted

