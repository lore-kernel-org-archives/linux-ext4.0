From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: remove redundant offset check in
 move_extents.c/mext_check_arguments
Date: Thu, 27 Sep 2012 08:03:29 -0400
Message-ID: <20120927120329.GF15707@thunk.org>
References: <500D0542.1020000@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	ext4 development <linux-ext4@vger.kernel.org>,
	linux-kernel@vger.kernel.org
To: Wang Sheng-Hui <shhuiw@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:52666 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752912Ab2I0MDd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 27 Sep 2012 08:03:33 -0400
Content-Disposition: inline
In-Reply-To: <500D0542.1020000@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jul 23, 2012 at 04:03:14PM +0800, Wang Sheng-Hui wrote:
> In the check code above, if orig_start != donor_start, we would
> return -EINVAL. So here, orig_start should be equal with donor_start.
> Remove the redundant check here.
> 
> Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>

Applied, thanks.  (And apologies for the delay in getting back to
you!)

					- Ted
