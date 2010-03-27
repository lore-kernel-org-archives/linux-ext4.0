From: "Theodore Ts'o" <tytso@mit.edu>
Subject: FIEMAP sometimes returns bad information for delalloc extents
Date: Sat, 27 Mar 2010 11:07:30 -0400
Message-ID: <E1NvXbm-00087i-Tf@closure.thunk.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:45826 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753396Ab0C0PHg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 27 Mar 2010 11:07:36 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


I was monitoring the progress of a distributed download program, and saw
the following output from two runs of filefrag taken a few seconds
apart:

   8     790  8825663  8825551     65 
   9     855        0  8825727    319 unknown,delalloc
  10    1174  8798367      318    128 

   7     790  8825663  8825559     69 
   8    1174  8798367  8825731    128 

The length of the delalloc extent, 319, is bogus.  The 319 seems to come
from 1174 - 855.   But it's not actually the number of delayed
allocation blocks, as we can see when the blocks finally get written;
apparently it was only 4 blocks long.

I don't have time to try to track this down just now, and it's not all
that serious a bug since delalloc regions are by definition highly
transient, but it does look like we have a bug here.

						- Ted
