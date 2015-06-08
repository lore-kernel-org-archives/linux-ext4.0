From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/5] jbd2: Simplify code flow in do_get_write_access()
Date: Mon, 8 Jun 2015 12:39:56 -0400
Message-ID: <20150608163956.GJ19168@thunk.org>
References: <1427983100-29889-1-git-send-email-jack@suse.cz>
 <1427983100-29889-2-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:53261 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752521AbbFHQj7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 8 Jun 2015 12:39:59 -0400
Content-Disposition: inline
In-Reply-To: <1427983100-29889-2-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Apr 02, 2015 at 03:58:16PM +0200, Jan Kara wrote:
> needs_copy is set only in one place in do_get_write_access(), just move
> the frozen buffer copying into that place and factor it out to a
> separate function to make do_get_write_access() slightly more readable.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Thanks, applied.

						- Ted
