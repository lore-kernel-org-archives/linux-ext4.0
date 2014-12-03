From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 0/7 v4] ext4: Extent status tree shrinker improvements
Date: Tue, 2 Dec 2014 21:20:18 -0500
Message-ID: <20141203022018.GM13618@thunk.org>
References: <1416927336-9328-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:35947 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750969AbaLCCUX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 2 Dec 2014 21:20:23 -0500
Content-Disposition: inline
In-Reply-To: <1416927336-9328-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I realized I hadn't ack'ed this patch series, but since this patch
series is an improvement on what we have now, I've included them in
the ext4 git tree.  I'm sure there's more improvements we can do on
the shrinker, but we can use these patches as a starting point.

Thanks to Jan and Zheng for their work!

						- Ted
