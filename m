Return-Path: <SRS0=F3Rs=OG=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41480 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729259AbeK0TyG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 27 Nov 2018 14:54:06 -0500
Date: Tue, 27 Nov 2018 09:56:53 +0100
From: Jan Kara <jack@suse.cz>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Jan Kara <jack@suse.cz>, Phillip Potter <phil@philpotter.co.uk>,
        Jan Kara <jack@suse.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Ext4 <linux-ext4@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [RFC][PATCH v4 04/09] ext2: use common file type conversion
Message-ID: <20181127085653.GC14128@quack2.suse.cz>
References: <20181121190653.GA7710@pathfinder>
 <20181122114023.GE9840@quack2.suse.cz>
 <CAOQ4uxiOOJuFDO7x=sY9Cy3wGr8xo6AGKY4Hep10jwvOVkqd_A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxiOOJuFDO7x=sY9Cy3wGr8xo6AGKY4Hep10jwvOVkqd_A@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 22-11-18 14:47:39, Amir Goldstein wrote:
> On Thu, Nov 22, 2018 at 1:40 PM Jan Kara <jack@suse.cz> wrote:
> >
> > On Wed 21-11-18 19:06:53, Phillip Potter wrote:
> > > Deduplicate the ext2 file type conversion implementation - file systems
> > > that use the same file types as defined by POSIX do not need to define
> > > their own versions and can use the common helper functions decared in
> > > fs_types.h and implemented in fs_types.c
> > >
> > > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > > Signed-off-by: Phillip Potter <phil@philpotter.co.uk>
> >
> > Looks good. You can add:
> >
> > Reviewed-by: Jan Kara <jack@suse.cz>
> 
> Jan,
> 
> As you know, Al probably has bigger fish to fry at the moment.
> Will you take this patch along with patch #1 through your tree?
> Other fs maintainers could apply patches on next cycle (or coordinate
> they pull request with you).
> 
> If you would agree to that, I suggest to copy the following section
> from the cover letter into the ext2 patch:
> 
> The current implementation has a lurking out-of-bounds access
> bug to the ext2_type_by_mode array.
> The array is defined with size S_IFMT >> S_SHIFT, so 15.
> This means that it is possible with a malformed inode to
> get an index of 15, as the array is always accessed with:
> ext2_type_by_mode[(mode & S_IFMT)>>S_SHIFT];

Yes, I will do that.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
