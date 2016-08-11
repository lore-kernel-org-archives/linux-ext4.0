From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 10/11] ext4: Remove (almost) unused variables from
 ext4_expand_extra_isize_ea()
Date: Thu, 11 Aug 2016 13:34:06 -0400
Message-ID: <20160811173406.GJ10626@thunk.org>
References: <1470220795-17045-1-git-send-email-jack@suse.cz>
 <1470220795-17045-11-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Dave Chinner <david@fromorbit.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:45660 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751204AbcHKReH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 11 Aug 2016 13:34:07 -0400
Content-Disposition: inline
In-Reply-To: <1470220795-17045-11-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Aug 03, 2016 at 12:39:54PM +0200, Jan Kara wrote:
> 'start' variable is completely unused in ext4_expand_extra_isize_ea().
> Variable 'first' is used only once in one place. So just remove them.
> Variables 'entry' and 'last' are only really used later in the function
> inside a loop. Move their declarations there.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Thanks, applied.

					- Ted
