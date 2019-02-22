Return-Path: <SRS0=rve6=Q5=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C775C43381
	for <linux-ext4@archiver.kernel.org>; Fri, 22 Feb 2019 02:51:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 00A0520836
	for <linux-ext4@archiver.kernel.org>; Fri, 22 Feb 2019 02:51:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Kc29hitp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726318AbfBVCvX (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 21 Feb 2019 21:51:23 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:58742 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725869AbfBVCvX (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 21 Feb 2019 21:51:23 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x1M2nNDu007607;
        Fri, 22 Feb 2019 02:51:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2018-07-02;
 bh=EEHFAbiLOwsLyMMd+WQLEdd04j4914veZ/6J2sA/06E=;
 b=Kc29hitp9ohY1v2DLIA+uUTB8d8oyOwVsbqCk7YXkyTnSs8cGwKALessg6me0P7tiaJd
 Bcs9UX+6yOhQ88483ltt5cNBaHo+YEuD+Du1tBioLgiAdaQgluaM9TI8JXVdFZ1Z+0cP
 1jWq6iNPDJbvcxGwkmHP4ZQSv4zHQA/pDkwKz8yFZJN96qGn58utvYJscxb6hhTAEVak
 dI6xBaTucjEVWnwgnnG2kMT9HEp6dJwGrC2rs/NBfL4l4znTpETLEY24i8V33+bzmc1Z
 XVubS0DK4wrJhDHdYZxXfrzLNSuFDStPwilUEN5NfIXlEdD0Kce2/+j2E2cKJYI1q7Dk Lw== 
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2130.oracle.com with ESMTP id 2qp9xubxr8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Feb 2019 02:51:16 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x1M2pGqn001612
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Feb 2019 02:51:16 GMT
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x1M2pFrf017944;
        Fri, 22 Feb 2019 02:51:15 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 21 Feb 2019 18:51:15 -0800
To:     Keith Busch <keith.busch@intel.com>
Cc:     Ric Wheeler <ricwheeler@gmail.com>,
        Dave Chinner <david@fromorbit.com>,
        lsf-pc@lists.linux-foundation.org,
        linux-xfs <linux-xfs@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-ext4 <linux-ext4@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        linux-block@vger.kernel.org
Subject: Re: [LSF/MM TOPIC] More async operations for file systems - async discard?
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <92ab41f7-35bc-0f56-056f-ed88526b8ea4@gmail.com>
        <20190217210948.GB14116@dastard>
        <46540876-c222-0889-ddce-44815dcaad04@gmail.com>
        <20190220234723.GA5999@localhost.localdomain>
Date:   Thu, 21 Feb 2019 21:51:12 -0500
In-Reply-To: <20190220234723.GA5999@localhost.localdomain> (Keith Busch's
        message of "Wed, 20 Feb 2019 16:47:24 -0700")
Message-ID: <yq18sy8ili7.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9174 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=723 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1902220016
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org


Keith,

> With respect to fs block sizes, one thing making discards suck is that
> many high capacity SSDs' physical page sizes are larger than the fs
> block size, and a sub-page discard is worse than doing nothing.

That ties into the whole zeroing as a side-effect thing.

The devices really need to distinguish between discard-as-a-hint where
it is free to ignore anything that's not a whole multiple of whatever
the internal granularity is, and the WRITE ZEROES use case where the end
result needs to be deterministic.

-- 
Martin K. Petersen	Oracle Linux Engineering
