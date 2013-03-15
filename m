From: Eric Whitney <enwlinux@gmail.com>
Subject: possible dev branch regression - xfstest 285/1k
Date: Fri, 15 Mar 2013 18:28:18 -0400
Message-ID: <20130315222818.GA16100@wallace>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-vb0-f52.google.com ([209.85.212.52]:33891 "EHLO
	mail-vb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754406Ab3COW2Y (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 15 Mar 2013 18:28:24 -0400
Received: by mail-vb0-f52.google.com with SMTP id fa15so2166366vbb.39
        for <linux-ext4@vger.kernel.org>; Fri, 15 Mar 2013 15:28:23 -0700 (PDT)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I'm seeing Xfstest 285 consistently fail for the 1k test case using the
latest dev branch while running on both x86 and ARM.  Subtest 08 is
the problem. From the test output:

08. Test file with unwritten extents, only have unwritten pages
08.01 SEEK_HOLE expected 0 or 4194304, got 11264.                 FAIL
08.02 SEEK_HOLE expected 1 or 4194304, got 11264.                 FAIL
08.03 SEEK_DATA expected 10240 or 10240, got 0.                   FAIL
08.04 SEEK_DATA expected 10240 or 10240, got 1.                   FAIL

>From previous discussions, we expect 285 to fail in the ext3 (nodelalloc,
no flex_bg, and no extents) test case, but in subtest 07.  It still does
that.

In the dev branch, reverting 4f42f80a8f - "ext4: use s_extent_max_zeroout_kb
value as number of kb" - results in success for 285 in the 1k test case.

Regards,
Eric




