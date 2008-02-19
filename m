From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH 2/4] ext4: add missing ext4_journal_stop()
Date: Mon, 18 Feb 2008 23:45:44 -0800
Message-ID: <1203407144.3612.24.camel@localhost.localdomain>
References: <20080217061137.GI3390@APFDCB5C>
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
Received: from e2.ny.us.ibm.com ([32.97.182.142]:56656 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758867AbYBSHpt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 19 Feb 2008 02:45:49 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e2.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m1J7jmJ3015789
	for <linux-ext4@vger.kernel.org>; Tue, 19 Feb 2008 02:45:48 -0500
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m1J7jmCH243840
	for <linux-ext4@vger.kernel.org>; Tue, 19 Feb 2008 02:45:48 -0500
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m1J7jmI8032574
	for <linux-ext4@vger.kernel.org>; Tue, 19 Feb 2008 02:45:48 -0500
In-Reply-To: <20080217061137.GI3390@APFDCB5C>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, 2008-02-17 at 15:11 +0900, Akinobu Mita wrote:
> Add missing ext4_journal_stop() in error handling.
> 
Reviewed and Acked ext2/3/4 changes.

ext4 patch is also queued in ext4 patch queue
http://repo.or.cz/w/ext4-patch-queue.git

Mingming
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> Cc: Stephen Tweedie <sct@redhat.com>
> Cc: adilger@clusterfs.com
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Mingming Cao <cmm@us.ibm.com>
> Cc: Theodore Tso <tytso@MIT.EDU>
> ---
>  fs/ext4/resize.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> Index: 2.6-rc/fs/ext4/resize.c
> ===================================================================
> --- 2.6-rc.orig/fs/ext4/resize.c
> +++ 2.6-rc/fs/ext4/resize.c
> @@ -1037,6 +1037,7 @@ int ext4_group_extend(struct super_block
>  		ext4_warning(sb, __FUNCTION__,
>  			     "multiple resizers run on filesystem!");
>  		unlock_super(sb);
> +		ext4_journal_stop(handle);
>  		err = -EBUSY;
>  		goto exit_put;
>  	}
> -
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
