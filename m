From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Fix trimming of a single group
Date: Fri, 7 Jan 2011 00:02:15 -0500
Message-ID: <20110107050215.GD2857@thunk.org>
References: <1294324378-21712-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Lukas Czerner <lczerner@redhat.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:57389 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751275Ab1AGFCT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 7 Jan 2011 00:02:19 -0500
Content-Disposition: inline
In-Reply-To: <1294324378-21712-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jan 06, 2011 at 03:32:58PM +0100, Jan Kara wrote:
> When ext4_trim_fs() is called to trim a part of a single group, the
> logic will wrongly set last block of the interval to 'len' instead
> of 'first_block + len'. Thus a shorter interval is possibly trimmed.
> Fix it.
> 
> CC: Lukas Czerner <lczerner@redhat.com>
> Signed-off-by: Jan Kara <jack@suse.cz>

Thanks, added to the ext4 tree.

				- Ted
