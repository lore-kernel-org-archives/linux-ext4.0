From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 3/4] jbd2: Unify revoke and tag block checksum handling
Date: Mon, 22 Feb 2016 23:27:00 -0500
Message-ID: <20160223042700.GM1215@thunk.org>
References: <1452177715-9671-1-git-send-email-jack@suse.cz>
 <1452177715-9671-4-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:39558 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757231AbcBWE1D (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 22 Feb 2016 23:27:03 -0500
Content-Disposition: inline
In-Reply-To: <1452177715-9671-4-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jan 07, 2016 at 03:41:54PM +0100, Jan Kara wrote:
> Revoke and tag descriptor blocks are just different kinds of descriptor
> blocks and thus have checksum in the same place. Unify computation and
> checking of checksums for these.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Thanks, applied.

					- Ted
