From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: ext4_orphan_add() remove unnecessary comments
Date: Mon, 11 Jul 2011 18:47:34 -0400
Message-ID: <20110711224734.GU28763@thunk.org>
References: <1309272617-30943-1-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:56667 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756169Ab1GKWrg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 11 Jul 2011 18:47:36 -0400
Content-Disposition: inline
In-Reply-To: <1309272617-30943-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jun 28, 2011 at 04:50:17PM +0200, Lukas Czerner wrote:
> The comment from Al Viro about possible race in the ext4_orphan_add() is
> not justified. There is no race possible as we always have either i_mutex
> locked, or the inode can not be referenced from outside hence the
> J_ASSERS should not be hit from the reason described in comment.
> 
> This commit replaces it with notion that we are holding i_mutex so it
> should not be possible for i_nlink to be changed while waiting for
> s_orphan_lock.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>

Applied, thanks.

						- Ted
