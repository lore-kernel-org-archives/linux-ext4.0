From: tytso@mit.edu
Subject: Re: Bug#738758: [PATCH] ext4: kill i_version support for
 Hurd-castrated file systems
Date: Fri, 21 Mar 2014 10:39:27 -0400
Message-ID: <20140321143927.GA31179@thunk.org>
References: <20140319202009.GA21361@jessie01>
 <1395290051-25682-1-git-send-email-tytso@mit.edu>
 <3DF297F8-04E0-4EE6-8CD5-127997293D5A@dilger.ca>
 <20140320081048.GA21164@infradead.org>
 <20140320144456.GA20618@thunk.org>
 <1395336632.2770.13.camel@deadeye.wl.decadent.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: 738758@bugs.debian.org, Christoph Hellwig <hch@infradead.org>,
	Andreas Dilger <adilger@dilger.ca>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	"1o5g4r8o@gmail.com" <1o5g4r8o@gmail.com>
To: Ben Hutchings <ben@decadent.org.uk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:44450 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751634AbaCUOjo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 21 Mar 2014 10:39:44 -0400
Content-Disposition: inline
In-Reply-To: <1395336632.2770.13.camel@deadeye.wl.decadent.org.uk>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Mar 20, 2014 at 05:30:32PM +0000, Ben Hutchings wrote:
> 
> It looks like ext2 and ext3 would always initialise i_version to 1 in
> memory; does it matter that you're changing that to 0 for Hurd
> filesystems?

No, NFS only cares that the i_version number has changed, and it's
mainly important if you have two clients trying to simultaneously
access the same file, so they get a signal that they need to
invalidate their locally cached metadata (or data, in the case of
NFSv4).  But Hurd only supports NFSv2, and the performance is such
that I doubt anyone would be all that interested in using a Hurd
server as a NFS server for even a small workgroup, let alone a
department, so this is unlikely to be a big deal.

Cheers,

					- Ted
