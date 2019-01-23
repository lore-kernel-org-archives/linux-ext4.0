Return-Path: <SRS0=JWl4=P7=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AB54C282C0
	for <linux-ext4@archiver.kernel.org>; Wed, 23 Jan 2019 14:32:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E425521726
	for <linux-ext4@archiver.kernel.org>; Wed, 23 Jan 2019 14:32:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="AbAv+aaJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726350AbfAWOcP (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 23 Jan 2019 09:32:15 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:45340 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725995AbfAWOcP (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 23 Jan 2019 09:32:15 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id x0NENwvk075999
        for <linux-ext4@vger.kernel.org>; Wed, 23 Jan 2019 14:32:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=mime-version :
 message-id : date : from : to : cc : subject : content-type :
 content-transfer-encoding; s=corp-2018-07-02;
 bh=R8pbZmbQQEzT8aW4229/wv12cqSiEGp/zm/kkPvwRv8=;
 b=AbAv+aaJVcxLFuI8EmZR3HfWzxxieAZwiuCnYauiUBEWl4zlk63VQkwfiXTWBcWjScgH
 /DrXiXdcxUd1TJYhEk4Q+9+1P3hP3axSFuPpz8yXl/MEJIV7+JxPckvnyQHMbhMgaOB3
 EUlWektCMaC7MTuaI2E/nJDJJOKqmsoHDjdxajJnSzoZEzP8B+IGmGaL7RWQ6REMfKjx
 9/mZJIA5fG0PTqcO98n8nJiHjM2NqfIC21x0N9LY8hDu4ZW38pvRlX2WW6gQiMEMe3Yu
 kK3H3P8TtBAM/mffybjB4jKAwYn0AFnSzdKr4BcsZVxJHdygQCMmFopfM/bkXXD7lMsf 2w== 
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2120.oracle.com with ESMTP id 2q3vhrt1tw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-ext4@vger.kernel.org>; Wed, 23 Jan 2019 14:32:13 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x0NEWD2u010995
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-ext4@vger.kernel.org>; Wed, 23 Jan 2019 14:32:13 GMT
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x0NEWDOq010562
        for <linux-ext4@vger.kernel.org>; Wed, 23 Jan 2019 14:32:13 GMT
MIME-Version: 1.0
Message-ID: <73b3ad85-9d29-40a1-b94f-80be35e6c26b@default>
Date:   Wed, 23 Jan 2019 06:32:12 -0800 (PST)
From:   Dongli Zhang <dongli.zhang@oracle.com>
To:     <linux-ext4@vger.kernel.org>
Cc:     Joe Jin <joe.jin@oracle.com>, Junxiao Bi <junxiao.bi@oracle.com>
Subject: Why jbd2 might freeze in kjournald2()
X-Mailer: Zimbra on Oracle Beehive
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9144 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=739
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1901230108
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Hi,

I am writing to ask why jbd2 might freeze in kjournald2()?

I am asking this because since blk-mq commit bc27c01b5c46 (blk-mq: Do not
invoke .queue_rq() for a stopped queue), the I/O request will be queued
when the queue is stopped, that is, when OS is frozen (e.g., during xen
live migration or "echo freeze > /sys/power/state" in kvm guest). I think
it should be fine to not freeze jbd2.

Why would kjournald2() freeze to avoid submitting I/O?

Is it because of what is mentioned in code that "The simpler the better",
or there is any other reason?

Thank you very much!

Dongli Zhang
