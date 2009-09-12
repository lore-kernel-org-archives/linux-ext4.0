From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: ext4: Can we talk about bforget() and metadata blocks
Date: Sat, 12 Sep 2009 20:30:36 +0530
Message-ID: <20090912150036.GA13906@skywalker.linux.vnet.ibm.com>
References: <6601abe90909091029s74465ebave932987e5fdf93ba@mail.gmail.com>
 <20090909225429.GB24951@mit.edu>
 <6601abe90909091707s1df9e71bvb4551772dc4917cb@mail.gmail.com>
 <20090910013540.GF24951@mit.edu>
 <20090910065401.GB8690@skywalker.linux.vnet.ibm.com>
 <6601abe90909100846x3f7f491cnabc1474056155767@mail.gmail.com>
 <20090910162435.GA5321@skywalker.linux.vnet.ibm.com>
 <20090910185826.GC23700@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Curt Wohlgemuth <curtw@google.com>, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:54999 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754194AbZILPAr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 12 Sep 2009 11:00:47 -0400
Received: from d23relay01.au.ibm.com (d23relay01.au.ibm.com [202.81.31.243])
	by e23smtp02.au.ibm.com (8.14.3/8.13.1) with ESMTP id n8CEwZtS016554
	for <linux-ext4@vger.kernel.org>; Sun, 13 Sep 2009 00:58:35 +1000
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by d23relay01.au.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id n8CF0m18397608
	for <linux-ext4@vger.kernel.org>; Sun, 13 Sep 2009 01:00:49 +1000
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n8CF0mdc015737
	for <linux-ext4@vger.kernel.org>; Sun, 13 Sep 2009 01:00:48 +1000
Content-Disposition: inline
In-Reply-To: <20090910185826.GC23700@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Sep 10, 2009 at 02:58:26PM -0400, Theodore Tso wrote:
> On Thu, Sep 10, 2009 at 09:54:35PM +0530, Aneesh Kumar K.V wrote:
> > 
> > But how would it work for fsync ? I mean 
> > 
> > I would expect for no journal mode ext4_sync_file  should be doing
> > simple_fsync(). That should be forcing the metadata buffer_heads
> > via sync_mapping_buffers. And if we reuse these meta buffers we
> > drop them the inode->mapping->private_list using bforget.
> > 
> > But I don't see any of the above in code
> 
> Aneesh, you're addressing a different problem than the one that Curt
> were trying to deal with this patch.  The problem we are worry about
> is one where an inode's extent tree or indirect blocks are modified
> right before the inode is deleted, and then one or more of those
> metadata blocks get reallocated and written right away (most likely
> this will happen via an O_DIRECT write), and then, because we didn't
> use bforget(), the dirty metadata block in the buffer cache would get
> written out, overwriting the O_DIRECT block.
> 
> What you're worrying about, is a different issue.  You're concerned
> about the fact that since we are not associating an inode's extent
> tree or indirect blocks with the inode, those blocks won't get forced
> out to disk on an fsync() in ext4 no-journal mode.  This may not be a
> big deal for applications which expect to recover from an unclean
> using mke2fs (and thus probably don't use fsync in any case), but
> here's a patch to deal with the problem you've raised.
> 
>        	       	       	    		       - Ted
> 
> commit 417cf58253fbf3e36df7b3aca11c120e8367f5e6
> Author: Theodore Ts'o <tytso@mit.edu>
> Date:   Thu Sep 10 14:58:02 2009 -0400
> 
>     ext4: Assure that metadata blocks are written during fsync in no journal mode
>     
>     When there is no journal present, we must attach buffer heads
>     associated with extent tree and indirect blocks to the inode's
>     mapping->private_list so that fsync() will write out the inode's
>     metadata blocks.  This is done via mark_buffer_dirty_inode().
>     
>     Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> 
> diff --git a/fs/ext4/ext4_jbd2.c b/fs/ext4/ext4_jbd2.c
> index ecb9ca4..6a94099 100644
> --- a/fs/ext4/ext4_jbd2.c
> +++ b/fs/ext4/ext4_jbd2.c
> @@ -89,7 +89,10 @@ int __ext4_handle_dirty_metadata(const char *where, handle_t *handle,
>  			ext4_journal_abort_handle(where, __func__, bh,
>  						  handle, err);
>  	} else {
> -		mark_buffer_dirty(bh);
> +		if (inode && bh)
> +			mark_buffer_dirty_inode(bh, inode);
> +		else
> +			mark_buffer_dirty(bh);
>  		if (inode && inode_needs_sync(inode)) {
>  			sync_dirty_buffer(bh);
>  			if (buffer_req(bh) && !buffer_uptodate(bh)) {
> 


This does add the meta data buffer_head to the inode->mapping->private_list.
But ext4_sync_file is not writing them. I guess we need to call sync_mapping_buffers
for no-journal mode in ext4_sync_file

-aneesh
