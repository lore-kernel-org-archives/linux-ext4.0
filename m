From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/2] ext4: ext4_init_block_bitmap move error report out
 of atomic context
Date: Mon, 13 Oct 2014 04:00:12 -0400
Message-ID: <20141013080012.GB9738@thunk.org>
References: <1413147967-30487-1-git-send-email-dmonakhov@openvz.org>
 <1413147967-30487-2-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:49519 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752384AbaJMIAZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 13 Oct 2014 04:00:25 -0400
Content-Disposition: inline
In-Reply-To: <1413147967-30487-2-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Oct 13, 2014 at 01:06:07AM +0400, Dmitry Monakhov wrote:
> Error report likely result in IO so it is bad idea to do it from atomic context.

Thanks, applied.

					- Ted
