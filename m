From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 0/2] ext3: Reduce calling ext3_mark_inode_dirty() for speedup
Date: Mon, 30 Jan 2012 13:36:14 -0700
Message-ID: <97F0BDAD-B6D8-4246-B790-E269025F4A7D@dilger.ca>
References: <4F2657AD.9060901@sx.jp.nec.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: ext4 <linux-ext4@vger.kernel.org>, Jan Kara <jack@suse.cz>
To: Kazuya Mio <k-mio@sx.jp.nec.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:61869 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753762Ab2A3UgP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 30 Jan 2012 15:36:15 -0500
In-Reply-To: <4F2657AD.9060901@sx.jp.nec.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2012-01-30, at 1:41 AM, Kazuya Mio wrote:
> ext3 has a performance problem that parallel write is too slow.
> I looked into this and found out that ext3 calls ext3_mark_inode_dirty()
> unnecessarily.
> 
> The following result is the time of writing 16 files whose size are 3GB
> by 16 threads. This measurement was performed in linux3.3-rc1 with
> 4-way server, 512GB memory.
> 
>    filesystem        time(sec)  call ext3_mark_inode_dirty(times)
>    ---
>    ext3              220.5      50,338,104
>    ext3 (patched)    196.3      25,169,658
>    ext4 (*1)         190.3      28,465,799
> 
>    *1 disable ext4-specific option (delalloc, extent, and so on)

Can you please run this same measurement on ext4 formatted and running
with the default options?  I'd like to know if this is still a problem
in ext4 or not.


There is a better mechanism to handle the inode updates that could be
implemented if there is still a real performance concern.  There are
journal pre-commit callbacks on the buffer heads that could be run to
copy the modified data from the VFS inodes to the buffer blocks.

This would reduce the ext4_mark_inode_dirty() to setting a single dirty
flag in the inode, and updating the VFS inode ctime.  Only once per
journal commit would the VFS inode be copied into the buffer, greatly
reducing the overhead of these operations.  This should also noticeably
reduce the overhead from metadata checksums, since the checksum would
only be computed once for each inode per journal commit.

> ext3 in RHEL5.5 clearly shows the difference in performance.
> Writing by the same method takes 533 seconds, though writing by one thread
> takes 191 seconds.
> 
> Every time we write one page, ext3 calls ext3_mark_inode_dirty() four times.
> Two of these are unnecessary in many case, so I add the conditions to call
> the function only when it is necessary.
> 
>      sys_write
>        ...
>          __generic_file_aio_write
>            file_update_time
>              mark_inode_dirty_sync
>            generic_file_buffered_write
>              ...
>                ext3_get_blocks_handle
>                  ext3_write_begin
>                    ...
>                      ext3_new_blocks
>                        vfs_dq_alloc_block
>    1)                    mark_inode_dirty
>                        vfs_dq_free_block
>    2)                    mark_inode_dirty      <-- patch 1/2
>                    ext3_splice_branch
>    3)                ext3_mark_inode_dirty     <-- patch 2/2
>                  ext3_ordered_write_end
>                    update_file_sizes
>    4)                mark_inode_dirty
> 
> Regards,
> Kazuya Mio


Cheers, Andreas





