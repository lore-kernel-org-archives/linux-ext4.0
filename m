From: Theodore Tso <tytso@mit.edu>
Subject: Re: Enable asynchronous commits by default patch revoked?
Date: Wed, 26 Aug 2009 09:14:03 -0400
Message-ID: <20090826131403.GN32712@mit.edu>
References: <4A92F7E0.9010001@redhat.com> <20090824220738.GG17684@mit.edu> <4A93103B.2000909@redhat.com> <20090824232804.GJ17684@mit.edu> <20090824234336.GU5931@webber.adilger.int> <20090825001554.GN17684@mit.edu> <20090825175247.GX5931@webber.adilger.int> <4A94287C.9060509@redhat.com> <20090825211132.GV17684@mit.edu> <20090826095035.GH5931@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ric Wheeler <rwheeler@redhat.com>,
	Christian Fischer <Christian.Fischer@easterngraphics.com>,
	linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:34003 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932896AbZHZNOU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 26 Aug 2009 09:14:20 -0400
Content-Disposition: inline
In-Reply-To: <20090826095035.GH5931@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Aug 26, 2009 at 03:50:35AM -0600, Andreas Dilger wrote:
> On Aug 25, 2009  17:11 -0400, Theodore Ts'o wrote:
> > The problem is without my patch, the barrier=1 mount option is
> > completely ignored, and there's no way to enable barriers with
> > async_commit --- which is clearly wrong.  So with my patch, it now
> > becomes safe for people to experiment with async_commit --- and if
> > they also to experiment with the barrier=0 w/ "hdparm -W 0" they can
> > do so.  For any given workload and hardware combination, there is
> > therefore three safe configuarions that people can try benchmarking:
> > 
> >      !async_commit,barrier=1,"hdparm -W 1"	(currently the default)
> >      async_commit,barrier=1,"hdparm -W 1"
> >      async_commit,barrier=0,"hdparm -W 0"
> > 
> > (n.b., !async_commit,barrier=0,"hdparm -W 0" is not completely safe,
> > since without the barrier, it's possible, although granted not very
> > likely, for the block layer elevator algorithm to reorder blocks in
> > block device queue.)
> 
> I'm not sure I understand about the "n.b." case.  If the filesystem
> is running with !async_commit,barrier=0,wcache=0 (which is basically
> ext3 with write cache off), it should still have the jbd code doing
> an explicit wait for the data blocks (which should be guaranteed to
> make it to disk, wcache being off) before even submitting the commit
> block to the elevator?  It doesn't matter what order the transaction
> blocks are written to disk, so long as the commit block is last.

Gack, sorry, I screwed that up.  What I should have written is this:

The safe configurations people could try benchmarking:

      !async_commit,barrier=1,"hdparm -W 1"	(currently the default)
      !async_commit,barrier=0,"hdparm -W 0"
      async_commit,barrier=1,"hdparm -W 1"

and the unsafe case in the nb should have been <async_commit,
barrier=0, "hdparm -W 0">, since without the barrier, async_commit
writes the commit block at the same time as the rest of the journal
(data, metadata, and revoke) blocks, and so there is the chance the
commit block could get reordered in front of the other journal blocks.

       	     	       		    	  - Ted
