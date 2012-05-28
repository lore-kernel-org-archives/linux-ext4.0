From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH V2] ext4: Protect group inode free counting with group
 lock.
Date: Mon, 28 May 2012 18:23:12 -0400
Message-ID: <20120528222312.GE5610@thunk.org>
References: <1337240139-5005-1-git-send-email-tm@tao.ma>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Tao Ma <tm@tao.ma>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:46086 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751251Ab2E1WXO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 May 2012 18:23:14 -0400
Content-Disposition: inline
In-Reply-To: <1337240139-5005-1-git-send-email-tm@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, May 17, 2012 at 03:35:39PM +0800, Tao Ma wrote:
> From: Tao Ma <boyu.mt@taobao.com>
> 
> Now when we set the group inode free count, we don't have a proper
> group lock so that multiple threads may decrease the inode free
> count at the same time....
>
> btw, it is found by xfstests test case 269 and the volume is
> mkfsed with the parameter
> "-O ^resize_inode,^uninit_bg,extent,meta_bg,flex_bg,ext_attr"
> and I have run it 100 times and the error in e2fsck doesn't
> show up again.
> 
> Cc: Theodore Ts'o <tytso@mit.edu>
> Signed-off-by: Tao Ma <boyu.mt@taobao.com>

Thanks, applied.

						- Ted
