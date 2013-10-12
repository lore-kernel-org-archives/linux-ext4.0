From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH v1 10/22] debugfs: handle inline_data feature in
 dirsearch command
Date: Sat, 12 Oct 2013 15:21:02 +0800
Message-ID: <20131012072102.GB3191@gmail.com>
References: <1375436989-18948-1-git-send-email-wenqing.lz@taobao.com>
 <1375436989-18948-11-git-send-email-wenqing.lz@taobao.com>
 <20131012003036.GU6860@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
	Zheng Liu <wenqing.lz@taobao.com>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:50548 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752090Ab3JLHTJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 12 Oct 2013 03:19:09 -0400
Received: by mail-pa0-f47.google.com with SMTP id kp14so5334294pab.20
        for <linux-ext4@vger.kernel.org>; Sat, 12 Oct 2013 00:19:08 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20131012003036.GU6860@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Oct 11, 2013 at 05:30:36PM -0700, Darrick J. Wong wrote:
> On Fri, Aug 02, 2013 at 05:49:37PM +0800, Zheng Liu wrote:
> > From: Zheng Liu <wenqing.lz@taobao.com>
> > 
> > We don't need to support inline data in dirsearch command.
> 
> What if I want to dirsearch for a directory entry?  Shouldn't debugfs print
> more than nothing?  I don't see why I shouldn't be able to search an inline
> directory?

I have discussed this with Ted [1], and the result shows that making
dirsearch command support inline data is not very useful for libext2fs.
So this time I don't add this support.  Personally, I don't object to
support this.  But, yes, I am convinced by Ted.

1. http://www.spinics.net/lists/linux-ext4/msg38376.html

Thanks,
                                                - Zheng

> 
> --D
> > 
> > Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> > Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
> > ---
> >  debugfs/htree.c |    4 ++++
> >  1 file changed, 4 insertions(+)
> > 
> > diff --git a/debugfs/htree.c b/debugfs/htree.c
> > index d94dbea..b226f1d 100644
> > --- a/debugfs/htree.c
> > +++ b/debugfs/htree.c
> > @@ -387,9 +387,13 @@ void do_dirsearch(int argc, char *argv[])
> >  	pb.search_name = argv[2];
> >  	pb.len = strlen(pb.search_name);
> >  
> > +	if (ext2fs_inode_has_inline_data(current_fs, inode))
> > +		goto out;
> > +
> >  	ext2fs_block_iterate3(current_fs, inode, BLOCK_FLAG_READ_ONLY, 0,
> >  			      search_dir_block, &pb);
> >  
> > +out:
> >  	free(pb.buf);
> >  }
> >  
> > -- 
> > 1.7.9.7
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
