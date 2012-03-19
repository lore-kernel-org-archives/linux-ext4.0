From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH 2/9] ext4: Use pr_fmt and pr_<level>
Date: Mon, 19 Mar 2012 00:14:30 -0400 (EDT)
Message-ID: <20120319.001430.1735750114727679638.davem@davemloft.net>
References: <cover.1331856299.git.joe@perches.com>
	<ceb0e02f9f0c1548a654e8718fbadc147595f8ee.1331856300.git.joe@perches.com>
	<20120319040950.GG31682@thunk.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: joe@perches.com, adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([198.137.202.13]:56465 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752174Ab2CSEOs (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 19 Mar 2012 00:14:48 -0400
In-Reply-To: <20120319040950.GG31682@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: "Ted Ts'o" <tytso@mit.edu>
Date: Mon, 19 Mar 2012 00:09:50 -0400

> Changing printk's to pr_info and pr_cont is patch noise as far as I'm
> concerned.

Ted, get off your high horse.

I apply patches like Joe's all the time to the networking, consistency
has high value whether you choose to believe it or not.  And no we
don't have huge problems with patch conflicts and stuff like that
either, it simply isn't a real issue so don't use that as an excuse
either.

