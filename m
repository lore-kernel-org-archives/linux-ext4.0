From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Bail out from make_indexed_dir() on first error
Date: Thu, 30 Oct 2014 10:24:05 -0400
Message-ID: <20141030142405.GA31927@thunk.org>
References: <1414077533-2133-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:53168 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757587AbaJ3OYJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 30 Oct 2014 10:24:09 -0400
Content-Disposition: inline
In-Reply-To: <1414077533-2133-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Oct 23, 2014 at 05:18:53PM +0200, Jan Kara wrote:
> When ext4_handle_dirty_dx_node() or ext4_handle_dirty_dirent_node()
> fail, there's really something wrong with the fs and there's no point in
> continuing further. Just return error from make_indexed_dir() in that
> case. Also initialize frames array so that if we return early due to
> error, dx_release() doesn't try to dereference uninitialized memory
> (which could happen also due to error in do_split()).
> 
> Coverity-id: 741300
> Signed-off-by: Jan Kara <jack@suse.cz>

Applied, thanks.

					- Ted
