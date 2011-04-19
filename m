From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: Ext4 Punch Hole Support: Change summary and test case summary
Date: Tue, 19 Apr 2011 02:29:05 -0600
Message-ID: <F28E8BBB-A8B7-44AA-A84C-DB247B2A88CC@dilger.ca>
References: <4DAD3BD7.3080107@linux.vnet.ibm.com>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Allison Henderson <achender@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:2073 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752833Ab1DSI3H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 19 Apr 2011 04:29:07 -0400
In-Reply-To: <4DAD3BD7.3080107@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-04-19, at 1:37 AM, Allison Henderson wrote:
> Big Hole Test
> ---------------------------------------------------------------
> A hole large hole is punched in a large file (exact file size=638169088 bytes, exact hole size = 638150422 bytes, offset = 6144 bytes), 
> resulting in all but 5 blocks being punched out (2 in the front, 3 in the back).  This test case verifies that the code can properly
> punch out a hole covering multiple extents.
> 
> This test is successful when the following conditions are met:
> - File frag shows extents only for the first two blocks and the last 3 blocks
> - The test file contains zeros from bytes 6144 to 638156566
> (* ls and df is not measured here because some blocks will still be reserved
> as index blocks causing the consumed space to be appear larger)

Shouldn't the remaining two extents fit inside the inode, so there is no need for index blocks, or does the extent removal code not shrink the index blocks?

Cheers, Andreas





