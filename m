From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 6/8] fsstress: translate flags in fiemap_f
Date: Thu, 6 Mar 2014 09:48:13 -0800
Message-ID: <20140306174813.GE28297@infradead.org>
References: <1394034699-21187-1-git-send-email-lczerner@redhat.com>
 <1394034699-21187-7-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	xfs@oss.sgi.com
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:36973 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751951AbaCFRsN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 6 Mar 2014 12:48:13 -0500
Content-Disposition: inline
In-Reply-To: <1394034699-21187-7-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> +#ifdef HAVE_LINUX_FIEMAP_H
> +struct print_flags fiemap_flags[] = {
> +	{ FIEMAP_FLAG_SYNC, "SYNC"},
> +	{ FIEMAP_FLAG_XATTR, "XATTR"},
> +	{ -1, NULL}
> +};

Can be static.

> +
> +#define translate_fiemap_flags(mode)	\
> +	({translate_flags(mode, "|", fiemap_flags);})
> +#endif

Any reason to not have these two inside fiemap_f?

Otherwise:

Reviewed-by: Christoph Hellwig <hch@lst.de>
