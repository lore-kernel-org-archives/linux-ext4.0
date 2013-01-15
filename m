From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/5] mke2fs: enforce that the cluster size must be less
 that the block size
Date: Mon, 14 Jan 2013 19:41:58 -0500
Message-ID: <20130115004158.GC24179@thunk.org>
References: <20130114211014.GA22642@thunk.org>
 <1358210232-30578-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: gnehzuil.liu@gmail.com
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:43396 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756107Ab3AOAmA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 14 Jan 2013 19:42:00 -0500
Content-Disposition: inline
In-Reply-To: <1358210232-30578-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jan 14, 2013 at 07:37:08PM -0500, Theodore Ts'o wrote:
> +		if (fs_param.s_log_cluster_size &&
> +		    fs_param.s_log_cluster_size < fs_param.s_log_block_size) {
> +			com_err(program_name, 0,
> +				_("The cluster size must not be "
> +				  "smaller than the block size.\n"));

This would read better: "the cluster size may not be smaller than the
block size"

					- Ted
