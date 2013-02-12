From: Jan Kara <jack@suse.cz>
Subject: Re: help about ext3 read-only issue on ext3(2.6.16.30)
Date: Tue, 12 Feb 2013 13:19:49 +0100
Message-ID: <20130212121949.GA19583@quack.suse.cz>
References: <50BFF149.6080007@huawei.com>
 <20121206123744.GA17951@quack.suse.cz>
 <CAEjEV8CpTT1Sk5g=FkGL2VEa_sW4go1jpNeFh=jDcdKWN_n2XQ@mail.gmail.com>
 <20121206170913.GC21029@quack.suse.cz>
 <50C1BF05.6020605@huawei.com>
 <50C6E86F.8040308@huawei.com>
 <20121212100444.GB18885@quack.suse.cz>
 <50C86AFC.7080301@huawei.com>
 <50CEF92F.6050306@huawei.com>
 <20121220113213.GB3301@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, qixuan wu <wuqixuan@gmail.com>,
	Tao Ma <tm@tao.ma>, Theodore Ts'o <tytso@mit.edu>,
	Eric Sandeen <sandeen@redhat.com>,
	Yafang Shao <laoar.shao@gmail.com>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	wuqixuan@huawei.com, xieshuangyi@huawei.com, tao.peng@emc.com
To: Li Zefan <lizefan@huawei.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:48116 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759190Ab3BLMT6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 12 Feb 2013 07:19:58 -0500
Content-Disposition: inline
In-Reply-To: <20121220113213.GB3301@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 20-12-12 12:32:13, Jan Kara wrote:
>   Hello,
> 
> On Mon 17-12-12 18:51:27, Li Zefan wrote:
> > >>> last_offset=-1, last_fpos=-1, f_pos=4024
> > >>>
> > >>> -1 means we hit the bug in the first iteration in the insde while in
> > >>> ext3_readdir().
> > >>>
> > >>> I've checked how ext3_readdir() works and how f_pos, f_version and i_version
> > >>> get initialized and modified. Now I'm lost. I really can't see how f_pos got
> > >>> corrupted. :(
> > >>   Hum, it looks really curious. So f_pos has been 4024 when we entered
> > >> ext3_readdir()?
> > > 
> > > dunno. but what else can be
> > > 
> > >> Do you know what it was when we last left ext3_readdir()
> > >> for that filp? You can store that value in some debug entry added to struct
> > >> file... Also any chance we ever hit:
> > >>                                 if (version != filp->f_version)
> > >>                                         goto revalidate;
> > >> I don't think it can ever happen since we hold i_mutex and
> > >> generic_file_llseek() takes i_mutex as well. But better be sure.
> > >>
> > > 
> > > Yesterday I've added more debug aids, which convers all the above information
> > > mentioned. Actually the code tracks all the places that change f_pos, and
> > > I think only lseek() and readdir() can change it.
> > > 
> > > Now I'm waiting for the bug to happen again, can be several days...
> > > 
> > 
> > The bug was triggered again:
> > 
> > EXT3-fs error (device sda7): ext3_readdir: bad entry in directory #9372013: rec_len is smaller than minimal - offset=4028, inode=0, rec_len=0, name_len=0
> > 
> > And I've confirmed f_pos=4028 when we entered ext3_readdir(), while it
> > should be 4096.
>   OK, interesting.
>  
> > I wrote a simple ring buffer to track operations on log dirs, and from the
> > ring buffer, we can see that there were no lseek, unlink, rename, etc.
> > 
> > This is correct:
> > 
> > dir=9372013, seq=1549, spot=readdir_1, f_pos=0, f_pos_delta=0
> > dir=9372013, seq=1550, spot=readdir_3, f_pos=0, f_pos_delta=0
> > dir=9372013, seq=1551, spot=readdir_5, f_pos=12, f_pos_delta=12
> > dir=9372013, seq=1552, spot=readdir_5, f_pos=24, f_pos_delta=12
> > ...
> > dir=9372013, seq=1595, spot=readdir_5, f_pos=1488, f_pos_delta=28
> > dir=9372013, seq=1596, spot=readdir_5, f_pos=1516, f_pos_delta=28
> > dir=9372013, seq=1597, spot=readdir_5, f_pos=1556, f_pos_delta=40
> > dir=9372013, seq=1598, spot=readdir_5, f_pos=1584, f_pos_delta=28
> > ...
> > dir=9372013, seq=1627, spot=readdir_5, f_pos=2392, f_pos_delta=28
> > dir=9372013, seq=1628, spot=readdir_5, f_pos=4096, f_pos_delta=1704
> > dir=9372013, seq=1629, spot=readdir_1, f_pos=4096, f_pos_delta=0
> > 
> > (readir_1 is the entry of readdir(), and readdir_3 is when we enter
> > (f_version != i_version), and readdir_5 is we iterate the dir block)
>   Can you post the readdir() code you now run including your logging?
> Thanks!
> 
> > Then f_pos went wrong suddenly:
> > 
> > dir=9372013, seq=1676, spot=readdir_5, f_pos=1488, f_pos_delta=28
> > dir=9372013, seq=1677, spot=readdir_5, f_pos=1516, f_pos_delta=28
> > dir=9372013, seq=1678, spot=readdir_5, f_pos=1556, f_pos_delta=40
> > dir=9372013, seq=1679, spot=readdir_5, f_pos=1516, f_pos_delta=28   <-- !!!!!!!!
> > dir=9372013, seq=1680, spot=readdir_5, f_pos=1540, f_pos_delta=24
> > ...
> > dir=9372013, seq=1708, spot=readdir_5, f_pos=2324, f_pos_delta=28
> > dir=9372013, seq=1709, spot=readdir_5, f_pos=4028, f_pos_delta=1704
> > dir=9372013, seq=1710, spot=readdir_1, f_pos=4028, f_pos_delta=0
> > 
> > This is odd...
> > 
> > While f_pos was wrong, offset is always correct, and this is not some
> > single-bit error in memory, so someone else changed f_pos? but we were
> > holding i_mutex, and we see nothing else except readdir in the ring
> > buffer...
>   How do you know 'offset' was correct? I don't see it in the ring
> buffer... Anyway, this all points to us taking the:
>                                if (version != filp->f_version)
>                                         goto revalidate;
> branch when 'offset' is already advanced but f_pos isn't. Then we don't
> enter:
> 	if (filp->f_version != inode->i_version) {
> branch and thus f_pos and 'offset' stay out of sync and problems happen.
> 
> But how these strange issues with f_version happen is a mystery for me so
> far.
  Were there any more test results regarding this? I'm just curious what
the problem is / was...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
