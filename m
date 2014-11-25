From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Remove never taken branch from
 ext4_ext_shift_path_extents()
Date: Tue, 25 Nov 2014 16:24:41 -0500
Message-ID: <20141125212441.GE28449@thunk.org>
References: <1413969304-2842-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:51634 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751174AbaKYVYm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 25 Nov 2014 16:24:42 -0500
Content-Disposition: inline
In-Reply-To: <1413969304-2842-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Oct 22, 2014 at 11:15:04AM +0200, Jan Kara wrote:
> path[depth].p_hdr can never be NULL for a path passed to us (and even if
> it could, EXT_LAST_EXTENT() would make something != NULL from it). So
> just remove the branch.
> 
> Coverity-id: 1196498
> Signed-off-by: Jan Kara <jack@suse.cz>

Applied, thanks.

						- Ted
