From: Andreas Dilger <adilger@whamcloud.com>
Subject: Re: [PATCH] tests: use make rules to run tests in parallel
Date: Wed, 23 May 2012 06:48:49 -0600
Message-ID: <774E9809-8790-4613-B2AC-1E56182C4233@whamcloud.com>
References: <1337776849-1138-1-git-send-email-adilger@whamcloud.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: "Ext4 Mailing List" <linux-ext4@vger.kernel.org>,
	Theodore Ts'o <tytso@mit.edu>
To: Andreas Dilger <adilger@whamcloud.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34244 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752319Ab2EWMsx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 23 May 2012 08:48:53 -0400
Received: by pbbrp8 with SMTP id rp8so9846571pbb.19
        for <linux-ext4@vger.kernel.org>; Wed, 23 May 2012 05:48:53 -0700 (PDT)
In-Reply-To: <1337776849-1138-1-git-send-email-adilger@whamcloud.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

[PS: I typo'd Ted's email when sending the patch from git, I assume
the patch sent to the list will make it...]

On 2012-05-23, at 6:40 AM, Andreas Dilger wrote:
> Change the e2fsck/mke2fs/tune2fs/e2image/debugfs regression tests
> to be driven by Makefile rules instead of by a script loop.  This
> allows the tests to be run in parallel like a build and reduces
> testing time significantly.
> 
> One major change to the tests themselves is to avoid printing any
> status output until the test has passed or failed, to avoid mixing
> lines from the tests.  The other major change is to use unique
> filenames for each test, which was mostly handled already, but in
> some cases temporary files are called $test_name.tmp to avoid any
> collision between running tests.
> 
> On my old system it reduced the testing time from 160s to about 40s.
> Most of the savings is running the MMP test check delays in parallel,
> but it still takes the length of the slowest test, f_mmp_garbage.
> There will be ongoing benefit in the future as more tests are added.
> Tests were run with "make -j", "make -j4", "make -j12", "make -j16",
> and "make -j24" repeatedly without any test failures.

The main motivation for this patch is because I'm running a LOT of
regression tests as I'm rebasing our e2fsprogs tree to catch up to
the upstream master.  This sometimes means running "make check" for
many patches in my own series as it is rebased incrementally on
successive upstream targets, in addition to the larger number of
tests in our tree.

I just got tired of waiting for the MMP tests to time out...

Cheers, Andreas
--
Andreas Dilger                       Whamcloud, Inc.
Principal Lustre Engineer            http://www.whamcloud.com/




