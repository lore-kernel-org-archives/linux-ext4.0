From: Namjae Jeon <namjae.jeon@samsung.com>
Subject: RE: [PATCH 5/5] ext4: Fix extent merging in
 ext4_ext_shift_path_extents()
Date: Thu, 17 Apr 2014 14:55:41 +0900
Message-ID: <005f01cf5a01$aa187370$fe495a50$@samsung.com>
References: <004501cf5a00$18bec8d0$4a3c5a70$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: 7bit
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: =?iso-8859-2?Q?Luk=E1=B9_Czerner?= <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:19756 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751852AbaDQFzp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 17 Apr 2014 01:55:45 -0400
Received: from epcpsbgr3.samsung.com
 (u143.gpu120.samsung.co.kr [203.254.230.143])
 by mailout3.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0N4500HY3V4TTR00@mailout3.samsung.com> for
 linux-ext4@vger.kernel.org; Thu, 17 Apr 2014 14:55:41 +0900 (KST)
In-reply-to: <004501cf5a00$18bec8d0$4a3c5a70$@samsung.com>
Content-language: ko
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> There is a bug in ext4_ext_shift_path_extents() where if we actually
> manage to merge a extent we would skip shifting the next extent. This
> will result in in one extent in the extent tree not being properly
> shifted.
> 
> This is causing failure in various xfstests tests using fsx or fsstress
> with collapse range support. It will also cause file system corruption
> which looks something like:
> 
>  e2fsck 1.42.9 (4-Feb-2014)
>  Pass 1: Checking inodes, blocks, and sizes
>  Inode 20 has out of order extents
>         (invalid logical block 3, physical block 492938, len 2)
>  Clear? yes
>  ...
> 
> when running e2fsck.
> 
> It's also very easily reproducible just by running fsx without any
> parameters. I can usually hit the problem within a minute.
> 
> Fix it by increasing ex_start only if we're not merging the extent.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
You can add : Reviewed-by: Namjae Jeon <namjae.jeon@samsung.com>

Thanks!




