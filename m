From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH][BUG] ext4: dx_map_entry cannot support over 64KB block
	size
Date: Sun, 21 Jun 2009 22:47:57 -0400
Message-ID: <20090622024757.GB26079@mit.edu>
References: <20090605165049.e8bd9c74.toshi.okajima@jp.fujitsu.com> <20090605212000.GV9002@webber.adilger.int> <20090608163055.0eab9737.toshi.okajima@jp.fujitsu.com> <20090621035731.GA6719@mit.edu> <4A3EE269.3020704@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@sun.com>, linux-ext4@vger.kernel.org
To: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:38480 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751403AbZFVCsA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 21 Jun 2009 22:48:00 -0400
Content-Disposition: inline
In-Reply-To: <4A3EE269.3020704@jp.fujitsu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jun 22, 2009 at 10:46:17AM +0900, Toshiyuki Okajima wrote:
> I have been reviewing the logic around dir_index(fs/ext4/dir.c
> fs/ext4/namei.c) for the sake of performance and quality
> improvement. Then I found this bug.  Sorry, therefore it is not a
> result of the real test.

I've started doing some testing on the e2fsprogs side, and fixed some
problems in for the upcoming e2fsprogs 1.41.7, but both the kernel and
e2fsprogs currently don't officially support a blocksize larger than
64k.  At least e2fsprogs in the git tree will mke2fs that passes
e2fsck for a 128k block filesystem; this is *not* yet true for 256k
block filesystems (but it requires some commits in the 64k block
numbers patches which I don't want to merge into the maint branch).

Are you aware of any patches that enable an IA64 system to support a
page size greater than 64kB?  (And whether any customer would actually
want to use them, given the downsides of very large page size?)  The
issue is that Linux doesn't support filesystem block sizes > than the
page size.  In any case, I don't mind adding patches that attempt to
make it better to support large block sizes; I don't really want to
claim that we support it until we can actually fully test for that
feature, though.  Is it your intent to actually try to provide support
for this at some point?  I'll help you if you are, but you'll have to
do the testing, since I don't have access to an IA64 platform that
might be able to support these sorts of large pages.

Thanks,

						- Ted
