From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: finding the author of the patches in ext4-patch-queue
Date: Wed, 4 Jul 2007 22:54:16 -0600
Message-ID: <20070705045416.GA5633@schatzie.adilger.int>
References: <468B2AF5.5060207@linux.vnet.ibm.com> <1183519649.3922.1.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	Theodore Tso <tytso@mit.edu>,
	Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from 74-0-229-162.T1.lbdsl.net ([74.0.229.162]:33231 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751647AbXGEEyU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 5 Jul 2007 00:54:20 -0400
Content-Disposition: inline
In-Reply-To: <1183519649.3922.1.camel@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Jul 03, 2007  23:27 -0400, Mingming Cao wrote:
> On Wed, 2007-07-04 at 10:37 +0530, Aneesh Kumar K.V wrote:
> > With respect to ext4-patch-queue it is kind of difficult to find who wrote the patch.
> > I guess we can solve this by adding From: < author name > in the patches. This will make sure
> > when the patches get applied to linus tree we have the right author.
> > 
> 
> Thanks, Aneesh, I will add From: <authro> for all patches in ext4 patch
> queue.

You may as well add "Signed-off-by: <author>", since that is the standard
way to do this.  If you have any questions about who wrote a particular
CFS patch I can tell you.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
