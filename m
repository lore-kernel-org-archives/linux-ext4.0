From: Zach Brown <zab@redhat.com>
Subject: Re: [RFC PATCH 3/3] ext4: cache all of an extent tree's leaf block
 upon reading
Date: Thu, 11 Jul 2013 11:54:23 -0700
Message-ID: <20130711185423.GA25414@lenny.home.zabbo.net>
References: <1373517542-21234-1-git-send-email-tytso@mit.edu>
 <1373517542-21234-3-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Zheng Liu <gnehzuil.liu@gmail.com>,
	Zheng Liu <wenqing.lz@taobao.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35662 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754513Ab3GKSyb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 11 Jul 2013 14:54:31 -0400
Content-Disposition: inline
In-Reply-To: <1373517542-21234-3-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> @@ -490,6 +491,31 @@ __read_extent_tree_block(const char *function, unsigned int line,
>  	if (err)
>  		goto errout;
>  	set_buffer_verified(bh);
> +	/*
> +	 * If this is a leaf block, cache all of its entries
> +	 */
> +	if (!(flags & EXT4_EX_NOCACHE) && depth == 0) {
> +		struct ext4_extent_header *eh = ext_block_hdr(bh);
> +		struct ext4_extent *ex = EXT_FIRST_EXTENT(eh);
> +		int i;
> +
> +		for (i = eh->eh_entries; i > 0; i--, ex++) {
> +			unsigned int status = EXTENT_STATUS_WRITTEN;
> +			ext4_lblk_t prev = 0, lblk = le32_to_cpu(ex->ee_block);
> +			int len = ext4_ext_get_actual_len(ex);
> +
> +			if (prev && (prev != lblk))
> +				ext4_es_cache_extent(inode, prev,
> +						     lblk - prev, ~0,
> +						     EXTENT_STATUS_HOLE);
> +
> +			if (ext4_ext_is_uninitialized(ex))
> +				status = EXTENT_STATUS_UNWRITTEN;
> +			ext4_es_cache_extent(inode, lblk, len,
> +					     ext4_ext_pblock(ex), status);
> +			prev = lblk + len;
> +		}
> +	}

Isn't prev going to be reinitialized to 0 for every extent?

- z
