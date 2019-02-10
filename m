Return-Path: <SRS0=BtLx=QR=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 615C8C4151A
	for <linux-ext4@archiver.kernel.org>; Sun, 10 Feb 2019 14:07:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3AE2121773
	for <linux-ext4@archiver.kernel.org>; Sun, 10 Feb 2019 14:07:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726158AbfBJOHQ (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sun, 10 Feb 2019 09:07:16 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:41986 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726130AbfBJOHQ (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 10 Feb 2019 09:07:16 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x1AE3Y5S017327
        for <linux-ext4@vger.kernel.org>; Sun, 10 Feb 2019 09:07:15 -0500
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2qjcnbh0rm-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-ext4@vger.kernel.org>; Sun, 10 Feb 2019 09:07:15 -0500
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-ext4@vger.kernel.org> from <zohar@linux.ibm.com>;
        Sun, 10 Feb 2019 14:07:12 -0000
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Sun, 10 Feb 2019 14:07:08 -0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x1AE77rs55967756
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 10 Feb 2019 14:07:07 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 580AF52050;
        Sun, 10 Feb 2019 14:07:07 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.80.91.85])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 0D27C52052;
        Sun, 10 Feb 2019 14:07:05 +0000 (GMT)
Subject: Re: Proposal: Yet another possible fs-verity interface
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        "Theodore Y. Ts'o" <tytso@mit.edu>
Cc:     Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Eric Biggers <ebiggers@kernel.org>,
        linux-fscrypt@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        James Bottomley <James.Bottomley@HansenPartnership.com>
Date:   Sun, 10 Feb 2019 09:06:55 -0500
In-Reply-To: <CAHk-=wh2j+Yy28H_QxEdsP=k9xcHxjCG1PqKAF2Uv=ckK8oPug@mail.gmail.com>
References: <20190207031101.GA7387@mit.edu>
         <CAHk-=wh2j+Yy28H_QxEdsP=k9xcHxjCG1PqKAF2Uv=ckK8oPug@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.20.5 (3.20.5-1.fc24) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19021014-0028-0000-0000-00000346D218
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19021014-0029-0000-0000-00002404EA8F
Message-Id: <1549807615.12743.109.camel@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-02-10_14:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1902100109
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Sat, 2019-02-09 at 12:38 -0800, Linus Torvalds wrote:
> On Thu, Feb 7, 2019 at 8:10 AM Theodore Y. Ts'o <tytso@mit.edu> wrote:
> >
> > After doing a lot of thinking and conferring with the other fs-verity
> > developers, our current thinking is to simply move the Merkle tree
> > creation into the kernel.  The upside of doing this is it completely
> > bypasses all of the complaints about how to transfer the Merkle tree
> > from userspace to the kernel.
> 
> This sounds very sane to me.

One of the more interesting use cases for fs-verity, at least to me,
was remote file systems.  Hopefully support for remote file systems
will be included in the new design.

> 
> In particular, may I suggest that  the interface be made idempotent,
> so that you can do the merkle tree operation several times with the
> same offset/length arguments, and if the merkle tree has already been
> calculated, you just return the resulting root hash directly.
> 
> Why? That allows you to "validate" images on filesystems that don't
> actually have any long-term storage model for the merkle tree. IOW,
> you could do the merkle tree calculation (and verification) every time
> at bootup, and on a filesystem that supports the long-term storage of
> said merkle data, it's a very cheap operation, but on a filesystem
> that doesn't, it would still be *possible* to just calculate the hash
> and mark it "finalized" for that boot (or that mount). IOW, it would
> work for something like ramfs (but you could also make it work for any
> random on-disk filesystem that doesn't support long-term storage).

For which files will the Merkle tree be created?  Is this for all
files on a per file system basis?  Or is there some sort of "flag" or
policy?  The original design was based on an ioctl enabling/disabling
a flag.  In this new design, is there still an ioctl?

> 
> At that point, the merkle tree thing ends up fairly equivalent to the
> IMA "measurement" thing, with the exception that the filesystem *may*
> optimize it to be long-term. Hmm?

Wouldn't fs-verity then be similar to IMA-appraisal?  Instead of
verifying the file hash, fs-verity verifies the Merkle tree file root
hash.  The file "measurement", in this case the Merkle tree file root
hash, could be used to extend the TPM and added to a measurement list
or in TCG terminology an event log.

> 
> Now, since I assume that only the merkle tree root hash would be
> returned by the "enable merkle tree" operation (so that the code
> enabling it can verify that the hash matches the expected value), you
> do have to worry about the preimage attack, and make sure that you
> can't fool the hashing by making the (bad) file contents themselves be
> just the hashes of the (good) blocks. So each level of the merkle tree
> needs to have a hash seeding thing or whatever.

Agreed, but wouldn't the Merkle tree file root hash then be system
specific?

The existing file hashes included in the measurement list and the
audit log, are currently being used for remote attestation, forensics
and security analytics.

Mimi

