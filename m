From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH 04/12] ext4: Disable merging of uninitialized extents
Date: Tue, 29 Jan 2013 16:37:00 +0800
Message-ID: <20130129083700.GA31325@gmail.com>
References: <1358510446-19174-1-git-send-email-jack@suse.cz>
 <1358510446-19174-5-git-send-email-jack@suse.cz>
 <87vcamdi6e.fsf@openvz.org>
 <20130128143647.GD22711@thunk.org>
 <871ud5fizk.fsf@openvz.org>
 <20130128153836.GH22711@thunk.org>
 <87y5fce8rq.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
	linux-ext4@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-da0-f44.google.com ([209.85.210.44]:52988 "EHLO
	mail-da0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753190Ab3A2IW4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 29 Jan 2013 03:22:56 -0500
Received: by mail-da0-f44.google.com with SMTP id z20so108568dae.31
        for <linux-ext4@vger.kernel.org>; Tue, 29 Jan 2013 00:22:56 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <87y5fce8rq.fsf@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jan 29, 2013 at 11:41:13AM +0400, Dmitry Monakhov wrote:
> On Mon, 28 Jan 2013 10:38:36 -0500, Theodore Ts'o <tytso@mit.edu> wrote:
> > On Mon, Jan 28, 2013 at 07:02:55PM +0400, Dmitry Monakhov wrote:
> > > Actually this patch consists of two peaces
> > > 1) disable merging of uninitialized extents. (1 line change) I'm
> > > absolutely agree with it.
> > 
> > To be clear, that's this patch chunk (one line change not including
> > comments :-), right?
> Off course.
> > 
> > --- a/fs/ext4/extents.c
> > +++ b/fs/ext4/extents.c
> > @@ -1579,11 +1576,13 @@ int
> >  ext4_can_extents_be_merged(struct inode *inode, struct ext4_extent *ex1,
> >  				struct ext4_extent *ex2)
> >  {
> >  
> >  	/*
> > -	 * Make sure that either both extents are uninitialized, or
> > -	 * both are _not_.
> > +	 * Make sure that both extents are initialized. We don't merge
> > +	 * uninitialized extents so that we can be sure that end_io code has
> > +	 * the extent that was written properly split out and conversion to
> > +	 * initialized is trivial.
> >  	 */
> > -	if (ext4_ext_is_uninitialized(ex1) ^ ext4_ext_is_uninitialized(ex2))
> > +	if (ext4_ext_is_uninitialized(ex1) || ext4_ext_is_uninitialized(ex2))
> >  		return 0;
> >  
> > 
> > The one thing I'm a bit worried about is how much worse will extent
> > fragmentation be once we do this, but it's clear we need to strive for
> > correctness first.
> This change should not affect fragmentation because
> 1) Most people call fallocate(2) on big chunks (>4M)
> 2) Once uninitialized extent filled with data and converted to
> initialized extents  will be merged immediately.
> 3) Most people use fallocate(2) for preallocation before write(2)
>    so effectively calls are interleaved so merging works as expected.
> 
> The only case where fragmentation will increase is when someone
> performs many fallocate(2) calls for small chunks (4k) w/o writes.
> As result leaf block will consist of 256 extents 4k each.
> Later writes can't help us because we can not merge extents from two
> leaf blocks. But I still think that this use case it inconvenient.

Yes, I doubt that no one does like this because it can not brings any
benefit.  We usually call fallocate(2) to preallocate some sequential
spaces.  Obviously preallocating a small chunk is useless.

> 
> BTW why do we not try to merge extents from two leaf blocs?
> I do not see any technical difficulties. If two adjacent leaf blocks
> are covered by common index block merging is possible (but we need +1
> journal block).

Yep, I also notice this.  I don't think there is a technical difficulty.
That would be great if two adjacent leaf blocks could be merged.

Regards,
                                                - Zheng
