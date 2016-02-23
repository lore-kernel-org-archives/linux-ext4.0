From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/4] jbd2: Remove some unnecessary arguments of
 jbd2_journal_write_revoke_records
Date: Mon, 22 Feb 2016 23:09:23 -0500
Message-ID: <20160223040923.GK1215@thunk.org>
References: <1452177715-9671-1-git-send-email-jack@suse.cz>
 <1452177715-9671-2-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:39476 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932176AbcBWEJZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 22 Feb 2016 23:09:25 -0500
Content-Disposition: inline
In-Reply-To: <1452177715-9671-2-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jan 07, 2016 at 03:41:52PM +0100, Jan Kara wrote:
> jbd2_journal_write_revoke_records() takes journal pointer and write_op,
> although journal can be obtained from the passed transaction and
> write_op is always WRITE_SYNC. Remove these superfluous arguments.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Thanks, applied.

						- Ted
