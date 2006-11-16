From: Badari Pulavarty <pbadari@us.ibm.com>
Subject: Re: [patch 15/23] ext3 -nobh option causes oops
Date: Thu, 16 Nov 2006 15:07:54 -0800
Message-ID: <1163718474.7662.26.camel@dyn9047017100.beaverton.ibm.com>
References: <20060804053258.391158155@quad.kroah.org>
	 <20060804054003.GP769@kroah.com>  <20061116225154.GK31879@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:60058 "EHLO
	e34.co.us.ibm.com") by vger.kernel.org with ESMTP id S1755486AbWKPXHg
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 16 Nov 2006 18:07:36 -0500
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e34.co.us.ibm.com (8.13.8/8.12.11) with ESMTP id kAGN7ae5020459
	for <linux-ext4@vger.kernel.org>; Thu, 16 Nov 2006 18:07:36 -0500
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay04.boulder.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id kAGN7Zv2268248
	for <linux-ext4@vger.kernel.org>; Thu, 16 Nov 2006 16:07:36 -0700
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id kAGN7Z8w007474
	for <linux-ext4@vger.kernel.org>; Thu, 16 Nov 2006 16:07:35 -0700
To: Adrian Bunk <bunk@stusta.de>
In-Reply-To: <20061116225154.GK31879@stusta.de>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


On Thu, 2006-11-16 at 23:51 +0100, Adrian Bunk wrote:
> It seems this patch that went into 2.6.17.8 should also be included in 
> the 2.6.16.x branch, or do I miss anything?
> 

Yes. This is needed for 2.6.16.x branch also.

Thanks,
Badari


> On Thu, Aug 03, 2006 at 10:40:03PM -0700, Greg KH wrote:
> > -stable review patch.  If anyone has any objections, please let us know.
> > 
> > ------------------
> > From: Badari Pulavarty <pbadari@us.ibm.com>
> > 
> > For files other than IFREG, nobh option doesn't make sense.  Modifications
> > to them are journalled and needs buffer heads to do that.  Without this
> > patch, we get kernel oops in page_buffers().
> > 
> > Signed-off-by: Badari Pulavarty <pbadari@us.ibm.com>
> > Signed-off-by: Andrew Morton <akpm@osdl.org>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> > 
> > ---
> >  fs/ext3/inode.c |    6 +++---
> >  1 file changed, 3 insertions(+), 3 deletions(-)
> > 
> > --- linux-2.6.17.7.orig/fs/ext3/inode.c
> > +++ linux-2.6.17.7/fs/ext3/inode.c
> > @@ -1159,7 +1159,7 @@ retry:
> >  		ret = PTR_ERR(handle);
> >  		goto out;
> >  	}
> > -	if (test_opt(inode->i_sb, NOBH))
> > +	if (test_opt(inode->i_sb, NOBH) && ext3_should_writeback_data(inode))
> >  		ret = nobh_prepare_write(page, from, to, ext3_get_block);
> >  	else
> >  		ret = block_prepare_write(page, from, to, ext3_get_block);
> > @@ -1245,7 +1245,7 @@ static int ext3_writeback_commit_write(s
> >  	if (new_i_size > EXT3_I(inode)->i_disksize)
> >  		EXT3_I(inode)->i_disksize = new_i_size;
> >  
> > -	if (test_opt(inode->i_sb, NOBH))
> > +	if (test_opt(inode->i_sb, NOBH) && ext3_should_writeback_data(inode))
> >  		ret = nobh_commit_write(file, page, from, to);
> >  	else
> >  		ret = generic_commit_write(file, page, from, to);
> > @@ -1495,7 +1495,7 @@ static int ext3_writeback_writepage(stru
> >  		goto out_fail;
> >  	}
> >  
> > -	if (test_opt(inode->i_sb, NOBH))
> > +	if (test_opt(inode->i_sb, NOBH) && ext3_should_writeback_data(inode))
> >  		ret = nobh_writepage(page, ext3_get_block, wbc);
> >  	else
> >  		ret = block_write_full_page(page, ext3_get_block, wbc);
> > 
