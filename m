From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: xfstest-bld generic/018 fails due to e4defrag issue
Date: Thu, 10 Apr 2014 09:56:37 -0400
Message-ID: <20140410135637.GC15925@thunk.org>
References: <CAGW2f1F1sL+if9zejgB92j0YDRjswvB3LG_dBR+pK3Yj4aQfHQ@mail.gmail.com>
 <20140409220320.GC15303@thunk.org>
 <CAGW2f1Fn2caBtQPjZnXyMdVf9H6wGvS_0YrLReggwujKZXL8CQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-ext4@vger.kernel.org List" <linux-ext4@vger.kernel.org>
To: jon ernst <jonernst07@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:52517 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964868AbaDJN4l (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 10 Apr 2014 09:56:41 -0400
Content-Disposition: inline
In-Reply-To: <CAGW2f1Fn2caBtQPjZnXyMdVf9H6wGvS_0YrLReggwujKZXL8CQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Apr 10, 2014 at 12:13:49AM -0400, jon ernst wrote:
> 
> Because bigalloc requires cluster-aware bitfield operations, which
> means we need EXT2_FLAG_64BITS.
> I see e2image.c creates image always with EXT2_FLAG_64BITS flag. It is
> safe to do same thing for e4defrag in my opinion. Please correct me if
> I am wrong.

Um.... I *think* so.  e4defrag is one of the less well
tested/maintained parts of e2fsprogs, as well as the kernel-side code
which supports e4defrag.  I can't think of any reason why there would
be any 32-bit dependencies in the kernel side code, although someone
should probably do a quick audit of the e4defrag code to make sure
it's not using blk_t where it should be using blk64_t, or have other
32-bit dependencies.

					- Ted
