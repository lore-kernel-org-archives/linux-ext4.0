From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH 2/9] ext4: Use pr_fmt and pr_<level>
Date: Tue, 20 Mar 2012 03:10:01 -0400 (EDT)
Message-ID: <20120320.031001.1532841232287663716.davem@davemloft.net>
References: <20120320025835.GE14363@thunk.org>
	<1332212574.7847.49.camel@joe2Laptop>
	<216818.1332222366@turing-police.cc.vt.edu>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: joe@perches.com, tytso@mit.edu, anca.emanuel@gmail.com,
	adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Valdis.Kletnieks@vt.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([198.137.202.13]:43811 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752926Ab2CTHKR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 20 Mar 2012 03:10:17 -0400
In-Reply-To: <216818.1332222366@turing-police.cc.vt.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Valdis.Kletnieks@vt.edu
Date: Tue, 20 Mar 2012 01:46:06 -0400

> OK. Say I'm a scraper.  How do I distinguish between:
> 
> pr_info("foo");
> printk(KERN_INFO "foo");
> 
> Oh my. seems that both result in exactly the same thing ending up in the
> dmesg buffer

No it doesn't result in the same output, read the definitions again.

pr_info can be influenced by pr_fmt, plain printk cannot


