From: Jan Kara <jack@suse.cz>
Subject: Re: help about ext3 read-only issue on ext3(2.6.16.30)
Date: Wed, 12 Dec 2012 11:04:44 +0100
Message-ID: <20121212100444.GB18885@quack.suse.cz>
References: <50BE007D.5080504@huawei.com>
 <20121204150928.GF29083@thunk.org>
 <50BF2537.6070809@huawei.com>
 <50BF597D.3040704@tao.ma>
 <50BFF149.6080007@huawei.com>
 <20121206123744.GA17951@quack.suse.cz>
 <CAEjEV8CpTT1Sk5g=FkGL2VEa_sW4go1jpNeFh=jDcdKWN_n2XQ@mail.gmail.com>
 <20121206170913.GC21029@quack.suse.cz>
 <50C1BF05.6020605@huawei.com>
 <50C6E86F.8040308@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, qixuan wu <wuqixuan@gmail.com>,
	Tao Ma <tm@tao.ma>, Theodore Ts'o <tytso@mit.edu>,
	Eric Sandeen <sandeen@redhat.com>,
	Yafang Shao <laoar.shao@gmail.com>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	wuqixuan@huawei.com, xieshuangyi@huawei.com
To: Li Zefan <lizefan@huawei.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <50C6E86F.8040308@huawei.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue 11-12-12 16:01:51, Li Zefan wrote:
> >>> We have already dump of the data by debugfs. The data is very good
> >>> without error. But we just did it before fsck, even the fsck is not
> >>> giving any error. I want to know whether fsck will modify disk data
> >>> without reporting any error or not ?
> >>   Ah, OK. So it seems that directory block is OK, just  f_pos gets corrupted
> >> somehow. There are guards in ext3_readdir() to rescan dir block when
> >> directory is modified but maybe that's not working correctly. I don't want
> >> to burn too much time on this since this is so ancient kernel but I'd be
> >> looking in that direction...
> >>
> > 
> > I've added some debug code into ext3, which does these things:
> > - dump the dir block
> > - print the current and last f_pos and offset
> > - dump_stack() to see which process triggers the bug
> > 
> > Hope we can trigger the bug in our labs (We did see this happened twice this week
> > in a lab), though we can't patch the kernel in the products.
> > 
> > I compared ext3_readdir() with latest ext3, and saw no difference except some
> > API changes. I'll dig deeper. Thansks for the suggestion!
> > 
> 
> We've managed to trigger the bug once, and collected some debug information. We
> found the buffer head wasn't corrupted, but f_pos was set to 4024 and then ext3
> reported error.
> 
> EXT3-fs error (device sda7): ext3_readdir: bad entry in directory #12747345: rec_len is smaller than minimal - offset=4024, inode=0, rec_len=0, name_len=0
> Aborting journal on device sda7.
> ext3_abort called.
> EXT3-fs error (device sda7): ext3_journal_start_sb: Detected aborted journal
> Remounting filesystem read-only
> 
> 00000000: 51 82 c2 00 0c 00 01 02 2e 00 00 00 04 80 c2 00  Q...............
> 00000010: 0c 00 02 02 2e 2e 00 00 d6 80 c2 00 10 00 06 02  ................
> 00000020: 62 61 63 6b 75 70 00 00 bb 82 c2 00 1c 00 11 01  backup..........
> 00000030: 4d 6f 6e 69 74 6f 72 53 65 72 76 69 63 65 2e 6f  MonitorService.o
> 00000040: 70 00 00 00 be 82 c2 00 1c 00 13 01 43 6f 6d 70  p...........Comp
> 00000050: 6c 61 69 6e 74 50 72 6f 63 65 73 73 2e 6f 70 00  laintProcess.op.
> 00000060: c2 82 c2 00 20 00 15 01 4c 6f 63 61 74 69 6f 6e  .... ...Location
> 00000070: 50 72 65 50 72 6f 63 65 73 73 2e 6f 70 00 00 00  PreProcess.op...
> 00000080: c9 82 c2 00 18 00 0f 01 4e 6f 72 74 68 50 72 6f  ........NorthPro
> 00000090: 63 65 73 73 2e 6f 70 00 d4 82 c2 00 18 00 0d 01  cess.op.........
> 000000a0: 53 79 73 4d 6f 6e 69 74 6f 72 2e 6f 70 00 00 00  SysMonitor.op...
> 000000b0: db 82 c2 00 1c 00 13 01 56 56 49 50 4e 6f 72 74  ........VVIPNort
> 000000c0: 68 50 72 6f 63 65 73 73 2e 6f 70 00 e1 82 c2 00  hProcess.op.....
> 000000d0: 34 0f 09 01 72 61 6e 73 61 75 2e 6f 70 00 00 00  4...ransau.op...
> 000000e0: 4f 83 c2 00 20 0f 1e 01 72 61 6e 73 61 75 2e 6f  O... ...ransau.o
> 000000f0: 70 2e 32 30 31 32 31 32 31 30 30 32 30 39 32 34  p.20121210020924
> 00000100: 34 35 31 33 39 34 00 00 79 83 c2 00 f8 0e 18 01  451394..y.......
> 00000110: 72 61 6e 73 61 75 2e 6f 70 2e 32 30 31 32 31 32  ransau.op.201212
> 00000120: 31 30 30 32 30 39 32 34 00 00 00 00 00 00 00 00  10020924........
> ...
> 00000ff0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> 
> last_offset=-1, last_fpos=-1, f_pos=4024
> 
> -1 means we hit the bug in the first iteration in the insde while in
> ext3_readdir().
> 
> I've checked how ext3_readdir() works and how f_pos, f_version and i_version
> get initialized and modified. Now I'm lost. I really can't see how f_pos got
> corrupted. :(
  Hum, it looks really curious. So f_pos has been 4024 when we entered
ext3_readdir()? Do you know what it was when we last left ext3_readdir()
for that filp? You can store that value in some debug entry added to struct
file... Also any chance we ever hit:
                                if (version != filp->f_version)
                                        goto revalidate;
I don't think it can ever happen since we hold i_mutex and
generic_file_llseek() takes i_mutex as well. But better be sure.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
