From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH 2/9] ext4: Use pr_fmt and pr_<level>
Date: Sun, 18 Mar 2012 22:39:37 -0700
Message-ID: <1332135577.9873.8.camel@joe2Laptop>
References: <cover.1331856299.git.joe@perches.com>
	 <ceb0e02f9f0c1548a654e8718fbadc147595f8ee.1331856300.git.joe@perches.com>
	 <20120319045514.GQ31682@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:53142 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755126Ab2CSFjk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 19 Mar 2012 01:39:40 -0400
In-Reply-To: <20120319045514.GQ31682@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 2012-03-19 at 00:55 -0400, Ted Ts'o wrote:
> On Thu, Mar 15, 2012 at 05:07:30PM -0700, Joe Perches wrote:
> > Use a more current logging style.
> Oh, just for yucks, I did a quick check:
> % git grep printk | wc -l
> 71266
> % git grep pr_ | wc -l
> 29552
> (and there are no doubt some false positives when grepping for "pr_")

As there are for printk.

I use "\bpr_(emerg|crit|alert|err|notice|warn|warning|info|debug)\b"
and "\bprintk\b" or -w

I did write "more current" and not predominate
as there are large blocks of historical crud.

You might try the same test on current code in
the last couple of years or so.

pr_<foo> was introduced October 2007 by
commit 1f7c8234c7a68

$ git log -p --since=2-years-ago | \
  grep -P "^\+.*\bpr_(emerg|crit|alert|err|notice|warn|warning|info|debug)\b" | \
  wc -l
22704

$ git log -p --since=2-years-ago | \
  grep -P "^\+.*\bprintk\b" | \
  wc -l
24899

A lot of that was original submissions of older
out-of-tree drivers with printk that were later
converted to pr_<level> or dev_<level>, etc.

In an aside:

Gads, I need a faster netbook, that took
10's of minutes to produce...

Any suggestions?

cheers, Joe

