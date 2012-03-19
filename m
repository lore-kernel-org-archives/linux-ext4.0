From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH 2/9] ext4: Use pr_fmt and pr_<level>
Date: Mon, 19 Mar 2012 01:12:11 -0400 (EDT)
Message-ID: <20120319.011211.89954160788757412.davem@davemloft.net>
References: <20120319040950.GG31682@thunk.org>
	<20120319.001430.1735750114727679638.davem@davemloft.net>
	<20120319043420.GL31682@thunk.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: joe@perches.com, adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([198.137.202.13]:56830 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752964Ab2CSFMZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 19 Mar 2012 01:12:25 -0400
In-Reply-To: <20120319043420.GL31682@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: "Ted Ts'o" <tytso@mit.edu>
Date: Mon, 19 Mar 2012 00:34:20 -0400

> Things like printk(KERN_INFO, ...) are quite well established, and
> changing really doesn't add any value.

It also allows you to modify pr_fmt at the top of the file or
elsewhere and have it influence the output, as just one example
of how it's better.

As a maintainer you can only take one of two positions:

1) Accept all properly written patches that convert code over to use
   the new and recommended way of doing things, such as pr_info() et
   al.

2) Advocate on linux-kernel to remove these new interfaces or improve
   them if you don't find them suitable, and then once suitable go
   back to #1.

Just keeping things the way they are because you simply feel like it
is really not acceptable Ted.
