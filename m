From: Theodore Tso <tytso@mit.edu>
Subject: Re: Performance of ext4
Date: Thu, 19 Jun 2008 13:42:11 -0400
Message-ID: <20080619174211.GB9119@mit.edu>
References: <20080612131928.GB18229@mit.edu> <Pine.LNX.4.64.0806121333480.27806@diagnostix.dwd.de> <20080612180605.GD22481@skywalker> <Pine.LNX.4.64.0806121940020.2974@diagnostix.dwd.de> <Pine.LNX.4.64.0806130753100.7097@diagnostix.dwd.de> <20080616175408.GF3279@atrey.karlin.mff.cuni.cz> <20080616181353.GA20686@skywalker> <Pine.LNX.4.64.0806171001200.6307@diagnostix.dwd.de> <20080619155645.GA8582@mit.edu> <485A8C2D.1090806@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Holger Kiehl <Holger.Kiehl@dwd.de>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	Jan Kara <jack@suse.cz>, Solofo.Ramangalahy@bull.net,
	Nick Dokos <nicholas.dokos@hp.com>, linux-ext4@vger.kernel.org,
	linux-kernel <linux-kernel@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:48678 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751828AbYFSRnq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 19 Jun 2008 13:43:46 -0400
Content-Disposition: inline
In-Reply-To: <485A8C2D.1090806@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jun 19, 2008 at 11:41:17AM -0500, Eric Sandeen wrote:
> 
> It might be worth runninga "simple" fsx under your kernel too; last time
> I tested fsx it was still happy and it exercises fs ops (including
> truncate) at random...
> 

>From what Holger described, it's doubtful that the bug is in the
truncate operation.  It sounds like i_size is actually dropping in
size at some pointer long after the file was written.  If I had to
guess the value in the inode cache is correct; and perhaps so is the
value on the journal.  But somehow, the wrong value is getting written
to disk (remember the jbd layer can keep up to three different
versions of filesystem metadata in memory, because most of the time we
don't block modifications to the filesystem while we are in the middle
of writing a previous commit to disk).  So depending on whether the
inode gets redirtied or not, the inconsistency could self-heal, and if
the inode never gets pushed out of memory due to memory pressure, the
problem might not be noticed until the system reboots or the
filesystem is unmounted.

This is one of the reasons why I'm a bit suspicious that the problem
may lie in the delayed allocation code; changing i_size without first
starting a transaction could lead to this sort of problem, for
example, and the delayed allocation could represent a different code
path where file blocks get allocated and i_size gets changed.

     	   	       	   	     	 	- Ted
