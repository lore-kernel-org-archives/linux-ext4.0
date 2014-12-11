From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 4/4] ext4: fix suboptimal seek_{data,hole} extents
 traversial
Date: Thu, 11 Dec 2014 15:05:40 -0500
Message-ID: <20141211200540.GE31008@thunk.org>
References: <1417518054-21733-1-git-send-email-dmonakhov@openvz.org>
 <1417518054-21733-4-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:51645 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758732AbaLKUFp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 11 Dec 2014 15:05:45 -0500
Content-Disposition: inline
In-Reply-To: <1417518054-21733-4-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Dmitry,

I only noticed this after I sent the pull request to Linus, but it
looks like this patch is triggering regression using the ext3 config:

./kvm-xfstests -c ext3 generic/285:

The failure reported by seek_santy_test is:

10. Test a huge file for offset overflow
10.01 SEEK_HOLE expected 65536 or 0, got 0.                       FAIL
10.02 SEEK_HOLE expected 65536 or 0, got 1.                       FAIL
10.03 SEEK_DATA expected 0 or 0, got -1.                          FAIL
10.04 SEEK_DATA expected 1 or 1, got -1.                          FAIL
10.05 SEEK_HOLE expected 0 or 0, got -65536.                      FAIL
10.06 SEEK_DATA expected -65536 or -65536, got -1.                FAIL
10.07 SEEK_DATA expected -65535 or -65535, got -1.                FAIL
10.08 SEEK_DATA expected -65536 or -65536, got -1.                FAIL

What's strange is that if I run the commands by hand, I get a very
different failure:

root@kvm-xfstests:~# ./xfstests/src/seek_sanity_test /vdd/seek_sanity_testfile
File system magic#: 0xef53
Allocation size: 4096
Kernel does not support llseek(2) extensions SEEK_HOLE and/or SEEK_DATA. Aborting.

Using strace, the problem is that the SEEK_DATA fallocate is failing:

pwrite64(3, "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"..., 8192, 0) = 8192
ftruncate64(3, 16384)                   = 0
_llseek(3, 0, 0xbff7fe70, SEEK_DATA)    = -1 ENXIO (No such device or address)

This fails with commit 14516bb: "ext4: fix suboptimal seek_{data,hole}
extents traversial" and succeeds with its immediate predesssor commit.

I've tried looking at this, but hte fact that I'm seeing different
results when I run it by hand (sometimes I can trigger the failure
with runtests.sh, usually I can't), means that it appears to be timing
dependent.

Could you take a look?

Many thanks!!

						- Ted
