From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [EXT4 set 9][PATCH 5/5]Extent micro cleanups
Date: Wed, 11 Jul 2007 17:29:35 -0400
Message-ID: <1184189375.3886.31.camel@localhost.localdomain>
References: <1183275539.4010.141.camel@localhost.localdomain>
	 <20070710232008.599b25aa.akpm@linux-foundation.org>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:39294 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964900AbXGLA3f (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 11 Jul 2007 20:29:35 -0400
In-Reply-To: <20070710232008.599b25aa.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, 2007-07-10 at 23:20 -0700, Andrew Morton wrote:
> On Sun, 01 Jul 2007 03:38:59 -0400 Mingming Cao <cmm@us.ibm.com> wrote:
> 
> > From: Dmitry Monakhov <dmonakhov@sw.ru>
> > Subject: ext4: extent macros cleanup
> > 
> > - Replace math equation to it's macro equivalent
> 
> s/it's/its/;)
Okay.

> 
> > - make ext4_ext_grow_indepth() indexes/leaf correct
> 
> hm, what was wrong with it?
> 
Looking at the code, ext4_ext_ext_grow_indepth() implements tree growing
procedure. It allocates a new index block, moves the top-level data of
the tree(root or leaf blocks in i_data) into the new block, initializes
the new root, creating index that points to the just created index block

The original top-level data (in i_data) could be extent tree root (index
block) or extents (leaf block). The current code (without the patch)
treats the top-level data always be the leaf block, which is incorrect.


assumes when the tree is growing the extent structure pass in is always
> > @@ -922,8 +922,11 @@ static int ext4_ext_grow_indepth(handle_t *handle, struct inode *inode,
> >  	curp->p_hdr->eh_max = cpu_to_le16(ext4_ext_space_root_idx(inode));
> >  	curp->p_hdr->eh_entries = cpu_to_le16(1);
> >  	curp->p_idx = EXT_FIRST_INDEX(curp->p_hdr);
> > -	/* FIXME: it works, but actually path[0] can be index */
> > -	curp->p_idx->ei_block = EXT_FIRST_EXTENT(path[0].p_hdr)->ee_block;
> > +	
> > +	if (path[0].p_hdr->eh_depth)
> > +	  curp->p_idx->ei_block = EXT_FIRST_INDEX(path[0].p_hdr)->ei_block;
> > +	else
> > +	  curp->p_idx->ei_block = EXT_FIRST_EXTENT(path[0].p_hdr)->ee_block;
> 
> whitespace bustage there.
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
