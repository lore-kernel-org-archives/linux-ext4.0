Return-Path: <SRS0=DlHj=QT=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC80FC282CE
	for <linux-ext4@archiver.kernel.org>; Tue, 12 Feb 2019 14:45:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A402A2083B
	for <linux-ext4@archiver.kernel.org>; Tue, 12 Feb 2019 14:45:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730194AbfBLOpC (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 12 Feb 2019 09:45:02 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:48450 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730018AbfBLOpB (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 12 Feb 2019 09:45:01 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x1CEhsQA061532
        for <linux-ext4@vger.kernel.org>; Tue, 12 Feb 2019 09:45:00 -0500
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2qkyk3sxx4-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-ext4@vger.kernel.org>; Tue, 12 Feb 2019 09:45:00 -0500
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-ext4@vger.kernel.org> from <zohar@linux.ibm.com>;
        Tue, 12 Feb 2019 14:44:57 -0000
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 12 Feb 2019 14:44:53 -0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x1CEiqOr43581624
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 12 Feb 2019 14:44:52 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 721184203F;
        Tue, 12 Feb 2019 14:44:52 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 026B942041;
        Tue, 12 Feb 2019 14:44:50 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.80.91.85])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 12 Feb 2019 14:44:49 +0000 (GMT)
Subject: Re: Proposal: Yet another possible fs-verity interface
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Eric Biggers <ebiggers@kernel.org>,
        linux-fscrypt@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Date:   Tue, 12 Feb 2019 09:44:39 -0500
In-Reply-To: <20190212051237.GQ23000@mit.edu>
References: <20190207031101.GA7387@mit.edu>
         <CAHk-=wh2j+Yy28H_QxEdsP=k9xcHxjCG1PqKAF2Uv=ckK8oPug@mail.gmail.com>
         <20190212051237.GQ23000@mit.edu>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.20.5 (3.20.5-1.fc24) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19021214-0028-0000-0000-00000347B03A
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19021214-0029-0000-0000-00002405D054
Message-Id: <1549982679.12743.248.camel@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-02-12_08:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1902120107
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

> At that point, the merkle tree thing ends up fairly equivalent to
the
> > IMA "measurement" thing, with the exception that the filesystem *may*
> > optimize it to be long-term. Hmm?
> 
> Well, except that it's just a less efficient way of doing IMA
> "measurement" (if the file system doesn't support Merkle tree
> storage).
> 
> So adding that complexity is, in my view, not really worth it, since I
> very much doubt anyone would use a slower scheme.  I think the much
> better model is that fsverity is for file system where you can store
> the Merkle tree (and it's really not that hard for most file systems
> to store it); and if you are using a file system which doesn't, use
> IMA in good health.

Ted, one of the problems with IMA is that the file hash/signature
verification is at file open.  It isn't aware when files are brought
in from cache.  Does fs-verity re-verify blocks as they're restored
from cache?  For some use cases, that might justify the up front cost
associated with building the Merkle tree.

Mimi

