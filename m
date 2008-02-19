From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH 4/4] ext4: check ext4_journal_get_write_access() errors
Date: Tue, 19 Feb 2008 00:19:30 -0800
Message-ID: <1203409170.3612.33.camel@localhost.localdomain>
References: <20080217061519.GK3390@APFDCB5C>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Stephen Tweedie <sct@redhat.com>, adilger@clusterfs.com,
	Theodore Tso <tytso@MIT.EDU>
To: Akinobu Mita <akinobu.mita@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:58311 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758797AbYBSITi (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 19 Feb 2008 03:19:38 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e5.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m1J8JZkg026701
	for <linux-ext4@vger.kernel.org>; Tue, 19 Feb 2008 03:19:35 -0500
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m1J8JZdC278456
	for <linux-ext4@vger.kernel.org>; Tue, 19 Feb 2008 03:19:35 -0500
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m1J8JYrR022135
	for <linux-ext4@vger.kernel.org>; Tue, 19 Feb 2008 03:19:35 -0500
In-Reply-To: <20080217061519.GK3390@APFDCB5C>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, 2008-02-17 at 15:15 +0900, Akinobu Mita wrote:
> Check ext4_journal_get_write_access() errors.
> 
Acked and added to ext4 patch queue

Mingming
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> Cc: Stephen Tweedie <sct@redhat.com>
> Cc: adilger@clusterfs.com
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Mingming Cao <cmm@us.ibm.com>
> Cc: Theodore Tso <tytso@MIT.EDU>
> ---
>  fs/ext4/namei.c |    9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> Index: 2.6-rc/fs/ext4/namei.c
> ===================================================================
> --- 2.6-rc.orig/fs/ext4/namei.c
> +++ 2.6-rc/fs/ext4/namei.c
> @@ -57,10 +57,15 @@ static struct buffer_head *ext4_append(h
> 
>  	*block = inode->i_size >> inode->i_sb->s_blocksize_bits;
> 
> -	if ((bh = ext4_bread(handle, inode, *block, 1, err))) {
> +	bh = ext4_bread(handle, inode, *block, 1, err);
> +	if (bh) {
>  		inode->i_size += inode->i_sb->s_blocksize;
>  		EXT4_I(inode)->i_disksize = inode->i_size;
> -		ext4_journal_get_write_access(handle,bh);
> +		*err = ext4_journal_get_write_access(handle, bh);
> +		if (*err) {
> +			brelse(bh);
> +			bh = NULL;
> +		}
>  	}
>  	return bh;
>  }
