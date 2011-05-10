From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/1] Null Pointer when make_indexed_dir returns -ENOSPC
Date: Tue, 10 May 2011 15:34:54 +0200
Message-ID: <20110510133454.GF4402@quack.suse.cz>
References: <4DC5DBB3.9030207@linux.vnet.ibm.com>
 <20110509110329.GF4122@quack.suse.cz>
 <BANLkTi=hSeN4mb8x9vu4DfBb-us_ocaqXw@mail.gmail.com>
 <20110509113052.GI4122@quack.suse.cz>
 <20110509135516.GJ4138@thunk.org>
 <20110509140537.GN4122@quack.suse.cz>
 <20110509142237.GA19811@thunk.org>
 <20110509144201.GP4122@quack.suse.cz>
 <4DC850EB.5020708@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Ted Ts'o <tytso@mit.edu>,
	Yongqiang Yang <xiaoqiangnk@gmail.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Allison Henderson <achender@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:33605 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754036Ab1EJNe4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 10 May 2011 09:34:56 -0400
Content-Disposition: inline
In-Reply-To: <4DC850EB.5020708@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 09-05-11 13:39:07, Allison Henderson wrote:
> On 5/9/2011 7:42 AM, Jan Kara wrote:
> >On Mon 09-05-11 10:22:37, Ted Tso wrote:
> >>On Mon, May 09, 2011 at 04:05:37PM +0200, Jan Kara wrote:
> >>>   Yes. ext4_append() can return ENOSPC and passed bh will get set to NULL
> >>>without being marked dirty.
> >>
> >>Ah, so the right fix then is to add to make the cleanup code like this:
> >>
> >>		ext4_mark_inode_dirty(handle, dir);
> >>		ext4_handle_dirty_metadata(handle, dir, frame->bh);
> >>+	        ext4_handle_dirty_metadata(handle, dir, bh2);
> >>+		if (bh)
> >>+			ext4_handle_dirty_metadata(handle, dir, bh);
> >>		dx_release(frames);
> >>		return retval;
> >>
> >>Agreed?
> >   Not quite. make_indexed_dir() does frame->bh = bh and bh = bh2 before
> >calling do_split(). So bh2 is not really carrying a valid buffer reference
> >at this point - even more so because do_split() does brelse() on the passed
> >bh so it need not be around when are at this point. The code is a real
> >mess. But for example attached patch will work because both callers of
> >do_split() do brelse() anyway.
> >
> >								Honza
> 
> Hi all,
> 
> Oh, I understand the problem now.  Sorry for the late response, I
> had to stop and dig around with this one for a bit.  Would people
> prefer to add the new code before the do_split like this:
> 
> +	ext4_handle_dirty_metadata(handle, dir, frame->bh);
> +	ext4_handle_dirty_metadata(handle, dir, bh);
> +
>  	de = do_split(handle,dir, &bh, frame, &hinfo, &retval);
>  	if (!de) {
>  		/*
> @@ -1421,8 +1425,6 @@ static int make_indexed_dir(handle_t *handle,
> struct dentry *dentry,
>  		 * with corrupted filesystem.
>  		 */
>  		ext4_mark_inode_dirty(handle, dir);
> -		ext4_handle_dirty_metadata(handle, dir, frame->bh);
> -		ext4_handle_dirty_metadata(handle, dir, bh);
>  		dx_release(frames);
>  		return retval;
>  	}
  This would be fine with me as well. It has a slight overhead of marking
buffer dirty twice but I don't think it really matters.

> I've tested both patches and they both seem to resolve the null
> pointer.  The only other solution that comes to mind would be to add
> flags to the do_split to skip the brelse or to do the mark dirty
> before the brelse as you suggest.
  Yes, I don't mind which of them Ted chooses...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
