From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/2] Use ext4_ext_next_allocated_block instead of
 mext_next_extent -v2
Date: Sun, 31 Aug 2014 15:23:40 -0400
Message-ID: <20140831192340.GG8974@thunk.org>
References: <1408195026-2313-1-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, lczerner@redhat.com
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:58091 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751912AbaHaTXq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 31 Aug 2014 15:23:46 -0400
Content-Disposition: inline
In-Reply-To: <1408195026-2313-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Aug 16, 2014 at 05:17:05PM +0400, Dmitry Monakhov wrote:
> This allow to make mext_next_extent static and potentially get rid of it.
> 
> Changes from v1-v2:
>  - Optimize traversing inside one leaf (in response to lczerner@ comments)
> 
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>

Applied, thanks.

					- Ted
