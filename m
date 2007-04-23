From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] Copy i_flags to ext3 inode flags on write (version 2)
Date: Mon, 23 Apr 2007 20:33:00 +0200
Message-ID: <20070423183300.GA6029@duck.suse.cz>
References: <20070417103855.GB11815@duck.suse.cz> <20070420005337.91beacfe.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: shaggy@austin.ibm.com, linux-ext4@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:34597 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1161219AbXDWSYJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 23 Apr 2007 14:24:09 -0400
Content-Disposition: inline
In-Reply-To: <20070420005337.91beacfe.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri 20-04-07 00:53:37, Andrew Morton wrote:
> On Tue, 17 Apr 2007 12:38:55 +0200 Jan Kara <jack@suse.cz> wrote:
> 
> >   attached is a second version of a patch that stores inode flags such as
> > S_IMMUTABLE, S_APPEND, etc. from i_flags to EXT3_I(inode)->i_flags when
> > inode is written to disk. The same thing is done on GETFLAGS ioctl.
> >   Quota code changes these flags on quota files (to make it harder for
> > sysadmin to screw himself) and these changes were not correctly
> > propagated into the filesystem (especially, lsattr did not show them and
> > users were wondering...). Andrew, could you please put the patch into your
> > queue? Thanks.
> 
> umm, OK.
  Thanks.

> What about ext2 and all the zillions of others?
  Oh, yes... I'll send you patch for ext2, GFS2 and OCFS2. The only
filesystem, which is capable to store such flags and is not converted is
JFS - I was not able to find a suitable place for copying flags from VFS
inode to ondisk copy (giving CC to Shaggy)...

								Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
