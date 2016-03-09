From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 3/6] ext4: Rename and split get blocks functions
Date: Tue, 8 Mar 2016 23:09:14 -0500
Message-ID: <20160309040914.GC3150@thunk.org>
References: <1455897582-13292-1-git-send-email-jack@suse.cz>
 <1455897582-13292-4-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:49192 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750942AbcCIEJR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 8 Mar 2016 23:09:17 -0500
Content-Disposition: inline
In-Reply-To: <1455897582-13292-4-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Feb 19, 2016 at 04:59:39PM +0100, Jan Kara wrote:
> Rename ext4_get_blocks_write() to ext4_get_blocks_unwritten() to better
> describe what it does. Also split out get blocks functions for direct
> IO. Later we move functionality from _ext4_get_blocks() there. There's no
> functional change in this patch.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Thanks, applied.

							- Ted
