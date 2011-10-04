From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH v2] ext4: Prevent stack overrun in ext4_file_open when
 recording last known mountpoint
Date: Tue, 4 Oct 2011 13:30:23 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1110041127420.7833@dhcp-27-109.brq.redhat.com>
References: <20110915231645.GE12086@tux1.beaverton.ibm.com> <m239fwfk4k.fsf@firstfloor.org> <20110916184005.GH12086@tux1.beaverton.ibm.com> <20110930194655.GX12086@tux1.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Andi Kleen <andi@firstfloor.org>, "Theodore Ts'o" <tytso@mit.edu>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: "Darrick J. Wong" <djwong@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45631 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755398Ab1JDLag (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 4 Oct 2011 07:30:36 -0400
In-Reply-To: <20110930194655.GX12086@tux1.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 30 Sep 2011, Darrick J. Wong wrote:

> On Fri, Sep 16, 2011 at 11:40:05AM -0700, Darrick J. Wong wrote:
> > In ext4_file_open, the filesystem records the mountpoint of the first file that
> > is opened after mounting the filesystem.  It does this by allocating a 64-byte
> > stack buffer, calling d_path() to grab the mount point through which this file
> > was accessed, and then memcpy()ing 64 bytes into the superblock's
> > s_last_mounted field, starting from the return value of d_path(), which is
> > stored as "cp".  However, if cp > buf (which it frequently is since path
> > components are prepended starting at the end of buf) then we can end up copying
> > stack data into the superblock.
> > 
> > Writing stack variables into the superblock doesn't sound like a great idea, so
> > use strlcpy instead.  Andi Kleen suggested using strlcpy instead of strncpy.
> 
> Ok, it's been a couple of weeks.... any thoughts, Ted?
> 
> --D

Makes sense.

Reviewed-by: Lukas Czerner <lczerner@redhat.com>

> > 
> > Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
> > ---
> > 
> >  fs/ext4/file.c |    4 ++--
> >  1 files changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/fs/ext4/file.c b/fs/ext4/file.c
> > index e4095e9..9781099 100644
> > --- a/fs/ext4/file.c
> > +++ b/fs/ext4/file.c
> > @@ -181,8 +181,8 @@ static int ext4_file_open(struct inode * inode, struct file * filp)
> >  		path.dentry = mnt->mnt_root;
> >  		cp = d_path(&path, buf, sizeof(buf));
> >  		if (!IS_ERR(cp)) {
> > -			memcpy(sbi->s_es->s_last_mounted, cp,
> > -			       sizeof(sbi->s_es->s_last_mounted));
> > +			strlcpy(sbi->s_es->s_last_mounted, cp,
> > +				sizeof(sbi->s_es->s_last_mounted));
> >  			ext4_mark_super_dirty(sb);
> >  		}
> >  	}
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
