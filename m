From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] fully and properly gettextize two error messages in
 e2fsck
Date: Sun, 1 Jun 2014 21:19:26 -0400
Message-ID: <20140602011926.GB6248@thunk.org>
References: <1401658069.328.123945581.4DB549FE@webmail.messagingengine.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Benno Schulenberg <bensberg@justemail.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:44568 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752612AbaFBBT3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 1 Jun 2014 21:19:29 -0400
Content-Disposition: inline
In-Reply-To: <1401658069.328.123945581.4DB549FE@webmail.messagingengine.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Thanks, applied.

BTW, it's much better to use git send-email to send a patch series.
That way, the patches are properly chained which makes it easier for
me to find and apply the messages in the proper order.  Also, that way
I can review the patch, and if it's Obviously Correct (tm), I can just
add it to a unix mbox file, and then apply a set of patches using the
"git am" command.

Cheers,

					- Ted
