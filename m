From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: fix unbalanced up_write() in ext4_ext_truncate()
 error path
Date: Sun, 22 May 2011 21:43:03 -0400
Message-ID: <20110523014303.GG10009@thunk.org>
References: <1305051177-18452-1-git-send-email-egouriou@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Eric Gouriou <egouriou@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:48092 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751224Ab1EWBnG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 22 May 2011 21:43:06 -0400
Content-Disposition: inline
In-Reply-To: <1305051177-18452-1-git-send-email-egouriou@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, May 10, 2011 at 11:12:57AM -0700, Eric Gouriou wrote:
> ext4_ext_truncate() should not invoke up_write(&EXT4_I(inode)->i_data_sem)
> when ext4_orphan_add() returns an error, as it hasn't performed a
> down_write() yet. This trivial patch fixes this by moving the up_write()
> invocation above the out_stop label.
> 
> Signed-off-by: Eric Gouriou <egouriou@google.com>

Thanks, applied to the ext4 tree!

					- Ted
