From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/9] ext4: Add -DDEBUG to Makefile
Date: Mon, 19 Mar 2012 21:05:02 -0400
Message-ID: <20120320010502.GB14363@thunk.org>
References: <cover.1331856299.git.joe@perches.com>
 <7ee60f3b750f4500f9bdcb64f358acbf17987036.1331856300.git.joe@perches.com>
 <4F63646D.1040700@cavium.com>
 <20120319043937.GN31682@thunk.org>
 <4F677F6C.8030902@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Daney <david.daney@cavium.com>,
	Joe Perches <joe@perches.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: David Daney <ddaney.cavm@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:46945 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754485Ab2CTBFG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 19 Mar 2012 21:05:06 -0400
Content-Disposition: inline
In-Reply-To: <4F677F6C.8030902@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 19, 2012 at 11:48:12AM -0700, David Daney wrote:
> 
> If you want to unconditionally define DEBUG for all of ext4, that is
> fine with me.

Since I don't see the value of pr_debug, and don't plan to use it, I
don't plan to unconditionally define DEBUG.  :-)

					- Ted
