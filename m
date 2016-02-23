From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 4/4] jbd2: Save some atomic ops in __JI_COMMIT_RUNNING
 handling
Date: Mon, 22 Feb 2016 23:27:14 -0500
Message-ID: <20160223042714.GN1215@thunk.org>
References: <1452177715-9671-1-git-send-email-jack@suse.cz>
 <1452177715-9671-5-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:39570 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757231AbcBWE1Q (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 22 Feb 2016 23:27:16 -0500
Content-Disposition: inline
In-Reply-To: <1452177715-9671-5-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jan 07, 2016 at 03:41:55PM +0100, Jan Kara wrote:
> Currently we used atomic bit operations to manipulate
> __JI_COMMIT_RUNNING bit. However this is unnecessary as i_flags are
> always written and read under j_list_lock. So just change the operations
> to standard bit operations.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Thanks, applied.

					- Ted
