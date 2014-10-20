From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: Valgrind-detected issues in e2fsck on corrupted filesystems
Date: Mon, 20 Oct 2014 13:57:36 -0700
Message-ID: <20141020205736.GB13081@birch.djwong.org>
References: <20141018232320.GA4392@sli.dy.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Sami Liedes <sami.liedes@iki.fi>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:40600 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753080AbaJTU5v (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 20 Oct 2014 16:57:51 -0400
Content-Disposition: inline
In-Reply-To: <20141018232320.GA4392@sli.dy.fi>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Oct 19, 2014 at 02:23:21AM +0300, Sami Liedes wrote:
> Hi,
> 
> Here are some issues that fuzz testing and running under valgrind
> discovered on e2fsck. All of them are from current master branch of
> e2fsprogs (commit 6a0f113535cdc4937b60f763667a545183b98c85).
> 
> The pristine image is
> 
>    http://www.niksula.hut.fi/~sliedes/ext4/testimg.ext4.pristine.bz2
> 
> The broken images are minimally different from the pristine in the
> sense that after un-flipping any of the flipped bits I could no longer
> reproduce the issue.
> 
> All were produced by running
> 
>   valgrind e2fsck -f -y image
> 
> using an e2fsck compiled with -g -O0.
> 
> 
> 1. memcpy with dest==src
> ========================
> 
> Image: http://www.niksula.hut.fi/~sliedes/e2fsck/testimg.ext4.1.min.bz2
> 
> 1-bit diff from pristine:
> 
>   http://www.niksula.hut.fi/~sliedes/e2fsck/testimg.ext4.1.min.diff
> 
> Valgrind output:
> 
>   Source and destination overlap in memcpy(0x5608c00, 0x5608c00, 1024)
>      at 0x4C2D75D: memcpy@@GLIBC_2.14 (vg_replace_strmem.c:915)
>      by 0x46D4C8: unix_write_blk64 (unix_io.c:826)
>      by 0x45CFAB: io_channel_write_blk64 (io_manager.c:94)
>      by 0x431C01: e2fsck_handle_read_error (ehandler.c:63)
>      by 0x46C1CD: raw_read_blk (unix_io.c:201)
>      by 0x46D1EF: unix_read_blk64 (unix_io.c:743)
>      by 0x45CF1B: io_channel_read_blk64 (io_manager.c:78)
>      by 0x44B609: ext2fs_read_dir_block4 (dirblock.c:30)
>      by 0x44C523: ext2fs_process_dir_block (dir_iterate.c:211)
>      by 0x4465C3: ext2fs_block_iterate3 (block.c:526)
>      by 0x44C370: ext2fs_dir_iterate2 (dir_iterate.c:126)
> 
> Full log: http://www.niksula.hut.fi/~sliedes/e2fsck/testimg.ext4.1.min.log

Heh.  On read error, the read_error handler is fed a pointer from the internal
block cache, which in this case is fed directly back into the write routine
(because e2fsck apparently tries to rewrite blocks when read errors happen.

The dumb solution is to only do the memcpy if (cache->block != buf) but that's
not a comprehensive fix.  I guess we could duplicate the buffer and pass that
around ... unless it's supposed to be a feature that the error handlers can
muck with the IO manager's internal cache state?  The pointer isn't const, so
they're perfectly welcome to do that.

> 2. Out-of-bounds read
> =====================
> 
> Image: http://www.niksula.hut.fi/~sliedes/e2fsck/testimg.ext4.33.min.bz2
> 
> 2-bit diff: http://www.niksula.hut.fi/~sliedes/e2fsck/testimg.ext4.33.min.diff
> 
> Valgrind output:
> 
>   Invalid read of size 2
>      at 0x44C0D7: ext2fs_get_rec_len (dir_iterate.c:31)
>      by 0x44C5A4: ext2fs_process_dir_block (dir_iterate.c:227)
>      by 0x44644F: ext2fs_block_iterate3 (block.c:492)
>      by 0x44C370: ext2fs_dir_iterate2 (dir_iterate.c:126)
>      by 0x44C45C: ext2fs_dir_iterate (dir_iterate.c:174)
>      by 0x456A52: ext2fs_get_pathname_int (get_pathname.c:100)
>      by 0x456D56: ext2fs_get_pathname (get_pathname.c:167)
>      by 0x4329C2: print_pathname (message.c:209)
>      by 0x4334A4: expand_percent_expression (message.c:473)
>      by 0x433817: print_e2fsck_message (message.c:552)
>      by 0x432B81: expand_at_expression (message.c:259)
>      by 0x433717: print_e2fsck_message (message.c:536)
>    Address 0x5719840 is 0 bytes after a block of size 1,024 alloc'd
>      at 0x4C28C20: malloc (vg_replace_malloc.c:296)
>      by 0x45911B: ext2fs_get_mem (ext2fs.h:1694)
>      by 0x456D11: ext2fs_get_pathname (get_pathname.c:162)
>      by 0x4329C2: print_pathname (message.c:209)
>      by 0x4334A4: expand_percent_expression (message.c:473)
>      by 0x433817: print_e2fsck_message (message.c:552)
>      by 0x432B81: expand_at_expression (message.c:259)
>      by 0x433717: print_e2fsck_message (message.c:536)
>      by 0x4325D1: fix_problem (problem.c:2130)
>      by 0x4254D0: check_dir_block (pass2.c:1286)
>      by 0x44AF96: ext2fs_dblist_iterate2 (dblist.c:211)
>      by 0x422E34: e2fsck_pass2 (pass2.c:149)
> 
> Full log: http://www.niksula.hut.fi/~sliedes/e2fsck/testimg.ext4.33.min.log

This is caused by the "offset < buflen" check in ext2fs_process_dir_block()
failing to notice that we can't call ext2fs_get_rec_len() if the distance
between offset and buflen is less than 6 bytes.

> 3. Use after free
> =================
> 
> Image: http://www.niksula.hut.fi/~sliedes/e2fsck/testimg.ext4.56745.min.bz2
> 
> 6-bit diff: http://www.niksula.hut.fi/~sliedes/e2fsck/testimg.ext4.56745.min.diff
> 
> Valgrind output:
> 
>   Invalid read of size 4
>      at 0x430D20: e2fsck_get_dir_info (dirinfo.c:230)
>      by 0x43139F: e2fsck_dir_info_set_dotdot (dirinfo.c:422)
>      by 0x428644: fix_dotdot (pass3.c:739)
>      by 0x4275AB: check_directory (pass3.c:322)
>      by 0x426E3F: e2fsck_pass3 (pass3.c:108)
>      by 0x4149DF: e2fsck_run (e2fsck.c:230)
>      by 0x4139E6: main (unix.c:1649)
>    Address 0x599d54c is 12 bytes inside a block of size 4,428 free'd
>      at 0x4C2AF2E: realloc (vg_replace_malloc.c:692)
>      by 0x4592CA: ext2fs_resize_mem (ext2fs.h:1759)
>      by 0x4309C0: e2fsck_add_dir_info (dirinfo.c:139)
>      by 0x427EA6: e2fsck_get_lost_and_found (pass3.c:550)
>      by 0x427FE0: e2fsck_reconnect_file (pass3.c:579)
>      by 0x42757A: check_directory (pass3.c:319)
>      by 0x426E3F: e2fsck_pass3 (pass3.c:108)
>      by 0x4149DF: e2fsck_run (e2fsck.c:230)
>      by 0x4139E6: main (unix.c:1649)
>   
>   Invalid write of size 4
>      at 0x4313B9: e2fsck_dir_info_set_dotdot (dirinfo.c:425)
>      by 0x428644: fix_dotdot (pass3.c:739)
>      by 0x4275AB: check_directory (pass3.c:322)
>      by 0x426E3F: e2fsck_pass3 (pass3.c:108)
>      by 0x4149DF: e2fsck_run (e2fsck.c:230)
>      by 0x4139E6: main (unix.c:1649)
>    Address 0x599d550 is 16 bytes inside a block of size 4,428 free'd
>      at 0x4C2AF2E: realloc (vg_replace_malloc.c:692)
>      by 0x4592CA: ext2fs_resize_mem (ext2fs.h:1759)
>      by 0x4309C0: e2fsck_add_dir_info (dirinfo.c:139)
>      by 0x427EA6: e2fsck_get_lost_and_found (pass3.c:550)
>      by 0x427FE0: e2fsck_reconnect_file (pass3.c:579)
>      by 0x42757A: check_directory (pass3.c:319)
>      by 0x426E3F: e2fsck_pass3 (pass3.c:108)
>      by 0x4149DF: e2fsck_run (e2fsck.c:230)
>      by 0x4139E6: main (unix.c:1649)
> 
>   [... 6 more similar errors]
> 
> Full log: http://www.niksula.hut.fi/~sliedes/e2fsck/testimg.ext4.56745.min.log

This is caused by the e2fsck dir_info structure maintaining a pointer (to cache
an array lookup) into an array that gets realloc'd.

> 4. Writing uninitialized data
> =============================
> 
> Image: http://www.niksula.hut.fi/~sliedes/e2fsck/testimg.ext4.12340.min.bz2
> 
> 2-bit diff: http://www.niksula.hut.fi/~sliedes/e2fsck/testimg.ext4.12340.min.diff
> 
> Valgrind output:
> 
>   Syscall param pwrite64(buf) points to uninitialised byte(s)
>      at 0x4E442F3: __pwrite_nocancel (syscall-template.S:81)
>      by 0x46C2DC: raw_write_blk (unix_io.c:234)
>      by 0x46C7E4: reuse_cache (unix_io.c:395)
>      by 0x46D1CC: unix_read_blk64 (unix_io.c:742)
>      by 0x45CF1B: io_channel_read_blk64 (io_manager.c:78)
>      by 0x44B609: ext2fs_read_dir_block4 (dirblock.c:30)
>      by 0x424895: check_dir_block (pass2.c:937)
>      by 0x44AF96: ext2fs_dblist_iterate2 (dblist.c:211)
>      by 0x422E34: e2fsck_pass2 (pass2.c:149)
>      by 0x4149DF: e2fsck_run (e2fsck.c:230)
>      by 0x4139E6: main (unix.c:1649)
>    Address 0x560904c is 12 bytes inside a block of size 1,024 alloc'd
>      at 0x4C28C20: malloc (vg_replace_malloc.c:296)
>      by 0x45911B: ext2fs_get_mem (ext2fs.h:1694)
>      by 0x45D0D0: io_channel_alloc_buf (io_manager.c:129)
>      by 0x46C583: alloc_cache (unix_io.c:324)
>      by 0x46CC9D: unix_open (unix_io.c:576)
>      by 0x4606C9: ext2fs_open2 (openfs.c:159)
>      by 0x4121D3: try_open_fs (unix.c:1073)
>      by 0x412A54: main (unix.c:1286)
> 
> Full log: http://www.niksula.hut.fi/~sliedes/e2fsck/testimg.ext4.12340.min.log

This is a side effect of ext2fs_xattrs_write() not zeroing the disk buffer
before writing out the EA block, which exposes heap contents.

Thanks for catching these!  I'll have patches out shortly.

--D
> 
> 	Sami


