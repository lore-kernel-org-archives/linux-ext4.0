From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH] check return of ext4_orphan_get properly
Date: Fri, 11 Apr 2008 13:23:32 -0700
Message-ID: <1207945412.3639.7.camel@localhost.localdomain>
References: <20080411193208.GB2757@unused.rdu.redhat.com>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Josef Bacik <jbacik@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:52118 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761382AbYDKUXd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 11 Apr 2008 16:23:33 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e4.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m3BKNWm0010173
	for <linux-ext4@vger.kernel.org>; Fri, 11 Apr 2008 16:23:32 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m3BKNWNh246974
	for <linux-ext4@vger.kernel.org>; Fri, 11 Apr 2008 16:23:32 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m3BKNVXa025884
	for <linux-ext4@vger.kernel.org>; Fri, 11 Apr 2008 16:23:31 -0400
In-Reply-To: <20080411193208.GB2757@unused.rdu.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 2008-04-11 at 15:32 -0400, Josef Bacik wrote:
> Hello,
> 
> Hit a panic while running fsfuzzer, seems we are improperly checking the return
> of ext4_orphan_get.  This patch fixes the problem, thank you
> 
> Signed-off-by: Josef Bacik <jbacik@redhat.com>
> 

Thanks, added to the patch queue.
> 
> Index: linux-2.6/fs/ext4/super.c
> ===================================================================
> --- linux-2.6.orig/fs/ext4/super.c
> +++ linux-2.6/fs/ext4/super.c
> @@ -1652,8 +1652,8 @@ static void ext4_orphan_cleanup (struct 
>  	while (es->s_last_orphan) {
>  		struct inode *inode;
> 
> -		if (!(inode =
> -		      ext4_orphan_get(sb, le32_to_cpu(es->s_last_orphan)))) {
> +		inode = ext4_orphan_get(sb, le32_to_cpu(es->s_last_orphan));
> +		if (IS_ERR(inode)) {
>  			es->s_last_orphan = 0;
>  			break;
>  		}
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

