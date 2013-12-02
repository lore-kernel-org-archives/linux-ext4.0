From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] jbd2: Revise KERN_EMERG error messages
Date: Mon, 2 Dec 2013 09:55:17 -0500
Message-ID: <20131202145517.GC25294@thunk.org>
References: <1385420357-30944-1-git-send-email-jack@suse.cz>
 <1385420357-30944-2-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Lubomir Rintel <lkundrak@v3.sk>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:35629 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751807Ab3LBOzX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 2 Dec 2013 09:55:23 -0500
Content-Disposition: inline
In-Reply-To: <1385420357-30944-2-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Nov 25, 2013 at 11:59:17PM +0100, Jan Kara wrote:
> Some of KERN_EMERG printk messages do not really deserve this log level
> and the one in log_wait_commit() is even rather useless (the journal has
> been previously aborted and *that* is where we should have been
> complaining). So make some messages just KERN_ERR and remove the useless
> message.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Thanks, applied.

						- Ted
