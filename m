From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] e2fsprogs: Fix tst_extents output on bigendian machine.
Date: Sat, 19 Jul 2008 11:51:40 +0530
Message-ID: <20080719062140.GB823@skywalker>
References: <1216382740-24369-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20080719011921.GB18506@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP01.au.ibm.com ([202.81.18.162]:58904 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756AbYGSGVv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 19 Jul 2008 02:21:51 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp01.au.ibm.com (8.13.1/8.13.1) with ESMTP id m6J6ME09028130
	for <linux-ext4@vger.kernel.org>; Sat, 19 Jul 2008 16:22:14 +1000
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m6J6LmIO289916
	for <linux-ext4@vger.kernel.org>; Sat, 19 Jul 2008 16:21:49 +1000
Received: from d23av02.au.ibm.com (loopback [127.0.0.1])
	by d23av02.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m6J6LmED029833
	for <linux-ext4@vger.kernel.org>; Sat, 19 Jul 2008 16:21:48 +1000
Content-Disposition: inline
In-Reply-To: <20080719011921.GB18506@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jul 18, 2008 at 09:19:21PM -0400, Theodore Tso wrote:
> On Fri, Jul 18, 2008 at 05:35:40PM +0530, Aneesh Kumar K.V wrote:
> > Add type __le16, __le32, and __le64 to indicate that
> > the variables need to be byteswaped when using.
> 
> I took out the __le16 types.  The artificial types don't really buy us
> much (a lot of work would be needed before we could use sparse on
> e2fsprogs) and for now just makes it harder to read the header file.
> I removed the __le types deliberately.
> 

The reason for me to use __le* types was to explicitly document that
these variables need to be accessed through the conversion APIs. In this
case I had to search rest of the code to figure out whether all of them
need to be accessed via the conversion APIs or not. Getting sparse to
run on e2fsprogs can be a long term goal. But more important is to
indicate how these variables need to be accessed in the program.


-aneesh
