Return-Path: <SRS0=OaGm=Q4=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23EC3C43381
	for <linux-ext4@archiver.kernel.org>; Thu, 21 Feb 2019 13:32:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F37062086A
	for <linux-ext4@archiver.kernel.org>; Thu, 21 Feb 2019 13:32:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727061AbfBUNcC (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 21 Feb 2019 08:32:02 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:35618 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726251AbfBUNcC (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 21 Feb 2019 08:32:02 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x1LDUQUw051409
        for <linux-ext4@vger.kernel.org>; Thu, 21 Feb 2019 08:32:00 -0500
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2qsum63rqs-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-ext4@vger.kernel.org>; Thu, 21 Feb 2019 08:32:00 -0500
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-ext4@vger.kernel.org> from <chandan@linux.ibm.com>;
        Thu, 21 Feb 2019 13:31:59 -0000
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 21 Feb 2019 13:31:56 -0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x1LDVtPv14221470
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 21 Feb 2019 13:31:55 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9F60F4203F;
        Thu, 21 Feb 2019 13:31:55 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D654E4204D;
        Thu, 21 Feb 2019 13:31:53 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.85.75.223])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 21 Feb 2019 13:31:53 +0000 (GMT)
From:   Chandan Rajendra <chandan@linux.ibm.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-fscrypt@vger.kernel.org, tytso@mit.edu,
        adilger.kernel@dilger.ca, jaegeuk@kernel.org
Subject: Re: [f2fs-dev] [RFC PATCH 05/10] fsverity: Add call back to decide if verity check has to be performed
Date:   Thu, 21 Feb 2019 18:24:52 +0530
Organization: IBM
In-Reply-To: <20190219232649.GF12177@gmail.com>
References: <20190218100433.20048-1-chandan@linux.ibm.com> <20190218100433.20048-6-chandan@linux.ibm.com> <20190219232649.GF12177@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-TM-AS-GCONF: 00
x-cbid: 19022113-0028-0000-0000-0000034B4F03
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19022113-0029-0000-0000-0000240993B2
Message-Id: <3323472.mdDe8xBITV@localhost.localdomain>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-02-21_08:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1902210099
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Wednesday, February 20, 2019 4:56:49 AM IST Eric Biggers wrote:
> Hi Chandan,
> 
> On Mon, Feb 18, 2019 at 03:34:28PM +0530, Chandan Rajendra wrote:
> > Ext4 and F2FS store verity metadata in data extents (beyond
> > inode->i_size) associated with a file. But other filesystems might
> > choose alternative means to store verity metadata. Hence this commit
> > adds a callback function pointer to 'struct fsverity_operations' to help
> > in deciding if verity operation needs to performed against a page-cache
> > page holding file data.
> > 
> > Signed-off-by: Chandan Rajendra <chandan@linux.ibm.com>
> > ---
> >  fs/ext4/super.c          | 9 +++++++++
> >  fs/post_read_process.c   | 5 +++--
> >  include/linux/fsverity.h | 1 +
> >  3 files changed, 13 insertions(+), 2 deletions(-)
> > 
> > diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> > index 9314dddfbf34..2d7781ab6824 100644
> > --- a/fs/ext4/super.c
> > +++ b/fs/ext4/super.c
> > @@ -1428,10 +1428,19 @@ static struct page *ext4_read_verity_metadata_page(struct inode *inode,
> >  	return read_mapping_page(inode->i_mapping, index, NULL);
> >  }
> >  
> > +static bool ext4_verity_required(struct inode *inode, pgoff_t index)
> > +{
> > +	if (index < ((i_size_read(inode) + PAGE_SIZE - 1) >> PAGE_SHIFT))
> > +		return true;
> > +	else
> > +		return false;
> > +}
> 
> This can be simplified to:
> 
> 	return index < (i_size_read(inode) + PAGE_SIZE - 1) >> PAGE_SHIFT;
>

You are right.

> > +
> >  static const struct fsverity_operations ext4_verityops = {
> >  	.set_verity		= ext4_set_verity,
> >  	.get_metadata_end	= ext4_get_verity_metadata_end,
> >  	.read_metadata_page	= ext4_read_verity_metadata_page,
> > +	.verity_required	= ext4_verity_required,
> >  };
> >  #endif /* CONFIG_FS_VERITY */
> 
> Doesn't f2fs need this too?  This patch only changes ext4.

Yes, My plan was to get review comments about the current approach and then
make corresponding changes in F2FS.

> 
> >  
> > diff --git a/fs/post_read_process.c b/fs/post_read_process.c
> > index 9720eeff0160..1f8663d70247 100644
> > --- a/fs/post_read_process.c
> > +++ b/fs/post_read_process.c
> > @@ -79,8 +79,9 @@ struct bio_post_read_ctx *get_bio_post_read_ctx(struct inode *inode,
> >  	if (IS_ENCRYPTED(inode) && S_ISREG(inode->i_mode))
> >  		post_read_steps |= 1 << STEP_DECRYPT;
> >  #ifdef CONFIG_FS_VERITY
> > -	if (inode->i_verity_info != NULL &&
> > -		(index < ((i_size_read(inode) + PAGE_SIZE - 1) >> PAGE_SHIFT)))
> > +	if (inode->i_verity_info != NULL
> > +		&& inode->i_sb->s_vop->verity_required
> > +		&& inode->i_sb->s_vop->verity_required(inode, index))
> >  		post_read_steps |= 1 << STEP_VERITY;
> 
> If ->verity_required is NULL, shouldn't that be equivalent to
> ->verity_required() returning true?
>

Yes, you are right about that. I will fix it in the next iteration of the
patchset.

> >  #endif
> >  	if (post_read_steps) {
> > diff --git a/include/linux/fsverity.h b/include/linux/fsverity.h
> > index 7c33b42abf1b..b83712d6c79a 100644
> > --- a/include/linux/fsverity.h
> > +++ b/include/linux/fsverity.h
> > @@ -18,6 +18,7 @@ struct fsverity_operations {
> >  	int (*set_verity)(struct inode *inode, loff_t data_i_size);
> >  	int (*get_metadata_end)(struct inode *inode, loff_t *metadata_end_ret);
> >  	struct page *(*read_metadata_page)(struct inode *inode, pgoff_t index);
> > +	bool (*verity_required)(struct inode *inode, pgoff_t index);
> >  };
> >  
> >  #ifdef CONFIG_FS_VERITY
> 
> - Eric
> 
> 


-- 
chandan



