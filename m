From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: ext4: make the bitmap read routines return real error codes
Date: Tue, 3 Nov 2015 11:20:41 -0800
Message-ID: <20151103192041.GC2223@birch.djwong.org>
References: <20151103120445.GA20788@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:29687 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755842AbbKCTUs (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 3 Nov 2015 14:20:48 -0500
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
	by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id tA3JKl0A023453
	(version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Tue, 3 Nov 2015 19:20:48 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
	by aserv0021.oracle.com (8.13.8/8.13.8) with ESMTP id tA3JKlS6009759
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-ext4@vger.kernel.org>; Tue, 3 Nov 2015 19:20:47 GMT
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
	by aserv0121.oracle.com (8.13.8/8.13.8) with ESMTP id tA3JKl7g009157
	for <linux-ext4@vger.kernel.org>; Tue, 3 Nov 2015 19:20:47 GMT
Content-Disposition: inline
In-Reply-To: <20151103120445.GA20788@mwanda>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Nov 03, 2015 at 03:04:45PM +0300, Dan Carpenter wrote:
> Hello Darrick J. Wong,
> 
> The patch 7d6232775976: "ext4: make the bitmap read routines return
> real error codes" from Oct 17, 2015, leads to the following static
> checker warning:
> 
> 	fs/ext4/mballoc.c:2989 ext4_mb_mark_diskspace_used()
> 	error: 'bitmap_bh' dereferencing possible ERR_PTR()
> 
> fs/ext4/mballoc.c
>   2899          bitmap_bh = ext4_read_block_bitmap(sb, ac->ac_b_ex.fe_group);
>   2900          if (IS_ERR(bitmap_bh)) {
>   2901                  err = PTR_ERR(bitmap_bh);
>   2902                  goto out_err;
>   2903          }
>   2904  
> 
> [ snip ]
> 
>   2987  
>   2988  out_err:
>   2989          brelse(bitmap_bh);
>   2990          return err;
>   2991  }
> 
> Also:
> 
> fs/ext4/mballoc.c:4894 ext4_free_blocks() error: 'bitmap_bh' dereferencing possible ERR_PTR()
> fs/ext4/mballoc.c:5028 ext4_group_add_blocks() error: 'bitmap_bh' dereferencing possible ERR_PTR()
> 
> This is One Err style error handling where one error label handles every
> possible error so it's error prone (handling every error is more
> complicated than doing a specific thing).
> 
> The old code relied on the sanity check in brelse() to avoid NULL
> dereferences but now we are passing ERR_PTRs so it's not enough.
> Probably the fix is to update the sanity check in brelse().  Another
> idea would be to not free things until they have been allocated.

Or just slip in a "bitmap_bh = NULL;" just before line 2902.  We've saved
the error code, so the pointer can be zeroed.

Hmm, thank you for the report, I'll get a patch out soon.  Guess I should
go figure out how to smatch-scan my dev tree. :)

(Particularly because I fixed this exact problem in other parts of the patch,
but not here. Sigh.)

--D

> 
> regards,
> dan carpenter
