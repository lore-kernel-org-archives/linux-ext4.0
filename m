From: Ted Ts'o <tytso@mit.edu>
Subject: Re: Feature request: e2fsck -z
Date: Wed, 10 Aug 2011 09:25:26 -0400
Message-ID: <20110810132526.GA726@thunk.org>
References: <4E4173D4.9010104@zytor.com>
 <4E422686.8080207@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-ext4@vger.kernel.org
To: Ric Wheeler <ricwheeler@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:55951 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750857Ab1HJNZb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 10 Aug 2011 09:25:31 -0400
Content-Disposition: inline
In-Reply-To: <4E422686.8080207@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Aug 10, 2011 at 07:34:46AM +0100, Ric Wheeler wrote:
> 
> Do you need it to be in the fsck tool?

As others have noted, (a) zerofree does this already, and (b) there's
also -E discard.

My take on it though is that it's a reasonable request.  It's much
like there is "sort -u" even though you could do this via "sort |
uniq".  Part of the Unix philosophy is to use tools that are
composable, yes --- but optimizing for common cases is also a good
thing, and with the advent of virtualization being more and more
popular, zeroing free blocks for virtualization images is good and
useful thing.

This is also why I agitated for adding support so that e2fsprogs tools
could operate directly on qemu-img files, and not just have support
which is hacked into e2image.  Yes, you can always take an qemu-img
file, decompress and expand it into a raw file, run debugfs or e2fsck
on it, and then convert it back to a qemu-img file --- but if lots of
people are doing that, it does make sense to optimize for the most
common use cases.

						- Ted
