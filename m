From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [RFC] mballoc patches
Date: Mon, 13 Aug 2007 15:52:21 +0530
Message-ID: <1187000545401-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org
To: alex@clusterfs.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ausmtp06.au.ibm.com ([202.81.18.155]:40897 "EHLO
	ausmtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937531AbXHMKWe (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 13 Aug 2007 06:22:34 -0400
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by ausmtp06.au.ibm.com (8.13.8/8.13.8) with ESMTP id l7DAP2hO1822836
	for <linux-ext4@vger.kernel.org>; Mon, 13 Aug 2007 20:25:02 +1000
Received: from d23av01.au.ibm.com (d23av01.au.ibm.com [9.190.250.242])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l7DAMUsQ4710568
	for <linux-ext4@vger.kernel.org>; Mon, 13 Aug 2007 20:22:31 +1000
Received: from d23av01.au.ibm.com (loopback [127.0.0.1])
	by d23av01.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l7DAMUEq028053
	for <linux-ext4@vger.kernel.org>; Mon, 13 Aug 2007 20:22:30 +1000
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


Alex actually pointed me the new mballoc patches at
ftp://ftp.clusterfs.com/pub/people/alex/mballoc3

The series is the forward port of the same on top of
d4ac2477fad0f2680e84ec12e387ce67682c5c13 (v2.6.23-rc2)


I guess the mballoc3 patch at clusterfs.com is based on
a patched ext3(I guess it is ext3 + extent tree local to
clusterfs ? ). The following series is based on ext4.


I tested the changes with different blocks per group
combination and it seems to be working fine. (The last
series did panic with mke2fs -g 800 )


I will now look at splitting this to smaller patches.

NOTE : I am not sure whether patch 2 will be able to make the list.
if not is there a place i can ftp/scp them so that others can access
the same ?

I haven't split the patches in any order and didn't bothered to
write any meaningful commit messages since this is mostly work in
progress.

-aneesh
