From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH 3/3] vfs: Add BUG_ON for delayed and unwritten extents
 in submit_bh
Date: Thu, 07 May 2009 10:37:24 -0500
Message-ID: <4A030034.50504@redhat.com>
References: <1241692770-22547-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1241692770-22547-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1241692770-22547-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: cmm@us.ibm.com, tytso@mit.edu, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:37913 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753837AbZEGPhk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 7 May 2009 11:37:40 -0400
In-Reply-To: <1241692770-22547-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Aneesh Kumar K.V wrote:
> We should not do submit_bh for delayed and unwritten extents. So
> add a BUG_ON on them.
> 
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

Makes sense to me, once we get our own house in order.  :)

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  fs/buffer.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/buffer.c b/fs/buffer.c
> index b3e5be7..ec480c8 100644
> --- a/fs/buffer.c
> +++ b/fs/buffer.c
> @@ -2931,6 +2931,8 @@ int submit_bh(int rw, struct buffer_head * bh)
>  	BUG_ON(!buffer_locked(bh));
>  	BUG_ON(!buffer_mapped(bh));
>  	BUG_ON(!bh->b_end_io);
> +	BUG_ON(buffer_delay(bh));
> +	BUG_ON(buffer_unwritten(bh));
>  
>  	/*
>  	 * Mask in barrier bit for a write (could be either a WRITE or a

