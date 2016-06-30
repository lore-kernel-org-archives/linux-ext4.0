From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/4] jbd2: Move lockdep instrumentation for jbd2 handles
Date: Thu, 30 Jun 2016 11:34:03 -0400
Message-ID: <20160630153403.GD2028@thunk.org>
References: <1466073736-30447-1-git-send-email-jack@suse.cz>
 <1466073736-30447-3-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Eryu Guan <eguan@redhat.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:40150 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932148AbcF3Pfy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 30 Jun 2016 11:35:54 -0400
Content-Disposition: inline
In-Reply-To: <1466073736-30447-3-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jun 16, 2016 at 12:42:14PM +0200, Jan Kara wrote:
> The transaction the handle references is free to commit once we've
> decremented t_updates counter. Move the lockdep instrumentation to that
> place. Currently it was a bit later which did not really matter but
> subsequent improvements to lockdep instrumentation would cause false
> positives with it.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Applied, thanks.

						- Ted
