From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] resize2fs: Calculate s_first_data_block into minimum
 filesystem size
Date: Wed, 15 Feb 2012 18:41:47 -0500
Message-ID: <20120215234147.GD20023@thunk.org>
References: <1323353349-9675-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:34727 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756036Ab2BOXlv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 15 Feb 2012 18:41:51 -0500
Content-Disposition: inline
In-Reply-To: <1323353349-9675-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Dec 08, 2011 at 03:09:09PM +0100, Jan Kara wrote:
> calculate_minimum_resize_size() forgot to account s_first_data_block
> into minimum filesystem size. Thus in case the size of filesystem was
> such that the last group had the minimal size (50 blocks + metadata
> overhead), the code in adjust_fs_info() decided the group is unneeded,
> removed it, and in some cases the resizing then failed with ENOSPC.
> 
> Fix the issue by properly accounting for s_first_data_block in
> calculate_minimum_resize_size().
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Thanks, applied.

						- Ted
