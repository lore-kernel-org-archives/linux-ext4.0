From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] misc/e2freefrag: Fix argument parsing in do_freefrag()
Date: Sun, 3 Aug 2014 00:12:18 -0400
Message-ID: <20140803041218.GT24826@thunk.org>
References: <1406999611-11532-1-git-send-email-artemiyv@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Artemiy Volkov <artemiyv@acm.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:42061 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750726AbaHCEMX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 3 Aug 2014 00:12:23 -0400
Content-Disposition: inline
In-Reply-To: <1406999611-11532-1-git-send-email-artemiyv@acm.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Aug 03, 2014 at 03:13:31AM +1000, Artemiy Volkov wrote:
> When do_freefrag() is called from debugfs, the value of optind is
> not reset. Rectify that by calling reset_getopt().
> 
> Signed-off-by: Artemiy Volkov <artemiyv@acm.org>

Applied, thanks.

						- Ted
