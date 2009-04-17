From: Theodore Tso <tytso@mit.edu>
Subject: Re: fsck.ext4: Group descriptors look bad... trying backup
	blocks...
Date: Fri, 17 Apr 2009 12:36:17 -0400
Message-ID: <20090417163617.GB26479@mit.edu>
References: <gs9nm5$8m1$1@ger.gmane.org> <20090417115659.GB7117@mit.edu> <gs9sdh$u9k$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jeremy Sanders <jss@ast.cam.ac.uk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:39434 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758861AbZDQQgV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 17 Apr 2009 12:36:21 -0400
Content-Disposition: inline
In-Reply-To: <gs9sdh$u9k$1@ger.gmane.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Apr 17, 2009 at 01:24:16PM +0100, Jeremy Sanders wrote:
> Theodore Tso wrote:
> 
> > I see from the dumpe2fs that you sent it had only been in use for a
> > week.  How were you using the filesystem?  Did you try using the
> > online resize feature at any time?
> 
> I assume that this isn't enough to corrupt the filesystem?
> 
> [root@xback2 ~]# tune2fs -i -1 /dev/md0
> tune2fs 1.41.4 (27-Jan-2009)
> Setting interval between checks to 18446744073709465216 seconds

No, but it won't do what you want, either.  To disable time-based
checks, you should use "tune2fs -i 0 /dev/md0".

Tune2fs should have flagged an error when you specified -1; I'll have
to fix that.

	    	       		     - Ted


