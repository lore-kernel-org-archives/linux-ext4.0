From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/3] ext4: Standardize error handling in
 ext4_da_write_inline_data_begin()
Date: Wed, 18 Dec 2013 00:45:46 -0500
Message-ID: <20131218054546.GB19434@thunk.org>
References: <1386670440-3158-1-git-send-email-jack@suse.cz>
 <1386670440-3158-3-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Akira Fujita <a-fujita@rs.jp.nec.com>, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:41188 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750886Ab3LRFpv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 18 Dec 2013 00:45:51 -0500
Content-Disposition: inline
In-Reply-To: <1386670440-3158-3-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Dec 10, 2013 at 11:13:59AM +0100, Jan Kara wrote:
> The function has a bit non-standard (for ext4) error recovery in that it
> used a mix of 'out' labels and testing for 'handle' being NULL. There
> isn't a good reason for that in the function so clean it up a bit.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Thanks, applied.

				- Ted
