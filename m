From: Theodore Ts'o <tytso@mit.edu>
Subject: New kvm-xfstests images uploaded
Date: Wed, 6 May 2015 19:12:03 -0400
Message-ID: <20150506231203.GA3275@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:49713 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751119AbbEFXMF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 6 May 2015 19:12:05 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I've uploaded a new kvm-xfstests image at:

https://www.kernel.org/pub/linux/kernel/people/tytso/kvm-xfstests

This has an updated e2fsprogs, xfstests, xfsprogs, etc:

efsprogs	v1.42.12-548-g8804a96 (Tue, 5 May 2015 10:52:12 -0400)
fio		fio-2.2.6 (Fri, 27 Feb 2015 08:30:04 -0700)
quota		022aabf (Wed, 26 Nov 2014 10:22:08 +0100)
xfsprogs	v3.2.2-36-g502544b (Mon, 13 Apr 2015 09:33:50 +1000)
xfstests-bld	843186f (Tue, 5 May 2015 23:53:00 -0400)
xfstests	linux-v3.8-656-gc3d3e1e (Mon, 4 May 2015 22:56:13 +1000)

Quick start information for using kvm-xfstests can be found here:

https://git.kernel.org/cgit/fs/ext2/xfstests-bld.git/plain/quick-start?h=META

Cheers,

						- Ted
