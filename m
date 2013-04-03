From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH] mke2fs: Disallow bigalloc with with bs < 4096
Date: Wed, 3 Apr 2013 16:47:55 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1304031645010.10110@localhost>
References: <1364997099-22590-1-git-send-email-lczerner@redhat.com> <20130403143554.GA13668@thunk.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54546 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932111Ab3DCOsA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 3 Apr 2013 10:48:00 -0400
In-Reply-To: <20130403143554.GA13668@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 3 Apr 2013, Theodore Ts'o wrote:

> Date: Wed, 3 Apr 2013 10:35:54 -0400
> From: Theodore Ts'o <tytso@mit.edu>
> To: Lukas Czerner <lczerner@redhat.com>
> Cc: linux-ext4@vger.kernel.org
> Subject: Re: [PATCH] mke2fs: Disallow bigalloc with with bs < 4096
> 
> On Wed, Apr 03, 2013 at 03:51:39PM +0200, Lukas Czerner wrote:
> > Currently there is nothing preventing user to create file system with
> > bigalloc feature enabled and block size smaller than 4096 Bytes. However
> > such combination does not make much sense at all because the whole point
> > of bigalloc is to have bigger allocation units.
> > 
> > This patch disallow such combination.
> 
> This makes sense by default but I do see a point in allowing it for
> testing purposes --- specifically, it allows us to verify that
> bigalloc works on architectures such as PowerPC and Itanium where page
> size is greater than the 4k block size.  So maybe a developer mode set
> via mke2fs.conf?

Yes, I though about that and I wanted to know what the general
opinion is. I'll prepare the patch which makes this tunable,
but restricted by default.

> 
> Another option would be to enforce that we only support bigalloc file
> systems where the blocksize == pagesize, but that means we wouldn't be
> able to mount 4k bigalloc file systems on architectures with a 8k or
> 16k page size.

Unfortunately we can't do that for the reasons you mentioned.

Thanks!
-Lukas

> 
> 						- Ted
> 
