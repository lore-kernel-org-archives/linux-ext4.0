From: Ruoxin Jiang <rj2394@columbia.edu>
Subject: Ext4 Bug Report
Date: Wed, 6 Sep 2017 11:58:19 -0400
Message-ID: <CAFzqJcYcZHFzSJEGKrjHy3HgwDfiDHg5_wbj6GM7g+4sFPZkDQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="001a11444ab2a9fbe505588769c8"
Cc: Suman Jana <sumanj@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from outprodmail01.cc.columbia.edu ([128.59.72.39]:38908 "EHLO
        outprodmail01.cc.columbia.edu" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932157AbdIFQOe (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 6 Sep 2017 12:14:34 -0400
Received: from hazelnut (hazelnut.cc.columbia.edu [128.59.213.250])
        by outprodmail01.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id v86Fu8bv036275
        for <linux-ext4@vger.kernel.org>; Wed, 6 Sep 2017 11:58:21 -0400
Received: from hazelnut (localhost.localdomain [127.0.0.1])
        by hazelnut (Postfix) with ESMTP id DD6BE6D
        for <linux-ext4@vger.kernel.org>; Wed,  6 Sep 2017 11:58:21 -0400 (EDT)
Received: from sendprodmail04.cc.columbia.edu (sendprodmail04.cc.columbia.edu [128.59.72.16])
        by hazelnut (Postfix) with ESMTP id BDE967E
        for <linux-ext4@vger.kernel.org>; Wed,  6 Sep 2017 11:58:21 -0400 (EDT)
Received: from mail-wr0-f197.google.com (mail-wr0-f197.google.com [209.85.128.197])
        by sendprodmail04.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id v86FwL1s058982
        (version=TLSv1/SSLv3 cipher=AES128-GCM-SHA256 bits=128 verify=NOT)
        for <linux-ext4@vger.kernel.org>; Wed, 6 Sep 2017 11:58:21 -0400
Received: by mail-wr0-f197.google.com with SMTP id w12so7930753wrc.2
        for <linux-ext4@vger.kernel.org>; Wed, 06 Sep 2017 08:58:21 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--001a11444ab2a9fbe505588769c8
Content-Type: text/plain; charset="UTF-8"

Hello,

We are researchers from Columbia University, New York. As part of our
current research we have found some semantic discrepancies between
ext4 and the POSIX specification/other popular filesystems.

We have attached two cases. The first one involves a direct access
read starting from file EOF. Ext4 behavior in this case seems to
violate the POSIX standard. In directory 2, we discovered that ext4
and other popular filesystems (xfs/btrfs/f2fs) return different error
codes for the same lseek syscall.

In each directory, you will find a Readme describing the issue and
pointing to the code that may cause the problem. For your convenience,
we also included test programs (min.cpp) and instructions in Readme to
help reproduce the issues.

We would appreciate very much if you could confirm the
two cases at your conveniences.

Thanks,
Amy

--001a11444ab2a9fbe505588769c8
Content-Type: application/x-gzip; name="ext4_issues.tar.gz"
Content-Disposition: attachment; filename="ext4_issues.tar.gz"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_j7977phf0

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
/RdJHTcEADoAAA==
--001a11444ab2a9fbe505588769c8--
