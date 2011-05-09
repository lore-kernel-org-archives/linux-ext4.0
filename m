From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH] e2fsprogs: fix memory leak in
 ext2fs_free_generic_bmap()
Date: Mon, 9 May 2011 10:09:47 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1105091008390.3694@dhcp-27-109.brq.redhat.com>
References: <1300702440-4835-1-git-send-email-lczerner@redhat.com> <20110508221055.GE15585@thunk.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:8290 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751954Ab1EIIJu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 9 May 2011 04:09:50 -0400
In-Reply-To: <20110508221055.GE15585@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, 8 May 2011, Ted Ts'o wrote:

> On Mon, Mar 21, 2011 at 11:14:00AM +0100, Lukas Czerner wrote:
> > In ext2fs_free_generic_bmap() when we are freeing 64-bit bitmap, we do
> > call free_bmap() to free backend specific bitmap structures, however we
> > should also free ext2fs_generic_bitmap structure as well. So this commit
> > fixes that and removes unnecessary assignments.
> > 
> > Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> > ---
> >  lib/ext2fs/gen_bitmap64.c |    8 ++++----
> >  1 files changed, 4 insertions(+), 4 deletions(-)
> > 
> > diff --git a/lib/ext2fs/gen_bitmap64.c b/lib/ext2fs/gen_bitmap64.c
> > index 8b9e4c5..f343cc7 100644
> > --- a/lib/ext2fs/gen_bitmap64.c
> > +++ b/lib/ext2fs/gen_bitmap64.c
> > @@ -153,11 +153,11 @@ void ext2fs_free_generic_bmap(ext2fs_generic_bitmap bmap)
> >  
> >  	bmap->bitmap_ops->free_bmap(bmap);
> >  
> > -	if (bmap->description) {
> > +	if (bmap->description)
> >  		ext2fs_free_mem(&bmap->description);
> > -		bmap->description = 0;
> > -	}
> > -	bmap->magic = 0;
> > +
> > +	ext2fs_free_mem(&bmap);
> > +	bmap = NULL;
> 
> Setting bmap to NULL is pointless since C doesn't have
> pass-by-reference ala C++ (i.e., it's not like this function parameter
> is declared "ext2fs_generic_bitmap &bmap").
> 
> So it's actually a good idea to zap bmap->description, and especially
> bmap->magic, since that will allow us to catch attempts to use the
> bitmap after we free it.
> 
> I'll make the simplification of your patch which just adds the missing
> "ext2fs_free_mem(&bmap)" call.
> 
> 					- Ted
> 

Agh, you're right, sorry about that.

Thanks!
-Lukas
