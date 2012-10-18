From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: A question about the naming of e2fsprogs/tests
Date: Wed, 17 Oct 2012 20:19:24 -0400
Message-ID: <20121018001924.GA18677@thunk.org>
References: <20121017131351.GA22794@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org, adilger.kernel@dilger.ca
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:56021 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752612Ab2JRAT2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 17 Oct 2012 20:19:28 -0400
Content-Disposition: inline
In-Reply-To: <20121017131351.GA22794@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Oct 17, 2012 at 09:13:51PM +0800, Zheng Liu wrote:
> 
> Now I am trying to create some regression tests for e2fsprogs to test
> inline data feature.  I have a question about the naming of
> e2fsprogs/tests.  I notice that in tests dir there are a lot of
> directories, which have different prefixes, such as d_loaddump,
> e_brel_bma, f_baddir, m_dasd_bs, r_move_itable, t_mmp_1on, and u_mke2fs.
> As far as I can understand, d_ is for debugfs, f_ means test for filesystem,
> m_ is for mke2fs, r_ is for resize2fs, t_ is for tune2fs, and u_ is for e2undo.
> Could anyone tell me what e_ stands for?  If I misunderstand something, please
> point it out.  Thanks.

The e_ calls were for unit tests for the "extent" functions --- where
extents are not the ext4 extents, but some utility functions which
were are used by resize2fs.  These days we generally don't use the
tests directory for unit tests, because it's a lot more work to do
things that way.  Instead there are tst_* files in lib/ext2fs that are
built and run with "make check".

I *do* ask that people who create new functions in libext2fs strongly
consider adding unit tests.  We are pretty good with integration tests
in the tests directory, but we are a bit light on unit tests coverage
in lib/ext2fs.

And of course, if someone is inspired to write some new unit tests for
existing functions, that would just great.

Thanks!!

						- Ted
