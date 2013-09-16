From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Fix performance regression in writeback of random
 writes
Date: Mon, 16 Sep 2013 08:28:09 -0400
Message-ID: <20130916122809.GA4159@thunk.org>
References: <1378842006-15237-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Yan Zheng <ukernel@gmail.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:60965 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752173Ab3IPM2M (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 16 Sep 2013 08:28:12 -0400
Content-Disposition: inline
In-Reply-To: <1378842006-15237-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Sep 10, 2013 at 09:40:06PM +0200, Jan Kara wrote:
> Linux Kernel Performance project guys have reported that commit 4e7ea81db5
> introduces a performance regression for the following fio workload:...

Applied, many thanks to Yan Zheng for finding this performance
regression and to Jan for fixing it!

	   					- Ted
