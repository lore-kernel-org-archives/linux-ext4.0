From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/9] ext4: Use pr_fmt and pr_<level>
Date: Mon, 19 Mar 2012 00:55:14 -0400
Message-ID: <20120319045514.GQ31682@thunk.org>
References: <cover.1331856299.git.joe@perches.com>
 <ceb0e02f9f0c1548a654e8718fbadc147595f8ee.1331856300.git.joe@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Joe Perches <joe@perches.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:52808 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752480Ab2CSEzN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 19 Mar 2012 00:55:13 -0400
Content-Disposition: inline
In-Reply-To: <ceb0e02f9f0c1548a654e8718fbadc147595f8ee.1331856300.git.joe@perches.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Mar 15, 2012 at 05:07:30PM -0700, Joe Perches wrote:
> Use a more current logging style.

Oh, just for yucks, I did a quick check:

% git grep printk | wc -l
71266
% git grep pr_ | wc -l
29552

(and there are no doubt some false positives when grepping for "pr_")

						- Ted
