From: Alex Tomas <alex@clusterfs.com>
Subject: Re: [RFC] mballoc patches
Date: Mon, 10 Sep 2007 16:29:52 +0400
Message-ID: <46E538C0.7090205@clusterfs.com>
References: <1187000545401-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <46C08902.7020709@linux.vnet.ibm.com> <46CB527B.5090300@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.rialcom.ru ([80.71.244.250]:46943 "EHLO mail.rialcom.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757829AbXIJMaj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 10 Sep 2007 08:30:39 -0400
In-Reply-To: <46CB527B.5090300@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Eric Sandeen wrote:
> +/*
> + * default stripe size = 1MB
> + */
> +#define MB_DEFAULT_STRIPE              256

agree, though seems we'd better make it blocksize-insensitive

> 
> Units?  Doesn't seem to matter anyway as it's never referenced.
> 
> +       /* tunables */
> +       unsigned long s_mb_factor;
> +       unsigned long s_stripe;
> +       unsigned long s_mb_small_req;
> +       unsigned long s_mb_large_req;
> +       unsigned long s_mb_max_to_scan;
> +       unsigned long s_mb_min_to_scan;
> 
> could we get some comments here as to what these are, and what units?

OK, I'll do as well as policy (and tunning) description.

> 
> Same is true many places... for example
> 
> +static int mb_find_extent(struct ext4_buddy *e3b, int order, int block,
> +                               int needed, struct ext4_free_extent *ex)
> 
> how many "what" are needed?

well, blocks :)

> And perhaps an addition of the new mount options to
> Documentation/fs/ext4.txt would be good.
> 
> +#define EXT4_MB_BITMAP(e3b)    ((e3b)->bd_bitmap)
> +#define EXT4_MB_BUDDY(e3b)     ((e3b)->bd_buddy)
> 
> For the sake of consistency should these (and others) be e4b?

OK

> 
> Also there are a *lot* of BUGs and BUG_ONs added in this patch... are
> none of these recoverable?

well, I'll review the code in this regard again, but most of them are not.
not that I like kernel panics, but BUG_ON() are very helpful to maintain
code, especially in long-term.

thanks, Alex
