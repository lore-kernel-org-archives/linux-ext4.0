From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: ext4_da_convert_inline_data_to_extent drop locked
 page after error
Date: Tue, 2 Dec 2014 20:36:57 -0500
Message-ID: <20141203013657.GK13618@thunk.org>
References: <1417530500-9958-1-git-send-email-dmonakhov@openvz.org>
 <20141202235913.GJ13618@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:35870 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750884AbaLCBhA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 2 Dec 2014 20:37:00 -0500
Content-Disposition: inline
In-Reply-To: <20141202235913.GJ13618@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Dec 02, 2014 at 06:59:13PM -0500, Theodore Ts'o wrote:
> This patch makes sense but I haven't been able to duplicate the
> failure.  Maybe it's sensitive to the size of the scratch device, or
> some such?

Anyway, I've applied the patch.

	     	     	       	     	- Ted
