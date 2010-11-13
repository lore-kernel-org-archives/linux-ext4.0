From: Mariusz Bialonczyk <manio@skyboo.net>
Subject: Re: Strange bug
Date: Sat, 13 Nov 2010 23:58:57 +0100
Message-ID: <4CDF1831.6070506@skyboo.net>
References: <loom.20101113T101254-909@post.gmane.org> <20101113224236.GA18658@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from skyboo.net ([82.160.187.4]:47931 "EHLO skyboo.net"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753343Ab0KMXYz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 13 Nov 2010 18:24:55 -0500
In-Reply-To: <20101113224236.GA18658@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 11/13/2010 11:42 PM, Ted Ts'o wrote:
> On Sat, Nov 13, 2010 at 09:18:39AM +0000, Mariusz Bialonczyk wrote:
>> Hello
>> I'd like to share the bug report which i had on yesterday's git kernel.
>
> I'm pretty sure it's not "yesterday's" git kernel.  At least, not as
> far as Linus's git tree is concerned.  The "57" in your version number
> in your dmesg:
>
> 	2.6.37-rc1-00057-gc3e1500-dirty
>
> ... is too small for Linus's git tree as of Friday, November 12th.
>
> I wasn't able to track down the git commit ID: c3e1500 so I'm guessing
> there are some commits from some other git tree involved.
Sorry - you're right about that, because i did:
git clone 
git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git v4l-dvb
cd v4l-dvb
git remote add linuxtv git://linuxtv.org/media_tree.git
git remote update
git checkout -b media-master remotes/linuxtv/staging/for_v2.6.38
... so it is not "pure" Linus's git tree
I'm sorry about misleading.

> However, looking at the BUG_ON which you reported:
>
>> Nov 12 23:19:34 draco kernel: [  997.220452] kernel BUG at fs/ext4/page-io.c:146!
>
> I'm pretty sure it's a bug which is fixed as of v2.6.37-rc1-git6,
> specifically by commit id: f7ad6d2e9 (ext4: handle writeback of inodes
> which are being freed).
>
> Best regards,
>
> 					- Ted
good to know, that it is fixed now :)
Thank you

regards,
-- 
Mariusz Bialonczyk
jabber/e-mail: manio@skyboo.net
http://manio.skyboo.net
