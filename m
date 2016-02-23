From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/4] jbd2: Factor out common descriptor block
 initialization
Date: Mon, 22 Feb 2016 23:18:56 -0500
Message-ID: <20160223041856.GL1215@thunk.org>
References: <1452177715-9671-1-git-send-email-jack@suse.cz>
 <1452177715-9671-3-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:39536 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757036AbcBWES6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 22 Feb 2016 23:18:58 -0500
Content-Disposition: inline
In-Reply-To: <1452177715-9671-3-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jan 07, 2016 at 03:41:53PM +0100, Jan Kara wrote:
> Descriptor block header is initialized in several places. Factor out the
> common code into jbd2_journal_get_descriptor_buffer().
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Thanks, applied.

					- Ted
