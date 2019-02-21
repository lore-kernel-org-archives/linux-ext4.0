Return-Path: <SRS0=OaGm=Q4=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28414C43381
	for <linux-ext4@archiver.kernel.org>; Thu, 21 Feb 2019 13:32:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EA8DD2084F
	for <linux-ext4@archiver.kernel.org>; Thu, 21 Feb 2019 13:32:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728022AbfBUNc2 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 21 Feb 2019 08:32:28 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:33120 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725385AbfBUNc1 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 21 Feb 2019 08:32:27 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x1LDTnCq008339
        for <linux-ext4@vger.kernel.org>; Thu, 21 Feb 2019 08:32:27 -0500
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2qsupvkkf1-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-ext4@vger.kernel.org>; Thu, 21 Feb 2019 08:32:26 -0500
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-ext4@vger.kernel.org> from <chandan@linux.ibm.com>;
        Thu, 21 Feb 2019 13:32:24 -0000
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 21 Feb 2019 13:32:20 -0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x1LDWJS521823738
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 21 Feb 2019 13:32:19 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5B9244204F;
        Thu, 21 Feb 2019 13:32:19 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B12C742054;
        Thu, 21 Feb 2019 13:32:17 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.85.75.223])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 21 Feb 2019 13:32:17 +0000 (GMT)
From:   Chandan Rajendra <chandan@linux.ibm.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-fscrypt@vger.kernel.org, tytso@mit.edu,
        adilger.kernel@dilger.ca, jaegeuk@kernel.org
Subject: Re: [f2fs-dev] [RFC PATCH 06/10] Introduce REQ_POST_READ_PROC bio flag
Date:   Thu, 21 Feb 2019 18:33:24 +0530
Organization: IBM
In-Reply-To: <20190220002059.GG12177@gmail.com>
References: <20190218100433.20048-1-chandan@linux.ibm.com> <20190218100433.20048-7-chandan@linux.ibm.com> <20190220002059.GG12177@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-TM-AS-GCONF: 00
x-cbid: 19022113-0016-0000-0000-000002593138
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19022113-0017-0000-0000-000032B38159
Message-Id: <8936377.epoSEyofgi@localhost.localdomain>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-02-21_08:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=5 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1902210099
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Wednesday, February 20, 2019 5:51:00 AM IST Eric Biggers wrote:
> Hi Chandan,
> 
> On Mon, Feb 18, 2019 at 03:34:29PM +0530, Chandan Rajendra wrote:
> > Ext4 and F2FS currently use a non-NULL value stored at bio->bi_private
> > to determine if the contents of the bio need to be "post processed"
> > i.e. whether its contents need to be decrypted and/or verified. For
> > block size < page size scenario, bio->bi_private would hold a pointer to
> > buffer_head. Hence, this commit adds the new flag REQ_POST_READ_PROC to
> > be able to decisively check for post process requirement for a bio.
> > 
> > Signed-off-by: Chandan Rajendra <chandan@linux.ibm.com>
> > ---
> >  fs/ext4/readpage.c        | 11 +++++++++--
> >  fs/post_read_process.c    |  2 +-
> >  include/linux/blk_types.h |  2 ++
> >  3 files changed, 12 insertions(+), 3 deletions(-)
> > 
> > diff --git a/fs/ext4/readpage.c b/fs/ext4/readpage.c
> > index 8943fc41fd33..c7dbab35deaa 100644
> > --- a/fs/ext4/readpage.c
> > +++ b/fs/ext4/readpage.c
> > @@ -245,6 +245,7 @@ int ext4_mpage_readpages(struct address_space *mapping,
> >  		}
> >  		if (bio == NULL) {
> >  			struct bio_post_read_ctx *ctx;
> > +			unsigned int op_flags = 0;
> >  
> >  			bio = bio_alloc(GFP_KERNEL,
> >  				min_t(int, nr_pages, BIO_MAX_PAGES));
> > @@ -259,8 +260,14 @@ int ext4_mpage_readpages(struct address_space *mapping,
> >  			bio->bi_iter.bi_sector = blocks[0] << (blkbits - 9);
> >  			bio->bi_end_io = mpage_end_io;
> >  			bio->bi_private = ctx;
> > -			bio_set_op_attrs(bio, REQ_OP_READ,
> > -						is_readahead ? REQ_RAHEAD : 0);
> > +
> > +			if (is_readahead)
> > +				op_flags |= REQ_RAHEAD;
> > +
> > +			if (ctx)
> > +				op_flags |= REQ_POST_READ_PROC;
> > +
> > +			bio_set_op_attrs(bio, REQ_OP_READ, op_flags);
> >  		}
> >  
> >  		length = first_hole << blkbits;
> > diff --git a/fs/post_read_process.c b/fs/post_read_process.c
> > index 1f8663d70247..66c1c6e57e70 100644
> > --- a/fs/post_read_process.c
> > +++ b/fs/post_read_process.c
> > @@ -104,7 +104,7 @@ void put_bio_post_read_ctx(struct bio_post_read_ctx *ctx)
> >  
> >  bool bio_post_read_required(struct bio *bio)
> >  {
> > -	return bio->bi_private && !bio->bi_status;
> > +	return bio->bi_opf & REQ_POST_READ_PROC;
> >  }
> >  
> >  static int __init bio_init_post_read_processing(void)
> > diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
> > index 5c7e7f859a24..6904945c8c40 100644
> > --- a/include/linux/blk_types.h
> > +++ b/include/linux/blk_types.h
> > @@ -320,6 +320,7 @@ enum req_flag_bits {
> >  	__REQ_RAHEAD,		/* read ahead, can fail anytime */
> >  	__REQ_BACKGROUND,	/* background IO */
> >  	__REQ_NOWAIT,           /* Don't wait if request will block */
> > +	__REQ_POST_READ_PROC,
> >  
> >  	/* command specific flags for REQ_OP_WRITE_ZEROES: */
> >  	__REQ_NOUNMAP,		/* do not free blocks when zeroing */
> > @@ -346,6 +347,7 @@ enum req_flag_bits {
> >  #define REQ_RAHEAD		(1ULL << __REQ_RAHEAD)
> >  #define REQ_BACKGROUND		(1ULL << __REQ_BACKGROUND)
> >  #define REQ_NOWAIT		(1ULL << __REQ_NOWAIT)
> > +#define REQ_POST_READ_PROC	(1ULL << __REQ_POST_READ_PROC)
> >  #define REQ_NOUNMAP		(1ULL << __REQ_NOUNMAP)
> >  #define REQ_HIPRI		(1ULL << __REQ_HIPRI)
> >  
> 
> I don't think this is an appropriate use of a request flag, as request flags are
> meant for the block layer.
> 
> Also doesn't the bio still need a pointer to the bio_post_read_ctx anyway?  So I
> don't see how this would solve the problem, if ->bi_private is already used.

I had glanced across block_read_full_page() function which implements reading
non-contiguous blocks mapped by the page in block size < page size
scenario. Here bio->bi_private would point to the buffer head that represents
the block on which read I/O was performed. In such a case,
bio_post_read_required() would always return true. Hence I decided to add this
request flag.

Now, I believe we can actually save away the ctx pointer in bh->b_private
member and later decide on whether the buffer head requires post processing
based on bh->bi_private's non-NULL value. I will have to read up the code more
thoroughly to confirm this.

-- 
chandan



