From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [PATCH 03/28] ext4: ext4_mkdir should dirty dir_block with the
	parent inode
Date: Fri, 21 Oct 2011 14:15:21 -0700
Message-ID: <20111021211521.GT12447@tux1.beaverton.ibm.com>
References: <20111008075343.20506.23155.stgit@elm3c44.beaverton.ibm.com> <20111008075403.20506.36338.stgit@elm3c44.beaverton.ibm.com> <4E9CFC83.5010905@tao.ma>
Reply-To: djwong@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	Theodore Tso <tytso@mit.edu>, Mingming Cao <cmm@us.ibm.com>,
	linux-ext4@vger.kernel.org
To: Tao Ma <tm@tao.ma>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:39945 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752481Ab1JUVP2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 21 Oct 2011 17:15:28 -0400
Received: from /spool/local
	by e6.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <djwong@us.ibm.com>;
	Fri, 21 Oct 2011 17:15:27 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p9LLFORs259604
	for <linux-ext4@vger.kernel.org>; Fri, 21 Oct 2011 17:15:24 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p9LLFMTL025484
	for <linux-ext4@vger.kernel.org>; Fri, 21 Oct 2011 17:15:23 -0400
Content-Disposition: inline
In-Reply-To: <4E9CFC83.5010905@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Oct 18, 2011 at 12:11:47PM +0800, Tao Ma wrote:
> Hi Darrick,
> On 10/08/2011 03:54 PM, Darrick J. Wong wrote:
> > ext4_mkdir calls ext4_handle_dirty_metadata with dir_block and the inode "dir".
> > Unfortunately, dir_block belongs to the newly created directory (which is
> > "inode"), not the parent directory (which is "dir").  Fix the incorrect
> > association.
> could you please re-send this patch and other fixes that isn't related
> to metadata checksum? I need this when implementing inlined dir, and I
> guess this can be merged in this merge window.

Just FYI it's patches 1-5 of this patchset, but I'm happy to resend.

--D
> 
> Thanks
> Tao
> > 
> > Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
> > ---
> >  fs/ext4/namei.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > 
> > diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> > index 6d3fab4..50c7294 100644
> > --- a/fs/ext4/namei.c
> > +++ b/fs/ext4/namei.c
> > @@ -1863,7 +1863,7 @@ retry:
> >  	ext4_set_de_type(dir->i_sb, de, S_IFDIR);
> >  	inode->i_nlink = 2;
> >  	BUFFER_TRACE(dir_block, "call ext4_handle_dirty_metadata");
> > -	err = ext4_handle_dirty_metadata(handle, dir, dir_block);
> > +	err = ext4_handle_dirty_metadata(handle, inode, dir_block);
> >  	if (err)
> >  		goto out_clear_inode;
> >  	err = ext4_mark_inode_dirty(handle, inode);
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

