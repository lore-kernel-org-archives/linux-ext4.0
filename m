Return-Path: <SRS0=DlHj=QT=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E66ADC282C4
	for <linux-ext4@archiver.kernel.org>; Tue, 12 Feb 2019 13:07:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BD669217D9
	for <linux-ext4@archiver.kernel.org>; Tue, 12 Feb 2019 13:07:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728145AbfBLNHM (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 12 Feb 2019 08:07:12 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:54936 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727312AbfBLNHM (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 12 Feb 2019 08:07:12 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x1CCwutb059467
        for <linux-ext4@vger.kernel.org>; Tue, 12 Feb 2019 08:07:10 -0500
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2qkwpwk3rc-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-ext4@vger.kernel.org>; Tue, 12 Feb 2019 08:07:10 -0500
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-ext4@vger.kernel.org> from <zohar@linux.ibm.com>;
        Tue, 12 Feb 2019 13:07:08 -0000
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 12 Feb 2019 13:07:05 -0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x1CD74KZ12910820
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 12 Feb 2019 13:07:04 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B89E511C050;
        Tue, 12 Feb 2019 13:07:04 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6620711C04A;
        Tue, 12 Feb 2019 13:07:03 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.80.91.85])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 12 Feb 2019 13:07:03 +0000 (GMT)
Subject: Re: Proposal: Yet another possible fs-verity interface
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     "Theodore Y. Ts'o" <tytso@mit.edu>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Eric Biggers <ebiggers@kernel.org>,
        linux-fscrypt@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        James Bottomley <James.Bottomley@HansenPartnership.com>
Date:   Tue, 12 Feb 2019 08:06:52 -0500
In-Reply-To: <20190212053123.GR23000@mit.edu>
References: <20190207031101.GA7387@mit.edu>
         <CAHk-=wh2j+Yy28H_QxEdsP=k9xcHxjCG1PqKAF2Uv=ckK8oPug@mail.gmail.com>
         <1549807615.12743.109.camel@linux.ibm.com> <20190212053123.GR23000@mit.edu>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.20.5 (3.20.5-1.fc24) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19021213-0008-0000-0000-000002BF89DA
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19021213-0009-0000-0000-0000222BA2E4
Message-Id: <1549976812.12743.225.camel@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-02-12_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1902120095
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Hi Ted,

The context for my comments/questions was Linus' suggestions, which
you've removed.

On Tue, 2019-02-12 at 00:31 -0500, Theodore Y. Ts'o wrote:
> On Sun, Feb 10, 2019 at 09:06:55AM -0500, Mimi Zohar wrote:
> > For which files will the Merkle tree be created?  Is this for all
> > files on a per file system basis?  Or is there some sort of "flag" or
> > policy?  The original design was based on an ioctl enabling/disabling
> > a flag. In this new design, is there still an ioctl?
> 
> So for our first use case, it will be used for "privileged APK files"
> in Android.  You can think of this as a "setuid binary", effectively.

Yes, I understand that your primary goal hasn't changed.  Linus was
suggesting "the interface be made idempotent" to support "filesystems
that don't actually have any long-term storage model for the merkle
tree.  IOW, you could do the merkle tree calculation (and
verification) every time at bootup".  In that context, I asked whether
the Merkle tree file hash would be for every file on the filesystem or
not, and how to identify those files.

> > The existing file hashes included in the measurement list and the
> > audit log, are currently being used for remote attestation, forensics
> > and security analytics.

Again, the context for this comment was Linus' suggestion "each level
of the merkle tree needs to have a hash seeding thing or whatever."
Up to this point, I had assumed the Merkle tree file root hash could
be used as an identifier, similar to the file hash.  With his
suggestion, it sounds like the Merkle tree file root hash would be
system dependent, making it useless for the above usages.

> 
> IMA has a very different set primary use cases than fsverity.

We need to differentiate between IMA's method of calculating the file
hash from the IMA measurement list.  I totally agree there is a place
for both methods of calculating the file hash.  I am hoping that we
would be able to use the Merkle tree file root hash in the IMA
measurement list.  It makes no sense to have to calculate the file
hash for the measurement list, if you're using fs-verity.

Mimi

