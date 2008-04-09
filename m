From: Dmitri Monakhov <dmonakhov@openvz.org>
Subject: Re: Problem with fsstress on powerpc
Date: Wed, 9 Apr 2008 11:44:57 +0400
Message-ID: <20080409074457.GB944@dmon-lap.sw.ru>
References: <20080408152455.GA10827@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>, Mingming Cao <cmm@us.ibm.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:34574 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752469AbYDIHzU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 9 Apr 2008 03:55:20 -0400
Content-Disposition: inline
In-Reply-To: <20080408152455.GA10827@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 20:54 Tue 08 Apr     , Aneesh Kumar K.V wrote:
> Hi All,
> 
> Test case: fsstress with fallocate test case added.
This may happens because of direct write.
Please add  exact fsstess command and options.
> 
> Inode 8170, i_size is 0, should be 839680.  Fix? no
> 
> tst_extents:  stat <8170>
> header: magic=af3 entries=512 max=1024 depth=0 generation=0
> (Left 1)
> (Left 0)
> Inode: 8170   Type: regular    Mode:  0666   Flags: 0x80000
> Generation: 3214836894
> User:     0   Group:     0   Size: 0
> File ACL: 0    Directory ACL: 0
> Links: 1   Blockcount: 96
> Fragment:  Address: 0    Number: 0    Size: 0
> ctime: 0x47fb705f -- Tue Apr  8 09:17:19 2008
> atime: 0x47fb6d1b -- Tue Apr  8 09:03:23 2008
> mtime: 0x47fb705f -- Tue Apr  8 09:17:19 2008
> Size of extra inode fields: 28
> BLOCKS:
> (193-198):1275331-1275336, (199-204):747341-747346
> TOTAL: 12
> 
> tst_extents:  inode <8170>
> header: magic=af3 entries=512 max=1024 depth=0 generation=0
> Loaded inode 8170
> tst_extents:  root
> (Left 1)
> extent: lblk 193--198, len 6, pblk 1275331, flags: LEAF 
> tst_extents:  nl
> (Left 0)
> extent: lblk 199--204, len 6, pblk 747341, flags: LEAF 
> tst_extents:  nl
> nl: No 'next' extent 
> tst_extents:  
> 
> [root@gekko-lp2 tmp]# ls -ali fsstress/p1b8/d0/da/d26/fc5
> 8170 -rw-rw-rw-  1 root root 0 Apr  8 09:17 fsstress/p1b8/d0/da/d26/fc5
> 
> 
> Inode 179868, i_size is 724992, should be 868352.  Fix? no
> 
> tst_extents:  stat <179868>
> header: magic=af3 entries=512 max=1024 depth=0 generation=0
> (Left 1)
> (Left 0)
> Inode: 179868   Type: regular    Mode:  0666   Flags: 0x80000
> Generation: 3214716167
> User: 122091   Group:     0   Size: 724992
> File ACL: 0    Directory ACL: 0
> Links: 1   Blockcount: 32
> Fragment:  Address: 0    Number: 0    Size: 0
> ctime: 0x47fb7009 -- Tue Apr  8 09:15:53 2008
> atime: 0x47fb6cd8 -- Tue Apr  8 09:02:16 2008
> mtime: 0x47fb6f74 -- Tue Apr  8 09:13:24 2008
> Size of extra inode fields: 28
> BLOCKS:
> (176):746755, (209-211):945533-945535
> TOTAL: 4
> 
> tst_extents:  inode <179868>
> header: magic=af3 entries=512 max=1024 depth=0 generation=0
> Loaded inode 179868
> tst_extents:  root
> (Left 1)
> extent: lblk 176--176, len 1, pblk 746755, flags: LEAF 
> tst_extents:  nl
> (Left 0)
> extent: lblk 209--211, len 3, pblk 945533, flags: LEAF 
> tst_extents:  nl
> nl: No 'next' extent 
> tst_extents:  
> 
> [root@gekko-lp2 tmp]# ls -alhi  fsstress/p98/d3/d12/d1b/d20/d11e/df1/f5b
> 179868 -rw-rw-rw-  1 122091 root 708K Apr  8 09:13
> fsstress/p98/d3/d12/d1b/d20/d11e/df1/f5b
> 
> The file system is 100% full
> /dev/sda7             9.2G  9.2G     0 100% /mnt/tmp
> 
> 
> -aneesh
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
