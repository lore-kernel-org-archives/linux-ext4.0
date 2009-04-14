From: Chris Mason <chris.mason@oracle.com>
Subject: [PATCH 0/2] ext3 data=guarded
Date: Tue, 14 Apr 2009 16:57:13 -0400
Message-ID: <1239742633.28321.39.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
To: Jan Kara <jack@suse.cz>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	"Theodore Ts'o" <tytso@mit.edu>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	Ext4 Developers
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rcsinet11.oracle.com ([148.87.113.123]:43321 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750883AbZDNU6n (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 14 Apr 2009 16:58:43 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello everyone,

Here is the ext3 data=guarded code again, this time it has passed some
basic tests.  It should safely leave non data=guarded mounts alone and
only be dangerous when the new code is turned on (I hope).

On the performance side, it runs the same as data=writeback, except when
you're making files with holes where it runs the same as data=ordered.

There's definitely more CPU time involved with tracking the data=guarded
buffer heads and updating i_size when the IO is over, but at least on my
5 drive array that doesn't show up.

For the fsync + background streaming write workload, data=guarded does
fsync's in 0.8s, just like data=writeback.  data=ordered on the same
test was doing between 5 and 30s per fsync, so it seems I've fixed that
part at least.

The next step is much more testing (blocksize != pagesize among others)
and much more review.  But, I'm hoping for some feedback first on if
this is a direction we want to take the ext3 code.

The diffstat looks scary, but lots of the changes are comments...

-chris


