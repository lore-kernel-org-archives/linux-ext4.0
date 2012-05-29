From: Andreas Dilger <adilger@whamcloud.com>
Subject: Re: [PATCH] tests: use make rules to run tests in parallel (v3)
Date: Tue, 29 May 2012 01:02:11 -0600
Message-ID: <37AFC02E-AB57-4B17-906A-D5FE643B7226@whamcloud.com>
References: <1338245904-31827-1-git-send-email-adilger@whamcloud.com> <20120529012859.GF5610@thunk.org>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:53237 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751423Ab2E2HCP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 29 May 2012 03:02:15 -0400
Received: by dady13 with SMTP id y13so5026323dad.19
        for <linux-ext4@vger.kernel.org>; Tue, 29 May 2012 00:02:15 -0700 (PDT)
In-Reply-To: <20120529012859.GF5610@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2012-05-28, at 7:28 PM, Ted Ts'o wrote:
> On Mon, May 28, 2012 at 04:58:24PM -0600, Andreas Dilger wrote:
>> Change the e2fsck/mke2fs/tune2fs/e2image/debugfs regression tests
>> to be driven by Makefile rules instead of by a script loop.  This
>> allows the tests to be run in parallel like a build and reduces
>> testing time significantly.
> 
> Applied with some fixes; test_script was still working correctly with
> VPATH.  Also, removing the writeable flag from test_one and
> test_script means that Makefile will get a "permission denied" if it
> needs to rebuild those two files.

Hrm, one reason I made the generated files read-only is to avoid
accidentally editing the generated copy, and then losing the resulting
changes when the file is recreated (as happened several times with the
test_script file, when rebasing the patch).  I'd prefer to mark the
generated files read-only, and then have the Makefile rules delete the
file before recreating it.

That avoids accidentally having developers edit the file, while allowing
the always-remembering Makefile rule to recreate the file without errors.

Cheers, Andreas
--
Andreas Dilger                       Whamcloud, Inc.
Principal Lustre Engineer            http://www.whamcloud.com/




