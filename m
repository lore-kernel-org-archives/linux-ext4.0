From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: Porting punch hole to rhel 6.3
Date: Mon, 12 Dec 2011 13:43:16 -0700
Message-ID: <4EE66764.3060400@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e8.ny.us.ibm.com ([32.97.182.138]:50365 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751701Ab1LLUnX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 12 Dec 2011 15:43:23 -0500
Received: from /spool/local
	by e8.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <achender@linux.vnet.ibm.com>;
	Mon, 12 Dec 2011 15:43:22 -0500
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id pBCKhJuW175316
	for <linux-ext4@vger.kernel.org>; Mon, 12 Dec 2011 15:43:20 -0500
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id pBCKhJrh023417
	for <linux-ext4@vger.kernel.org>; Mon, 12 Dec 2011 15:43:19 -0500
Received: from lc4eb0185863151.ibm.com ([9.57.70.179])
	by d01av04.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVin) with ESMTP id pBCKhIFH023323
	for <linux-ext4@vger.kernel.org>; Mon, 12 Dec 2011 15:43:19 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi All,

I have a request to port punch hole to rhel 6.3, so I am currently 
collecting a list of patches that I think I will need.  I think I 
already have a good idea of what punch hole changes have occurred since 
the first punch hole set, but it looks like ext4_ext_map_blocks will 
also need porting too.  I am not as familiar with the history of this 
function, so I am still going through patches looking for anything that 
have modified it.  If any one has submitted a patch that you think needs 
to be included, let me know and I will add it to my list.  Thx!

Allison Henderson

