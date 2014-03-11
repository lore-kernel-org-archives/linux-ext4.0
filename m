From: Eric Whitney <enwlinux@gmail.com>
Subject: shared/289 failures on metadata_csum, e2fsprogs master branch
Date: Tue, 11 Mar 2014 15:38:19 -0400
Message-ID: <20140311193819.GA2274@wallace>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qc0-f171.google.com ([209.85.216.171]:43781 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753881AbaCKTiX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 11 Mar 2014 15:38:23 -0400
Received: by mail-qc0-f171.google.com with SMTP id x13so10094179qcv.2
        for <linux-ext4@vger.kernel.org>; Tue, 11 Mar 2014 12:38:22 -0700 (PDT)
Received: from wallace (c-75-67-250-69.hsd1.nh.comcast.net. [75.67.250.69])
        by mx.google.com with ESMTPSA id b30sm33197656qge.21.2014.03.11.12.38.22
        for <linux-ext4@vger.kernel.org>
        (version=TLSv1.2 cipher=RC4-SHA bits=128/128);
        Tue, 11 Mar 2014 12:38:22 -0700 (PDT)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Xfstest shared/289 fails when run on an ext4 test filesystem created with
the metadata_csum and 64bit options and using executables from the latest
e2fsprogs master branch (46d2a26683).  I've seen the problem on kernel
versions from 3.14-rc1 through 3.14-rc6, but I think this is an e2fsprogs
regression rather than a kernel problem.

The failing portion of shared/289 can be boiled down to:

mkfs.ext4 -O metadata_csum,64bit /dev/vdc
dumpe2fs -h /dev/vdc 2>/dev/null | awk '/Free blocks:/{print $3}'

The problem (in my test config) is that the reported free block value is
184684916231 (much larger than my test device) where the reported block
count is 1382400 (much saner).

The bug appears to have been introduced between two merges of the maint
branch: 72958b6670 (good - 10 Jan) and f0996c12d5 (bad - 30 Jan).  Some
weeks ago, I thought I'd bisected the problem to a specific patch
(8e44eb64bb - libext2fs: mark group data blocks when loading block bitmap),
which seemed like a plausible candidate.  However, I find I can't
reproduce the bisection now, as e2fsprogs doesn't want to support the
metadata_csum, 64bit options during bisection in the master branch (that'll
teach me for not mentioning this earlier... :-) ).

Thanks,
Eric
