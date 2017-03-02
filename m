From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 0/2] e2fsprogs: misc fixes; online e2freefrag
Date: Thu, 02 Mar 2017 14:20:39 -0800
Message-ID: <148849323931.17335.16297720312431312922.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1050.oracle.com ([141.146.126.70]:37402 "EHLO
        aserp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751332AbdCCFuo (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 3 Mar 2017 00:50:44 -0500
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69])
        by aserp1050.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v22MMC23015216
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-ext4@vger.kernel.org>; Thu, 2 Mar 2017 22:22:12 GMT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi all,

Two patches: one to fix compiler warnings, and another to teach e2freefrag
to use GETFSMAP to find free space on a mounted filesystem.

--D
