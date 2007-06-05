From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Subject: Re: [RFC][PATCH] Set JBD2_FEATURE_INCOMPAT_64BIT on filesystems
	larger than 32-bit blocks (take 2).
Date: Tue, 05 Jun 2007 08:14:43 -0500
Message-ID: <1181049283.18452.0.camel@kleikamp.austin.ibm.com>
References: <20070601105234.4be40028@rx8>
	 <20070601225441.GF5181@schatzie.adilger.int> <20070604113210.1a76934b@gara>
	 <20070604175728.GT5181@schatzie.adilger.int>
	 <1180998105.3770.27.camel@dyn9047017103.beaverton.ibm.com>
	 <20070605064109.2cb6bad7@gara>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: cmm@us.ibm.com, Andreas Dilger <adilger@clusterfs.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: "Jose R. Santos" <jrs@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:34846 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758675AbXFENOp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 5 Jun 2007 09:14:45 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e2.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l55DEjEx019662
	for <linux-ext4@vger.kernel.org>; Tue, 5 Jun 2007 09:14:45 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l55DEjdG551938
	for <linux-ext4@vger.kernel.org>; Tue, 5 Jun 2007 09:14:45 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l55DEio9026925
	for <linux-ext4@vger.kernel.org>; Tue, 5 Jun 2007 09:14:45 -0400
In-Reply-To: <20070605064109.2cb6bad7@gara>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, 2007-06-05 at 06:41 -0500, Jose R. Santos wrote:
> On Mon, 04 Jun 2007 16:01:45 -0700
> Mingming Cao <cmm@us.ibm.com> wrote:
> 
> > On Mon, 2007-06-04 at 11:57 -0600, Andreas Dilger wrote:
> > > On Jun 04, 2007  11:32 -0500, Jose R. Santos wrote:
> > > > Set the journals JBD2_FEATURE_INCOMPAT_64BIT on devices with more
> > > > than 32bit block sizes during mount time.  This ensure proper record
> > > > lenth when writing to the journal.
> > > > 
> > > > Signed-off-by: Jose R. Santos <jrs@us.ibm.com>
> > > > ---
> > > >  fs/ext4/super.c |   11 +++++++++++
> > > >  1 file changed, 11 insertions(+)
> > > > 
> > > > Index: linux-2.6.22-rc3/fs/ext4/super.c
> > > > ===================================================================
> > > > --- linux-2.6.22-rc3.orig/fs/ext4/super.c	2007-06-04 11:01:20.028360650 -0500
> > > > +++ linux-2.6.22-rc3/fs/ext4/super.c	2007-06-04 11:05:11.389126418 -0500
> > > > @@ -1824,6 +1824,17 @@ static int ext4_fill_super (struct super
> > > >  		goto failed_mount3;
> > > >  	}
> > > >  
> > > > +        /*
> > > > +	 * Make sure to set JBD2_FEATURE_INCOMPAT_64BIT on filesystems
> > > > +	 * with more that 32-bit block counts
> > > > +	 */
> > > > +	if(es->s_blocks_count_hi &&
> > 
> > This need to be le32_to_cpu(es->s_blocks_count_hi)
> 
> I'm curious,
> 
> Why do we need to do an endian conversion to check for a non-zero value
> in s_blocks_count_hi?  Seems unnecessary here.

Jose is right.  The endian conversion is unnecessary.

Shaggy
-- 
David Kleikamp
IBM Linux Technology Center
