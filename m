From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [PATCH] JBD: use GFP_NOFS  in kmalloc
Date: Wed, 19 Sep 2007 22:25:21 -0600
Message-ID: <20070920042521.GU32520@schatzie.adilger.int>
References: <1190057391.3845.22.camel@localhost.localdomain> <1190066466.31220.5.camel@dyn9047017100.beaverton.ibm.com> <1190069851.6725.6.camel@localhost.localdomain> <20070918090407.GA671@infradead.org> <1190133347.3819.6.camel@localhost.localdomain> <1190138690.6528.23.camel@norville.austin.ibm.com> <1190163601.3819.15.camel@localhost.localdomain> <20070918191920.a2130a3c.akpm@linux-foundation.org> <1190229352.4318.12.camel@localhost.localdomain> <1190229729.4318.19.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	ext4 development <linux-ext4@vger.kernel.org>,
	lkml <linux-kernel@vger.kernel.org>
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([74.0.229.162]:48088 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468AbXITEY5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 20 Sep 2007 00:24:57 -0400
Content-Disposition: inline
In-Reply-To: <1190229729.4318.19.camel@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sep 19, 2007  12:22 -0700, Mingming Cao wrote:
> Convert the GFP_KERNEL flag used in JBD/JBD2 to GFP_NOFS, consistent
> with the rest of kmalloc flag used in the JBD/JBD2 layer.
> 
> @@ -653,7 +653,7 @@ static journal_t * journal_init_common (
> -	journal = kmalloc(sizeof(*journal), GFP_KERNEL);
> +	journal = kmalloc(sizeof(*journal), GFP_NOFS);
> @@ -723,7 +723,7 @@ journal_t * journal_init_dev(struct bloc
> -	journal->j_wbuf = kmalloc(n * sizeof(struct buffer_head*), GFP_KERNEL);
> +	journal->j_wbuf = kmalloc(n * sizeof(struct buffer_head*), GFP_NOFS);
> @@ -777,7 +777,7 @@ journal_t * journal_init_inode (struct i
> -	journal->j_wbuf = kmalloc(n * sizeof(struct buffer_head*), GFP_KERNEL);
> +	journal->j_wbuf = kmalloc(n * sizeof(struct buffer_head*), GFP_NOFS);

Is there a reason for this change except "it's in a filesystem, so it
should be GFP_NOFS"?  We are only doing journal setup during mount so
there shouldn't be any problem using GFP_KERNEL.  I don't think it will
inject any defect into the code, but I don't think it is needed either.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
