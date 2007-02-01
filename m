From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Subject: Re: [Resubmit][PATCH 5/5] Secure Deletion and Trash-Bin Support
	for Ext4
Date: Thu, 01 Feb 2007 19:32:19 +0000
Message-ID: <1170358339.12263.39.camel@kleikamp.austin.ibm.com>
References: <Pine.GSO.4.53.0701310955130.28263@compserv1>
	 <1170263470.12392.23.camel@kleikamp.austin.ibm.com>
	 <Pine.GSO.4.53.0702011200340.9072@compserv1>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Harry Papaxenopoulos <harry@cs.sunysb.edu>,
	linux-ext4@vger.kernel.org, ezk@cs.sunysb.edu
To: Nikolai Joukov <kolya@cs.sunysb.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:43828 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422957AbXBATcX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 1 Feb 2007 14:32:23 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e6.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l11JX1T7017828
	for <linux-ext4@vger.kernel.org>; Thu, 1 Feb 2007 14:33:01 -0500
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.2) with ESMTP id l11JWLHC274564
	for <linux-ext4@vger.kernel.org>; Thu, 1 Feb 2007 14:32:21 -0500
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l11JWKRm021274
	for <linux-ext4@vger.kernel.org>; Thu, 1 Feb 2007 14:32:21 -0500
In-Reply-To: <Pine.GSO.4.53.0702011200340.9072@compserv1>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, 2007-02-01 at 12:17 -0500, Nikolai Joukov wrote:

> > I don't have a strong opinion for or against the function and your
> > design.  The only potential problem I see in the approach is that
> > the .trash directory may conflict with some other use of the same name.
> > Since this is primarily vfs function, you'll probably get a wider
> > audience on linux-fsdevel.
> 
> Well, I guess lost+found has the same problem but it is not a problem at
> all to pick some other (longer) name.

Right, I didn't see it as a show-stopper, just something to consider.
> 
> > Have you considered putting ALL of the function in the vfs layer?  It
> > looks like this could be done without touching any code in the
> > individual file systems.
> 
> Unfortunately, we need some file system-specific code to access per-file
> secure deletion and per-file trash bit attributes.  These attributes are
> supported only by some file systems and in different ways.  

Yeah, I did see that.  I wonder adding some inode or file operation just
to query the existence of those attributes (or something more generic)
would be too ugly.

> We need no
> file system-specific code to support trash-bin deletion for whole file
> systems.
> 
> Nikolai.
-- 
David Kleikamp
IBM Linux Technology Center
