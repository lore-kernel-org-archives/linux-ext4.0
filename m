From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext4: delayed inode insertion into transaction at write()
Date: Tue, 21 Feb 2017 11:09:36 +0100
Message-ID: <20170221100936.GA2581@quack2.suse.cz>
References: <20170221033407.GA1895@son-VirtualBox>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: jack@suse.cz, tytso@mit.edu, adilger.kernel@dilger.ca,
        linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Seongbae Son <seongbae.son@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170221033407.GA1895@son-VirtualBox>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue 21-02-17 12:34:07, Seongbae Son wrote:
> On Wed 15-02-17 14:18:39, Seongbae Son wrote:
> >> If a write request writes a data which is larger than 4 KB, the inode of
> >> the file is updated by the write system call, and also by kworker thread.
> >> This duplicated inode update causes malfunction of the EXT4 journaling
> >> behavior in ordered mode.
> >>
> >> For example, if 6KB write(fileA) on 18KB file is performed,
> >>
> >> 1. The inode is updated to 20KB in the write() system call and inserted
> >> into the transaction.
> >> 2. After that, kworker thread allocates a new block, updates the inode to
> >> 24 KB, and inserts the inode into the transaction.
> >>
> >> But, if fsync(fileB) is executed before kworker thread runs and system
> >> crash occurs, fileA is broken. The size of fileA is 20KB, but the data
> >> between 18KB and 20KB is filled with invalid one.
> 
> >Thanks for report and the patch. Do you have a testcase that reproduces the
> >problem? Can you share it? With which kernel version do you see the
> >corruption?  Include this information in the changelog next time please.
> 
> >I'm somewhat surprised that the file size is 20KB - ext4 uses i_disksize
> >field for tracking real inode size on disk and that gets updated only when
> >data is written out from flusher work (you refer to it as kworker). In
> >particular ext4_da_write_end() (or generic_write_end() for that matter)
> >does not update i_disksize unless the blocks underlying the data are
> >already allocated (which is the case of the first 2KB written but not the
> >case for the remaining 4KB). So if you can really observe increased
> >i_disksize, it needs more debugging where that gets set...
> >
> >                                                                Honza
> 
> Thank you for replying the patch.
> Yes, I can reproduce the problem. Using virtual box, I tested Linux 4.10.0-rc7
> and Linux 4.10.0-rc8, and the problem occurred in both of them. I used a test
> program and below is its pseudo-code.
> 
> procedure testfsync(write_volume)
>    for file = file0; file <= file9; file++ do
>       f[idx] = open(file, O_RDWR, O_CREATE);
>       lseek(f[idx], 0, SEEK_END);
>       write((f[idx], buf, write_volume);
>       if file == file9
>          fsync(f[idx]);
>       close(f[idx]);
>    end for
> end procedure
> 
> The problem happened to file0,…,file8 if the blocks underlying the data are 
> already allocated and system crash occurs after fsync(file9). For example, 
> 6KB write(file0,…,file9) on 18KB sized file or 2KB write(file0,…file9) on 26KB 
> sized file is performed. The problem does not occur when a block should be 
> allocated for the beginning of user data (For example, 6KB write(file0,…file9) 
> on 24KB or 2KB write(file0,…file9) on 20KB). Below is the scenario to figure 
> the problem out.
> 
> 1.	Perform the above test program
> 2.	System crash (before flusher work runs)
> 
> I debugged which part changes i_disksize field in ext4_da_write_end() and it 
> was ext4_update_i_disksize(). This function is performed when the blocks 
> underlying the data are already allocated. The problem does not occur once 
> the function is removed. But file size of file9 is not changed without the 
> function when write volume is below 4KB and the blocks underlying the data are 
> already allocated for the above scenario. So I keep i_disksize changed in 
> ext4_da_write_end() and allow the inode not to be inserted to the transaction.
> During flusher work, the inode is inserted to the transaction.

OK, thanks for details. So in the situation you describe we have the last
file block that is partial (not fully filled with data). We write some data
into the partial block, thus extending the file, and you are right that in
that case we update the i_disksize directly in ext4_da_write_end() (by
calling ext4_update_i_disksize()). If we crash after the transaction
commits but before the data is actually written out from page cache, you
can see zeros at the end of the file - you speak about invalid data but did
you ever see anything else than zeros? If you can see only zeros, then this
is within the guarantees data=ordered mode provides - we guarantee you will
never see data of other files after a crash. data=ordered mode does not
give guarantees that correct data will be in the file after a crash. In
particular if a block is already allocated (and your test is a special case
of that), we do not bind writeout of the data from page cache with
transactions in any way (so you can observe e.g. inode time stamps updated
while data is not in the file after a crash). Does that make things clear?

Maybe to explain a bit why we actually do things this way: We update
i_disksize in ext4_da_write_end() in this case so that the time stamps and
i_disksize of the inode get updated in the same transaction. This saves us
from having to journal the inode again after the writeback of this page is
complete (i.e., it is a performance optimization). Furthermore if we
postponed i_disksize updates after IO submission even for non-allocating
writes (as you essentially do in your patch), we would have to deal with
difficult issues of having to update i_disksize when page writeback happens
from jbd2 process committing a transaction or from kswapd cleaning dirty
pages on memory pressure.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
