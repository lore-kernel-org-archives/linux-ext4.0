From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: Ext4 Punch Hole v6 Change Summary
Date: Tue, 03 May 2011 09:47:48 -0700
Message-ID: <4DC031B4.4040603@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:57184 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753630Ab1ECQsI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 3 May 2011 12:48:08 -0400
Received: from d03relay03.boulder.ibm.com (d03relay03.boulder.ibm.com [9.17.195.228])
	by e32.co.us.ibm.com (8.14.4/8.13.1) with ESMTP id p43GapsO005994
	for <linux-ext4@vger.kernel.org>; Tue, 3 May 2011 10:36:51 -0600
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay03.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p43Gm2DZ127896
	for <linux-ext4@vger.kernel.org>; Tue, 3 May 2011 10:48:03 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p43GlrwA027517
	for <linux-ext4@vger.kernel.org>; Tue, 3 May 2011 10:47:53 -0600
Received: from [9.65.15.245] (sig-9-65-15-245.mts.ibm.com [9.65.15.245])
	by d03av01.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVin) with ESMTP id p43GlmU1026844
	for <linux-ext4@vger.kernel.org>; Tue, 3 May 2011 10:47:49 -0600
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi All,

Here is the latest copy of punch hole for ext4.  This copy has been 
modified to apply on top of Yongqiang's v2 patch set that revises the 
split extents routines.  So the patch that used to modify the split 
extents routines (patch 2/6 of punch hole v5) has been removed.  I have 
tested this combination of patch sets against the same tests I used for 
v5 and they all look good.  Thx Yongqiang for all your work :)

Some other things that changed between v5 and v6:

patch 1/5:
The flag that this patch adds has been changed to use new EXT4_MB flag 
instead of creating a new set of flags

patch 5/5:
New function "ext4_ext_check_cache" has been added.  It is similar to 
ext4_ext_in_cache but it accepts a ext4_ext_cache parameter instead of a 
ext4_extent.  After letting one of my test cases run overnight, I found 
a bug that was caused by the ext4_ext_in_cache routine trying to copy a 
ext4_ext_cache field into a ext4_extent field that was too small to 
contain it.  So the new ext4_ext_check_cache corrects this.

That's pretty much all of the changes between the sets.  As always feed 
back is appreciated.  Thx all!

Allison Henderson
