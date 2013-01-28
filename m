From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 01/12] ext4: Always use ext4_bio_write_page() for writeout
Date: Mon, 28 Jan 2013 09:31:08 -0500
Message-ID: <20130128143108.GB22711@thunk.org>
References: <1358510446-19174-1-git-send-email-jack@suse.cz>
 <1358510446-19174-2-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:45848 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756514Ab3A1ObL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Jan 2013 09:31:11 -0500
Content-Disposition: inline
In-Reply-To: <1358510446-19174-2-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jan 18, 2013 at 01:00:35PM +0100, Jan Kara wrote:
> Currently we sometimes used block_write_full_page() and sometimes
> ext4_bio_write_page() for writeback (depending on mount options and call
> path). Let's always use ext4_bio_write_page() to simplify things a bit.
> 
> Reviewed-by: Zheng Liu <wenqing.lz@taobao.com>
> Signed-off-by: Jan Kara <jack@suse.cz>

Thanks, applied.

					- Ted
