From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH][BUG] ext4: do not execute ext4_std_error with EFBIG at
 ext4_setattr
Date: Mon, 26 Jul 2010 21:09:13 -0400
Message-ID: <20100727010913.GC14072@thunk.org>
References: <20100628114256.0c633779.toshi.okajima@jp.fujitsu.com>
 <4C28B8AD.6040001@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>, adilger@sun.com,
	linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:59502 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755325Ab0G0Bdb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 26 Jul 2010 21:33:31 -0400
Content-Disposition: inline
In-Reply-To: <4C28B8AD.6040001@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jun 28, 2010 at 09:58:53AM -0500, Eric Sandeen wrote:
> Toshiyuki Okajima wrote:
> > From: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
> > 
> > You know, do_truncate() can call ext4_setattr() (via notify_change()).
> > And, ext4_setattr() can return with -EFBIG if the argument(length) of 
> > do_truncate() is more than sbi->s_bitmap_maxbytes. At that time, 
> > it also calls ext4_std_error() with -EFBIG.
> > 
> > Besides, a panic happens when ext4_setattr() returns with -EFBIG
> > after we mount an ext4 filesystem with errors=panic.
> 
> ...
> 
> > This changes prevent this problem from happening.
> 
> Whoops, that one was my fault; thanks for catching it.
> 
> I might just "return error" at that spot, but this works fine too.

I've fixed this by simply returning EFBIG at that spot, since that's a
bit simpler and it reduces the line count to boot.

Toshiyuki-san, thanks for pointing this out!

							- Ted
