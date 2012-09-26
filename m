From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/4] ext4: move_extent code cleanup
Date: Wed, 26 Sep 2012 12:30:36 -0400
Message-ID: <20120926163036.GA18983@thunk.org>
References: <1348489434-22778-1-git-send-email-dmonakhov@openvz.org>
 <1348489434-22778-2-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, a-fujita@rs.jp.nec.com
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:52511 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757201Ab2IZQao (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 26 Sep 2012 12:30:44 -0400
Content-Disposition: inline
In-Reply-To: <1348489434-22778-2-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Sep 24, 2012 at 04:23:51PM +0400, Dmitry Monakhov wrote:
> - Remove usless checks, because it is too late to check that inode != NULL
>   at the moment it was referenced several times.
> - Double lock routines looks very ugly and locking ordering relays on
>   order of i_ino, but other kernel code relay on order of pointers.
>   Let's  make them simple and clean.
> - check that inodes belongs to the same SB as soon as possible.
> 
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>

Applied, thanks!!

						- Ted
