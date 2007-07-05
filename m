From: Theodore Tso <tytso@mit.edu>
Subject: Re: finding the author of the patches in ext4-patch-queue
Date: Thu, 5 Jul 2007 10:26:02 -0400
Message-ID: <20070705142602.GE341@thunk.org>
References: <468B2AF5.5060207@linux.vnet.ibm.com> <1183519649.3922.1.camel@localhost.localdomain> <20070705045416.GA5633@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Mingming Cao <cmm@us.ibm.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:52659 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752778AbXGEO0S (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 5 Jul 2007 10:26:18 -0400
Content-Disposition: inline
In-Reply-To: <20070705045416.GA5633@schatzie.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Jul 04, 2007 at 10:54:16PM -0600, Andreas Dilger wrote:
> On Jul 03, 2007  23:27 -0400, Mingming Cao wrote:
> > On Wed, 2007-07-04 at 10:37 +0530, Aneesh Kumar K.V wrote:
> > > With respect to ext4-patch-queue it is kind of difficult to find who wrote the patch.
> > > I guess we can solve this by adding From: < author name > in the patches. This will make sure
> > > when the patches get applied to linus tree we have the right author.
> > > 
> > 
> > Thanks, Aneesh, I will add From: <authro> for all patches in ext4 patch
> > queue.
> 
> You may as well add "Signed-off-by: <author>", since that is the standard
> way to do this.  If you have any questions about who wrote a particular
> CFS patch I can tell you.

In general the first Signed-off-by: is the author, yes.  I believe
what Aneesh is talking about is formatting the patches so that when
they are pulled into git, "git log" shows the correct author information.

     	 	     	       	    - Ted
