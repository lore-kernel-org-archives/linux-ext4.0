From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 0/4] e2fprogs: fun with compilers
Date: Fri, 19 Jan 2018 22:12:50 -0800
Message-ID: <151642877063.9652.3628059578106842868.stgit@magnolia>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:32808 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751386AbeATGMz (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sat, 20 Jan 2018 01:12:55 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi all,

This patch series enhances the e2fsprogs build system to allow us to
take advantage of new compiler technologies.  The first patch enables
LTO, which can perform executable-wide code optimizations (particularly
eliminating dead functions).  The three patches after that enable the
sanitizers for undefined behavior, memory access, and thread safety.
With these sanitizers we can collect runtime reports about questionable
C code, memory access problems, and thread safety problems (though at
the moment e2fsprogs isn't heavily threaded).

Questions?  Comments?

--D
