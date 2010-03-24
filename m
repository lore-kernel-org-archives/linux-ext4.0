From: tytso@mit.edu
Subject: Re: [PATCH] ext4/super.c: Replace CONTIG_EXT{2,3}_FS by
 CONFIG_EXT{2,3}_FS
Date: Wed, 24 Mar 2010 12:27:47 -0400
Message-ID: <20100324162747.GI2159@thunk.org>
References: <2d0a357f1003240405x1178f0c6x188d30d1d311cb5@mail.gmail.com>
 <20100324161201.GG2159@thunk.org>
 <4BAA3C27.2000505@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:58304 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932404Ab0CXR4e (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 24 Mar 2010 13:56:34 -0400
Content-Disposition: inline
In-Reply-To: <4BAA3C27.2000505@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Mar 24, 2010 at 11:21:59AM -0500, Eric Sandeen wrote:
> On 03/24/2010 11:12 AM, tytso@mit.edu wrote:
> > Thanks for catching this!  This should fix it up...
> > 
> >        	   	    	   	       	   - Ted
> > 
> > ext4: Fix build error when EXT4_USE_FOR_EXT23 disabled
> > 
> > Fix a stupid type (CONTIG != CONFIG) and a stupid assumption that
> > ext3_fs_type would always be defined.
> > 
> > (The build failure could also happen when EXT4_USE_FOR_EXT23 is
> > enabled and ext3 is built as a module.)
> 
> A little late, but right now we have this in Kconfig:
> 
> config EXT4_USE_FOR_EXT23
>         bool "Use ext4 for ext2/ext3 file systems"
>         depends on EXT4_FS
>         depends on EXT3_FS=n || EXT2_FS=n
> 
> do we really want "||" ?
> 
> so, if you turn off ext2, but leave ext3 on, it will ask you if you want
> to use ext4 for ext3?  That doesn't make sense to me.

Well, the idea is you can use ext4 instead of ext2 or ext3.  So if
ext3 is turned on, but ext2 is off, then the option will use ext4 for
ext2, but ext3 will stay ext3.

This is explained in more detail in the help message.  I guess we
could make "ext2/ext3 filesystems" be "ext2 or ext3 filesystems" and
then add a slightly more explicit explanation in the help text....

     	   	    	 	  	      	 - Ted
