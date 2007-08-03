From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [patch] i_version mount option
Date: Fri, 03 Aug 2007 10:57:16 -0700
Message-ID: <46B36C7C.2090701@us.ibm.com>
References: <46ADFA27.8080601@bull.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Jean noel Cordenner <jean-noel.cordenner@bull.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:57873 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758263AbXHCR5T (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 3 Aug 2007 13:57:19 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e32.co.us.ibm.com (8.12.11.20060308/8.13.8) with ESMTP id l73Gp1Xn003465
	for <linux-ext4@vger.kernel.org>; Fri, 3 Aug 2007 12:51:01 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v8.4) with ESMTP id l73HvIhI260074
	for <linux-ext4@vger.kernel.org>; Fri, 3 Aug 2007 11:57:18 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l73HvIJJ010146
	for <linux-ext4@vger.kernel.org>; Fri, 3 Aug 2007 11:57:18 -0600
In-Reply-To: <46ADFA27.8080601@bull.net>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Jean noel Cordenner wrote:
> hi,
> 
> This patch apply on the top of the ext4 git tree.
> It adds a mount option to enable i_version feature for ext4.
> 


I think we should fix overwrite case first. Per lkml discussion, if we 
fix the overwrite case by updating the counter in file_update_time() all 
the time, then the concern is this will impact other filesystems that 
don't want inode versioning support.

I believe that's how leads to put this patch back (adding a mount option).

It's better to have a VFS level super block flag to indicating if the 
filesystem as inode versioning support or not.

Thanks
Mingming
> Signed-off-by: Jean noel Cordenner <jean-noel.cordenner@bull.net>
> 
