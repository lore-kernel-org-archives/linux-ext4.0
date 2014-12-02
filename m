From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/4] ext4: fix potential use after free during resize V2
Date: Tue, 2 Dec 2014 18:06:56 -0500
Message-ID: <20141202230656.GE13618@thunk.org>
References: <1417518054-21733-1-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:35581 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932722AbaLBXG7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 2 Dec 2014 18:06:59 -0500
Content-Disposition: inline
In-Reply-To: <1417518054-21733-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Dec 02, 2014 at 03:00:51PM +0400, Dmitry Monakhov wrote:
> We need some sort of synchronization while updating ->s_group_desc
> because there are a lot of users which can access old ->s_group_desc
> array after it was released.
> 
> changes from V1:
>   - use RCU instead seqcount
> 
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>

Thanks, applied

					- Ted
