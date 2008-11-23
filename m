From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: [PATCH -V2 3/5] ext4: Fix the race between read_block_bitmap
	and mark_diskspace_used
Date: Sun, 23 Nov 2008 14:02:24 -0500
Message-ID: <20081123190224.GE26473@mit.edu>
References: <1227285875-18011-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1227285875-18011-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1227285875-18011-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <4926EE3C.7050207@redhat.com> <20081121173135.GF11212@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>, cmm@us.ibm.com,
	linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:64897 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752295AbYKWTCn (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sun, 23 Nov 2008 14:02:43 -0500
Content-Disposition: inline
In-Reply-To: <20081121173135.GF11212@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Nov 21, 2008 at 11:01:35PM +0530, Aneesh Kumar K.V wrote:
> Same is true with inode bitmap also.
> 

I don't see how this patch could affect any races with the inode
bitmaps; the patch only affects mballoc.c, and only changes the
locking around bitmaps.

This is one that I think we may want to send to Linus soon as a 2.6.28
bugfix.

							- Ted
