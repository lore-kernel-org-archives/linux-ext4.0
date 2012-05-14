From: Akira Fujita <a-fujita@rs.jp.nec.com>
Subject: Re: dereference before check in ext4_move_extents()
Date: Mon, 14 May 2012 17:30:23 +0900
Message-ID: <4FB0C29F.2080403@rs.jp.nec.com>
References: <20120513184321.GA16541@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:38341 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752548Ab2ENIbR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 14 May 2012 04:31:17 -0400
In-Reply-To: <20120513184321.GA16541@elgon.mountain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Dan,

> fs/ext4/move_extent.c:1381 ext4_move_extents()
> 	 warn: variable dereferenced before check 'holecheck_path' (see line 1292)

Thanks for reporting.
I tried to reproduce this with Smatch and kernel 3.4-rc7,
but another compile warning turned up.

# make CHECK="/home/KERN/smatch/smatch -p=kernel" C=1 bzImage modules

<snip>

  CHECK   fs/ext4/block_validity.c
  CC      fs/ext4/block_validity.o
  CHECK   fs/ext4/move_extent.c
fs/ext4/move_extent.c:696 mext_replace_branches() warn: variable dereferenced before check 'dext' (see line 686)
  CC      fs/ext4/move_extent.o
  CHECK   fs/ext4/mmp.c

I'll fix above compile warning surely, but it's not the original
you reported. Hmm, how can I reproduce yours?

Regards,
Akira Fujita


(2012/05/14 3:43), Dan Carpenter wrote:
> Hi, going through some static checker warnings and reporting bugs.
> These were introduced a long time ago.
> 
> The patch 748de6736c1e: "ext4: online defrag -- Add EXT4_IOC_MOVE_EXT
> ioctl" from Jun 17, 2009, leads to the following Smatch complaint:
> 
> fs/ext4/move_extent.c:1381 ext4_move_extents()
> 	 warn: variable dereferenced before check 'holecheck_path' (see line 1292)
> 
> fs/ext4/move_extent.c
>    1291			ext_prev = ext_cur;
>    1292			last_extent = mext_next_extent(orig_inode, holecheck_path,
>                                                                     ^^^^^^^^^^^^^^
> Dereferenced unconditionally inside the mext_next_extent() function.
> 
>    1293							&ext_cur);
>    1294			if (last_extent<  0) {
>    1295				ret1 = last_extent;
>    1296				break;
>    1297			}
> 
> 	[snip]
> 
>    1376			double_down_write_data_sem(orig_inode, donor_inode);
>    1377			if (ret1<  0)
>    1378				break;
>    1379	
>    1380			/* Decrease buffer counter */
>    1381			if (holecheck_path)
>                              ^^^^^^^^^^^^^^
> Checked here.
> 
>    1382				ext4_ext_drop_refs(holecheck_path);
>    1383			ret1 = get_ext_path(orig_inode, seq_start,&holecheck_path);
> 
> regards,
> dan carpenter
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

