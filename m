From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 4/4] ext4: reimplement uninit extent optimization for
 move_extent_per_page V2
Date: Wed, 26 Sep 2012 12:56:55 -0400
Message-ID: <20120926165655.GD18983@thunk.org>
References: <1348489434-22778-1-git-send-email-dmonakhov@openvz.org>
 <1348489434-22778-5-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, a-fujita@rs.jp.nec.com
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:52526 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757209Ab2IZQ47 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 26 Sep 2012 12:56:59 -0400
Content-Disposition: inline
In-Reply-To: <1348489434-22778-5-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Sep 24, 2012 at 04:23:54PM +0400, Dmitry Monakhov wrote:
> Uninitialized extent may became initialized(parallel writeback task)
> at any moment after we drop i_data_sem, so we have to recheck extent's
> state after we hold page's lock and i_data_sem.
> 
> If we about to change page's mapping we must hold page's lock in order to
> serialize other users.
> Changes from V1 in response to Akira's comments:
> - fix last block mistype
> - Rerutn inital error code
> 
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>

Thanks, applied.

					- Ted
