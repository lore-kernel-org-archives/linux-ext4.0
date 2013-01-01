From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/2 v2] debugfs: fixup the hard-coded buffer length in
 dump_file
Date: Tue, 1 Jan 2013 15:14:19 -0500
Message-ID: <20130101201419.GA12554@thunk.org>
References: <1357043415-24668-1-git-send-email-wenqing.lz@taobao.com>
 <1357043415-24668-2-git-send-email-wenqing.lz@taobao.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, George Spelvin <linux@horizon.com>,
	Zheng Liu <wenqing.lz@taobao.com>
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:41219 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752464Ab3AAUOZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 1 Jan 2013 15:14:25 -0500
Content-Disposition: inline
In-Reply-To: <1357043415-24668-2-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jan 01, 2013 at 08:30:14PM +0800, Zheng Liu wrote:
> +	retval = ext2fs_get_array(1, blocksize, &buf);

Thanks, applied.  I did make one change to the above line:

	retval = ext2fs_get_mem(blocksize, &buf);

							- Ted
