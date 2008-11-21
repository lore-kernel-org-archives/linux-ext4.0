From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH -V4] ext4: sparse fixes
Date: Fri, 21 Nov 2008 12:51:10 -0500
Message-ID: <20081121175110.GA12412@infradead.org>
References: <1227285636-16221-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com,
	linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:45243 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751942AbYKURvX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 21 Nov 2008 12:51:23 -0500
Content-Disposition: inline
In-Reply-To: <1227285636-16221-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Nov 21, 2008 at 10:10:36PM +0530, Aneesh Kumar K.V wrote:
>  #define EXT4_HAS_COMPAT_FEATURE(sb,mask)			\
> -	(EXT4_SB(sb)->s_es->s_feature_compat & cpu_to_le32(mask))
> +	(__force __u32)!!(EXT4_SB(sb)->s_es->s_feature_compat &	\
> +					cpu_to_le32(mask))

As mentioned before please don't abuse __force here.

	((EXT4_SB(sb)->s_es->s_feature_compat & cpu_to_le32(mask)) != 0)

does the right things and is a lote more readable.

