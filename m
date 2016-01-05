From: Jan Kara <jack@suse.cz>
Subject: Re: ext4 out of order when use cfq scheduler
Date: Tue, 5 Jan 2016 16:30:50 +0100
Message-ID: <20160105153050.GF14464@quack.suse.cz>
References: <697280a570654ae0aa1723fb7d11f51e@SGPMBX1004.APAC.bosch.com>
 <20151222150037.GB18178@quack.suse.cz>
 <c67f356b63d94d35ad010a6e987b68f0@SGPMBX1004.APAC.bosch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: "HUANG Weller (CM/ESW12-CN)" <Weller.Huang@cn.bosch.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41537 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751882AbcAEPaq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 5 Jan 2016 10:30:46 -0500
Content-Disposition: inline
In-Reply-To: <c67f356b63d94d35ad010a6e987b68f0@SGPMBX1004.APAC.bosch.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 04-01-16 05:25:15, HUANG Weller (CM/ESW12-CN) wrote:
> > -----Original Message-----
> > From: Jan Kara [mailto:jack@suse.cz]
> > Sent: Tuesday, December 22, 2015 11:01 PM
> > To: HUANG Weller (CM/EPF1-CN) <Weller.Huang@cn.bosch.com>
> > Cc: linux-ext4@vger.kernel.org; Li, Michael <huayil@qti.qualcomm.com>
> > Subject: Re: ext4 out of order when use cfq scheduler
> > 
> >   Hello,
> > 
> > On Tue 22-12-15 06:24:29, HUANG Weller (CM/EPF1-CN) wrote:
> > > I am doing the power failure on a storage device. We are arm 
> > > embedded system.
> > >
> > > Test environment:
> > > Kernel: 3.10.63
> > > Test type: power failure
> > > File create type: O_SYNC flag enabled Mount option: data=ordered, 
> > > journal_checksum,barrier=1 IO scheduler:
> > > CFQ
> > >
> > > Debug method: kernel print every block number of write request. 
> > > print whether it is journal block.  print whether it is (REQ_FUA | 
> > > REQ_META
> > > |
> > > write) After system startup, backup journal blocks before mount the 
> > > test partition.
> > 
> > Do you know blktrace / blkparse tools? They would give you this 
> > information without the need of patching the kernel...
> 
> Yes, I know that tool. Normally, I use that tool, but in this case, I patch kernel because of following reasons:
> 1. this is power failure test, blktrace might not catch some log near to the power failure. 
> 2. I add some calculation when print these block numbers in the kernel patch. So I can directly use the value print from kernel.
> blktrace give me lots of logs and I have to do block number conversion one by one.

OK, fair enough.

> > > Below is analysis which I think there is a out of order:
> > > hp0000017aMhWY3i0vMv is the file which checksum is error. Only half 
> > > of the file contents is correct.
> > 
> > Can you post the test program you are using? What is in the incorrect block?
> > Previous content of the file or some random garbage? If you are just 
> > overwriting the file and see old contents, that could happen and is 
> > legal (we just guarantee newly allocated blocks are first written out).
> > 
> > Is the problem reproducible?
> 
> The test tool(attached in this mail)  not rewrite a file but create many
> files after delete the old test files in every  new test round.  The test
> tool create file in this way: filename format: hp[HEX NUMBER][RANDOM
> STRING].  For example: hp0000017aMhWY3i0vMv, hex number: 0000017a  random
> string: MhWY3i0vMv
> 
> The file contents has some relationship to the file name.  every 512
> bytes has its own checksum and sequence number.  Also contain the file
> name and the random string. So we can easily trace the file contents(see
> the attached picture).

I see.

> >What is in the incorrect block?
> 
> Since I clean the test partition with /dev/zero, so what I saw is that,
> half of the file is ok. But the rest are 0. !!!! But another information
> is that:!!!!  hp0000017aMhWY3i0vMv is not the last file.  from the number
> in the file name , we can know there still 3 files created after it and
> these files are all checksum OK.  Except the last file is zero length.
> 
> This issue is very easy to reproducible. Even we test with emmc, we also
> see this issue.  If you need I to do anymore test, just let me know.

So you are running in 'ws' mode of your tool, am I right? Just looking into
the sources you've sent me I've noticed that although you set O_SYNC in
openflg when mode == MODE_WS, you do not use openflg at all. So file won't
be synced at all. That would well explain why you see that not all file
contents is written. So did you just send me a different version of the
source or is your test program really buggy?

								Honza

> > > [root@SiRFatlas6 ~]# debugfs /dev/nandblk0p3 debugfs 1.42.9
> > > (28-Dec-2013)
> > > debugfs:  imap test/hp0000017aMhWY3i0vMv Inode 390 is part of block 
> > > group 0
> > >         located at block 141, offset 0x0280
> > >
> > > 00000280  80 81 00 00 10 00 04 00  c8 09 00 00 66 0a 00 00
> > > |............f...|
> > > 00000290  66 0a 00 00 00 00 00 00  00 00 01 00 04 02 00 00
> > > |f...............|
> > > 000002a0  00 00 08 00 01 00 00 00  0a f3 02 00 04 00 00 00
> > > |................|
> > > 000002b0  00 00 00 00 00 00 00 00  80 00 00 00 00 2c 01 00
> > > |.............,..|  ==> the file contents is at 0x00012c00
> > > 000002c0  80 00 00 00 01 00 00 00  8e 26 01 00 00 00 00 00
> > > |.........&......|
> > >
> > >
> > > Search the block number from the journal blocks:
> > >
> > > [root@SiRFatlas6 ~]# hexdump j.bin  -C |  grep "00 2c 01 00"
> > > 00039ab0  00 00 00 00 00 00 00 00  80 00 00 00 00 2c 01 00
> > > |.............,..|
> > >
> > > Search file name which the file checksum is error in journal blocks:
> > >
> > > [root@SiRFatlas6 ~]# hexdump j.bin  -C |  grep "3i0vMv" -B1
> > > 00030c60  86 01 00 00 1c 00 14 01  68 70 30 30 30 30 30 31
> > > |........hp000001|
> > > 00030c70  37 61 4d 68 57 59 33 69  30 76 4d 76 88 01 00 00
> > > |7aMhWY3i0vMv....|
> > >
> > >
> > > List all journal block record to check which journal block records it:
> > >
> > > [root@SiRFatlas6 ~]# hexdump j.bin -C | grep "c0 3b 39 98"
> > > 00000000  c0 3b 39 98 00 00 00 04  00 00 00 00 00 00 08 00
> > > |.;9.............|
> > > 00000800  c0 3b 39 98 00 00 00 05  00 00 00 6f 00 00 00 24
> > > |.;9........o...$|
> > > 00001000  c0 3b 39 98 00 00 00 01  00 00 00 6f 00 00 00 75
> > > |.;9........o...u|
> > > 0000c800  c0 3b 39 98 00 00 00 02  00 00 00 6f 00 00 00 00
> > > |.;9........o....|
> > > 0000d000  c0 3b 39 98 00 00 00 01  00 00 00 70 00 00 00 65
> > > |.;9........p...e|
> > > 00016000  c0 3b 39 98 00 00 00 02  00 00 00 70 00 00 00 00
> > > |.;9........p....|
> > > 00016800  c0 3b 39 98 00 00 00 01  00 00 00 71 00 00 00 7c
> > > |.;9........q...||
> > > 00021000  c0 3b 39 98 00 00 00 02  00 00 00 71 00 00 00 00
> > > |.;9........q....|
> > > 00021800  c0 3b 39 98 00 00 00 01  00 00 00 72 00 00 00 82
> > > |.;9........r....|
> > > 0002d000  c0 3b 39 98 00 00 00 02  00 00 00 72 00 00 00 00
> > > |.;9........r....|
> > > 0002d800  c0 3b 39 98 00 00 00 01  00 00 00 73 00 00 00 88  
> > > |.;9........s....|
> > ==>00039ab0 is in last block, the file name and the start block number 
> > are all recorded in the journals.
> > > 0003a000  c0 3b 39 98 00 00 00 02  00 00 00 73 00 00 00 00
> > > |.;9........s....|
> > >
> > >
> > > Back to see the kernel log which it print all the block numbers:
> > >
> > > ...
> > > ...
> > > [   46.222671] 244109  75277
> > > [   46.222693]
> > > [   46.272438] 244352  75520
> > > [   46.272460]
> > > [   46.348417] 238443  69611
> > > [   46.348438]
> > > [   46.349811] 244480  75648
> > > [   46.352287]
> > > [   46.404904] 244609  75777
> > > [   46.404926]
> > > [   46.454698] 244738  75906
> > > [   46.454719]
> > > [   46.505439] 244992  76160
> > > [   46.505459]
> > > [   46.557783] 245120  76288
> > > [   46.557804]
> > > [   46.610075] 245249  76417
> > > [   46.610096]
> > > [   46.660196] 245378  76546
> > > [   46.660219]
> > > [   46.709906] 201691  32859   ==> journal start is 32768, so the offset is 91,
> > block size=2048,  so, the offset address in the j.bin is 0x2d800
> > > [   46.709928] J [   46.711233]
> > > [   46.740635] drop to 9v
> > > [   46.749540] 201716  32884
> > > [   46.749560] J S
> > > [   46.751039]
> > > [   46.753151] 245632  76800  ==> 76800 in hex is 0x012c00, it is the same start
> > block of the file which checksum is error.
> > > [   46.755284]
> > > nanddisk idle -> 1.
> > > [   46.800227] 6v irq-2
> > >
> > >
> > > The j.bin offset 0x2d800
> > >
> > > 0002d800  c0 3b 39 98 00 00 00 01  00 00 00 73 00 00 00 88
> > > |.;9........s....|  ==>00039ab0 is in last block
> > > 0003a000  c0 3b 39 98 00 00 00 02  00 00 00 73 00 00 00 00
> > > |.;9........s....|
> > >
> > >
> > > Normally, ext4 will first write the file contents, and then write 
> > > the journal and journal commit. Then after some delay, it will write 
> > > the meta data.  So The journal blocks contains the meta data of the 
> > > file which the file contents already been written before.  But from 
> > > above analysis,  the journal sequence 0x73 already contain the file
> > > name(hp0000017aMhWY3i0vMv) and the start block number(76800). So 
> > > from the kernel log,  the block
> > > number(76800) should be available before the journal blocks but NOT 
> > > after it.  It seems that there is out of order happen.
> > >
> > > Could you please help to check this issue ? or give a explanation 
> > > about it ?  Many thanks.
> > >
> > > Best regards
> > >
> > > Weller HUANG
> > >
> > >
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-ext4"
> > > in the body of a message to majordomo@vger.kernel.org More majordomo 
> > > info at  http://vger.kernel.org/majordomo-info.html
> > --
> > Jan Kara <jack@suse.com>
> > SUSE Labs, CR



-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
