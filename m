From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Subject: Re: ext4-online-defrag-free-space-fragmentation.patch uses
	do_fsync()
Date: Wed, 23 Jan 2008 08:10:20 -0600
Message-ID: <1201097420.9082.5.camel@norville.austin.ibm.com>
References: <E1JHg4T-0007lQ-8f@closure.thunk.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, Mingming Cao <cmm@us.ibm.com>,
	Takashi Sato <t-sato@yk.jp.nec.com>,
	Akira Fujita <a-fujita@rs.jp.nec.com>
To: "Theodore Ts'o" <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:36650 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752097AbYAWOKb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 23 Jan 2008 09:10:31 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e2.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m0NEARf2025081
	for <linux-ext4@vger.kernel.org>; Wed, 23 Jan 2008 09:10:27 -0500
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m0NEAQCH147182
	for <linux-ext4@vger.kernel.org>; Wed, 23 Jan 2008 09:10:26 -0500
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m0NEAQ39014052
	for <linux-ext4@vger.kernel.org>; Wed, 23 Jan 2008 09:10:26 -0500
In-Reply-To: <E1JHg4T-0007lQ-8f@closure.thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


> diff --git a/fs/ext4/defrag.c b/fs/ext4/defrag.c
> index 4ef3dc0..19d2cfd 100644
> --- a/fs/ext4/defrag.c
> +++ b/fs/ext4/defrag.c
> @@ -632,8 +632,9 @@ static int ext4_ext_defrag_victim(struct file *target_filp,
>  		}
> 
>  		/* Sync journal blocks before reservation */
> -		if (do_fsync(target_filp, 0)) {
> -			printk(KERN_ERR "defrag: failed do_fsync\n");
> +		ret = ext4_force_commit(sb);
> +		if (ret) {
> +			printk(KERN_ERR "defrag: failed do_fsync (%d)\n", ret);

I'd think you'd want to change the printk text as well.  "defrag: failed
ext4_force_commit (%d)\n" maybe?

>  			goto ERR;
>  		}
>  	}

-- 
David Kleikamp
IBM Linux Technology Center
