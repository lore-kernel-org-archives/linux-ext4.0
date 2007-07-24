From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: Re: New e2fsprog doc on the ext4 wiki page.
Date: Tue, 24 Jul 2007 11:35:07 -0500
Message-ID: <20070724113507.72ed9687@rx8>
References: <20070724110741.65ade06e@rx8>
	<46A62672.70808@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:60160 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751609AbXGXQhH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 24 Jul 2007 12:37:07 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e36.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id l6OGb6N6002544
	for <linux-ext4@vger.kernel.org>; Tue, 24 Jul 2007 12:37:06 -0400
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v8.4) with ESMTP id l6OGb6u8205964
	for <linux-ext4@vger.kernel.org>; Tue, 24 Jul 2007 10:37:06 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l6OGb64d017885
	for <linux-ext4@vger.kernel.org>; Tue, 24 Jul 2007 10:37:06 -0600
Received: from austin.ibm.com (netmail2.austin.ibm.com [9.41.248.176])
	by d03av01.boulder.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id l6OGb5wA017854
	for <linux-ext4@vger.kernel.org>; Tue, 24 Jul 2007 10:37:06 -0600
In-Reply-To: <46A62672.70808@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, 24 Jul 2007 21:48:58 +0530
"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com> wrote:

> 
> 
> Jose R. Santos wrote:
> > Hi folks
> > 
> >
> > 
> > ext4migrate:
> > - Patches submited to the mailing list by Aneesh Kumar
> > http://thread.gmane.org/gmane.comp.file-systems.ext4/1395
> > 
> 
> 
> I guess what we are looking at here is 
> 
> a) ext3 -> ext4 conversion would be done via option for defrag. This
> conversion is now done via a ioctl. This is the suggested method for
> defragmenting an ext3 inode (convert to ext4 and then defrag). 
> 
> b) small inode to large inode conversion is done via tune2fs -I <
> new_inode_size> I have patches for this ready. Will be sending them
> in a day or two.
> 
> So the ext4migrate command may not be really needed.
> 
> 
> -aneesh  

I will remove this item then and add the tune2fs changes.

Is the defrag code going to be part of e2fsprogs or is this going to be
a standalone app?

-JRS
