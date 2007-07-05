From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Subject: Re: finding the author of the patches in ext4-patch-queue
Date: Thu, 05 Jul 2007 08:40:11 -0500
Message-ID: <1183642811.13486.2.camel@kleikamp.austin.ibm.com>
References: <468B2AF5.5060207@linux.vnet.ibm.com>
	 <1183519649.3922.1.camel@localhost.localdomain>
	 <20070705045416.GA5633@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Mingming Cao <cmm@us.ibm.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	Theodore Tso <tytso@mit.edu>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:55384 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759850AbXGENkS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 5 Jul 2007 09:40:18 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e6.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l65DfSAY019336
	for <linux-ext4@vger.kernel.org>; Thu, 5 Jul 2007 09:41:28 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l65DeEGS559024
	for <linux-ext4@vger.kernel.org>; Thu, 5 Jul 2007 09:40:17 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l65DeEev006736
	for <linux-ext4@vger.kernel.org>; Thu, 5 Jul 2007 09:40:14 -0400
In-Reply-To: <20070705045416.GA5633@schatzie.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, 2007-07-04 at 22:54 -0600, Andreas Dilger wrote:
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

You should never add someone else's Signed-off-by without being
explicitly asked to do so.

Shaggy
-- 
David Kleikamp
IBM Linux Technology Center
