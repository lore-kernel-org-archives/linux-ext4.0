From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] ext4: fix blkdev_issue_flush() failure handling
Date: Mon, 30 Mar 2009 13:46:07 -0400
Message-ID: <20090330174607.GR13356@mit.edu>
References: <200903291928.14451.bzolnier@gmail.com> <49CFB33A.9020406@redhat.com> <20090330022521.GB13356@mit.edu> <49D03AE1.8070009@redhat.com> <1238413667.30488.2.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1755349AbZC3Rqc@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1238413667.30488.2.camel@think.oraclecorp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Mar 30, 2009 at 07:47:47AM -0400, Chris Mason wrote:
> > Yes, it was.  Although I got the idea when hch pointed out that SuSE did
> > this... thanks to Chris.  It's come full circle.  :)
> 
> Grin.  I'm not sure the I_DIRTY checks alone are enough to decide that a
> commit is required though.  I think the inode could be clean but still
> have metadata that needs commit.

So to close this hole, I think what we can do is to track the last
transaction id where ext4_do_update_inode() was called, and if that
transaction id == the currently running transaction id, then we need
to call ext4_force_commit() even though the inode is clean.  I think
that should fix up the race that you're concerned about.

     	    	       	    	 		  - Ted
