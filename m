From: Ted Ts'o <tytso@mit.edu>
Subject: Re: ext4: Fix 32bit overflow in ext4_ext_find_goal()
Date: Sun, 2 Jan 2011 16:40:31 -0500
Message-ID: <20110102214031.GA10889@thunk.org>
References: <4D05B132.3060402@sx.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 <linux-ext4@vger.kernel.org>
To: Kazuya Mio <k-mio@sx.jp.nec.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:32933 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753344Ab1ACCtt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 2 Jan 2011 21:49:49 -0500
Content-Disposition: inline
In-Reply-To: <4D05B132.3060402@sx.jp.nec.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Dec 12, 2010 at 07:37:54PM -0000, Kazuya Mio wrote:
> Hi,
> 
> ext4_ext_find_goal() returns an ideal physical block number that the block
> allocator tries to allocate first. However, if a required file offset is
> smaller than the existing extent's one, ext4_ext_find_goal() returns
> a wrong block number because it may overflow at
> "block - le32_to_cpu(ex->ee_block)". This patch fixes the problem.

Thanks, applied.  One comment which I've added to the code:

The block placement algorithm in this section of code assumes that we
are filling in a file which will eventually be non-sparse --- i.e., in
the case of libbfd writing an ELF object sections out-of-order but in
a way the eventually results in a contiguous object or executable
file, or the old BSD dbm library writing dbm files.  However, this is
actually somewhat non-ideal if we are writing a sparse file such as
qemu or KVM writing a raw image file, as it will result in the free
space getting unnecessarily fragmented.  Maybe we should have some
hueristics to determine whether we are in the first or second case?

I don't currently think using raw image files is that common in most
virtualization application, but if someone can think of some common
use cases where we would care, it might be worth adding either some
hueristics to detect this, or perhaps some way that userspace can pass
a hint to the file system that what we're doing is writing a raw
sparse file.  For now I'm going to consider the first scenario more
common than the second....

						- Ted
