From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 07/12] ext4: Simplify list handling in
 ext4_do_flush_completed_IO()
Date: Mon, 28 Jan 2013 09:51:48 -0500
Message-ID: <20130128145148.GG22711@thunk.org>
References: <1358510446-19174-1-git-send-email-jack@suse.cz>
 <1358510446-19174-8-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Dmitry Monakhov <dmonakhov@openvz.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:45870 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751755Ab3A1Ov6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Jan 2013 09:51:58 -0500
Content-Disposition: inline
In-Reply-To: <1358510446-19174-8-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jan 18, 2013 at 01:00:41PM +0100, Jan Kara wrote:
> The function splices i_completed_io_list to its private list first. From that
> moment on we don't need any lock for working with io_end structures because all
> io_end structure on the list are only our own. So we can remove the other two
> lists in the function and free io_end immediately after we are done with it.
> 
> CC: Dmitry Monakhov <dmonakhov@openvz.org>
> Signed-off-by: Jan Kara <jack@suse.cz>

Thanks, applied.

						- Ted
