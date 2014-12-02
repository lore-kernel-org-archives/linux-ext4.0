From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/4] ext4: prevent fsreentrance deadlock for inline_data
Date: Tue, 2 Dec 2014 18:07:07 -0500
Message-ID: <20141202230707.GF13618@thunk.org>
References: <1417518054-21733-1-git-send-email-dmonakhov@openvz.org>
 <1417518054-21733-2-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:35587 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932722AbaLBXHI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 2 Dec 2014 18:07:08 -0500
Content-Disposition: inline
In-Reply-To: <1417518054-21733-2-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Dec 02, 2014 at 03:00:52PM +0400, Dmitry Monakhov wrote:
> ext4_da_convert_inline_data_to_extent() invokes grab_cache_page_write_begin().
> grab_cache_page_write_begin performs memory allocation, so fs-reentrance
> should be prohibited because we are inside journal transaction.
> 
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>

Thanks, applied.

						- Ted
