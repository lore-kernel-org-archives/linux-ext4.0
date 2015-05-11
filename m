From: Eric Whitney <enwlinux@gmail.com>
Subject: 4.1-rc2 kvm-xfstests regressions for ext3 test config
Date: Mon, 11 May 2015 17:37:31 -0400
Message-ID: <20150511213731.GA4012@wallace>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, dccitaliano@gmail.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qc0-f172.google.com ([209.85.216.172]:36516 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435AbbEKVhf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 11 May 2015 17:37:35 -0400
Received: by qcbgy10 with SMTP id gy10so76236703qcb.3
        for <linux-ext4@vger.kernel.org>; Mon, 11 May 2015 14:37:34 -0700 (PDT)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I've got six new test failures in the ext3 test configuration when
running a 4.1-rc2 kernel on x86_64 with the latest version of
kvm-xfstests.

The new failures include generic/075, generic/091, generic/112,
generic/127, generic/231, and generic/263.  All also fail on ARM
(Pandaboard) when running a 4.1-rc2 kernel on bare metal.

Reverting an -rc2 patch corrects all these failures:
ext4: move check under lock scope to close a race (280227a75b56)

All the failed tests use fsx, all fail when attempting to perform a
COLLAPSE_RANGE, and fsx uses this statement to determine whether a
particular fallocate mode is supported (and then doesn't use it if not):

	if (fallocate(fd, mode, 0, 1) && errno == EOPNOTSUPP)

In -rc1, ext4_fallocate()/extents.c returns EOPNOTSUPP, and in -rc2,
EINVAL.  What's happened is that we no longer immediately fail a
COLLAPSE_RANGE request for a block-mapped file with EOPNOTSUPP.  Instead,
we now first check to see if the COLLAPSE_RANGE request is cluster-aligned
and sized in ext4_collapse_range()/extents.c, and return EINVAL if not.
(There's still a check for block-mapped files, but it's applied later in
ext4_collapse_range().)

I think we'd want to return EOPNOTSUPP first in this case.

Eric



