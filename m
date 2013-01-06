From: Guo Chao <yan@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/3] ext4: report error if things go wrong when do
 checksum
Date: Sun, 6 Jan 2013 10:37:14 +0800
Message-ID: <20130106023713.GA5497@yanx>
References: <1357371781-18194-1-git-send-email-yan@linux.vnet.ibm.com>
 <20130105195054.GL20106@blackbox.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:47278 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755120Ab3AFChY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 5 Jan 2013 21:37:24 -0500
Received: from /spool/local
	by e28smtp01.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <yan@linux.vnet.ibm.com>;
	Sun, 6 Jan 2013 08:06:07 +0530
Received: from d28relay05.in.ibm.com (d28relay05.in.ibm.com [9.184.220.62])
	by d28dlp02.in.ibm.com (Postfix) with ESMTP id F1B22394004C
	for <linux-ext4@vger.kernel.org>; Sun,  6 Jan 2013 08:07:17 +0530 (IST)
Received: from d28av03.in.ibm.com (d28av03.in.ibm.com [9.184.220.65])
	by d28relay05.in.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id r062bGbf40239316
	for <linux-ext4@vger.kernel.org>; Sun, 6 Jan 2013 08:07:16 +0530
Received: from d28av03.in.ibm.com (loopback [127.0.0.1])
	by d28av03.in.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id r062bH0X021081
	for <linux-ext4@vger.kernel.org>; Sun, 6 Jan 2013 13:37:17 +1100
Content-Disposition: inline
In-Reply-To: <20130105195054.GL20106@blackbox.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


Hello, Darrick,

On Sat, Jan 05, 2013 at 11:50:54AM -0800, Darrick J. Wong wrote:
> On Sat, Jan 05, 2013 at 03:42:59PM +0800, Guo Chao wrote:
> > In ext4_dx_csum_verify(), if we detect corrupted data,
> > we do not compare checksum because checksum itself may
> > be wrong, but we should report error in this case.
> > 
> > Cc: Darrick J. Wong <darrick.wong@oracle.com>
> > Signed-off-by: Guo Chao <yan@linux.vnet.ibm.com>
> > ---
> >  fs/ext4/namei.c |    4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> > index cac4482..843e29f 100644
> > --- a/fs/ext4/namei.c
> > +++ b/fs/ext4/namei.c
> > @@ -370,14 +370,14 @@ static int ext4_dx_csum_verify(struct inode *inode,
> >  	c = get_dx_countlimit(inode, dirent, &count_offset);
> >  	if (!c) {
> >  		EXT4_ERROR_INODE(inode, "dir seems corrupt?  Run e2fsck -D.");
> > -		return 1;
> > +		return 0;
> >  	}
> >  	limit = le16_to_cpu(c->limit);
> >  	count = le16_to_cpu(c->count);
> >  	if (count_offset + (limit * sizeof(struct dx_entry)) >
> >  	    EXT4_BLOCK_SIZE(inode->i_sb) - sizeof(struct dx_tail)) {
> >  		warn_no_space_for_csum(inode);
> > -		return 1;
> > +		return 0;
> 
> In both of these cases we cannot figure out where the dx block checksum lives,
> and therefore we have no stored checksum to compare against.  This can result
> from enabling checksums on a existing filesystem and ignoring tune2fs' request
> to run fsck -D to rebuild dx blocks that are completely full.  However, since
> we haven't a checksum that we could use to decide if there's real corruption,
> there's no cause to return -EIO to the user.  Therefore, we print a warning and
> trust the sanity checks to catch totally bogus blocks, which is the best we can
> hope for.
> 
> Sorry, but this doesn't seem necessary.

Thanks for the explaination. 

I think ext4_dirent_csum_verify() can encounter similar problem but return
error. But I'm not sure it's the same case.

Thanks,
Guo Chao

> --D
> >  	}
> >  	t = (struct dx_tail *)(((struct dx_entry *)c) + limit);
> >  
> > -- 
> > 1.7.9.5
> > 

