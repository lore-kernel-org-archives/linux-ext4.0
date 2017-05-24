From: Marc Thomas <marc@dragonfly.plus.com>
Subject: Re: [PATCH] e2fsck: fix sparse bmap to extent conversion
Date: Wed, 24 May 2017 12:30:58 +0100
Message-ID: <982fc176-2a8d-1318-8eec-2524c6af1e00@dragonfly.plus.com>
References: <20170523190019.GF4510@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>,
        "Theodore Ts'o" <tytso@mit.edu>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from avasout01.plus.net ([84.93.230.227]:49702 "EHLO
        avasout01.plus.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932911AbdEXLbB (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 24 May 2017 07:31:01 -0400
In-Reply-To: <20170523190019.GF4510@birch.djwong.org>
Content-Language: en-GB
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Darrick,

Thanks very much for the patch. I applied it to the git-master and built
e2fsprogs. The new "make check" test for "f_convert_bmap_sparse" passes,
and indeed my test-case script now passes.
However the test for "f_detect_junk" is failing for me:

---
$ cat f_detect_junk.failed
--- ../../tests/f_detect_junk/expect    2017-05-24 08:58:29.025273717 +0000
+++ f_detect_junk.log   2017-05-24 09:23:41.426168239 +0000
@@ -13,6 +13,7 @@
 
 *** debugfs
 test.img: Bad magic number in super-block while opening filesystem
+Checksum errors in superblock!  Retrying...
 *** tune2fs
 ../misc/tune2fs: Bad magic number in super-block while trying to open
test.img
 *** mke2fs
---

I think the expect test maybe just needs updating.


I will now try the patched e2fsck on the full data-migration process I'm
doing and report back. This will take a few hours.

Kind Regards,
Marc
