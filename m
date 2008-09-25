From: Alex Tomas <bzzz@sun.com>
Subject: Re: [RFC] dynamic inodes
Date: Fri, 26 Sep 2008 03:00:22 +0400
Message-ID: <48DC1806.90805@sun.com>
References: <48DA28B0.2020207@sun.com>
 <20080925220936.GL10950@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=ISO-8859-1
Content-Transfer-Encoding: 7BIT
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from gmp-eb-inf-1.sun.com ([192.18.6.21]:59276 "EHLO
	gmp-eb-inf-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752922AbYIYXAh (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 25 Sep 2008 19:00:37 -0400
Received: from fe-emea-10.sun.com (gmp-eb-lb-1-fe3.eu.sun.com [192.18.6.10])
	by gmp-eb-inf-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m8PN0ZhC008576
	for <linux-ext4@vger.kernel.org>; Thu, 25 Sep 2008 23:00:35 GMT
Received: from conversion-daemon.fe-emea-10.sun.com by fe-emea-10.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0K7R00G01X8VB800@fe-emea-10.sun.com> (original mail from bzzz@sun.com)
 for linux-ext4@vger.kernel.org; Fri, 26 Sep 2008 00:00:35 +0100 (BST)
Received: from gw.home.net ([83.237.175.238])
 by fe-emea-10.sun.com (Sun Java System Messaging Server 6.2-8.04 (built Feb 28
 2007)) with ESMTPSA id <0K7R0088OX8XAF30@fe-emea-10.sun.com> for
 linux-ext4@vger.kernel.org; Fri, 26 Sep 2008 00:00:34 +0100 (BST)
In-reply-to: <20080925220936.GL10950@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Andreas Dilger wrote:
> Alternately, any inode >= 2^32 would be dynamic?  One clear benefit of
> putting the dynamic inodes at the end of the number space is that they
> will only be used if the static inodes are full, which reduces risk due
> to corruption and overhead due to dynamic allocations.

the highest (63th) bit put dynamic inodes at the end, no? the idea is that
using 48 bits we can address block directly, w/o any additional lookup via
some metainode. essentially this is just a way to introduce 64bit addressable
fragments of 2^(64-48-1) size.

>>   * each block is covered by two bits: in inode (I) and block (B) bitmaps:
>>     I: 0, B: 0 - block is just free
>>     I: 0, B: 1 - block is used, but not contains inodes
>>     I: 1, B: 0 - block is full of inodes
>>     I: 1, B: 1 - block contains few inodes, has free space
> 
> Storing B:0 for an in-use block seems very dangerous to me.  This also
> doesn't really address the need to be able to quickly locate free inodes,
> because it means "I:1" _might_ mean the inode is free or it might not,
> so EVERY "in-use" inode would need to be checked to see if it is free.

just combine I and B into single bitmap:
1) when you look for free block it's any 0 bit in bitmap made by (I & B)
2) when you look for free inode (in current inode blocks) it's any 1 bit
    in bitmap made again by (I & B), then you read corresponded block and
    find free slot there (for example, it can be null i_mode)

looks very simple and doable?

> We need to start with a "dynamic inode bitmap" (DIB) that is mapped from
> an "inode table file" (possibly only for the dynamic inode table blocks).
> Free inodes can be scanned using the normal ext4_find_next_zero_bit()
> in each of the bitmaps.

the idea is that we can implement truly dynamic and varlen inodes w/o
introducing special files, using existing structures.

thanks, Alex

