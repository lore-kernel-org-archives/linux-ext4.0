From: Jan Kara <jack@suse.cz>
Subject: Re: EXT4 nodelalloc => back to stone age.
Date: Tue, 2 Apr 2013 15:46:34 +0200
Message-ID: <20130402134634.GB7999@quack.suse.cz>
References: <87d2uese6t.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	linux-fsdevel@vger.kernel.org, axboe@kernel.dk,
	Jan Kara <jack@suse.cz>
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87d2uese6t.fsf@openvz.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon 01-04-13 15:06:18, Dmitry Monakhov wrote:
> 
> I've mounted ext4 with -onodelalloc on my SSD (INTEL SSDSA2CW120G3,4PC10362)
> It shows numbers which are slower than HDD which was produced 15 years ago
> #mount  $SCRATCH_DEV $SCRATCH_MNT -onodelalloc
> # dd if=/dev/zero of=/mnt_scratch/file bs=1M count=1024 conv=fsync,notrunc
>   1073741824 bytes (1.1 GB) copied, 46.7948 s, 22.9 MB/s
> # dd if=/dev/zero of=/mnt_scratch/file bs=1M count=1024 conv=fsync,notrunc
>   1073741824 bytes (1.1 GB) copied, 41.2717 s, 26.0 MB/s
> blktrace shows horrible traces:

> 253,1    0       11     0.004965203 13618  Q  WS 1219360 + 8 [jbd2/dm-1-8]
> 253,1    0       11     0.004965203 13618  Q  WS 1219360 + 8 [jbd2/dm-1-8]
> 253,1    0       11     0.004965203 13618  Q  WS 1219360 + 8 [jbd2/dm-1-8]
> 253,1    0       11     0.004965203 13618  Q  WS 1219360 + 8 [jbd2/dm-1-8]
> 253,1    1       39     0.004983642     0  C  WS 1219344 + 8 [0]
> 253,1    1       39     0.004983642     0  C  WS 1219344 + 8 [0]
> 253,1    1       39     0.004983642     0  C  WS 1219344 + 8 [0]
> 253,1    1       39     0.004983642     0  C  WS 1219344 + 8 [0]
> 253,1    1       40     0.005082898     0  C  WS 1219352 + 8 [0]
> 253,1    1       40     0.005082898     0  C  WS 1219352 + 8 [0]
> 253,1    1       40     0.005082898     0  C  WS 1219352 + 8 [0]
> 253,1    1       40     0.005082898     0  C  WS 1219352 + 8 [0]
> 253,1    3       12     0.005106049  2580  Q   W 1219368 + 8 [flush-253:1]
> 253,1    3       12     0.005106049  2580  Q   W 1219368 + 8 [flush-253:1]
> 253,1    3       12     0.005106049  2580  Q   W 1219368 + 8 [flush-253:1]
> 253,1    3       12     0.005106049  2580  Q   W 1219368 + 8 [flush-253:1]
> 253,1    2       17     0.005197143 13750  Q  WS 1219376 + 8 [dd]
> 253,1    2       17     0.005197143 13750  Q  WS 1219376 + 8 [dd]
> 253,1    2       17     0.005197143 13750  Q  WS 1219376 + 8 [dd]
> 253,1    2       17     0.005197143 13750  Q  WS 1219376 + 8 [dd]
> 253,1    1       41     0.005199871     0  C  WS 1219360 + 8 [0]
> 253,1    1       41     0.005199871     0  C  WS 1219360 + 8 [0]
> 253,1    1       41     0.005199871     0  C  WS 1219360 + 8 [0]
> 253,1    1       41     0.005199871     0  C  WS 1219360 + 8 [0]
  Hum, not sure why you see all the events 4x. But that's not important I
guess.

> As one can see data written from two threads dd and jbd2 on per-page basis and
> jbd2 submit pages with WRITE_SYNC  i.e. we write page-by-page
> synchronously :)
>
> Exact calltrace:
> journal_submit_inode_data_buffers
>  wbc.sync_mode =  WB_SYNC_ALL
>  ->generic_writepages
>    ->write_cache_pages
>      ->ext4_writepage
>        ->ext4_bio_write_page
>          ->io_submit_add_bh
>            ->io_submit_init
>              io->io_op = (wbc->sync_mode == WB_SYNC_ALL ?  WRITE_SYNC :
>              WRITE);
>        ->ext4_io_submit(io);
> 
> 1)Do we really have to use WRITE_SYNC in case of WB_SYNC_ALL ?
  Actually WRITE_SYNC doesn't mean we write sychronously. We just tell the
IO scheduler that we are going to wait for the IO to complete soon. So it
prioritizes these writes against other async writes. We don't have to use
WRITE_SYNC but really in this case we do pretty much what IO scheduler
people want - flag IO that's going to be waited upon.

>   Why blk_finish_plug(&plug) which is called from generic_writepages() is
>   not enough? As far as I can see this code was copy-pasted from XFS,
>   also DIO also tag bio-s with WRITE_SYNC, but what happen if file
>   is highly fragmented (or block device is RAID0) we will endup doing
>   synchronous io.
  I see you are tracing the DM device. That may be actually somewhat
confusing since you are missing some actions like merges of requests and
dispatches to underlying device. 

> 2) Why don't we have writepages for non delalloc case ?
> 
> I want to fix (2) by implementing writepages() for non delalloc case
> Once this will be done we may add new flag WB_SYNC_NOALLOC so
> journal_submit_inode_data_buffers will use
> __filemap_fdatawrite_range(, , , WB_SYNC_ALL| WB_SYNC_NOALLC)
> which will call optimized ->ext4_writepages() 
  So what would you expect from ->writepages() implementation?

Anyway the throughput you see looks bad. What kernel version are you using?
There's possibility my recent changes to ext4_writepage() could have slowed
down something...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
