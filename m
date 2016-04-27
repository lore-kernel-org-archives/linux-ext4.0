From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v4 2/3] ext4: fix races between changing inode journal
 mode and ext4_writepages
Date: Wed, 27 Apr 2016 10:30:32 -0400
Message-ID: <20160427143032.GG30021@thunk.org>
References: <1319414639.152111461744250568.JavaMail.weblogic@ep2mlwas01c>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "jack@suse.cz" <jack@suse.cz>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Daeho Jeong <daeho.jeong@samsung.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:48118 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751550AbcD0Oai (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 27 Apr 2016 10:30:38 -0400
Content-Disposition: inline
In-Reply-To: <1319414639.152111461744250568.JavaMail.weblogic@ep2mlwas01c>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Apr 27, 2016 at 08:04:10AM +0000, Daeho Jeong wrote:
> Oops, sorry about causing the regression.
> 
> But in the version I worked on, we passed the test case and
> we still pass that. I executed the test case as belows.
> 
> kvm-xfstests -c 1k -C 10 generic/231
> 
> I am going to retry the test using GCE with the latest kernel version.

Hi, sorry, it looks like I jumped to conclusions too hastily.

I let the tests finish last night and generic/231 is failing around
10-20% of the time prior to your patch series.  I just didn't notice it
at first because the failure happened at the very end:

xfstests results 201604270033 - 4.6.0-rc4-ext4
Passed all 1 tests
Passed all 1 tests
Passed all 1 tests
Passed all 1 tests
Passed all 1 tests
Passed all 1 tests
Passed all 1 tests
Passed all 1 tests
Failures: generic/231
Failures: generic/231

With your patches, it remains at about the same level, but when the
tests failed caused me to assume they were the caused by your patches.

xfstests results 201604270044 - 4.6.0-rc4-ext4-00007-g76bee81 (Just before your patches)
Passed all 1 tests
Passed all 1 tests
Passed all 1 tests
Passed all 1 tests
Failures: generic/231
Passed all 1 tests
Passed all 1 tests
Passed all 1 tests
Failures: generic/231
Passed all 1 tests

xfstests results 201604270054 - 4.6.0-rc4-ext4-00008-g31cedaa (Your 1/3 patch)
Passed all 1 tests
Passed all 1 tests
Passed all 1 tests
Failures: generic/231
Passed all 1 tests
Passed all 1 tests
Passed all 1 tests
Passed all 1 tests
Passed all 1 tests
Passed all 1 tests

xfstests results 201604270052 - 4.6.0-rc4-ext4-00009-g46ceec9 (Your 2/3 patch)
Failures: generic/231   <=== this is why I thought this commit was the regression
Passed all 1 tests
Passed all 1 tests
Passed all 1 tests
Passed all 1 tests
Passed all 1 tests
Passed all 1 tests
Passed all 1 tests
Passed all 1 tests
Failures: generic/231

xfstests results 201604270046 - 4.6.0-rc4-ext4-00010-geed525e (Your 3/3 patch)
Failures: generic/231
Failures: generic/231
Failures: generic/231
Failures: generic/231
Failures: generic/231
Passed all 1 tests
Passed all 1 tests
Passed all 1 tests
Passed all 1 tests
Failures: generic/231   

So enabling per-file data journalling and delalloc is definitely makes
the problem much more visible, but it looks like it was always there.

Apologies for the initial misdiagnosis....

						- Ted
