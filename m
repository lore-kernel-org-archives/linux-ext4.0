Return-Path: <SRS0=XaFB=Y5=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B9BFCA9ED3
	for <linux-ext4@archiver.kernel.org>; Tue,  5 Nov 2019 01:54:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0B55F20717
	for <linux-ext4@archiver.kernel.org>; Tue,  5 Nov 2019 01:54:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="q4c+6c4K"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729801AbfKEByR (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 4 Nov 2019 20:54:17 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:35096 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729597AbfKEByR (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 4 Nov 2019 20:54:17 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA51rocx174547;
        Tue, 5 Nov 2019 01:54:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2019-08-05;
 bh=qUirGUg9RfgaKFgt6/FaksaZF0ZbhJGCre40diJJQaA=;
 b=q4c+6c4KEeW0lD8j8LMXHuLB2GVDRPqc/uFXzU/MONur/Odf2OIFYejSMyLHa5z9E5sk
 OdjSPVUFFsMU/VkJvWACLcpMLMjxAO279DsC+PTw7GUfF73q51mn9vWJntfmpMH26QYs
 O29sPbA4YydgtNjIrcHN7iSOwvLbL9Pl0NoEf5z5zAnAB4IxvjFEgYMDBgpf5hhjSrRo
 15UF7/WkaeLpPq5iC6LySlH7ELEXMq9usukwZRh68oB9EJA7wIYTLrqi1hzPonOO1cld
 k5+y2WVI4BPNU69rPP3IpUqbuZTNXLHqpV9RN/XD8h4NTm6R9P/wGvBTz7n5oSiBoHNB aA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2w117tu421-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Nov 2019 01:54:14 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA51s9SV028899;
        Tue, 5 Nov 2019 01:54:13 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2w2wcgf77k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Nov 2019 01:54:12 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xA51s9eU007503;
        Tue, 5 Nov 2019 01:54:09 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 04 Nov 2019 17:54:09 -0800
Subject: [PATCH 0/2] e2scrub: fix some problems
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     tytso@mit.edu, darrick.wong@oracle.com
Cc:     linux-ext4@vger.kernel.org
Date:   Mon, 04 Nov 2019 17:54:08 -0800
Message-ID: <157291884852.328601.5452592601628272222.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9431 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=637
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1911050013
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9431 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=720 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1911050013
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Hi all,

Fix a couple of problems that have been reported against e2scrub_all.
The first fixes a complaint about a large increase in boot time due to
automatic reaping of e2scrub snapshots.  The second eliminates some
broken hackery around loop iteration in bash.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D
