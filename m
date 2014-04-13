From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 3/3] ext4: remove obsoleted check
Date: Sun, 13 Apr 2014 18:13:46 -0400
Message-ID: <20140413221346.GF8122@thunk.org>
References: <1397403361-20459-1-git-send-email-dmonakhov@openvz.org>
 <1397403361-20459-3-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:53681 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750758AbaDMWNs (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 13 Apr 2014 18:13:48 -0400
Content-Disposition: inline
In-Reply-To: <1397403361-20459-3-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Apr 13, 2014 at 07:36:01PM +0400, Dmitry Monakhov wrote:
> BH can not be NULL at this point, ext4_read_dirblock() always return
> non null value, and we already have done all necessery checks.
> 
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>

Thanks, queued for the next merge window (since it's not a bug fix,
but just a clean up).

						- Ted
