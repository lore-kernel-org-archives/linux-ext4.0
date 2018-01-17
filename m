From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH 8/8] ext4: enable encryption for blocksize less than page size
Date: Wed, 17 Jan 2018 19:12:46 +0530
Message-ID: <4623372.lWF4DCE0j7@localhost.localdomain>
References: <20180112141129.27507-1-chandan@linux.vnet.ibm.com> <20180112141129.27507-9-chandan@linux.vnet.ibm.com> <20180117024004.GH4477@zzz.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        tytso@mit.edu
To: Eric Biggers <ebiggers3@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:55888 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752100AbeAQNle (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 17 Jan 2018 08:41:34 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id w0HDekkW060910
        for <linux-ext4@vger.kernel.org>; Wed, 17 Jan 2018 08:41:33 -0500
Received: from e06smtp15.uk.ibm.com (e06smtp15.uk.ibm.com [195.75.94.111])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2fj5xrd5ak-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-ext4@vger.kernel.org>; Wed, 17 Jan 2018 08:41:33 -0500
Received: from localhost
        by e06smtp15.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-ext4@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Wed, 17 Jan 2018 13:41:31 -0000
In-Reply-To: <20180117024004.GH4477@zzz.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wednesday, January 17, 2018 8:10:04 AM IST Eric Biggers wrote:
> On Fri, Jan 12, 2018 at 07:41:29PM +0530, Chandan Rajendra wrote:
> > Now that we have all the code to support encryption for block size less
> > than page size scenario, this commit removes the conditional check in
> > filesystem mount code.
> > 
> > Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
> > ---
> >  fs/ext4/super.c | 9 +--------
> >  1 file changed, 1 insertion(+), 8 deletions(-)
> > 
> > diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> > index ebb7edb..5a52c98 100644
> > --- a/fs/ext4/super.c
> > +++ b/fs/ext4/super.c
> > @@ -4138,14 +4138,7 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
> >  		}
> >  	}
> >  
> > -	if ((DUMMY_ENCRYPTION_ENABLED(sbi) || ext4_has_feature_encrypt(sb)) &&
> > -	    (blocksize != PAGE_SIZE)) {
> > -		ext4_msg(sb, KERN_ERR,
> > -			 "Unsupported blocksize for fs encryption");
> > -		goto failed_mount_wq;
> > -	}
> > -
> > -	if (DUMMY_ENCRYPTION_ENABLED(sbi) && !sb_rdonly(sb) &&
> > +	if (DUMMY_ENCRYPTION_ENABLED(sbi) && !(sb->s_flags & MS_RDONLY) &&
> >  	    !ext4_has_feature_encrypt(sb)) {
> >  		ext4_set_feature_encrypt(sb);
> >  		ext4_commit_super(sb, 1);
> 
> Why change sb_rdonly() to 'sb->s_flags & MS_RDONLY'?
> 

I am sorry, I messed up this one when rebasing the patchset onto the 
latest linux-next. . The old code base had 'sb->s_flags & MS_RDONLY'.
I will fix this up in the next version of this patchset.

-- 
chandan
