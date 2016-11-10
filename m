From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Subject: Re: [PATCH] ext4: ext4_mb_seq_groups_show: Fix stack memory corruption
Date: Thu, 10 Nov 2016 11:14:17 +0530
Message-ID: <6088605.ZfrVhX6KQh@localhost.localdomain>
References: <1478501141-15651-1-git-send-email-chandan@linux.vnet.ibm.com> <20161108092115.GG32353@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, adilger@dilger.ca
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:58285 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751120AbcKJFoi (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 10 Nov 2016 00:44:38 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id uAA5hcfs124734
        for <linux-ext4@vger.kernel.org>; Thu, 10 Nov 2016 00:44:37 -0500
Received: from e23smtp01.au.ibm.com (e23smtp01.au.ibm.com [202.81.31.143])
        by mx0a-001b2d01.pphosted.com with ESMTP id 26mfb9fdwk-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-ext4@vger.kernel.org>; Thu, 10 Nov 2016 00:44:37 -0500
Received: from localhost
        by e23smtp01.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-ext4@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Thu, 10 Nov 2016 15:44:33 +1000
Received: from d23relay06.au.ibm.com (d23relay06.au.ibm.com [9.185.63.219])
        by d23dlp03.au.ibm.com (Postfix) with ESMTP id 7C0E53578058
        for <linux-ext4@vger.kernel.org>; Thu, 10 Nov 2016 16:44:30 +1100 (EST)
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.234.97])
        by d23relay06.au.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id uAA5iUZr31981776
        for <linux-ext4@vger.kernel.org>; Thu, 10 Nov 2016 16:44:30 +1100
Received: from d23av03.au.ibm.com (localhost [127.0.0.1])
        by d23av03.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id uAA5iTVk028708
        for <linux-ext4@vger.kernel.org>; Thu, 10 Nov 2016 16:44:30 +1100
In-Reply-To: <20161108092115.GG32353@quack2.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tuesday, November 08, 2016 10:21:15 AM Jan Kara wrote:
> On Mon 07-11-16 12:15:41, Chandan Rajendra wrote:
> > The number of 'counters' elements needed in 'struct sg' is
> > super_block->s_blocksize_bits + 2. Presently we have 16 'counters'
> > elements in the array. This is insufficient for block sizes >= 32k. In
> > such cases the memcpy operation performed in ext4_mb_seq_groups_show()
> > would cause stack memory corruption.
> > 
> > Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
> > ---
> >  fs/ext4/mballoc.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> > index a937ac7..67e6fcb 100644
> > --- a/fs/ext4/mballoc.c
> > +++ b/fs/ext4/mballoc.c
> > @@ -2287,7 +2287,7 @@ static int ext4_mb_seq_groups_show(struct seq_file *seq, void *v)
> >  	struct ext4_group_info *grinfo;
> >  	struct sg {
> >  		struct ext4_group_info info;
> > -		ext4_grpblk_t counters[16];
> > +		ext4_grpblk_t counters[16 + 2];
> 
> How about using EXT4_MAX_BLOCK_LOG_SIZE + 2? It would be somewhat clearer
> what that means...  Having a function returning number of buddy counters in
> a group info would be even better (and a constant for maximum number of
> counters) but that's an independent cleanup...

Sorry about the late reply. I will send out V2 with the fix. Also, I will work
on the cleanup patch and send it out soon.

-- 
chandan

