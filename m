From: Akira Fujita <a-fujita@rs.jp.nec.com>
Subject: Re: bugs of Online Defragmentation
Date: Wed, 26 Nov 2008 20:11:18 +0900
Message-ID: <492D2ED6.3050500@rs.jp.nec.com>
References: <49221C94.3010500@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Li Zefan <lizf@cn.fujitsu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:36048 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751741AbYKZLLY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 26 Nov 2008 06:11:24 -0500
In-Reply-To: <49221C94.3010500@cn.fujitsu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Li,

Thank you for testing and sorry for delay reply.
I am looking into this problem now,
It seems to take a little time to fix.

(In my look, s_dirty_blocks goes wrong so that free blocks
on memory decreases.  Maybe delalloc handling isn't good)

Thanks,
Akira Fujita

Li Zefan wrote:
> I tested Online Defrag, and seems this feature is still
> very unstable.
> 
> 1)
> 
> # mkfs.ext4 -m 0 -b 1024 -O ^flex_bg /dev/sdb7
> # mount -t ext4 -o nodelalloc /dev/sdb7 mnt_point
> # (age /dev/sdb7 using ffsb)
> ...
> # df
> Filesystem           1K-blocks      Used Available Use% Mounted on
> ...
> /dev/sdb7              5159829   5118866     40963 100% ...
> 
> sdb7 has 40M free space left. And I ran e4defrag on a directory full
> of small files (most < 1M), but all failed, and dmesg didn't tell
> me the reasion.
> 
> # e4defrag mnt_point/data0/
> ...
> [62/1562]/../mnt_point/data0/fillfile1420:        0%    [ NG ]
> [63/1562]/../mnt_point/data0/fillfile188:         0%    [ NG ]
> ...
>         Success:                        [ 0/1562 ]
>         Failure:                        [ 1562/1562 ]
> 
> # df
> Filesystem           1K-blocks      Used Available Use% Mounted on
> ...
> /dev/sdb7              5159829   5159807        22 100% ...
> 
> Though all failed, but now the 40M free space was occupied, why?
> 
> If delalloc is turned on, things are somewhat different, most files can
> be defraged, and dmesg told me not enough free blocks for the failure
> cases.
> 
> 2)
> 
> I sometimes got panic after defrag a directory:
> 
> Dirty block accounting went wrong -8977
> Dirty block accounting went wrong -9279
> Dirty block accounting went wrong -9718
> Dirty block accounting went wrong -10258
> ...
> ...
> Dirty block accounting went wrong -157352
> Dirty block accounting went wrong -157700
> EXT4-fs error(device sdb7): ext_mb_free_metadata: Double free of blocks 985 (984 2)
> 
