From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/2] ext4: avoid hangs in
 ext4_da_should_update_i_disksize()
Date: Mon, 12 Dec 2011 21:27:22 +0100
Message-ID: <20111212202722.GA5214@quack.suse.cz>
References: <1323656828-24465-1-git-send-email-aarcange@redhat.com>
 <1323656828-24465-2-git-send-email-aarcange@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Theodore Tso <tytso@MIT.EDU>,
	Jan Kara <jack@suse.cz>
To: Andrea Arcangeli <aarcange@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52571 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751203Ab1LLU1Z (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 12 Dec 2011 15:27:25 -0500
Content-Disposition: inline
In-Reply-To: <1323656828-24465-2-git-send-email-aarcange@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 12-12-11 03:27:07, Andrea Arcangeli wrote:
> If the pte mapping in generic_perform_write() is unmapped between
> iov_iter_fault_in_readable() and iov_iter_copy_from_user_atomic(), the
> "copied" parameter to ->end_write can be zero. ext4 couldn't cope with
> it with delayed allocations enabled.
  I'd expand this sentence with: because ext4_da_should_update_i_disksize()
is passed -1 as an offset and loops (almost) infinitely.
  I know it's also in the gdb dump below but it takes a while to notice it
if you don't know what you are looking for.

> This skips the i_disksize
> enlargement logic if copied is zero and no new data was appeneded to
> the inode.
> 
>  gdb> bt
>  #0  0xffffffff811afe80 in ext4_da_should_update_i_disksize (file=0xffff88003f606a80, mapping=0xffff88001d3824e0, pos=0x1\
>  08000, len=0x1000, copied=0x0, page=0xffffea0000d792e8, fsdata=0x0) at fs/ext4/inode.c:2467
>  #1  ext4_da_write_end (file=0xffff88003f606a80, mapping=0xffff88001d3824e0, pos=0x108000, len=0x1000, copied=0x0, page=0\
>  xffffea0000d792e8, fsdata=0x0) at fs/ext4/inode.c:2512
>  #2  0xffffffff810d97f1 in generic_perform_write (iocb=<value optimized out>, iov=<value optimized out>, nr_segs=<value o\
>  ptimized out>, pos=0x108000, ppos=0xffff88001e26be40, count=<value optimized out>, written=0x0) at mm/filemap.c:2440
>  #3  generic_file_buffered_write (iocb=<value optimized out>, iov=<value optimized out>, nr_segs=<value optimized out>, p\
>  os=0x108000, ppos=0xffff88001e26be40, count=<value optimized out>, written=0x0) at mm/filemap.c:2482
>  #4  0xffffffff810db5d1 in __generic_file_aio_write (iocb=0xffff88001e26bde8, iov=0xffff88001e26bec8, nr_segs=0x1, ppos=0\
>  xffff88001e26be40) at mm/filemap.c:2600
>  #5  0xffffffff810db853 in generic_file_aio_write (iocb=0xffff88001e26bde8, iov=0xffff88001e26bec8, nr_segs=<value optimi\
>  zed out>, pos=<value optimized out>) at mm/filemap.c:2632
>  #6  0xffffffff811a71aa in ext4_file_write (iocb=0xffff88001e26bde8, iov=0xffff88001e26bec8, nr_segs=0x1, pos=0x108000) a\
>  t fs/ext4/file.c:136
>  #7  0xffffffff811375aa in do_sync_write (filp=0xffff88003f606a80, buf=<value optimized out>, len=<value optimized out>, \
>  ppos=0xffff88001e26bf48) at fs/read_write.c:406
>  #8  0xffffffff81137e56 in vfs_write (file=0xffff88003f606a80, buf=0x1ec2960 <Address 0x1ec2960 out of bounds>, count=0x4\
>  000, pos=0xffff88001e26bf48) at fs/read_write.c:435
>  #9  0xffffffff8113816c in sys_write (fd=<value optimized out>, buf=0x1ec2960 <Address 0x1ec2960 out of bounds>, count=0x\
>  4000) at fs/read_write.c:487
>  #10 <signal handler called>
>  #11 0x00007f120077a390 in __brk_reservation_fn_dmi_alloc__ ()
>  #12 0x0000000000000000 in ?? ()
>  gdb> print offset
>  $22 = 0xffffffffffffffff
>  gdb> print idx
>  $23 = 0xffffffff
>  gdb> print inode->i_blkbits
>  $24 = 0xc
>  gdb> up
>  #1  ext4_da_write_end (file=0xffff88003f606a80, mapping=0xffff88001d3824e0, pos=0x108000, len=0x1000, copied=0x0, page=0\
>  xffffea0000d792e8, fsdata=0x0) at fs/ext4/inode.c:2512
>  2512                    if (ext4_da_should_update_i_disksize(page, end)) {
>  gdb> print start
>  $25 = 0x0
>  gdb> print end
>  $26 = 0xffffffffffffffff
>  gdb> print pos
>  $27 = 0x108000
>  gdb> print new_i_size
>  $28 = 0x108000
>  gdb> print ((struct ext4_inode_info *)((char *)inode-((int)(&((struct ext4_inode_info *)0)->vfs_inode))))->i_disksize
>  $29 = 0xd9000
>  gdb> down
>  2467            for (i = 0; i < idx; i++)
>  gdb> print i
>  $30 = 0xd44acbee
> 
> This is 100% reproducible with some autonuma development code tuned in
> a very aggressive manner (not normal way even for knumad) which does
> "exotic" changes to the ptes. It wouldn't normally trigger but I don't
> see why it can't happen normally if the page is added to swap cache in
> between the two faults leading to "copied" being zero (which then
> hangs in ext4). So it should be fixed. Especially possible with lumpy
> reclaim (albeit disabled if compaction is enabled) as that would
> ignore the young bits in the ptes.
> 
> Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
  You can add:
Reviewed-by: Jan Kara <jack@suse.cz>

								Honza
> ---
>  fs/ext4/inode.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index fffec40..63f9541 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -2508,7 +2508,7 @@ static int ext4_da_write_end(struct file *file,
>  	 */
>  
>  	new_i_size = pos + copied;
> -	if (new_i_size > EXT4_I(inode)->i_disksize) {
> +	if (copied && new_i_size > EXT4_I(inode)->i_disksize) {
>  		if (ext4_da_should_update_i_disksize(page, end)) {
>  			down_write(&EXT4_I(inode)->i_data_sem);
>  			if (new_i_size > EXT4_I(inode)->i_disksize) {
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
