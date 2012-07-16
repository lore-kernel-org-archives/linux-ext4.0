From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH 04/12 v2] xfs: pass LLONG_MAX to
 truncate_inode_pages_range
Date: Mon, 16 Jul 2012 13:52:00 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1207161348140.943@dhcp-1-248.brq.redhat.com>
References: <1342185555-21146-1-git-send-email-lczerner@redhat.com> <1342185555-21146-4-git-send-email-lczerner@redhat.com> <20120715231117.GD30524@devil.redhat.com> <alpine.LFD.2.00.1207160854080.3857@dhcp-1-248.brq.redhat.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="571144193-1223212112-1342439525=:943"
Cc: Dave Chinner <dchinner@redhat.com>, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
	hch@infradead.org
To: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41504 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752540Ab2GPLwN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 16 Jul 2012 07:52:13 -0400
In-Reply-To: <alpine.LFD.2.00.1207160854080.3857@dhcp-1-248.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--571144193-1223212112-1342439525=:943
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT

On Mon, 16 Jul 2012, Luká¨ Czerner wrote:

> Date: Mon, 16 Jul 2012 09:13:44 +0200 (CEST)
> From: Luká¨ Czerner <lczerner@redhat.com>
> To: Dave Chinner <dchinner@redhat.com>
> Cc: Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org,
>     linux-fsdevel@vger.kernel.org, tytso@mit.edu, achender@linux.vnet.ibm.com
> Subject: Re: [PATCH 04/12 v2] xfs: pass LLONG_MAX to
>     truncate_inode_pages_range
> 
> On Mon, 16 Jul 2012, Dave Chinner wrote:
> 
> > Date: Mon, 16 Jul 2012 09:11:17 +1000
> > From: Dave Chinner <dchinner@redhat.com>
> > To: Lukas Czerner <lczerner@redhat.com>
> > Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, tytso@mit.edu,
> >     achender@linux.vnet.ibm.com
> > Subject: Re: [PATCH 04/12 v2] xfs: pass LLONG_MAX to
> >     truncate_inode_pages_range
> > 
> > On Fri, Jul 13, 2012 at 03:19:07PM +0200, Lukas Czerner wrote:
> > > Currently we're passing -1 to truncate_inode_pages_range() which is
> > > actually really confusing since the argument is signed so we do not get
> > > "huge" number as one would expect, but rather just -1. To make things
> > > clearer and easier for truncate_inode_pages_range() just pass LLONG_MAX
> > > since it is actually what was intended anyway.
> > > 
> > > It also makes thing easier for allowing truncate_inode_pages_range() to
> > > handle non page aligned regions. Moreover letting the lend argument to
> > > be negative might actually hide some bugs.
> > > 
> > > Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> > > Cc: Dave Chinner <dchinner@redhat.com>
> > > ---
> > >  fs/xfs/xfs_fs_subr.c |    6 ++++--
> > >  1 files changed, 4 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/fs/xfs/xfs_fs_subr.c b/fs/xfs/xfs_fs_subr.c
> > > index 652b875..6e9b052 100644
> > > --- a/fs/xfs/xfs_fs_subr.c
> > > +++ b/fs/xfs/xfs_fs_subr.c
> > > @@ -34,7 +34,8 @@ xfs_tosspages(
> > >  {
> > >  	/* can't toss partial tail pages, so mask them out */
> > >  	last &= ~(PAGE_SIZE - 1);
> > > -	truncate_inode_pages_range(VFS_I(ip)->i_mapping, first, last - 1);
> > > +	truncate_inode_pages_range(VFS_I(ip)->i_mapping, first,
> > > +				   last == -1 ? LLONG_MAX : last);
> > 
> > The last paramter changed from (last -1) to last. so if we pass in
> > last = 16384, we now truncate to 16384 (first byte of page index 5)
> > instead of 16383 (last byte of page index 4). That's a change of
> > behaviour and a potential off-by one error, right?
> 
> Right, this could potentially cause off-by-one errors, but as it is
> now I do not think this could happen. The only place where it is
> used with a proper range is XFS_IOC_ZERO_RANGE and you're going to
> convert the whole range to unwritten anyway. But it was unintended
> and I\ll fix it.

Hi Dave,

Is there a reason for aligning the last page in the xfs_tosspages()
other than truncate_inode_pages_range() does not handle unaligned
regions ? Because with my patch it does now, so it seems to me that
we can easily get rid of the xfs_tosspages() and just use
truncate_inode_pages_range() instead in xfs_change_file_space() and
xfs_swap_extents().

Thanks!
-Lukas

> 
> 
> > 
> > > @@ -53,7 +54,8 @@ xfs_flushinval_pages(
> > >  	ret = filemap_write_and_wait_range(mapping, first,
> > >  				last == -1 ? LLONG_MAX : last);
> > >  	if (!ret)
> > > -		truncate_inode_pages_range(mapping, first, last);
> > > +		truncate_inode_pages_range(mapping, first,
> > > +					   last == -1 ? LLONG_MAX : last);
> > 
> > Given this is also done immediately above in the function, perhaps
> > this should be done before anything:
> > 
> > 	if (last == -1)
> > 		last = LLONG_MAX;
> > 
> > and the parameter simply passed to the two functions without the
> > conditional logic?
> 
> Yes, it makes sense to do this, I'll change it in the next
> iteration.
> 
> Thanks for the review Dave.
> -Lukas
> 
> > 
> > Cheers,
> > 
> > Dave.
> > 
> 
--571144193-1223212112-1342439525=:943--
