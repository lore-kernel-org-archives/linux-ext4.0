From: Avantika Mathur <mathur@linux.vnet.ibm.com>
Subject: Ext4 devel interlock meeting minutes (July 30, 2007)
Date: Mon, 06 Aug 2007 23:58:30 -0700
Message-ID: <46B81816.1070602@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from over.ny.us.ibm.com ([32.97.182.150]:46143 "EHLO
	over.ny.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753724AbXHGHPg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 7 Aug 2007 03:15:36 -0400
Received: from e36.co.us.ibm.com (e36.co.us.ibm.com [32.97.110.154])
	by pokfb.esmtp.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id l777BT36011158
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Tue, 7 Aug 2007 03:11:29 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e36.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id l776vqlO027973
	for <linux-ext4@vger.kernel.org>; Tue, 7 Aug 2007 02:57:52 -0400
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v8.4) with ESMTP id l776vpoN242058
	for <linux-ext4@vger.kernel.org>; Tue, 7 Aug 2007 00:57:52 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l776vpLO031752
	for <linux-ext4@vger.kernel.org>; Tue, 7 Aug 2007 00:57:51 -0600
Received: from [9.67.29.111] (wecm-9-67-29-111.wecm.ibm.com [9.67.29.111])
	by d03av01.boulder.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id l776vpqE031744
	for <linux-ext4@vger.kernel.org>; Tue, 7 Aug 2007 00:57:51 -0600
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Ext4 Developer Interlock Call:  August 6, 2007 Meeting Minutes

Attendees: Mingming Cao, Ted T'so, Andreas Dilger, Jean Pierre Dion, 
Valerie Clement, Jose Santos, Aneesh Veetil, Avantika Mathur

- Valerie has developed a series of patches to e2fsprogs, preparing it 
for 64-bit support.  She still needs to re-write some of the patches, 
taking Ted and Andreas' comments into account.  
    -- The current patches are against e2fsprogs-1.40, in which there is 
no extents support.  Ted will first work on designing the extents 
interface before extents will supported in e2fsprogs.

- Aneesh has been working on an undo I/O manager. Currently his this is 
only for mke2fs, Andreas said it would be useful to have this 
functionality available in e2fsck as well.  Aneesh will try to add this 
as he gets time.

- Aneesh's enlarge inode patches are desired for addition in e2fsprogs.  
Current interface is through tunefs.  Andreas wonders if it might make 
sense to make this function part of resizefs rather than adding 
complexity to tunefs.  Also, since we will also have the ability to 
change the number of inodes, resizefs would be a good place for this 
functionality.
- Aneesh will also try to post some testcases for the feature next time 
he posts the patches

There was much discussion on the Flexible block groups feature under 
development by Jose; including the desired function and how it is 
implemented.  Jose proposed implementing dynamic inode tables on top of 
the flex_bg feature.
- Jose will send an e-mail to the mailing list with the purpose of the 
feature and current plans, to make sure there is consensus before moving 
forward.
