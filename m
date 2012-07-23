From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [patch -next] ext4: locking issue on error path
Date: Sun, 22 Jul 2012 20:20:43 -0400
Message-ID: <20120723002043.GF9958@thunk.org>
References: <20120717063106.GA14985@elgon.mountain>
 <20120717081351.GA4513@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Dan Carpenter <dan.carpenter@oracle.com>,
	Zheng Liu <wenqing.lz@taobao.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:40585 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752677Ab2GWAUu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 22 Jul 2012 20:20:50 -0400
Content-Disposition: inline
In-Reply-To: <20120717081351.GA4513@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jul 17, 2012 at 04:13:51PM +0800, Zheng Liu wrote:
> On Tue, Jul 17, 2012 at 09:31:06AM +0300, Dan Carpenter wrote:
> > We recently changed how the locking worked here, but this error path was
> > missed.
> > 
> > Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> Sorry, it is my fault.  Thanks for pointing out this bug.

Since this patch hadn't been promoted past the master branch pointer
(it was only in the dev branch, which can be rebased), I've merged
this fix up with Zheng's original patch.

Dan, may thanks for finding and pointing it out!!

					- Ted
