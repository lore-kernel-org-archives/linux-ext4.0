From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 10/25] debugfs: create journal handling routines
Date: Thu, 11 Sep 2014 14:53:43 -0400
Message-ID: <20140911185343.GB8366@thunk.org>
References: <20140908231135.25904.66591.stgit@birch.djwong.org>
 <20140908231242.25904.81768.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:51721 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752453AbaIKSxq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 11 Sep 2014 14:53:46 -0400
Content-Disposition: inline
In-Reply-To: <20140908231242.25904.81768.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Sep 08, 2014 at 04:12:42PM -0700, Darrick J. Wong wrote:
> +recovery.o: $(srcdir)/../e2fsck/recovery.c
> +	cp $(srcdir)/../e2fsck/recovery.c $(srcdir)/recovery.c
> +	$(E) "	CC $@"
> +	$(Q) $(CC) -c $(ALL_CFLAGS) -I$(srcdir) \
> +		 $(srcdir)/recovery.c -DDEBUGFS -o $@
> +
> +revoke.o: $(srcdir)/../e2fsck/revoke.c
> +	cp $(srcdir)/../e2fsck/revoke.c $(srcdir)/revoke.c
> +	$(E) "	CC $@"
> +	$(Q) $(CC) -c $(ALL_CFLAGS) -I$(srcdir) \
> +		 $(srcdir)/revoke.c -DDEBUGFS -o $@
> +

Please don't copy the .c files around.  That just invites confusion
because git will show that there are new files, debugfs/recovery.c and
debugfs/revoke.c, and some future unwary developer might try to edit
recovery.c and revoke.c in the debugfs directory.

Much better to do it this way:

recovery.o: $(srcdir)/../e2fsck/recovery.c
	$(E) "	CC $@"
	$(Q) $(CC) -c $(ALL_CFLAGS) -I$(srcdir) \
		 $(srcdir)/../e2fsck/recovery.c -DDEBUGFS -o $@

revoke.o: $(srcdir)/../e2fsck/revoke.c
	$(E) "	CC $@"
	$(Q) $(CC) -c $(ALL_CFLAGS) -I$(srcdir) \
		 $(srcdir)/../e2fsck/revoke.c -DDEBUGFS -o $@

I'll fix this up when I apply this patch.

Cheers,

						- Ted
