From: Tao Ma <tm@tao.ma>
Subject: Re: [PATCH] ext4: Protect group inode free counting with group lock.
Date: Tue, 29 May 2012 10:18:14 +0800
Message-ID: <4FC431E6.7020206@tao.ma>
References: <1337158192-4591-1-git-send-email-tm@tao.ma> <4FB3AF00.9060704@redhat.com> <4FB3BFC9.20901@tao.ma> <4FB3CC8C.4030502@redhat.com> <4FB45FBE.10004@tao.ma> <20120528222241.GD5610@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:43313 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752386Ab2E2CST (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 28 May 2012 22:18:19 -0400
In-Reply-To: <20120528222241.GD5610@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 05/29/2012 06:22 AM, Ted Ts'o wrote:
> On Thu, May 17, 2012 at 10:17:34AM +0800, Tao Ma wrote:
>> oh, I see. Yes, we mkfs the system with the following configurations:
>> mke2fs -O ^resize_inode,^uninit_bg,extent,meta_bg,flex_bg,ext_attr
>> Maybe that's the reason why it has never be met by others before. ;)
> 
> I'm curious -- is there a specific reason you're disabling the group
> descriptor checksum?  Or was that just something that was picked at
> one point and you haven't changed it since?
We are just disabling the uninit_bg so as to let the block group
initialization happen in the mkfs time. I don't know why the checksum is
also disabled by ^uninit_bg.

Thanks
Tao
> 
> Thanks,
> 
> 						- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

