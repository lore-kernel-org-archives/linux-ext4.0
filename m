From: Zeev Tarantov <zeev.tarantov@gmail.com>
Subject: problem(?) in ext4 or mke2fs
Date: Sun, 3 Apr 2011 21:07:43 +0300
Message-ID: <BANLkTi=gE-utOo479RU8qcWM99NpBrFmvQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:35057 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752715Ab1DCSIE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 3 Apr 2011 14:08:04 -0400
Received: by pzk9 with SMTP id 9so1102893pzk.19
        for <linux-ext4@vger.kernel.org>; Sun, 03 Apr 2011 11:08:03 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

While testing zram I ran a script that creates a block devices,
creates a filesystem on in and untars Qt on that filesystem.
I was surprised to find ext4_mb_scan_aligned near the top of the profile output.
This was evidently because the command "mke2fs -t ext4 -m 0 -I 128 -O
^has_journal,^ext_attr <block device>"
 created a filesystem with (output of tune2fs):
RAID stride:              1
RAID stripe width:        1

I thought this strange and removed these values using debugfs:
set_super_value raid_stride 0
set_super_value raid_stripe_width 0

With this "fix" the symbol ext4_mb_scan_aligned disappeared from perf's output:

    18.98%     -3.66%  gzip                            [.] zip
     0.00%    +14.84%  [kernel.kallsyms]               [k] ext4_mb_scan_aligned
    17.91%     -3.44%  gzip                            [.]
treat_file.part.4.2264
    13.73%     -2.47%  [csnappy_compress]              [k]
snappy_compress_fragment
     3.96%     -0.77%  [kernel.kallsyms]               [k]
copy_user_generic_string
     3.05%     -0.41%  libc-2.13.so                    [.] __memcpy_ssse3
     0.89%     +1.49%  [kernel.kallsyms]               [k] _raw_spin_lock
     2.63%     -0.49%  [kernel.kallsyms]               [k] __memcpy
     1.61%     -0.17%  [kernel.kallsyms]               [k] __memset
     0.78%     -0.11%  [kernel.kallsyms]               [k] ext4_mark_iloc_dirty
     0.63%     -0.11%  [kernel.kallsyms]               [k] system_call
     0.66%     -0.14%  gzip                            [.] treat_stdin.2262
     0.58%     -0.12%  libc-2.13.so                    [.] _int_malloc

This is using mke2fs 1.41.14 (22-Dec-2010) on Linux 2.6.38.2.

Is this expected behavior? Do you need me to provide more information?

regards,
-Z.T.
