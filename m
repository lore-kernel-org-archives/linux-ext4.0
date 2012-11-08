From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: fix possible memory leak in ext4_xattr_set_acl()
Date: Thu, 8 Nov 2012 15:11:35 -0500
Message-ID: <20121108201135.GL19977@thunk.org>
References: <1349694672-16992-1-git-send-email-eugene.shatokhin@rosalab.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Eugene Shatokhin <eugene.shatokhin@rosalab.ru>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:60102 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756720Ab2KHWVC (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 8 Nov 2012 17:21:02 -0500
Content-Disposition: inline
In-Reply-To: <1349694672-16992-1-git-send-email-eugene.shatokhin@rosalab.ru>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Oct 08, 2012 at 03:11:12PM +0400, Eugene Shatokhin wrote:
> In ext4_xattr_set_acl(), if ext4_journal_start() returns an error,
> posix_acl_release() will not be called for 'acl' which may result
> in a memory leak.
> 
> This patch fixes that.
> 
> Signed-off-by: Eugene Shatokhin <eugene.shatokhin@rosalab.ru>

Thanks, applied.

					- Ted
