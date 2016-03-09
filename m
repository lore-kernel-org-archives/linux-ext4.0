From: Eric Whitney <enwlinux@gmail.com>
Subject: regression in 4.5-rc5 - generic/324 failure
Date: Wed, 9 Mar 2016 17:17:46 -0500
Message-ID: <20160309221746.GA1763@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, guaneryu@gmail.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qk0-f172.google.com ([209.85.220.172]:33453 "EHLO
	mail-qk0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752142AbcCIWRL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 9 Mar 2016 17:17:11 -0500
Received: by mail-qk0-f172.google.com with SMTP id s5so26780488qkd.0
        for <linux-ext4@vger.kernel.org>; Wed, 09 Mar 2016 14:17:10 -0800 (PST)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I'm seeing generic/324 fail consistently when run with xfstest-bld's test
appliance in the 1k block size test case on x86_64.  This happened first on my
4.5-rc5 regression run, and it repeated on -rc6 and -rc7.

Reverting a commit introduced in 4.5-rc5 inhibits the failure:
"ext4: don't read blocks from disk after extents being swapped" (bcff24887d00)

And here's the failed test output:

generic/324 15s ...	[22:10:20][    3.304758] run fstests generic/324 at 2016-03-09 22:10:20
 [22:10:21] [failed, exit status 1] - output mismatch (see /results/results-1k/generic/324.out.bad)
    --- tests/generic/324.out	2015-10-25 10:50:34.000000000 +0000
    +++ /results/results-1k/generic/324.out.bad	2016-03-09 22:10:21.753937505 +0000
    @@ -22,2509 +22,5 @@
     XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
     Before: in_range(10, 40)
     After: in_range(1, -1)
    -Defragment file with 250 * 2 fragments
    -wrote 1234/1234 bytes at offset 0
    -XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
    -wrote 1234/1234 bytes at offset 123400
    ...
    (Run 'diff -u tests/generic/324.out /results/results-1k/generic/324.out.bad'  to see the entire diff)
diff: standard output: Broken pipe
Ran: generic/324
Failures: generic/324
Failed 1 of 1 tests

Thanks,
Eric
