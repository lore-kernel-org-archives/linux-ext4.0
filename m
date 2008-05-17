From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 1/3] libext2fs: ext2fs_node_split
Date: Sat, 17 May 2008 19:20:43 -0400
Message-ID: <20080517232043.GF16496@mit.edu>
References: <1210875464-25552-1-git-send-email-sandeen@redhat.com> <1210875464-25552-2-git-send-email-sandeen@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:50069 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751712AbYEQXUp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 17 May 2008 19:20:45 -0400
Content-Disposition: inline
In-Reply-To: <1210875464-25552-2-git-send-email-sandeen@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> +	/* splitting root level means moving them all out */
> +	if (handle->level == 0) {
> +		new_root = 1;
> +		tocopy = ext2fs_le16_to_cpu(eh->eh_entries);
> +	} else {
> +		tocopy = ext2fs_le16_to_cpu(eh->eh_entries) / 2;
> +	}

This is probably in the "would be nice" category, but if we know that
we are appending to the file, it might actually be better to move all
of the entries into one block, and create an empty block to the right.
That way, the average density of the leaf nodes will be much closer to
100%, instead of 50% full.

This optimization is far more important in the kernel, though.

     		     	      		       - Ted
