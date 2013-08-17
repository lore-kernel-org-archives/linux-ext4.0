From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/2] quota: Provide interface for readding allocated
 space into reserved space
Date: Sat, 17 Aug 2013 09:45:08 -0400
Message-ID: <20130817134508.GB30769@thunk.org>
References: <1376053620-26987-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:44964 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753131Ab3HQNpM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 17 Aug 2013 09:45:12 -0400
Content-Disposition: inline
In-Reply-To: <1376053620-26987-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Aug 09, 2013 at 03:06:59PM +0200, Jan Kara wrote:
> ext4 needs to convert allocated (metadata) blocks back into blocks
> reserved for delayed allocation. Add functions into quota code for
> supporting such operation.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Thanks, applied.

						- Ted
