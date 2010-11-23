From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [patch] fs: fix deadlocks in writeback_if_idle
Date: Tue, 23 Nov 2010 07:34:07 -0500
Message-ID: <1290515274-sup-3895@think>
References: <20101123100239.GA4232@amd>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	Jan Kara <jack@suse.cz>, Eric Sandeen <sandeen@redhat.com>,
	"Theodore Ts'o" <tytso@mit.edu>
To: Nick Piggin <npiggin@kernel.dk>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-reply-to: <20101123100239.GA4232@amd>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Excerpts from Nick Piggin's message of 2010-11-23 05:02:39 -0500:

[ ... ]

> 
> Avoid both these issues by issuing completely asynchronous writeback request in
> writeback_inodes_sb_if_idle. Don't let that fool you into thinking these
> functions don't suck any more.
> 
> ext4 now passes extensive stress testing with xfstests, fs_mark, dbench,
> with a writeback_inodes_if_idle call added directly into ext4_da_write_begin
> to trigger the path frequently. Previously it would spew lockdep stuff and
> hang in a number of ways very quickly.
> 
> Signed-off-by: Nick Piggin <npiggin@kernel.dk>
> 
> ---
>  fs/fs-writeback.c |   32 ++++++++++++++++++++------------
>  1 file changed, 20 insertions(+), 12 deletions(-)
> 
> Index: linux-2.6/fs/fs-writeback.c
> ===================================================================
> --- linux-2.6.orig/fs/fs-writeback.c    2010-11-23 20:57:23.000000000 +1100
> +++ linux-2.6/fs/fs-writeback.c    2010-11-23 20:59:10.000000000 +1100
> @@ -1152,16 +1152,17 @@ EXPORT_SYMBOL(writeback_inodes_sb);
>   *
>   * Invoke writeback_inodes_sb if no writeback is currently underway.
>   * Returns 1 if writeback was started, 0 if not.
> + *
> + * Even if 1 is returned, writeback may not be started if memory allocation
> + * fails. This function makes no guarantees about anything.
>   */
>  int writeback_inodes_sb_if_idle(struct super_block *sb)
>  {
>      if (!writeback_in_progress(sb->s_bdi)) {
> -        down_read(&sb->s_umount);
> -        writeback_inodes_sb(sb);
> -        up_read(&sb->s_umount);
> +        bdi_start_writeback(sb->s_bdi, get_nr_dirty_pages());

I'll put on my skis and channel Christoph for a minute.  This isn't
quite the same as the original.  writeback_inodes_sb() writes inodes on a
specific super block, while bdi_start_writeback() writes them for any SB
on that bdi.

For btrfs there's only one bdi per SB, but for most everyone else a disk
with a bunch of partitions is going to have multiple filesystems on the
same bdi.

My original btrfs patch just exported the bdi_ funcs so that btrfs could
do the above internally.  But Christoph objected, and I think he's
right.  We should either give everyone a bdi or make sure the writeback
func kicks only one filesystem.

-chris
