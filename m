From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [EXT4 set 1][PATCH 2/2] Enable extents by default for ext4dev
Date: Tue, 10 Jul 2007 17:35:13 -0400
Message-ID: <1184103313.3759.44.camel@localhost.localdomain>
References: <1183275361.4010.119.camel@localhost.localdomain>
	 <20070710163015.ab40ed2a.akpm@linux-foundation.org>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@mit.edu>, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:54321 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751119AbXGKAfM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 10 Jul 2007 20:35:12 -0400
In-Reply-To: <20070710163015.ab40ed2a.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, 2007-07-10 at 16:30 -0700, Andrew Morton wrote:
> On Sun, 01 Jul 2007 03:36:01 -0400
> Mingming Cao <cmm@us.ibm.com> wrote:
> 
> > Turn on extents feature by default in ext4 filesystem. User could use
> > -o noextents to turn it off.
> > 
> 
> Oh, there you go.
> 
> > 
> > Index: linux-2.6.22-rc4/fs/ext4/super.c
> > ===================================================================
> > --- linux-2.6.22-rc4.orig/fs/ext4/super.c	2007-06-11 17:02:22.000000000 -0700
> > +++ linux-2.6.22-rc4/fs/ext4/super.c	2007-06-11 17:03:09.000000000 -0700
> > @@ -1546,6 +1546,12 @@
> >  
> >  	set_opt(sbi->s_mount_opt, RESERVATION);
> >  
> > +	/*
> > +	 * turn on extents feature by default in ext4 filesystem
> > +	 * User -o noextents to turn it off
> > +	 */
> > +	set_opt (sbi->s_mount_opt, EXTENTS);
> > +
> 
> Broken coding style.
> 
> Please feed all the ext4 patches through scripts/checkpatch.pl (preferably
> version 0.07 - see Andy's patch on lkml) and then consider addressing the
> (quite large) number of mistakes which are detected.
> 

Sorry about this. I was using version 0.04. The latest one I can find
for now is 0.05(searching lkml), but it didn't catch this codling style
bug either. I appreciate if anyone can point me the version 0.07, thanks

Mingming
