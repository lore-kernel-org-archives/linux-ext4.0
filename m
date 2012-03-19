From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 5/9] ext4: Avoid output message interleaving in
 ext4_error_<foo>
Date: Mon, 19 Mar 2012 00:51:07 -0400
Message-ID: <20120319045107.GO31682@thunk.org>
References: <cover.1331856299.git.joe@perches.com>
 <32524e1c6f17ec482a90cb0066934c1955704561.1331856300.git.joe@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Joe Perches <joe@perches.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:43666 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752480Ab2CSEvH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 19 Mar 2012 00:51:07 -0400
Content-Disposition: inline
In-Reply-To: <32524e1c6f17ec482a90cb0066934c1955704561.1331856300.git.joe@perches.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Mar 15, 2012 at 05:07:33PM -0700, Joe Perches wrote:
> Using pr_cont means that messages from multiple threads
> may be interleaved.  Avoid this by using a single pr_<level>
> call in ext4_error_inode and ext4_error_file.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Applied, (with some changes so the patch would apply cleanly), thanks.

	       	    	       	   - Ted
