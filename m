From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Determining if an ext4 fs uses the whole partition
Date: Mon, 30 Apr 2012 13:26:04 -0500
Message-ID: <4F9ED93C.2060308@redhat.com>
References: <CAMLZHHSi=1U=-V+qMOOunPnuSWDcTm81aSjXdnc51kvYk=n_vA@mail.gmail.com> <4F9ECC0E.8020201@redhat.com> <CAMLZHHQUQKK10XQ2WZdgoMO9PPTmP2tNYL5xN2aQirD+TLSzbA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Daniel Drake <dsd@laptop.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44752 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755985Ab2D3S0R (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 30 Apr 2012 14:26:17 -0400
In-Reply-To: <CAMLZHHQUQKK10XQ2WZdgoMO9PPTmP2tNYL5xN2aQirD+TLSzbA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 4/30/12 1:18 PM, Daniel Drake wrote:

...

> Trying the statfs approach (the fs in question is already mounted):
> 
> # dumpe2fs -h /dev/mmcblk0p2 | grep "Block count\|Block size"
> dumpe2fs 1.42 (29-Nov-2011)
> Block count:              949248
> Block size:               4096
> 
> # stat -f /
>   File: "/"
>     ID: f09a7645207bdd68 Namelen: 255     Type: ext2/ext3
> Block size: 4096       Fundamental block size: 4096
> Blocks: Total: 934935     Free: 198205     Available: 188947
> Inodes: Total: 227824     Free: 133103
> 
> The numbers don't agree.
> 
> (Not a big deal, since I can use the other 2 approaches you mentioned,
> just wanted to point it out)

Oh, that's because statfs on extN subtracts out the "overhead" from superblocks,
block group descriptors, etc.    I guess that's a reasonable interpretation
of "/* total data blocks in file system */" but honestly I forgot that
it did that... TBH, not entirely sure why it does.

-Eric
