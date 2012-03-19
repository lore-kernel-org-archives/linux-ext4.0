From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 6/9] ext4: Remove redundant "EXT4-fs: " from uses of
 ext4_msg
Date: Mon, 19 Mar 2012 00:13:35 -0400
Message-ID: <20120319041335.GI31682@thunk.org>
References: <cover.1331856299.git.joe@perches.com>
 <d029f3995ba3c6f50a031671c40dfbcc764da4d2.1331856300.git.joe@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Joe Perches <joe@perches.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:41403 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750801Ab2CSENd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 19 Mar 2012 00:13:33 -0400
Content-Disposition: inline
In-Reply-To: <d029f3995ba3c6f50a031671c40dfbcc764da4d2.1331856300.git.joe@perches.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Mar 15, 2012 at 05:07:34PM -0700, Joe Perches wrote:
> ext4_msg adds "EXT4-fs: " to the messsage output.
> Remove the redundant bits from uses.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Applied, thanks.

					- Ted
