From: Jan Kara <jack@suse.cz>
Subject: Re: Question on fallocate/ftruncate sequence (and flags)
Date: Wed, 29 Jul 2009 17:29:23 +0200
Message-ID: <20090729152923.GA25919@atrey.karlin.mff.cuni.cz>
References: <6601abe90907200936w61ebda92reae368a2b9efac66@mail.gmail.com> <4A64F37D.7020803@redhat.com> <1248211771.20743.2.camel@bobble.smo.corp.google.com> <20090721215421.GM4231@webber.adilger.int> <1248378517.8421.4.camel@bobble.smo.corp.google.com> <4A68C9EC.4050301@redhat.com> <1248382893.14764.8.camel@bobble.smo.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>,
	Andreas Dilger <adilger@sun.com>,
	Curt Wohlgemuth <curtw@google.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Frank Mayhar <fmayhar@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:33436 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750977AbZG2P3X (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 29 Jul 2009 11:29:23 -0400
Content-Disposition: inline
In-Reply-To: <1248382893.14764.8.camel@bobble.smo.corp.google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> On Thu, 2009-07-23 at 15:37 -0500, Eric Sandeen wrote:
> > As for:
> > 
> > #define EXT4_EXT_MIGRATE                0x00100000 /* Inode is migrating */
> > 
> > this is not in the mask that FS_IOC_GETFLAGS can see ... and I don't
> > think anyone else uses FS_DIRECTIO_FL.
> > 
> > I'm not sure if the flags not in FS_FL_USER_VISIBLE are supposed to be
> > fs-unique.
> 
> The flag will need to be generic in any case, since inode_setattr() has
> to look at it when it's deciding whether or not to call vmtruncate().
> Other filesystems that properly implement fallocate() may want to use it
> for this purpose as well.
  Actually, Nick Piggin is changing the truncate path (the patches may
already be in Al Viro's tree) so that filesystem can come in earlier in
the truncate path and can make the decision when to truncate and when
not on its own. I guess this would help you...

									Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
