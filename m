From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH 03/12 v2] shmem: pass LLONG_MAX to shmem_truncate_range
Date: Thu, 19 Jul 2012 08:40:49 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1207190839330.4970@localhost>
References: <1342185555-21146-1-git-send-email-lczerner@redhat.com> <1342185555-21146-3-git-send-email-lczerner@redhat.com> <5007145C.1080407@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, tytso@mit.edu,
	achender@linux.vnet.ibm.com, Hugh Dickins <hughd@google.com>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:64379 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751717Ab2GSGlA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 19 Jul 2012 02:41:00 -0400
In-Reply-To: <5007145C.1080407@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 18 Jul 2012, Eric Sandeen wrote:

> Date: Wed, 18 Jul 2012 14:54:04 -0500
> From: Eric Sandeen <sandeen@redhat.com>
> To: Lukas Czerner <lczerner@redhat.com>
> Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, tytso@mit.edu,
>     achender@linux.vnet.ibm.com, Hugh Dickins <hughd@google.com>
> Subject: Re: [PATCH 03/12 v2] shmem: pass LLONG_MAX to shmem_truncate_range
> 
> On 7/13/12 8:19 AM, Lukas Czerner wrote:
> > Currently we're passing -1 to shmem_truncate_range which can then call
> > truncate_inode_pages_range() which is actually really confusing since the
> > argument is signed so we do not get "huge" number as one would expect,
> > but rather just -1. To make things clearer and easier for
> > truncate_inode_pages_range() just pass LLONG_MAX since it is actually what
> > was intended anyway.
> > 
> > It also makes thing easier for allowing truncate_inode_pages_range() to
> > handle non page aligned regions. Moreover letting the lend argument to
> > be negative might actually hide some bugs.
> > 
> > Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> > Cc: Hugh Dickins <hughd@google.com>
> > ---
> >  mm/shmem.c |    3 ++-
> >  1 files changed, 2 insertions(+), 1 deletions(-)
> > 
> > diff --git a/mm/shmem.c b/mm/shmem.c
> > index 4ce02e0..3199733 100644
> > --- a/mm/shmem.c
> > +++ b/mm/shmem.c
> > @@ -2961,7 +2961,8 @@ void shmem_unlock_mapping(struct address_space *mapping)
> >  
> >  void shmem_truncate_range(struct inode *inode, loff_t lstart, loff_t lend)
> >  {
> > -	truncate_inode_pages_range(inode->i_mapping, lstart, lend);
> > +	truncate_inode_pages_range(inode->i_mapping, lstart,
> > +				   lend == -1 ? LLONG_MAX : last);
> 
> Where'd "last" come from?  That won't build; should be "lend" right?
> 
> (code only goes this way if !CONFIG_SHMEM so you might have missed it)

Ah, I definitely missed it. Thanks Eric. But from the discussion
with the Hugh, we're going to do this a bit differently anyway.

-Lukas

> 
> -Eric
> 
> >  }
> >  EXPORT_SYMBOL_GPL(shmem_truncate_range);
> >  
> > 
> 
> 
> 
