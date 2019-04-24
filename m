Return-Path: <SRS0=cG1U=S2=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CA4FC282CE
	for <linux-ext4@archiver.kernel.org>; Wed, 24 Apr 2019 14:58:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 775CE2089F
	for <linux-ext4@archiver.kernel.org>; Wed, 24 Apr 2019 14:58:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732733AbfDXO6c (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 24 Apr 2019 10:58:32 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:51194 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1733105AbfDXO6Y (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 24 Apr 2019 10:58:24 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x3OEsTwj123347
        for <linux-ext4@vger.kernel.org>; Wed, 24 Apr 2019 10:58:23 -0400
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2s2s1puyf9-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-ext4@vger.kernel.org>; Wed, 24 Apr 2019 10:58:23 -0400
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-ext4@vger.kernel.org> from <chandan@linux.ibm.com>;
        Wed, 24 Apr 2019 15:58:21 +0100
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 24 Apr 2019 15:58:16 +0100
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x3OEwFZG11206870
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Apr 2019 14:58:15 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8E3F34C058;
        Wed, 24 Apr 2019 14:58:15 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5EABB4C040;
        Wed, 24 Apr 2019 14:58:13 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.85.81.252])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 24 Apr 2019 14:58:13 +0000 (GMT)
From:   Chandan Rajendra <chandan@linux.ibm.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-fscrypt@vger.kernel.org, tytso@mit.edu,
        adilger.kernel@dilger.ca, ebiggers@kernel.org, jaegeuk@kernel.org,
        yuchao0@huawei.com
Subject: Re: [PATCH V1 02/14] Consolidate "post read processing" into a new file
Date:   Wed, 24 Apr 2019 20:29:10 +0530
Organization: IBM
In-Reply-To: <20190424142423.GA12761@infradead.org>
References: <20190424043730.13683-1-chandan@linux.ibm.com> <6353008.fQNhCuxumZ@localhost.localdomain> <20190424142423.GA12761@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-TM-AS-GCONF: 00
x-cbid: 19042414-0016-0000-0000-000002732725
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19042414-0017-0000-0000-000032CF99D4
Message-Id: <7402364.ucYHGh3o57@localhost.localdomain>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-04-24_09:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1904240116
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Wednesday, April 24, 2019 7:54:23 PM IST Christoph Hellwig wrote:
> On Wed, Apr 24, 2019 at 03:34:17PM +0530, Chandan Rajendra wrote:
> > To clarify, Are you suggesting that a new kconfig option (say
> > CONFIG_FS_READ_CALLBACKS) be provided to the user so that the following could
> > occur,
> > 
> > 1. User selects CONFIG_FS_ENCRYPTION and/or CONFIG_FS_VERITY and this causes
> > CONFIG_FS_READ_CALLBACKS to be set to 'y'.
> > 2. User selects CONFIG_FS_READ_CALLBACKS explicitly.
> 
> If you don't add a user description to a Kconfig entry it won't be
> visible to users, but only selectable by other options.  That is what
> I suggest.
> 
> 

Thanks for the clarification. I will make the necessary changes.

-- 
chandan



