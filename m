From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] ext4: Fix small file fragmentation
Date: Sat, 16 Aug 2008 10:13:09 +0530
Message-ID: <20080816044309.GC6423@skywalker>
References: <1218735880-10915-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20080814231816.GA13048@mit.edu> <20080815175243.GD6511@skywalker> <20080815180745.GE6511@skywalker> <20080815200502.GC22395@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, sandeen@redhat.com, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:36357 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952AbYHPEnS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 16 Aug 2008 00:43:18 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp06.au.ibm.com (8.13.1/8.13.1) with ESMTP id m7G4gXdg008382
	for <linux-ext4@vger.kernel.org>; Sat, 16 Aug 2008 14:42:33 +1000
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.234.97])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m7G4hF6h166990
	for <linux-ext4@vger.kernel.org>; Sat, 16 Aug 2008 14:43:15 +1000
Received: from d23av03.au.ibm.com (loopback [127.0.0.1])
	by d23av03.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m7G4hEOZ027086
	for <linux-ext4@vger.kernel.org>; Sat, 16 Aug 2008 14:43:15 +1000
Content-Disposition: inline
In-Reply-To: <20080815200502.GC22395@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Aug 15, 2008 at 04:05:02PM -0400, Theodore Tso wrote:
> Aneesh, thanks!  Chris Mason also pointed us at this proposed patch,
> where he seems to be tracking a very similar issue for btrfs.  I don't
> know if you've seen it....
> 
> http://article.gmane.org/gmane.linux.file-systems/25560
> 

I have a done a similar change in the patch I sent. I also observed
wrong values in the writeback_index for range_cyclic mode. Well
as suggested in the thread I will move it to file system.

But I don't seen anything being mentioned about the fragmentation issue
in the thread.

-aneesh
