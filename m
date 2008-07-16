From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 15/15][e2fsprogs] 64-bit mke2fs cleanup
Date: Wed, 16 Jul 2008 10:54:29 -0400
Message-ID: <20080716145429.GA2167@mit.edu>
References: <20080715164332.28567.27913.stgit@ichigo> <20080715165129.28567.7837.stgit@ichigo> <87tzeq0z95.fsf@frosties.localdomain> <20080716090931.6c8ca875@ichigo>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Goswin von Brederlow <goswin-v-b@web.de>,
	linux-ext4@vger.kernel.org
To: "Jose R. Santos" <jrs@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:50908 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755751AbYGPOyc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 16 Jul 2008 10:54:32 -0400
Content-Disposition: inline
In-Reply-To: <20080716090931.6c8ca875@ichigo>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jul 16, 2008 at 09:09:31AM -0500, Jose R. Santos wrote:
> No, ext2fs_get_device_size2() should return EFBIG size if the device is
> larger than 48-bit.  I need to fix that on ext2fs_get_device_size2() but 
> this check here is ok.

No, please don't do that.  Make it reuturn EFBIG if the device won't
fit in a blk64_t type (i.e., larger than 64-bits).  In mke2fs, there
should be a separate check to make sure the size is no larger than
48-bits.  Otherwise, at some future point, perhaps we might enhance
ext4 to support full a 64-bit physical block number, and then we would
have to make behavioural changes to ext2fs_get_device_size2() that
would necessitate renaming the function yet again.

It's really important when doing library design to think about future
expandability.

						- Ted
