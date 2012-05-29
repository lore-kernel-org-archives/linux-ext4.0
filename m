From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] ext4: Protect group inode free counting with group lock.
Date: Mon, 28 May 2012 23:57:59 -0600
Message-ID: <8932CA1F-B08D-4327-AD23-38EA56D49F47@dilger.ca>
References: <1337158192-4591-1-git-send-email-tm@tao.ma> <4FB3AF00.9060704@redhat.com> <4FB3BFC9.20901@tao.ma> <4FB3CC8C.4030502@redhat.com> <4FB45FBE.10004@tao.ma> <20120528222241.GD5610@thunk.org> <4FC431E6.7020206@tao.ma>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Ted Ts'o <tytso@mit.edu>, Eric Sandeen <sandeen@redhat.com>,
	linux-ext4@vger.kernel.org
To: Tao Ma <tm@tao.ma>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:46063 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790Ab2E2F6B (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 29 May 2012 01:58:01 -0400
In-Reply-To: <4FC431E6.7020206@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2012-05-28, at 8:18 PM, Tao Ma wrote:
> On 05/29/2012 06:22 AM, Ted Ts'o wrote:
>> On Thu, May 17, 2012 at 10:17:34AM +0800, Tao Ma wrote:
>>> oh, I see. Yes, we mkfs the system with the following configurations:
>>> mke2fs -O ^resize_inode,^uninit_bg,extent,meta_bg,flex_bg,ext_attr
>>> Maybe that's the reason why it has never be met by others before. ;)
>> 
>> I'm curious -- is there a specific reason you're disabling the group
>> descriptor checksum?  Or was that just something that was picked at
>> one point and you haven't changed it since?
> 
> We are just disabling the uninit_bg so as to let the block group
> initialization happen in the mkfs time. I don't know why the checksum is
> also disabled by ^uninit_bg.

The checksum is controlled by uninit_bg, because there was a need to
ensure the bg_itable_unused count and the UNINIT flags could be
trusted when doing an e2fsck.

If you don't want to do lazy inode table initialization, that is
disabled by "mke2fs -E lazy_itable_init=0".

Cheers, Andreas





