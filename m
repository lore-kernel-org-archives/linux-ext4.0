From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [Resubmit][PATCH 5/5] Secure Deletion and Trash-Bin Support
	for Ext4
Date: Thu, 01 Feb 2007 12:41:31 -0800
Message-ID: <1170362491.4271.31.camel@localhost.localdomain>
References: <Pine.GSO.4.53.0701310955130.28263@compserv1>
	 <1170263470.12392.23.camel@kleikamp.austin.ibm.com>
	 <Pine.GSO.4.53.0702011200340.9072@compserv1>
	 <1170358339.12263.39.camel@kleikamp.austin.ibm.com>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Nikolai Joukov <kolya@cs.sunysb.edu>,
	Harry Papaxenopoulos <harry@cs.sunysb.edu>,
	linux-ext4@vger.kernel.org, ezk@cs.sunysb.edu
To: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:58645 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422994AbXBAUld (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 1 Feb 2007 15:41:33 -0500
Received: from westrelay02.boulder.ibm.com (westrelay02.boulder.ibm.com [9.17.195.11])
	by e32.co.us.ibm.com (8.12.11.20060308/8.13.8) with ESMTP id l11KfOUA012427
	for <linux-ext4@vger.kernel.org>; Thu, 1 Feb 2007 15:41:24 -0500
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by westrelay02.boulder.ibm.com (8.13.8/8.13.8/NCO v8.2) with ESMTP id l11KfWLb510728
	for <linux-ext4@vger.kernel.org>; Thu, 1 Feb 2007 13:41:32 -0700
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l11KfWHs013866
	for <linux-ext4@vger.kernel.org>; Thu, 1 Feb 2007 13:41:32 -0700
In-Reply-To: <1170358339.12263.39.camel@kleikamp.austin.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, 2007-02-01 at 19:32 +0000, Dave Kleikamp wrote:
> On Thu, 2007-02-01 at 12:17 -0500, Nikolai Joukov wrote:
> 
> > > I don't have a strong opinion for or against the function and your
> > > design.  The only potential problem I see in the approach is that
> > > the .trash directory may conflict with some other use of the same name.
> > > Since this is primarily vfs function, you'll probably get a wider
> > > audience on linux-fsdevel.
> > 
> > Well, I guess lost+found has the same problem but it is not a problem at
> > all to pick some other (longer) name.
> 
> Right, I didn't see it as a show-stopper, just something to consider.
> > 
> > > Have you considered putting ALL of the function in the vfs layer?  It
> > > looks like this could be done without touching any code in the
> > > individual file systems.
> > 
> > Unfortunately, we need some file system-specific code to access per-file
> > secure deletion and per-file trash bit attributes.  These attributes are
> > supported only by some file systems and in different ways.  
> 

The check for fs specific attributes has to be underlying fs code.  But
the code the handling the secure delete and trash bin (although now is
only two functions being called) are identical for all fs, could be move
to VFS layer.

> Yeah, I did see that.  I wonder adding some inode or file operation just
> to query the existence of those attributes (or something more generic)
> would be too ugly.
> 

I gave a brief thought on that yesterday, it was not very pretty:)


Thanks,
Mingming
