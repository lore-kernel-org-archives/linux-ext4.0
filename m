From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH 2/9] ext4: Use pr_fmt and pr_<level>
Date: Mon, 19 Mar 2012 13:53:42 -0400 (EDT)
Message-ID: <20120319.135342.859237474072712585.davem@davemloft.net>
References: <20120319043420.GL31682@thunk.org>
	<20120319.011211.89954160788757412.davem@davemloft.net>
	<20120319153133.GA2502@thunk.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: joe@perches.com, adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([198.137.202.13]:36703 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964832Ab2CSRxy (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 19 Mar 2012 13:53:54 -0400
In-Reply-To: <20120319153133.GA2502@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: "Ted Ts'o" <tytso@mit.edu>
Date: Mon, 19 Mar 2012 11:31:34 -0400

> And in the past we've always allowed for local variations of style;
> it's never been a strict style nazism.  Linus has always given
> maintainers latitude and has frowned on patch churn for churn's sake.

The variations in opinion and taste are why it's important for
us to discuss the interfaces and tweak them so that most people
are happy with them and then everyone uses them.

Your story about get_fs() still being around isn't a victory,
or an accomplishment, it's just a small failure that we've been
too lazy to fix.  But it's one that if someone did post a patch
for it, would be accepted.

And the thing you call churn, I call development and progress.

