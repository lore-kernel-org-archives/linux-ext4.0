From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: Re: [RFC][PATCH] Set JBD2_FEATURE_INCOMPAT_64BIT on filesystems
 larger than 32-bit blocks (take 2).
Date: Tue, 5 Jun 2007 06:41:09 -0500
Message-ID: <20070605064109.2cb6bad7@gara>
References: <20070601105234.4be40028@rx8>
	<20070601225441.GF5181@schatzie.adilger.int>
	<20070604113210.1a76934b@gara>
	<20070604175728.GT5181@schatzie.adilger.int>
	<1180998105.3770.27.camel@dyn9047017103.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger@clusterfs.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: cmm@us.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:50114 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760444AbXFELl1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 5 Jun 2007 07:41:27 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e36.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id l55BfOSf003051
	for <linux-ext4@vger.kernel.org>; Tue, 5 Jun 2007 07:41:24 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l55BfMN1266816
	for <linux-ext4@vger.kernel.org>; Tue, 5 Jun 2007 05:41:24 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l55BfLMc001445
	for <linux-ext4@vger.kernel.org>; Tue, 5 Jun 2007 05:41:22 -0600
In-Reply-To: <1180998105.3770.27.camel@dyn9047017103.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, 04 Jun 2007 16:01:45 -0700
Mingming Cao <cmm@us.ibm.com> wrote:

> On Mon, 2007-06-04 at 11:57 -0600, Andreas Dilger wrote:
> > On Jun 04, 2007  11:32 -0500, Jose R. Santos wrote:
> > > Set the journals JBD2_FEATURE_INCOMPAT_64BIT on devices with more
> > > than 32bit block sizes during mount time.  This ensure proper record
> > > lenth when writing to the journal.
> > > 
> > > Signed-off-by: Jose R. Santos <jrs@us.ibm.com>
> > > ---
> > >  fs/ext4/super.c |   11 +++++++++++
> > >  1 file changed, 11 insertions(+)
> > > 
> > > Index: linux-2.6.22-rc3/fs/ext4/super.c
> > > ===================================================================
> > > --- linux-2.6.22-rc3.orig/fs/ext4/super.c	2007-06-04 11:01:20.028360650 -0500
> > > +++ linux-2.6.22-rc3/fs/ext4/super.c	2007-06-04 11:05:11.389126418 -0500
> > > @@ -1824,6 +1824,17 @@ static int ext4_fill_super (struct super
> > >  		goto failed_mount3;
> > >  	}
> > >  
> > > +        /*
> > > +	 * Make sure to set JBD2_FEATURE_INCOMPAT_64BIT on filesystems
> > > +	 * with more that 32-bit block counts
> > > +	 */
> > > +	if(es->s_blocks_count_hi &&
> 
> This need to be le32_to_cpu(es->s_blocks_count_hi)

I'm curious,

Why do we need to do an endian conversion to check for a non-zero value
in s_blocks_count_hi?  Seems unnecessary here.

-JRS
