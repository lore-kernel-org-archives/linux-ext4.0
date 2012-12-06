From: Jan Kara <jack@suse.cz>
Subject: Re: help about ext3 read-only issue on ext3(2.6.16.30)
Date: Thu, 6 Dec 2012 18:09:13 +0100
Message-ID: <20121206170913.GC21029@quack.suse.cz>
References: <CALOAHbDC8jguV7GeSuN01UWBk+74wVHho8Fe9HLan06FZSpw0g@mail.gmail.com>
 <50BCE885.8010609@redhat.com>
 <50BE007D.5080504@huawei.com>
 <20121204150928.GF29083@thunk.org>
 <50BF2537.6070809@huawei.com>
 <50BF597D.3040704@tao.ma>
 <50BFF149.6080007@huawei.com>
 <20121206123744.GA17951@quack.suse.cz>
 <CAEjEV8CpTT1Sk5g=FkGL2VEa_sW4go1jpNeFh=jDcdKWN_n2XQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Li Zefan <lizefan@huawei.com>,
	Tao Ma <tm@tao.ma>, Theodore Ts'o <tytso@mit.edu>,
	Eric Sandeen <sandeen@redhat.com>,
	Yafang Shao <laoar.shao@gmail.com>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	wuqixuan@huawei.com
To: qixuan wu <wuqixuan@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAEjEV8CpTT1Sk5g=FkGL2VEa_sW4go1jpNeFh=jDcdKWN_n2XQ@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri 07-12-12 00:21:25, qixuan wu wrote:
> Hi Kara,
> 
> On Thu, Dec 6, 2012 at 8:37 PM, Jan Kara <jack@suse.cz> wrote:
> > On Thu 06-12-12 09:13:45, Li Zefan wrote:
> >> >> I found this in one log:
> >> >>
> >> >> Nov 14 05:26:55 kernel: EXT3-fs error (device sda7): ext3_readdir: bad entry in directory #7225391: rec_len is smaller than minimal - offset=3952, inode=0, rec_len=0, name_len=0
> >> >> Nov 14 13:42:40 kernel: EXT3-fs error (device sda7): ext3_readdir: bad entry in directory #7225391: rec_len is smaller than minimal - offset=4024, inode=0, rec_len=0, name_len=0
> >> >> Nov 16 17:29:40 kernel: EXT3-fs error (device sda7): ext3_readdir: bad entry in directory #7225391: rec_len is smaller than minimal - offset=4084, inode=0, rec_len=0, name_len=0
> >> >> Nov 23 19:42:44 kernel: EXT3-fs error (device sda7): ext3_readdir: bad entry in directory #7225391: rec_len is smaller than minimal - offset=3952, inode=0, rec_len=0, name_len=0
> >   Sorry for posting here in the thread but I got unsubscribed from the
> > list so I don't have the beginning of the thread in my inbox.
> >
> >   ext3 directory format is such that the last directory entry in the block
> > should have length to exactly fill up the whole block. Apparently, the
> > length got trimmed for some reason so we ended up before end of directory
> > block looked of another directory entry there and didn't find anything. I
> > will also make one observation regarding offsets. They are 3952, 4024, and
> > 4084. If we subtract that from 4096 (block size), we get differences (in
> > binary) 10010000, 01001000, 00001100. Interestingly these have always two
> > bits set. Might be luck but need not...
> 
> Yes, we also found the interesting things that the offset happen in
> many boards are like below:
> 1) 3952
> 2) 3988( 3952+36)
> 3) 4024( 3988+36)
> 4) 4048(4042+24)
> 5) 4084(same as the rec_len of ".." file if there isn't any file).
> 
> I need introduce the rule of the files in the dir, for example:
> .
> ..
> current_log.txt (len is 15, rec_len is 24 when there is file after it,
> the value "24" i think has relative with  offset 4048)
> 20120526124556.865213.txt(len is 25, rec_len is 36 when there is file after it).
> 20120526124984.239475.txt(len is 25, rec_len is 36 when there is file after it).
> ....
> Because the rec_len is 36, it has some relative with those offset
> values( the diff of those values are multiple of 36).
> I need tell another thing, customer's app invoke opendir/readdir very
> frequently. There are more than 1000 times, every second(the value
> need to be confirmed).
> 
> > Anyway it would be interesting to get the dump of the corrupted directory
> > before e2fsck is run. You can do that by running:
> >   debugfs -R "dump_inode <7225391> /tmp/corrupted_dir" /dev/sda7
> >
> > Then you can send the dump of the corrupted directory here.
> 
> We have already dump of the data by debugfs. The data is very good
> without error. But we just did it before fsck, even the fsck is not
> giving any error. I want to know whether fsck will modify disk data
> without reporting any error or not ?
  Ah, OK. So it seems that directory block is OK, just  f_pos gets corrupted
somehow. There are guards in ext3_readdir() to rescan dir block when
directory is modified but maybe that's not working correctly. I don't want
to burn too much time on this since this is so ancient kernel but I'd be
looking in that direction...

									Honza

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
