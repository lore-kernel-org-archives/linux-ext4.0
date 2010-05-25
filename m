From: tytso@mit.edu
Subject: Re: [PATCH] ext4: restart ext4_ext_remove_space() after
 transaction restart
Date: Tue, 25 May 2010 09:32:41 -0400
Message-ID: <20100525133241.GF5556@thunk.org>
References: <1271910671-16627-1-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, jack@suse.cz,
	aneesh.kumar@linux.vnet.ibm.com, tytso@mit.ed
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:38953 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755010Ab0EYNcr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 25 May 2010 09:32:47 -0400
Content-Disposition: inline
In-Reply-To: <1271910671-16627-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Apr 22, 2010 at 08:31:11AM +0400, Dmitry Monakhov wrote:
> @@ -2480,6 +2480,11 @@ static int ext4_ext_remove_space(struct inode *inode, ext4_lblk_t start)
>  out:
>  	ext4_ext_drop_refs(path);
>  	kfree(path);
> +	if (err == EAGAIN) {

Surely this should be "err == -EAGAIN", no?  I'm curious how this
patch worked for with this typo....

> +		err = 0;
> +		goto again;
> +	}
> +	ext4_clear_inode_state(inode, EXT4_STATE_EXT_TRUNC);
>  	ext4_journal_stop(handle);
>  
>  	return err;

					- Ted
