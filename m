From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: Ext4 Punch Hole Support: Change summary and test case summary
Date: Tue, 19 Apr 2011 10:49:33 -0700
Message-ID: <1303235373.2534.8.camel@mingming-laptop>
References: <4DAD3BD7.3080107@linux.vnet.ibm.com>
	 <F28E8BBB-A8B7-44AA-A84C-DB247B2A88CC@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Allison Henderson <achender@linux.vnet.ibm.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:53570 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753913Ab1ECQ4x (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 3 May 2011 12:56:53 -0400
Received: from d01relay05.pok.ibm.com (d01relay05.pok.ibm.com [9.56.227.237])
	by e2.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p43Gb7Fe019876
	for <linux-ext4@vger.kernel.org>; Tue, 3 May 2011 12:37:07 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay05.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p43GugSB100596
	for <linux-ext4@vger.kernel.org>; Tue, 3 May 2011 12:56:42 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p43GugqA014104
	for <linux-ext4@vger.kernel.org>; Tue, 3 May 2011 13:56:42 -0300
In-Reply-To: <F28E8BBB-A8B7-44AA-A84C-DB247B2A88CC@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 2011-04-19 at 02:29 -0600, Andreas Dilger wrote:
> On 2011-04-19, at 1:37 AM, Allison Henderson wrote:
> > Big Hole Test
> > ---------------------------------------------------------------
> > A hole large hole is punched in a large file (exact file size=638169088 bytes, exact hole size = 638150422 bytes, offset = 6144 bytes), 
> > resulting in all but 5 blocks being punched out (2 in the front, 3 in the back).  This test case verifies that the code can properly
> > punch out a hole covering multiple extents.
> > 
> > This test is successful when the following conditions are met:
> > - File frag shows extents only for the first two blocks and the last 3 blocks
> > - The test file contains zeros from bytes 6144 to 638156566
> > (* ls and df is not measured here because some blocks will still be reserved
> > as index blocks causing the consumed space to be appear larger)
> 
> Shouldn't the remaining two extents fit inside the inode, so there is no need for index blocks, or does the extent removal code not shrink the index blocks?
> 

It seems so, the extent removal code today not shrink the index blocks 
> Cheers, Andreas
> 
> 
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


