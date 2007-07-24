From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: New e2fsprog doc on the ext4 wiki page.
Date: Tue, 24 Jul 2007 21:48:58 +0530
Message-ID: <46A62672.70808@linux.vnet.ibm.com>
References: <20070724110741.65ade06e@rx8>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: "Jose R. Santos" <jrs@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:49355 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911AbXGXQTF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 24 Jul 2007 12:19:05 -0400
Received: from d23relay01.au.ibm.com (d23relay01.au.ibm.com [202.81.18.232])
	by ausmtp04.au.ibm.com (8.13.8/8.13.8) with ESMTP id l6OGgRA0090232
	for <linux-ext4@vger.kernel.org>; Wed, 25 Jul 2007 02:42:27 +1000
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.250.237])
	by d23relay01.au.ibm.com (8.13.8/8.13.8/NCO v8.4) with ESMTP id l6OGIPCm139032
	for <linux-ext4@vger.kernel.org>; Wed, 25 Jul 2007 02:18:25 +1000
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l6OGJ2tv026107
	for <linux-ext4@vger.kernel.org>; Wed, 25 Jul 2007 02:19:02 +1000
In-Reply-To: <20070724110741.65ade06e@rx8>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org



Jose R. Santos wrote:
> Hi folks
> 
>
> 
> ext4migrate:
> - Patches submited to the mailing list by Aneesh Kumar
> http://thread.gmane.org/gmane.comp.file-systems.ext4/1395
> 


I guess what we are looking at here is 

a) ext3 -> ext4 conversion would be done via option for defrag. This
conversion is now done via a ioctl. This is the suggested method for
defragmenting an ext3 inode (convert to ext4 and then defrag). 

b) small inode to large inode conversion is done via tune2fs -I < new_inode_size>
   I have patches for this ready. Will be sending them in a day or two.

So the ext4migrate command may not be really needed.


-aneesh
