From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH RESEND] Documentation: Remove the obsolete parameters
 in 2 jbd2 functions.
Date: Sun, 12 Jun 2011 22:46:36 -0400
Message-ID: <20110613024636.GA23775@thunk.org>
References: <20110511145957.dff6c0ca.rdunlap@xenotime.net>
 <1307459528-12266-1-git-send-email-tm@tao.ma>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>
To: Tao Ma <tm@tao.ma>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:54860 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752262Ab1FMCqj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 12 Jun 2011 22:46:39 -0400
Content-Disposition: inline
In-Reply-To: <1307459528-12266-1-git-send-email-tm@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jun 07, 2011 at 11:12:08PM +0800, Tao Ma wrote:
> From: Tao Ma <boyu.mt@taobao.com>
> 
> credits isn't a parameter for jbd2_journal_get_write_access and
> jbd2_journal_get_undo_access. So remove the corresponding comments.
> 
> Acked-by: Jan Kara <jack@suse.cz>
> Cc: Randy Dunlap <rdunlap@xenotime.net>
> Cc: "Theodore Ts'o" <tytso@mit.edu>
> Signed-off-by: Tao Ma <boyu.mt@taobao.com>

Added to the ext4 tree.  Thanks for the resend/reminder.

						- Ted
