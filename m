From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Fix to read empty directory blocks correctly in
	64k blocksize filesystems
Date: Mon, 16 Feb 2009 19:05:09 -0500
Message-ID: <20090217000509.GI23758@mini-me.lan>
References: <4990FAE4.1080009@cn.fujitsu.com> <20090210152049.GF30689@mini-me.lan> <20090211054816.GP3209@webber.adilger.int> <20090211151547.GK29220@mini-me.lan> <20090216233256.GI3199@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Wei Yongjun <yjwei@cn.fujitsu.com>, linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:35305 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752097AbZBQP7Z (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 17 Feb 2009 10:59:25 -0500
Content-Disposition: inline
In-Reply-To: <20090216233256.GI3199@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Feb 16, 2009 at 04:32:56PM -0700, Andreas Dilger wrote:
> There are probably a dozen other places in the ext* code that expect
> blocksize <= 65536, so I don't think this new encoding is really helping
> us at all.  We are already restricted to 2^32-1 inodes due to the dirent
> format and I expect we will have changed the dirent format by that time
> anyways.

I can only find one other place, actually, which would be the extended
attribute code --- e_value_offs is a 16 bit offset (although we could
steal bits form e_value block if necessary).

> I'd rather keep this change as simple as possible (i.e. the original
> 65535 or 0 values, preferring 65535).

For 64k block sizes, I've kept this, although I preferred 0 since it's
a cleaner change if we want to allow bigger blocksize alternative.  I
don't think 65535 is any worse than 0 in terms of detecting directory
corruption.

					- Ted
