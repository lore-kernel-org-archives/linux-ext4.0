From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Generating patches with diff -p
Date: Tue, 29 May 2007 11:42:07 +0530
Message-ID: <465BC437.1070707@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ausmtp05.au.ibm.com ([202.81.18.154]:40615 "EHLO
	ausmtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750872AbXE2GNP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 29 May 2007 02:13:15 -0400
Received: from sd0208e0.au.ibm.com (d23rh904.au.ibm.com [202.81.18.202])
	by ausmtp05.au.ibm.com (8.13.8/8.13.8) with ESMTP id l4T6EhSi7127216
	for <linux-ext4@vger.kernel.org>; Tue, 29 May 2007 16:14:46 +1000
Received: from d23av01.au.ibm.com (d23av01.au.ibm.com [9.190.250.242])
	by sd0208e0.au.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l4T6GK7R171570
	for <linux-ext4@vger.kernel.org>; Tue, 29 May 2007 16:16:30 +1000
Received: from d23av01.au.ibm.com (loopback [127.0.0.1])
	by d23av01.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l4T6COmv011380
	for <linux-ext4@vger.kernel.org>; Tue, 29 May 2007 16:12:25 +1000
Received: from [9.124.35.21] (skywalker.in.ibm.com [9.124.35.21])
	by d23av01.au.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id l4T6CCkD010764
	for <linux-ext4@vger.kernel.org>; Tue, 29 May 2007 16:12:14 +1000
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi,

It would be nice to have patches in the ext4-patch-queue to be generated 
using diff -p.

-p  --show-c-function
               Show which C function each change is in.

-aneesh
