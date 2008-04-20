From: Andi Kleen <andi@firstfloor.org>
Subject: Re: Mentor for a GSoC application wanted (Online ext2/3 filesystem checker)
Date: Mon, 21 Apr 2008 01:37:37 +0200
Message-ID: <87ej9085dq.fsf@basil.nowhere.org>
References: <f19298770804180720w2e72b821j95b709c1dd1b1c25@mail.gmail.com>
	<20080419012952.GE25797@mit.edu>
	<f19298770804190244y5d6a8502p39f98d1c420135a@mail.gmail.com>
	<20080419185603.GA30449@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Alexey Zaytsev <alexey.zaytsev@gmail.com>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	Rik van Riel <riel@surriel.com>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out04.alice-dsl.net ([88.44.63.6]:40932 "EHLO
	smtp-out04.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750931AbYDTXhj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 20 Apr 2008 19:37:39 -0400
In-Reply-To: <20080419185603.GA30449@mit.edu> (Theodore Tso's message of "Sat, 19 Apr 2008 14:56:03 -0400")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso <tytso@mit.edu> writes:
>
> If you are going to store all of the cached objects then you will need
> to effectively store *all* of the filesystem metatdata in memory at
> the same time. 

Are you sure about all data? I think he would just need some lookup table from 
metadata block numbers to inode numbers and then when a hit occurs on a block
in  the table somehow invalidate all data related to that inode
and restart that part. And the same thing for bitmap blocks. That lookup
table should be much smaller than the full metadata.

Anyways my favourite fsck wish list feature would be a way to record the 
changes a read-only fsck would want to do and then some quick way
to apply them to a writable version of the file system without 
doing a full rescan. Then you could regularly do a background check
and if it finds something wrong just remount and apply the changes
quickly.

Or perhaps just tell the kernel which objects is suspicious and
should be EIOed.

-Andi
