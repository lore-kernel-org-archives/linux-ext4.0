From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: EXT4 nodelalloc => back to stone age.
Date: Mon, 01 Apr 2013 15:06:18 +0400
Message-ID: <87d2uese6t.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Cc: linux-fsdevel@vger.kernel.org, axboe@kernel.dk,
	Jan Kara <jack@suse.cz>
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-la0-f52.google.com ([209.85.215.52]:59797 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751104Ab3DALGX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 1 Apr 2013 07:06:23 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--=-=-=


I've mounted ext4 with -onodelalloc on my SSD (INTEL SSDSA2CW120G3,4PC10362)
It shows numbers which are slower than HDD which was produced 15 years ago
#mount  $SCRATCH_DEV $SCRATCH_MNT -onodelalloc
# dd if=/dev/zero of=/mnt_scratch/file bs=1M count=1024 conv=fsync,notrunc
  1073741824 bytes (1.1 GB) copied, 46.7948 s, 22.9 MB/s
# dd if=/dev/zero of=/mnt_scratch/file bs=1M count=1024 conv=fsync,notrunc
  1073741824 bytes (1.1 GB) copied, 41.2717 s, 26.0 MB/s
blktrace shows horrible traces:

--=-=-=
Content-Disposition: inline; filename=trace.log

253,1    0       11     0.004965203 13618  Q  WS 1219360 + 8 [jbd2/dm-1-8]
253,1    0       11     0.004965203 13618  Q  WS 1219360 + 8 [jbd2/dm-1-8]
253,1    0       11     0.004965203 13618  Q  WS 1219360 + 8 [jbd2/dm-1-8]
253,1    0       11     0.004965203 13618  Q  WS 1219360 + 8 [jbd2/dm-1-8]
253,1    1       39     0.004983642     0  C  WS 1219344 + 8 [0]
253,1    1       39     0.004983642     0  C  WS 1219344 + 8 [0]
253,1    1       39     0.004983642     0  C  WS 1219344 + 8 [0]
253,1    1       39     0.004983642     0  C  WS 1219344 + 8 [0]
253,1    1       40     0.005082898     0  C  WS 1219352 + 8 [0]
253,1    1       40     0.005082898     0  C  WS 1219352 + 8 [0]
253,1    1       40     0.005082898     0  C  WS 1219352 + 8 [0]
253,1    1       40     0.005082898     0  C  WS 1219352 + 8 [0]
253,1    3       12     0.005106049  2580  Q   W 1219368 + 8 [flush-253:1]
253,1    3       12     0.005106049  2580  Q   W 1219368 + 8 [flush-253:1]
253,1    3       12     0.005106049  2580  Q   W 1219368 + 8 [flush-253:1]
253,1    3       12     0.005106049  2580  Q   W 1219368 + 8 [flush-253:1]
253,1    2       17     0.005197143 13750  Q  WS 1219376 + 8 [dd]
253,1    2       17     0.005197143 13750  Q  WS 1219376 + 8 [dd]
253,1    2       17     0.005197143 13750  Q  WS 1219376 + 8 [dd]
253,1    2       17     0.005197143 13750  Q  WS 1219376 + 8 [dd]
253,1    1       41     0.005199871     0  C  WS 1219360 + 8 [0]
253,1    1       41     0.005199871     0  C  WS 1219360 + 8 [0]
253,1    1       41     0.005199871     0  C  WS 1219360 + 8 [0]
253,1    1       41     0.005199871     0  C  WS 1219360 + 8 [0]

--=-=-=


As one can see data written from two threads dd and jbd2 on per-page basis and
jbd2 submit pages with WRITE_SYNC  i.e. we write page-by-page
synchronously :)

Exact calltrace:
journal_submit_inode_data_buffers
 wbc.sync_mode =  WB_SYNC_ALL
 ->generic_writepages
   ->write_cache_pages
     ->ext4_writepage
       ->ext4_bio_write_page
         ->io_submit_add_bh
           ->io_submit_init
             io->io_op = (wbc->sync_mode == WB_SYNC_ALL ?  WRITE_SYNC :
             WRITE);
       ->ext4_io_submit(io);

1)Do we really have to use WRITE_SYNC in case of WB_SYNC_ALL ?
  Why blk_finish_plug(&plug) which is called from generic_writepages() is
  not enough? As far as I can see this code was copy-pasted from XFS,
  also DIO also tag bio-s with WRITE_SYNC, but what happen if file
  is highly fragmented (or block device is RAID0) we will endup doing
  synchronous io.

2) Why don't we have writepages for non delalloc case ?

I want to fix (2) by implementing writepages() for non delalloc case
Once this will be done we may add new flag WB_SYNC_NOALLOC so
journal_submit_inode_data_buffers will use
__filemap_fdatawrite_range(, , , WB_SYNC_ALL| WB_SYNC_NOALLC)
which will call optimized ->ext4_writepages() 


--=-=-=--
