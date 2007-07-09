From: Theodore Tso <tytso@mit.edu>
Subject: Re: [e2fsprogs] Bug in salvage_directory
Date: Mon, 9 Jul 2007 16:20:25 -0400
Message-ID: <20070709202025.GD2343@thunk.org>
References: <1183973522.3889.10.camel@garfield.linsyssoft.com> <20070709165016.GA21922@thunk.org> <1184003549.4347.6.camel@garfield> <20070709182923.GB2343@thunk.org> <20070709191733.GY5633@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Kalpak Shah <kalpak@clusterfs.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:35581 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752917AbXGIUU2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 9 Jul 2007 16:20:28 -0400
Content-Disposition: inline
In-Reply-To: <20070709191733.GY5633@schatzie.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Jul 09, 2007 at 01:17:33PM -0600, Andreas Dilger wrote:
> On Jul 09, 2007  14:29 -0400, Theodore Tso wrote:
> > On Mon, Jul 09, 2007 at 11:22:05PM +0530, Kalpak Shah wrote:
> > > Yes even prev->rec_len cannot be beyond fs->blocksize. 
> > 
> > Really?  Even after this:
> > 
> >                prev->rec_len += dirent->rec_len;
> >                              ^^^^^^^^^^^^^^^^^^^
> 
> I think Kalpak was agreeing with you...

Sorry, I misread his note.

       	 				- Ted
