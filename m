From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [RFC PATCH] coredump: avoid ext4 auto_da_alloc for core file
Date: Tue, 5 Jul 2016 10:37:14 -0400
Message-ID: <20160705143714.GG15193@thunk.org>
References: <5cdda475417b2719dced162cce89a283153cb818.1466012020.git.osandov@fb.com>
 <ae759802-f111-2c11-769e-e24e5dda4a5b@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Omar Sandoval <osandov@osandov.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	kernel-team@fb.com
To: Josef Bacik <jbacik@fb.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:35146 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754753AbcGEOhQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 5 Jul 2016 10:37:16 -0400
Content-Disposition: inline
In-Reply-To: <ae759802-f111-2c11-769e-e24e5dda4a5b@fb.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jul 05, 2016 at 09:42:13AM -0400, Josef Bacik wrote:
> > diff --git a/fs/coredump.c b/fs/coredump.c
> > index 281b768000e6..9da7357773f0 100644
> > --- a/fs/coredump.c
> > +++ b/fs/coredump.c
> > @@ -741,8 +741,10 @@ void do_coredump(const siginfo_t *siginfo)
> >  			goto close_fail;
> >  		if (!(cprm.file->f_mode & FMODE_CAN_WRITE))
> >  			goto close_fail;
> > -		if (do_truncate(cprm.file->f_path.dentry, 0, 0, cprm.file))
> > -			goto close_fail;
> > +		if (i_size_read(file_inode(cprm.file)) != 0) {
> > +			if (do_truncate(cprm.file->f_path.dentry, 0, 0, cprm.file))
> > +				goto close_fail;
> > +		}
> >  	}
> > 
> >  	/* get us an unshared descriptor table; almost always a no-op */
> > 
> 
> Omar, this probably breaks the case where we do
> fallocate(FALLOC_FL_KEEP_SIZE), the i_size will be 0 but there will be
> blocks to truncate.  Probably want to check i_blocks or something.  Thanks,

Sure, but this is in the coredump code; do we care there?  What are
the odds that someone will have fallocated blocks beyond i_size in a
file named "core"?  And if so, it's not like it's going to make the
coredump invalid or non-useful in any way.

      	       	     	 	  	      - Ted
