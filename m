From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: Online defragmentation and ext4migrate
Date: Mon, 21 May 2007 16:07:29 +0530
Message-ID: <46517669.50804@linux.vnet.ibm.com>
References: <464DA4ED.9040408@linux.vnet.ibm.com> <019c01c79b92$627b3280$4168010a@bsd.tnes.nec.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Takashi Sato <sho@tnes.nec.co.jp>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ausmtp05.au.ibm.com ([202.81.18.154]:42839 "EHLO
	ausmtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754950AbXEUK70 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 21 May 2007 06:59:26 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by ausmtp05.au.ibm.com (8.13.8/8.13.8) with ESMTP id l4LB0tG97807082
	for <linux-ext4@vger.kernel.org>; Mon, 21 May 2007 21:00:55 +1000
Received: from d23av01.au.ibm.com (d23av01.au.ibm.com [9.190.250.242])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l4LAxgC8066966
	for <linux-ext4@vger.kernel.org>; Mon, 21 May 2007 21:02:47 +1000
Received: from d23av01.au.ibm.com (loopback [127.0.0.1])
	by d23av01.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l4LAbaCl028504
	for <linux-ext4@vger.kernel.org>; Mon, 21 May 2007 20:37:37 +1000
In-Reply-To: <019c01c79b92$627b3280$4168010a@bsd.tnes.nec.co.jp>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org



Takashi Sato wrote:
> Hi Aneesh san,
> 
> 
> In my opinion, to keep the ioctl simple and small is very important
> for ease of maintenance.  So I would rather not support indirect
> block files in the ioctl.
> Instead, I can add the call of the migration ioctl to my defrag tool in 
> order
> to defragment indirect block files.  How do you think of it?
> 


That should be fine. So i will start moving the ext4migrate code as a 
ext4 ioctl and later will send you a patch to the defrag tool that will 
migrate and defrag.


-aneesh
