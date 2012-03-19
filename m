From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/9] ext4: Use pr_fmt and pr_<level>
Date: Mon, 19 Mar 2012 00:36:26 -0400
Message-ID: <20120319043626.GM31682@thunk.org>
References: <cover.1331856299.git.joe@perches.com>
 <ceb0e02f9f0c1548a654e8718fbadc147595f8ee.1331856300.git.joe@perches.com>
 <20120319040950.GG31682@thunk.org>
 <1332131137.23125.44.camel@joe2Laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Joe Perches <joe@perches.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:55809 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750881Ab2CSEgY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 19 Mar 2012 00:36:24 -0400
Content-Disposition: inline
In-Reply-To: <1332131137.23125.44.camel@joe2Laptop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Mar 18, 2012 at 09:25:37PM -0700, Joe Perches wrote:
> On Mon, 2012-03-19 at 00:09 -0400, Ted Ts'o wrote:
> > One evidence that this patch is noise is that it doesn't apply cleanly
> > just on top of my current patch set that I plan to send to Linus.
> 
> That's crap for evidence.
> 
> It's more evident that you don't make
> public your own internal patch queue
> quickly enough than anything else.

It's all in linux-next, under the dev branch.  There are a few things
which I recently added over the weekend, but it's all been there for
quite a while.

Tell you what, when you write your own file system you can develop it
however you please.

						- Ted
