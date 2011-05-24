From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH] ext4: invalidate gap cache when writing extents last
 block
Date: Tue, 24 May 2011 10:57:14 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1105241037190.4028@dhcp-27-109.brq.redhat.com>
References: <alpine.LFD.2.00.1105130829160.3768@dhcp-27-109.brq.redhat.com> <1305268616-5167-1-git-send-email-lczerner@redhat.com> <4DCCF208.3040704@sx.jp.nec.com> <4DDB6D66.3010703@sx.jp.nec.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org,
	tytso@mit.edu
To: Kazuya Mio <k-mio@sx.jp.nec.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55728 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755221Ab1EXI5Y (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 24 May 2011 04:57:24 -0400
In-Reply-To: <4DDB6D66.3010703@sx.jp.nec.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Kazuya,

I am really sorry for late answer. I think you're partly right. my
solution is not good, but I still think that your is not good as well. I
need to look at this again and more closely, sorry.

What do you think about this: ext4_ext_next_allocated_block() should
return next allocated block, however instead it in some cases returns
EXT_MAX_BLOCK, which points at the last logical block in a file, which
however in some cases might be equal to the last not allocated block,
not first allocated block in subsequent extent. And boom, we have (next
== lblock).

So if we want to really return next allocated block (or more
specifically, next block which we can not allocate), we should in those
cases return EXT_MAX_BLOCK+1. And we should do this in
ext4_ext_put_gap_in_cache() as well when there is no extent yet. Also
note that as I said EXT_MAX_BLOCK means maximum logical block, however
we use it as lenght in ext4_ext_put_gap_in_cache() which does not sound
right either. It seems all a little bit messy :-/. I need to look at it
and try it to see if it would work, but I think it does make sense.

What do you think?

Thanks!
-Lukas

On Tue, 24 May 2011, Kazuya Mio wrote:

> Hi Lukas,
> How do you think about my comment?
> 
> Regards,
> Kazuya Mio
> 
> 2011/05/13 17:55, Kazuya Mio wrote:
> > 2011/05/13 15:36, Lukas Czerner wrote:
> >> That is because due to defensive programming we planted a lot of
> >> BUG_ON's to prevent the length of the gap cache to be zero, but in this
> >> case it actually will be zero, because there will be no gap at the end
> >> of the file.
> > 
> > Um, I think there is a block (blocksize -1 byte) in gap.
> > And this gap should be used for the next block searching.
> > According to ext4_ext_in_cache(), len=0 means the special case
> > which we have no cache extent, so len=0 should be disallowed.
> > 
> > Moreover, if we create the file which has 2^32-1 offset,
> > we can't get extent which starts from this offset with FIEMAP ioctl.
> > That's why I think the maximum file size should be 2^32-1 * blocksize.
> > 
> > Regards,
> > Kazuya Mio
> 

-- 
