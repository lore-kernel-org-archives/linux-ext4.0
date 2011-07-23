From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Remove unnecessary ext4_get_group_info in
 ext4_mb_load_buddy.
Date: Sat, 23 Jul 2011 16:19:49 -0400
Message-ID: <20110723201949.GA3469@thunk.org>
References: <1310915483-2906-1-git-send-email-tm@tao.ma>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Tao Ma <tm@tao.ma>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:57982 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750792Ab1GWUTv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 23 Jul 2011 16:19:51 -0400
Content-Disposition: inline
In-Reply-To: <1310915483-2906-1-git-send-email-tm@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Jul 17, 2011 at 11:11:21PM +0800, Tao Ma wrote:
> From: Tao Ma <boyu.mt@taobao.com>
> 
> ext4_mb_load_buddy() calls ext4_get_group_info() for setting both
> "grp" and "e4b->bd_info", but it could do "e4b->bd_info = grp".
> 
> Reported-by:  Andreas Dilger <adilger@whamcloud.com>
> Signed-off-by: Tao Ma <boyu.mt@taobao.com>

Thanks, added to the ext4 tree.

					- Ted
