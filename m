From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH] ext4: update ctime and mtime for truncate with extents.
Date: Wed, 09 Apr 2008 21:39:57 -0700
Message-ID: <1207802397.3616.4.camel@localhost.localdomain>
References: <Pine.LNX.4.62.0804030034200.664@tamago.serverit.net>
	 <18425.57003.125097.61814@frecb006361.adech.frec.bull.fr>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, Szabolcs Szakacsits <szaka@ntfs-3g.com>
To: Solofo.Ramangalahy@bull.net
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:41790 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750828AbYDJEkA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 10 Apr 2008 00:40:00 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e6.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m3A4g1tL016486
	for <linux-ext4@vger.kernel.org>; Thu, 10 Apr 2008 00:42:01 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m3A4dtDO252762
	for <linux-ext4@vger.kernel.org>; Thu, 10 Apr 2008 00:39:57 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m3A4dsSv011894
	for <linux-ext4@vger.kernel.org>; Thu, 10 Apr 2008 00:39:55 -0400
In-Reply-To: <18425.57003.125097.61814@frecb006361.adech.frec.bull.fr>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 2008-04-07 at 10:43 +0200, Solofo.Ramangalahy@bull.net wrote:
> ext4: update ctime and mtime for truncate with extents.
> 
> From: Solofo Ramangalahy <Solofo.Ramangalahy@bull.net>
> 
> The recently announced "Linux POSIX file system test suite"
> catched a truncate issue when using extents:
> mtime and ctime are not updated when truncate is successful.
> 
> This is the single issue catched with "default" ext4 (mkfs and mount
> with minimal options).
> The testsuite does not report failure with -o noextents.
> 
> With the following patch, all tests of the testsuite passes.
> 
Thanks for the fix.

> Signed-off-by: Solofo Ramangalahy <Solofo.Ramangalahy@bull.net>
> 
> ---
>  fs/ext4/extents.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> Index: linux-2.6.25-rc8-git5-ext4-52c7a8013ad2c452551a68ff4daab4bacbe28f9d/fs/ext4/extents.c
> ===================================================================
> --- linux-2.6.25-rc8-git5-ext4-52c7a8013ad2c452551a68ff4daab4bacbe28f9d.orig/fs/ext4/extents.c
> +++ linux-2.6.25-rc8-git5-ext4-52c7a8013ad2c452551a68ff4daab4bacbe28f9d/fs/ext4/extents.c
> @@ -2947,6 +2947,7 @@ out_stop:
>  		ext4_orphan_del(handle, inode);
> 
>  	up_write(&EXT4_I(inode)->i_data_sem);
> +	inode->i_mtime = inode->i_ctime = ext4_current_time(inode);

Shouldn't we mark inode dirty after the ctime and and mtime is changed?

>  	ext4_journal_stop(handle);
>  }
> 

Regards,
Mingming
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

