From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH] Fix oops with jbd-stats-through-procfs and external
	journal
Date: Thu, 25 Oct 2007 12:24:06 -0700
Message-ID: <1193340246.4288.3.camel@localhost.localdomain>
References: <4720C6DC.7010803@redhat.com>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	johann.lombardi@bull.net
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:37752 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752718AbXJYTYG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 25 Oct 2007 15:24:06 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e1.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l9PJO3Lk006814
	for <linux-ext4@vger.kernel.org>; Thu, 25 Oct 2007 15:24:03 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l9PJO3s5053854
	for <linux-ext4@vger.kernel.org>; Thu, 25 Oct 2007 15:24:03 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l9PJO2gE029848
	for <linux-ext4@vger.kernel.org>; Thu, 25 Oct 2007 15:24:03 -0400
In-Reply-To: <4720C6DC.7010803@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Thanks, Added to ext4 patch queue at
http://repo.or.cz/w/ext4-patch-queue.git

On Thu, 2007-10-25 at 11:39 -0500, Eric Sandeen wrote:
> When using an external device for the journal,
> jbd2_stats_proc_init() wants to use journal->j_dev in its call
> to bdevname() but it's not assigned yet, resulting in an oops.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> 
> --- linux.orig/fs/jbd2/journal.c	2007-10-25 11:36:25.772354262 -0500
> +++ linux/fs/jbd2/journal.c	2007-10-25 11:36:35.058278242 -0500
> @@ -1035,11 +1035,11 @@
>  		journal = NULL;
>  		goto out;
>  	}
> -	jbd2_stats_proc_init(journal);
>  	journal->j_dev = bdev;
>  	journal->j_fs_dev = fs_dev;
>  	journal->j_blk_offset = start;
>  	journal->j_maxlen = len;
> +	jbd2_stats_proc_init(journal);
> 
>  	bh = __getblk(journal->j_dev, start, journal->j_blocksize);
>  	J_ASSERT(bh != NULL);
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
