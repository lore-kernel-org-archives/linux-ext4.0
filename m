From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Subject: Re: [PATCH] Journal Checksum - rebased to 2.6.22-rc5
Date: Tue, 26 Jun 2007 09:13:57 -0500
Message-ID: <1182867237.11569.2.camel@kleikamp.austin.ibm.com>
References: <1182504986.3788.18.camel@dhcp7.linsyssoft.com>
	 <1182854850.3041.16.camel@dhcp7.linsyssoft.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Ext4 Mailing List <linux-ext4@vger.kernel.org>,
	Andreas Dilger <adilger@clusterfs.com>,
	Theodore Tso <tytso@mit.edu>, Mingming Cao <cmm@us.ibm.com>
To: Girish Shilamkar <girish@linsyssoft.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:55051 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751466AbXFZOOB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 26 Jun 2007 10:14:01 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e2.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l5QEDx8g029718
	for <linux-ext4@vger.kernel.org>; Tue, 26 Jun 2007 10:13:59 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l5QEDxju554078
	for <linux-ext4@vger.kernel.org>; Tue, 26 Jun 2007 10:13:59 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l5QEDwLK023237
	for <linux-ext4@vger.kernel.org>; Tue, 26 Jun 2007 10:13:58 -0400
In-Reply-To: <1182854850.3041.16.camel@dhcp7.linsyssoft.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, 2007-06-26 at 16:17 +0530, Girish Shilamkar wrote:
> On Fri, 2007-06-22 at 15:06 +0530, Girish Shilamkar wrote:
> > Hi,
> > 	The previous patch was an old one. Hence I am sending the latest patch
> > rebased to 2.6.22-rc5. I have also fixed few coding style issues in both
> > the patches.
> > 
> > Regards,
> > Girish
> This patch had a bug. Thanks to Valerie for pointing it out.

I updated the patch queue with the updated patch and this fix.

Thanks,
Shaggy

> Regards,
> Girish.
> 
> Index: linux-2.6.22-rc5/fs/jbd2/commit.c
> ===================================================================
> --- linux-2.6.22-rc5.orig/fs/jbd2/commit.c
> +++ linux-2.6.22-rc5/fs/jbd2/commit.c
> @@ -121,8 +121,8 @@ static int journal_submit_commit_record(
>         bh = jh2bh(descriptor);
> 
>         for (i = 0; i < bh->b_size; i += 512) {
> -               struct commit_header *tmp = (struct commit_header *)bh->b_data +
> -                                           i;
> +               struct commit_header *tmp = (struct commit_header *)(bh->b_data+
> +                                           i);
>                 tmp->h_magic = cpu_to_be32(JBD2_MAGIC_NUMBER);
>                 tmp->h_blocktype = cpu_to_be32(JBD2_COMMIT_BLOCK);
>                 tmp->h_sequence = cpu_to_be32(commit_transaction->t_tid);
> 
> 

-- 
David Kleikamp
IBM Linux Technology Center
