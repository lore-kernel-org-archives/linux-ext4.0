From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH 04/10 v5] ext4: track all extent status in extent status
 tree
Date: Mon, 18 Feb 2013 00:26:02 +0800
Message-ID: <20130217162602.GA18260@gmail.com>
References: <1360313046-9876-1-git-send-email-wenqing.lz@taobao.com>
 <1360313046-9876-5-git-send-email-wenqing.lz@taobao.com>
 <20130213032819.GA2614@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>,
	Jan kara <jack@suse.cz>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f41.google.com ([209.85.160.41]:49692 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750752Ab3BQQLV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 17 Feb 2013 11:11:21 -0500
Received: by mail-pb0-f41.google.com with SMTP id um15so1281457pbc.0
        for <linux-ext4@vger.kernel.org>; Sun, 17 Feb 2013 08:11:21 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20130213032819.GA2614@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Feb 12, 2013 at 10:28:19PM -0500, Theodore Ts'o wrote:
> On Fri, Feb 08, 2013 at 04:44:00PM +0800, Zheng Liu wrote:
> > From: Zheng Liu <wenqing.lz@taobao.com>
> > 
> > By recording the phycisal block and status, extent status tree is able
> > to track the status of every extents.  When we call _map_blocks
> > functions to lookup an extent or create a new written/unwritten/delayed
> > extent, this extent will be inserted into extent status tree.  The hole
> > extent is inserted in ext4_ext_put_gap_in_cache().  If there is no any
> > extent, we will not insert a hole extent [0, ~0] into the extent status
> > tree in order to reduce the complextiy of code.
> > 
> > We don't load all extents from disk in alloc_inode() because it costs
> > too much memory, and if a file is opened and closed frequently it will
> > takes too much time to load all extent information.  So currently when
> > we create/lookup an extent, this extent will be inserted into extent
> > status tree.  Hence, the extent status tree may not comprehensively
> > contain all of the extents found in the file.
> > 
> > Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
> > Cc: "Theodore Ts'o" <tytso@mit.edu>
> > Cc: Jan kara <jack@suse.cz>
> 
> Unfortunately, this commit is apparently causing test failures with
> bigalloc:
> 
> --- 013.out	2013-01-01 22:52:04.000000000 -0500
> +++ 013.out.bad	2013-02-12 22:08:47.110766615 -0500
> @@ -8,7 +8,4 @@
>  -----------------------------------------------
>  fsstress.2 : -p 20 -r
>  -----------------------------------------------
> -
> ------------------------------------------------
> -fsstress.3 : -p 4 -z -f rmdir=10 -f link=10 -f creat=10 -f mkdir=10 -f rename=30 -f stat=30 -f unlink=30 -f truncate=20
> ------------------------------------------------
> +_check_generic_filesystem: filesystem on /dev/vdd is inconsistent (see 013.full)
> _check_generic_filesystem: filesystem on /dev/vdd is inconsistent (see 013.full)
> Ran: 013
> Failures: 013
> Failed 1 of 1 tests
> END TEST: Ext4 4k block w/bigalloc Tue Feb 12 22:08:49 EST 2013
> e2fsck 1.43-WIP (15-Jan-2013)
> Pass 1: Checking inodes, blocks, and sizes
> Inode 618, i_blocks is 1408, should be 1536.  Fix? yes
> 
> Pass 2: Checking directory structure
> Pass 3: Checking directory connectivity
> Pass 4: Checking reference counts
> Pass 5: Checking group summary information
> 
> /dev/vdd: ***** FILE SYSTEM WAS MODIFIED *****
> /dev/vdd: 3969/81936 files (13.1% non-contiguous), 176208/1310720 blocks
> 
> 
> I haven't been able to figure out what is going on here, but if we
> can't figure this out I may need to push off this patch series to the
> next merge window.  I've tried splitting up this patch into two pieces
> to make it clearer what is going on, but I still can't see how this
> would be affecting the i_blocks calculation.

Hi Ted,

I have fixed this regression.  The reason is that we miss to release
reserved space in ext4_da_page_release_reservation().  The root cause is
that when an extent is delayed allocated and later it could be allocated
by fallocate.  In this condition this extent need to keep as delayed
extent until the extent is written out because we need to update
reserved space according to these delayed extent.

I have run xfstests #13 serveral times and this regression never be
triggered.  Later the latest patch set will be sent out.

BTW, when I run xfstests to test the extent status tree patch sereis, I
get a regression against 'dev' branch of ext4 and a bug against 3.8-rc7.
I will file them in other mails.

Regards,
                                                - Zheng
