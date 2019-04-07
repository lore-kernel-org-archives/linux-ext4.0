Return-Path: <SRS0=afbN=SJ=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F0F4C282DD
	for <linux-ext4@archiver.kernel.org>; Sun,  7 Apr 2019 20:27:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DE34B20880
	for <linux-ext4@archiver.kernel.org>; Sun,  7 Apr 2019 20:27:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="i/pDYUgc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726461AbfDGU1Q (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sun, 7 Apr 2019 16:27:16 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:52010 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726397AbfDGU1P (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sun, 7 Apr 2019 16:27:15 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x37KN3Zc070689;
        Sun, 7 Apr 2019 20:27:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2018-07-02;
 bh=35ifg42zEenL7YYdIzei8tu3bHGzCDlXvpdEmpGEZok=;
 b=i/pDYUgcoqB269ddpKABvxhrxLkJqqLgpAzhiuesP7D0l6OAhEZcOvkF6siap0yGqFz/
 kzWPS2V9t5yZ7FZ+wAqyXbbDLDhaTdR1Mh1qkUDDiBoPQgArZGQOCTa2bP/Q1v6TMiDF
 l3SB3uCcXCSEEau64WqIbnZxy2ytpNLRrVNBm+r82VZvwzbeEYG8XmceDoPSQCEXgulC
 xvFeLHCqyuvfwHu+CCx381BtQS1uNxAXpk1mm3EPNGbq2jfPpzuWnkvDwmTTw6g6rvJi
 kLy27dVAGxodOCF/nm6mmm7fkbfdsDGUAyY/EinEFWIivwvm/j+nOnlo12xcX4niwyhA 3g== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 2rphme3bdu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 07 Apr 2019 20:27:11 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x37KQN6u165532;
        Sun, 7 Apr 2019 20:27:10 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2rph7rqdfn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 07 Apr 2019 20:27:10 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x37KR8wa025403;
        Sun, 7 Apr 2019 20:27:09 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 07 Apr 2019 13:27:08 -0700
Subject: [PATCH v2 0/4] vfs: make immutable files actually immutable
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     david@fromorbit.com, linux-xfs@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Date:   Sun, 07 Apr 2019 13:27:01 -0700
Message-ID: <155466882175.633834.15261194784129614735.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9220 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=954
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1904070193
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9220 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=981 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1904070193
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Hi all,

The chattr(1) manpage has this to say about the immutable bit that
system administrators can set on files:

"A file with the 'i' attribute cannot be modified: it cannot be deleted
or renamed, no link can be created to this file, most of the file's
metadata can not be modified, and the file can not be opened in write
mode."

Given the clause about how the file 'cannot be modified', it is
surprising that programs holding writable file descriptors can continue
to write to and truncate files after the immutable flag has been set,
but they cannot call other things such as utimes, fallocate, unlink,
link, setxattr, or reflink.

Since the immutable flag is only settable by administrators, resolve
this inconsistent behavior in favor of the documented behavior -- once
the flag is set, the file cannot be modified, period.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This has been lightly tested with fstests.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=immutable-files
