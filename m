From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: help about ext3 read-only issue on ext3(2.6.16.30)
Date: Tue, 4 Dec 2012 10:09:28 -0500
Message-ID: <20121204150928.GF29083@thunk.org>
References: <CALOAHbDC8jguV7GeSuN01UWBk+74wVHho8Fe9HLan06FZSpw0g@mail.gmail.com>
 <50BCE885.8010609@redhat.com>
 <50BE007D.5080504@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>,
	Yafang Shao <laoar.shao@gmail.com>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	wuqixuan@huawei.com, wuqixuan@gmail.com
To: Li Zefan <lizefan@huawei.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:36691 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751689Ab2LDPJh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 4 Dec 2012 10:09:37 -0500
Content-Disposition: inline
In-Reply-To: <50BE007D.5080504@huawei.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Dec 04, 2012 at 09:54:05PM +0800, Li Zefan wrote:
> 
> I've collected some logs in different machines, and the error was always
> triggered in ext3_readdir:
> 
> EXT3-fs error (device sda7): ext3_readdir: bad entry in directory #6685458: rec_len is smaller than minimal - offset=3860, inode=0, rec_len=0, name_len=0
> EXT3-fs error (device sda7): ext3_readdir: bad entry in directory #9650541: rec_len is smaller than minimal - offset=3960, inode=0, rec_len=0, name_len=0
> EXT3-fs error (device sda7): ext3_readdir: bad entry in directory #11124783: rec_len is smaller than minimal - offset=4072, inode=0, rec_len=0, name_len=0
> EXT3-fs error (device sda7): ext3_readdir: bad entry in directory #52740880: rec_len is smaller than minimal - offset=4024, inode=0, rec_len=0, name_len=0
> EXT3-fs error (device sda7): ext3_readdir: bad entry in directory #52740880: rec_len is smaller than minimal - offset=4084, inode=0, rec_len=0, name_len=0

This looks like the last part of the inode was zapped.  It might be
worth adding a kernel patch which dumps out the entire directory block
as a hex dump when this triggers --- and then compare it to what you
get if you dump the directory back out after the machine reboot.  That
might given you a hint if something is corrupting the directory block
in memory.  (especially if you set the remount read-only option).

> The last two errors happened on the same machine, and the same inode! One
> happened in 11/22 (I was told they had run fsck later on), and one in 12/01.

If it's always the same inode, you might want to correlate based on
the pathname.  Is there any commonality accross multiple machines in
terms of the directory name, and what application(s) might be touching
that directory?

> Yesterday they upgrade apps on ~30 machines, and soon after that 5 machines
> had filesystem corrupted. However they won't stop upgrading other machines!
> 
> On the other hand, we can hardly reproduce this bug in the lab.

This is why wise cloud companies have a (figurative) big red button to
stop upgrade rollouts (which are always done slowly and gradually),
and processes which make it relatively easy for engineers to be able
to push the "big red button".  I seem to recall the operations
engineer at Facebook giving a talk where he mentioned this.  :-)

Good luck!  Sorry, the pattern of corruption really doesn't sound
familiar to me...

						- Ted
