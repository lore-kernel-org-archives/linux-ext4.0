From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 10/25] debugfs: create journal handling routines
Date: Thu, 11 Sep 2014 12:03:49 -0700
Message-ID: <20140911190349.GP10351@birch.djwong.org>
References: <20140908231135.25904.66591.stgit@birch.djwong.org>
 <20140908231242.25904.81768.stgit@birch.djwong.org>
 <20140911185343.GB8366@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:20514 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753286AbaIKTDy (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 11 Sep 2014 15:03:54 -0400
Content-Disposition: inline
In-Reply-To: <20140911185343.GB8366@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Sep 11, 2014 at 02:53:43PM -0400, Theodore Ts'o wrote:
> On Mon, Sep 08, 2014 at 04:12:42PM -0700, Darrick J. Wong wrote:
> > +recovery.o: $(srcdir)/../e2fsck/recovery.c
> > +	cp $(srcdir)/../e2fsck/recovery.c $(srcdir)/recovery.c
> > +	$(E) "	CC $@"
> > +	$(Q) $(CC) -c $(ALL_CFLAGS) -I$(srcdir) \
> > +		 $(srcdir)/recovery.c -DDEBUGFS -o $@
> > +
> > +revoke.o: $(srcdir)/../e2fsck/revoke.c
> > +	cp $(srcdir)/../e2fsck/revoke.c $(srcdir)/revoke.c
> > +	$(E) "	CC $@"
> > +	$(Q) $(CC) -c $(ALL_CFLAGS) -I$(srcdir) \
> > +		 $(srcdir)/revoke.c -DDEBUGFS -o $@
> > +
> 
> Please don't copy the .c files around.  That just invites confusion
> because git will show that there are new files, debugfs/recovery.c and
> debugfs/revoke.c, and some future unwary developer might try to edit
> recovery.c and revoke.c in the debugfs directory.
> 
> Much better to do it this way:
> 
> recovery.o: $(srcdir)/../e2fsck/recovery.c
> 	$(E) "	CC $@"
> 	$(Q) $(CC) -c $(ALL_CFLAGS) -I$(srcdir) \
> 		 $(srcdir)/../e2fsck/recovery.c -DDEBUGFS -o $@
> 
> revoke.o: $(srcdir)/../e2fsck/revoke.c
> 	$(E) "	CC $@"
> 	$(Q) $(CC) -c $(ALL_CFLAGS) -I$(srcdir) \
> 		 $(srcdir)/../e2fsck/revoke.c -DDEBUGFS -o $@
> 
> I'll fix this up when I apply this patch.

Will that pick up debugfs/jfs_user.h, though?  I originally tried it this way
but gcc seemed to want to pull in the jfs_user.h from e2fsck/.

--D

> 
> Cheers,
> 
> 						- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
