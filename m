From: Mike Galbraith <efault@gmx.de>
Subject: Re: [PATCH] Add ext3 data=guarded mode
Date: Fri, 17 Apr 2009 13:04:36 +0200
Message-ID: <1239966276.8806.7.camel@marge.simson.net>
References: <1239816159-6868-1-git-send-email-chris.mason@oracle.com>
	 <a22f99ce2199ebebe63228edd8afa4809511ab1e.1239815649.git.chris.mason@oracle.com>
	 <1239910921.21233.98.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Jan Kara <jack@suse.cz>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Theodore Ts'o <tytso@mit.edu>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:43595 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1759289AbZDQLEo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 17 Apr 2009 07:04:44 -0400
In-Reply-To: <1239910921.21233.98.camel@think.oraclecorp.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 2009-04-16 at 15:42 -0400, Chris Mason wrote:
> Hello everyone,
> 
> Here's an updated (v4) patch for ext3 data=guarded mode.  The first two
> patches in the series are unchanged, and it looks like Linus pulled them
> in this morning.
> 
> This version fixes the bug Mike Galbraith hit.  The problem was with
> writes to the last block in the file that made the file bigger but
> didn't actually add a new block.  Since the block wasn't new, it
> wouldn't get sent through the guarded code and the on disk i_size wasn't
> always updated.

FWIW, I booted my backup fs drive mounted data=guarded, and have been
hammering it steadily since 6 A.M. with no hint of trouble.

	-Mike

