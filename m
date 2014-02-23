From: "Vitaliy Filippov" <vitalif@yourcmc.ru>
Subject: Re: [PATCH] misc: Use unsigned long long for file block count in
 filefrag
Date: Sun, 23 Feb 2014 20:28:53 +0400
Message-ID: <op.xbqtefu20ncgu9@vitalif.vhome>
References: <20140223091251.3545C47E837@yourcmc.ru>
 <20140223135834.GC2280@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
	format=flowed	delsp=yes
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from yourcmc.ru ([195.24.71.121]:39539 "EHLO yourcmc.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751173AbaBWQ2z (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 23 Feb 2014 11:28:55 -0500
In-Reply-To: <20140223135834.GC2280@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> Hi Vitaliy,
>
> Thanks for the patch!  Your patch is missing a Signed-Off-By footer.
> Also, you note that numblocks gets passed to filefrag_fibmap(), so if
> you're going to do this, and we fall back to using fibmap, you should
> probably check to see if numblocks would overflow an unsigned long,
> and if so, to give an error because fibmap ioctl only supports the use
> of a ulong.

OK, I've just resubmitted it :)

In fact, the block count was reported incorrectly for files bigger than  
0xffffffff bytes, not blocks, because filefrag does (numblocks *  
fsinfo.f_bsize >> blk_shift), and this overflows when numblocks is  
32-bit...

-- 
With best regards,
   Vitaliy Filippov
