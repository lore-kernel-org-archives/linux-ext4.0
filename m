From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [patch] ext4: clean up the flags passed to
 __blockdev_direct_IO for extent-based files
Date: Mon, 5 Mar 2012 10:25:09 -0500
Message-ID: <20120305152509.GA21356@thunk.org>
References: <x49zkc7c36m.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jeff Moyer <jmoyer@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:39083 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964837Ab2CEPZN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 5 Mar 2012 10:25:13 -0500
Content-Disposition: inline
In-Reply-To: <x49zkc7c36m.fsf@segfault.boston.devel.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Feb 24, 2012 at 04:49:21PM -0500, Jeff Moyer wrote:
> Hi,
> 
> For extent-based files, you can perform DIO to holes, as mentioned in
> the comments in ext4_ext_direct_IO.  However, that function passes
> DIO_SKIP_HOLES to __blockdev_direct_IO, which is *really* confusing to
> the uninitiated reader.  The key, here, is that the get_block function
> passed in, ext4_get_block_write, completely ignores the create flag that
> is passed to it (the create flag is passed in from the direct I/O code,
> which uses the DIO_SKIP_HOLES flag to determine whether or not it should
> be cleared).
> 
> This is a long-winded way of saying that the DIO_SKIP_HOLES flag is
> ultimately ignored.  So, in the interest of preserving sanity, I propose
> the following patch.
> 
> Signed-off-by: Jeff Moyer <jmoyer@redhat.com>

Thanks, applied.

					- Ted
