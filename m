From: Radek Pazdera <rpazdera@redhat.com>
Subject: [RFC] Optimizing readdir()
Date: Sun, 13 Jan 2013 16:22:04 +0100
Message-ID: <20130113152204.GB26803@laptop.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60892 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755193Ab3AMPZl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 13 Jan 2013 10:25:41 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r0DFPfYu009971
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Sun, 13 Jan 2013 10:25:41 -0500
Content-Disposition: inline; filename="ext4-proposal.txt"
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi!

I am a student at Brno University of Technology working on my "final
project". I'm doing this with great help of Lukas Czerner, who acts
as my mentor and leads me on the project.

I'd like to optimize the problem of getents() returning entries in
hash order, which can have an impact on performance in some cases.
It was mentioned here a few times already [1][2].

I did some tests [3] and it seems to me that the amount of available
page cache plays a crucial role in this case. It can compensate for
the seeks if the directory is "small enough". However, in case
of memory pressure or when something starts to evict your pages, the
performance can go down.

The biggest performance can be observed when copying an entire directory
(ext4-spd are with the spd_readdir preload - and it's *fast*):

    http://www.stud.fit.vutbr.cz/~xpazde00/ext4-tests/clean-3-1-block-files/cp.png
    http://www.stud.fit.vutbr.cz/~xpazde00/ext4-tests/clean-3-1-block-files/cp.results

Raw readdir() and stat() on every file is ok up to really large dirs
(as long as your page cache can hold all the inode tables, I think).
ext4's dir index is ok even with aged dirs:

    http://www.stud.fit.vutbr.cz/~xpazde00/ext4-tests/readdir-stat_clean-vs-aged.results
    http://www.stud.fit.vutbr.cz/~xpazde00/ext4-tests/clean-1/readdir-stat.png
    http://www.stud.fit.vutbr.cz/~xpazde00/ext4-tests/aged/readdir-stat.png


My idea was to try to add a second tree to the current index that would
be used to retrieve entries in inode-order. Its structure could be very
similar to the current HTree (the hash is 32bits and so are inode
numbers).

Question is, how hard would this hit creates/deletes, and renames.
Isolated create/delete would be definitely slower (ext4 would do
the same thing twice). But page cache could save the case of
creating/deleting a whole directory. Deletion might in fact benefit
from the inode-order readdir a little (compare ext4 and ext4-spd):

    http://www.stud.fit.vutbr.cz/~xpazde00/ext4-tests/clean-1/delete.png
    http://www.stud.fit.vutbr.cz/~xpazde00/ext4-tests/clean-1/delete.results

One downside is, it would roughly double the size of directory metadata, as
there probably would have to be two dirents for each entry (for each tree).
If one tree would link to another's dirents, it would make node splits,
extremely expensive. I had an idea about using a array of dirents shared
between the trees, but I'm not really sure how to manage free space in it
efficiently.

On-disk format would remain the same, apart from the dx_root structure,
which would have to carry a pointer to the root of the second tree. I
think, there might be a place in the embedded dx_root_info:

struct dx_root_info
{
        __le32 reserved_zero;
        u8 hash_version;
-        u8 info_length; /* 8 */
+        u8 info_length; /* 12 */
        u8 indirect_levels;
        u8 unused_flags;
+        __le32 itree_root_block;
}


What do you think about this approach? Is it worth trying?
Any feedback or sugesstions are greatly appreciated :).


Radek Pazdera


[1] http://thread.gmane.org/gmane.comp.file-systems.ext4/23794
[2] http://thread.gmane.org/gmane.linux.file-systems/61910
[3] http://www.stud.fit.vutbr.cz/~xpazde00/ext4-tests/
