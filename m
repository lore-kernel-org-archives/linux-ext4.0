From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 4/9] ext4: Add no_printk argument validation, fix
 fallout
Date: Mon, 19 Mar 2012 00:16:19 -0400
Message-ID: <20120319041619.GJ31682@thunk.org>
References: <cover.1331856299.git.joe@perches.com>
 <12b7235b4eeb7c50ac888b7f28bc1cf737bc397b.1331856300.git.joe@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Joe Perches <joe@perches.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:41408 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750823Ab2CSEQS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 19 Mar 2012 00:16:18 -0400
Content-Disposition: inline
In-Reply-To: <12b7235b4eeb7c50ac888b7f28bc1cf737bc397b.1331856300.git.joe@perches.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Mar 15, 2012 at 05:07:32PM -0700, Joe Perches wrote:
> Add argument validation to debug functions.
> Use ##__VA_ARGS__.
> 
> Fix format and argument mismatches.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Applied, thanks.

					- Ted
