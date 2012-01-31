From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: Delayed Extent Tree and Extent Lock Tree
Date: Tue, 31 Jan 2012 15:33:25 -0700
Message-ID: <4F286C35.8080402@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e8.ny.us.ibm.com ([32.97.182.138]:34763 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753461Ab2AaWeY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 31 Jan 2012 17:34:24 -0500
Received: from /spool/local
	by e8.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <achender@linux.vnet.ibm.com>;
	Tue, 31 Jan 2012 17:34:22 -0500
Received: from d01relay01.pok.ibm.com (d01relay01.pok.ibm.com [9.56.227.233])
	by d01dlp01.pok.ibm.com (Postfix) with ESMTP id 1583138C808C
	for <linux-ext4@vger.kernel.org>; Tue, 31 Jan 2012 17:33:28 -0500 (EST)
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay01.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id q0VMXRnA282644
	for <linux-ext4@vger.kernel.org>; Tue, 31 Jan 2012 17:33:27 -0500
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id q0VMXR9F020682
	for <linux-ext4@vger.kernel.org>; Tue, 31 Jan 2012 17:33:27 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Yongqiang,

I've have been working on an extent lock implementation that uses an 
rbtree to keep track of locked extents, and I think I will probably end 
up with a something similar to the tree that you've already set up for 
delayed extents.  So I wanted to send a note out to see what folks would 
think about the idea of merging the two solutions.

If we did this, the tree would get a little more complex in that it 
would have to keep track of more than just delayed extents. It would 
have to keep track of all extents and the processes that are waiting on 
them.  So I guess it would kind of turn into an extent status tree.  I 
also realize that some folks wanted to see range locks go into /lib as 
general purpose code so that other filesystems or kernel code could use 
it too, but the advantage to this approach would be one less tree for 
ext4 to keep track of.  Any thoughts?

Allison Henderson

