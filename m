From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: Feature request: e2fsck -z
Date: Wed, 10 Aug 2011 16:34:42 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1108101629570.4119@dhcp-27-109.brq.redhat.com>
References: <4E4173D4.9010104@zytor.com> <4E422686.8080207@gmail.com> <20110810132526.GA726@thunk.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Ric Wheeler <ricwheeler@gmail.com>,
	"H. Peter Anvin" <hpa@zytor.com>, linux-ext4@vger.kernel.org
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:20269 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752751Ab1HJOes (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 10 Aug 2011 10:34:48 -0400
In-Reply-To: <20110810132526.GA726@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 10 Aug 2011, Ted Ts'o wrote:

> On Wed, Aug 10, 2011 at 07:34:46AM +0100, Ric Wheeler wrote:
> > 
> > Do you need it to be in the fsck tool?
> 
> As others have noted, (a) zerofree does this already, and (b) there's
> also -E discard.
> 
> My take on it though is that it's a reasonable request.  It's much
> like there is "sort -u" even though you could do this via "sort |
> uniq".  Part of the Unix philosophy is to use tools that are
> composable, yes --- but optimizing for common cases is also a good
> thing, and with the advent of virtualization being more and more
> popular, zeroing free blocks for virtualization images is good and
> useful thing.

And since we already have punch hole support in ext4 I am going to use
that to "discard" - "punch out" unused blocks from the image. It is
probably not exactly what you are talking about, but it can be useful.

> 
> This is also why I agitated for adding support so that e2fsprogs tools
> could operate directly on qemu-img files, and not just have support
> which is hacked into e2image.  Yes, you can always take an qemu-img
> file, decompress and expand it into a raw file, run debugfs or e2fsck
> on it, and then convert it back to a qemu-img file --- but if lots of
> people are doing that, it does make sense to optimize for the most
> common use cases.

I am in favor if this, however I do not want to do it. I seems to me
that it is just rewriting the support that qemu already has. However if
qemu guys (or anyone) would create an library which we can use from
both projects, that would be certainly very useful.

Thanks!
-Lukas

> 
> 						- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
