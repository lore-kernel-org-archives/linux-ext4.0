From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [RESEND Patch] jbd2: remove excess descriptions for handle_s
Date: Thu, 5 May 2016 22:37:32 -0400
Message-ID: <20160506023732.GC31860@thunk.org>
References: <1458407163-10849-1-git-send-email-luisbg@osg.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	jack@suse.com
To: Luis de Bethencourt <luisbg@osg.samsung.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:52500 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757164AbcEFChh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 5 May 2016 22:37:37 -0400
Content-Disposition: inline
In-Reply-To: <1458407163-10849-1-git-send-email-luisbg@osg.samsung.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Apr 11, 2016 at 12:44:16PM +0100, Luis de Bethencourt wrote:
> Commit bf6993276f74 ("jbd2: Use tracepoints for history file")
> removed the members j_history, j_history_max and j_history_cur from struct
> handle_s but the descriptions stayed lingering. Removing them.
> 
> Signed-off-by: Luis de Bethencourt <luisbg@osg.samsung.com>
> Reviewed-by: Jan Kara <jack@suse.cz>

Applied, thanks.

					- Ted
