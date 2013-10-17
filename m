From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/2] ext4: Fix assertion in ext4_add_complete_io()
Date: Wed, 16 Oct 2013 23:31:44 -0400
Message-ID: <20131017033144.GA11932@thunk.org>
References: <1381843949-31805-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:47075 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761009Ab3JQDbt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 16 Oct 2013 23:31:49 -0400
Content-Disposition: inline
In-Reply-To: <1381843949-31805-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Oct 15, 2013 at 03:32:28PM +0200, Jan Kara wrote:
> It doesn't make sense to require io_end->handle when we are in nojournal
> mode. So update the assertion accordingly to avoid false warnings from
> ext4_add_complete_io().
> 
> Reported-by: Eric Whitney <enwlinux@gmail.com>
> Signed-off-by: Jan Kara <jack@suse.cz>

Thanks, applied.

					- Ted
