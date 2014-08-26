From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 3/5] ext4_zero_range: fix incorect journal credits
 reservation
Date: Mon, 25 Aug 2014 21:30:43 -0400
Message-ID: <20140826013043.GD11317@thunk.org>
References: <1408707147-22482-1-git-send-email-dmonakhov@openvz.org>
 <1408707147-22482-4-git-send-email-dmonakhov@openvz.org>
 <20140823190835.GB6236@thunk.org>
 <87k35x9gtw.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, lczerner@redhat.com
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:48877 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932194AbaHZBaq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 25 Aug 2014 21:30:46 -0400
Content-Disposition: inline
In-Reply-To: <87k35x9gtw.fsf@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> From ec7e1926e8bb99ccd0eb525efc6666cb8ea36a5e Mon Sep 17 00:00:00 2001
> From: Dmitry Monakhov <dmonakhov@openvz.org>
> Date: Mon, 25 Aug 2014 11:12:35 +0400
> Subject: [PATCH] ext4_zero_range: fix incorect journal credits reservation v2
> 
> Currently we reserve only 4 blocks but in worst case scenario
> ext4_zero_partial_blocks() may want to zeroout and convert two
> non adjacent blocks.
> 
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>

Applied, thanks.

					- Ted
