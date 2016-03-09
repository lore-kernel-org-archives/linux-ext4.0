From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 4/6] ext4: Move trans handling and completion deferal out
 of _ext4_get_block
Date: Tue, 8 Mar 2016 23:27:40 -0500
Message-ID: <20160309042740.GD3150@thunk.org>
References: <1455897582-13292-1-git-send-email-jack@suse.cz>
 <1455897582-13292-5-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:49264 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750981AbcCIE1m (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 8 Mar 2016 23:27:42 -0500
Content-Disposition: inline
In-Reply-To: <1455897582-13292-5-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Feb 19, 2016 at 04:59:40PM +0100, Jan Kara wrote:
> There is no need to handle starting of a transaction and deferal of DIO
> completion in _ext4_get_block() function. We can move this out to get
> block functions for direct IO that need it. That way we can add stricter
> checks verifying things work as we expect.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Thanks, applied.

						- Ted
