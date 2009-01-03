From: Frank Mayhar <fmayhar@google.com>
Subject: Re: [PATCH] Allow ext4 to run without a journal.
Date: Sat, 03 Jan 2009 12:19:00 -0800
Message-ID: <1231013940.22046.4.camel@bobble.smo.corp.google.com>
References: <1228953270.14314.15.camel@bobble.smo.corp.google.com>
	 <20081217031210.GA17588@mit.edu>  <20090103155221.GH4758@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.45.13]:27604 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759127AbZACUTp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 3 Jan 2009 15:19:45 -0500
In-Reply-To: <20090103155221.GH4758@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, 2009-01-03 at 10:52 -0500, Theodore Tso wrote:
> I've modified your patch to reflect the comments I made two weeks ago.
> Were there any other changes you have planned?  I'd like to get this
> pushed to Linus soon....

My apologies, I have a new patch that has been tested quite a bit more
(although I still wouldn't say quite thoroughly yet, but close), all I
need to do is set it up correctly for you guys and send it to the list.
Unfortunately other stuff (including the holidays) has gotten in the
way.  Expect it on Monday or Tuesday.  Note that this version will have
a handful of small but important bugs fixed, as well.

One question:  Shold I make the patch relative to the stable tree or to
the latest bits?
-- 
Frank Mayhar <fmayhar@google.com>
Google, Inc.

