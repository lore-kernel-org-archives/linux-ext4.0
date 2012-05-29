From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] tests: use make rules to run tests in parallel (v3)
Date: Mon, 28 May 2012 21:28:59 -0400
Message-ID: <20120529012859.GF5610@thunk.org>
References: <1338245904-31827-1-git-send-email-adilger@whamcloud.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@whamcloud.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:46106 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751760Ab2E2B3E (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 May 2012 21:29:04 -0400
Content-Disposition: inline
In-Reply-To: <1338245904-31827-1-git-send-email-adilger@whamcloud.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, May 28, 2012 at 04:58:24PM -0600, Andreas Dilger wrote:
> Change the e2fsck/mke2fs/tune2fs/e2image/debugfs regression tests
> to be driven by Makefile rules instead of by a script loop.  This
> allows the tests to be run in parallel like a build and reduces
> testing time significantly.
> 
> One major change to the tests themselves is to printing the test
> name, description, and status together after the test has passed
> or failed, to avoid mixing lines from the tests.  The other major
> change is to use unique temporary filenames for each test, which was
> mostly handled already via b4db1e4c7461a50e18c9fd135b9f1ba6f27e4390,
> but in some cases temporary files are changed to use $test_name.tmp
> to avoid any collision between running tests.
> 
> On my old 2-CPU system it reduced the testing time from 160s to 40s.
> Much of the savings is from the MMP test delays running in parallel.
> It still takes the time of the slowest test, f_mmp_garbage, though
> there will be ongoing benefit in the future as more tests are added
> since the wallclock time will not increase linearly for each test.
> 
> Tests were run with various combinations of "make -j", and "make -j2"
> through "make -j44" repeatedly without any test failures.
> 
> Signed-off-by: Andreas Dilger <adilger@whamcloud.com>

Applied with some fixes; test_script was still working correctly with
VPATH.  Also, removing the writeable flag from test_one and
test_script means that Makefile will get a "permission denied" if it
needs to rebuild those two files.

						- Ted
