From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: do not get s_umount sem on ext4_quota_off
Date: Wed, 3 Nov 2010 15:51:12 -0400
Message-ID: <20101103195112.GI25614@thunk.org>
References: <87tyk6ln54.fsf@dmon-lap.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:60240 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753563Ab0KCTvR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 3 Nov 2010 15:51:17 -0400
Content-Disposition: inline
In-Reply-To: <87tyk6ln54.fsf@dmon-lap.sw.ru>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Oct 28, 2010 at 12:47:19PM +0400, Dmitry Monakhov wrote:
> 
> It must be already acquired by caller. Fix lock_dep complain.
> 
> Signed-off-by: Dmitry Monakhov <dmonakhov@gmail.com>
> Reviewed-by: Jan Kara <jack@suse.cz>

Added to the patch queue, thanks.

					- Ted
