From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH][RESEND] tests: add another test for uninit extents past
 eof
Date: Mon, 30 Sep 2013 16:10:46 -0400
Message-ID: <20130930201046.GC5845@thunk.org>
References: <20130923143518.GA2464@wallace>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Eric Whitney <enwlinux@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:40341 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756299Ab3I3ULL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 30 Sep 2013 16:11:11 -0400
Content-Disposition: inline
In-Reply-To: <20130923143518.GA2464@wallace>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Sep 23, 2013 at 10:35:18AM -0400, Eric Whitney wrote:
> Commit d3f32c2db8 was intended to detect extents found outside their
> proper location in the extent tree, including invalid extents at the
> end of an extent block.  However, it incorrectly reported legal
> uninitialized extents created by fallocate() at the end of file with
> the FALLOC_FL_KEEP_SIZE flag as false positives.  xfstests
> generic/263 (among others) caught this problem, while the e2fsprogs
> test f_uninit_ext_past_eof did not.  The latter test failed to
> detect the problem in part because it uses a test file whose i_size
> is 0.
> 
> Add a test derived from the fsx-based test case in xfstests
> generic/263 consisting of a file with non-zero length, more than
> four extents total, and two uninitialized extents past EOF to
> reliably reproduce commit d3f32c2db8's false positive behavior.
> 
> Signed-off-by: Eric Whitney <enwlinux@gmail.com>

Applied, thanks.

						- Ted
