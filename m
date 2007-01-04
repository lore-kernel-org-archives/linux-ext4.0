From: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/1] Extent overlap bugfix in ext4
Date: Thu, 4 Jan 2007 13:43:14 +0530
Message-ID: <20070104081314.GB5345@amitarora.in.ibm.com>
References: <20070102090909.GA20503@amitarora.in.ibm.com> <m364bpn5ku.fsf@bzzz.home.net> <20070102094727.GA5932@amitarora.in.ibm.com> <m3irfobg29.fsf@bzzz.home.net> <459BF0C5.2060302@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Alex Tomas <alex@clusterfs.com>, linux-ext4@vger.kernel.org,
	suparna@in.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:32945 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932322AbXADINU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 4 Jan 2007 03:13:20 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e4.ny.us.ibm.com (8.13.8/8.12.11) with ESMTP id l048DJs8001095
	for <linux-ext4@vger.kernel.org>; Thu, 4 Jan 2007 03:13:19 -0500
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay04.pok.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id l048DJFK276920
	for <linux-ext4@vger.kernel.org>; Thu, 4 Jan 2007 03:13:19 -0500
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l048DIIJ019519
	for <linux-ext4@vger.kernel.org>; Thu, 4 Jan 2007 03:13:19 -0500
To: Mingming Cao <cmm@us.ibm.com>
Content-Disposition: inline
In-Reply-To: <459BF0C5.2060302@us.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Jan 03, 2007 at 10:07:01AM -0800, Mingming Cao wrote:
> Alex Tomas wrote:
> >I think that stuff that converts uninitialized blocks
> >to initialized ones should be a separate codepath and
> >shouldn't be done in the insert path. and an insert
> >(basic tree manipulation) should BUG_ON() one tries
> >to add extent with a block which is already covered
> >by the tree.
> >
> >IMHO, get_blocks() should look like:
> >
> >  path = find_path()
> >  if (found extent covers request block(s)) {
> >    if (extent is uninitialized) {
> >      convert();
> >    }
> >  }
> >
> >where
> >   function convert()
> >  {
> >    /* adopt existing extent so that it
> >     * doesn't cover requested blocks */
> >
> >    /* insert head or tail of existing
> >     * extent, if necessary */
> >
> >    /* insert new extent of initialized blocks */
> >  }
> >
> >thanks, Alex
> 
> I was thing about the same thing. The current ext4_ext_get_blocks()
> function becomes very bulky. The code to convert uninitialized blocks to
> initialized ones is pretty selfcontained, and worth the effort to put it
> into a seperate function.

Ok. I will move this code to a new function.

--
Regards,
Amit Arora
