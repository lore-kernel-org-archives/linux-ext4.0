From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Protect group inode free counting with group
 lock.
Date: Mon, 28 May 2012 18:22:41 -0400
Message-ID: <20120528222241.GD5610@thunk.org>
References: <1337158192-4591-1-git-send-email-tm@tao.ma>
 <4FB3AF00.9060704@redhat.com>
 <4FB3BFC9.20901@tao.ma>
 <4FB3CC8C.4030502@redhat.com>
 <4FB45FBE.10004@tao.ma>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org
To: Tao Ma <tm@tao.ma>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:46083 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751251Ab2E1WWp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 May 2012 18:22:45 -0400
Content-Disposition: inline
In-Reply-To: <4FB45FBE.10004@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, May 17, 2012 at 10:17:34AM +0800, Tao Ma wrote:
> oh, I see. Yes, we mkfs the system with the following configurations:
> mke2fs -O ^resize_inode,^uninit_bg,extent,meta_bg,flex_bg,ext_attr
> Maybe that's the reason why it has never be met by others before. ;)

I'm curious -- is there a specific reason you're disabling the group
descriptor checksum?  Or was that just something that was picked at
one point and you haven't changed it since?

Thanks,

						- Ted
