From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 4/4] ext4: fix suboptimal seek_{data,hole} extents
 traversial
Date: Sun, 28 Dec 2014 23:13:10 -0500
Message-ID: <20141229041310.GE24553@thunk.org>
References: <1417518054-21733-1-git-send-email-dmonakhov@openvz.org>
 <1417518054-21733-4-git-send-email-dmonakhov@openvz.org>
 <20141211200540.GE31008@thunk.org>
 <878uidgshe.fsf@openvz.org>
 <20141217035713.GW17575@thunk.org>
 <87y4q6joy4.fsf@openvz.org>
 <20141227153924.GC24553@thunk.org>
 <87tx0f7gel.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:45025 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751863AbaL2ENK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 28 Dec 2014 23:13:10 -0500
Content-Disposition: inline
In-Reply-To: <87tx0f7gel.fsf@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Dec 28, 2014 at 10:55:46PM +0400, Dmitry Monakhov wrote:
> Yes. I've already sent you updated patches
> https://patchwork.ozlabs.org/patch/422594/
> https://patchwork.ozlabs.org/patch/422595/

Thanks, this somehow got lost from my inbox.  I'm not sure how it
happened, but I do see it in patchwork.

	  	      	       	     - Ted
