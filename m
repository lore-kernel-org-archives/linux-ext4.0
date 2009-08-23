From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH 1/1] dir shrink (was Re: ext3/ext4 directories don't	shrink
 after deleting lots of files)
Date: Sat, 22 Aug 2009 21:10:39 -0600
Message-ID: <20090823031039.GF5931@webber.adilger.int>
References: <1242338523.6933.664.camel@timo-desktop>
 <605A8D56-81CD-4775-8FCD-58CDB12CBA36@iki.fi> <20090517213335.GB32019@mit.edu>
 <200908221620.50103.schlick@lavabit.com>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Andreas Schlick <schlick@lavabit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:37929 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933437AbZHWDKi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 22 Aug 2009 23:10:38 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n7N3Aagp023494
	for <linux-ext4@vger.kernel.org>; Sat, 22 Aug 2009 20:10:38 -0700 (PDT)
Content-disposition: inline
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.04 64bit (built Jul  2 2009))
 id <0KOT00G0075TMJ00@fe-sfbay-10.sun.com> for linux-ext4@vger.kernel.org; Sat,
 22 Aug 2009 20:10:36 -0700 (PDT)
In-reply-to: <200908221620.50103.schlick@lavabit.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Aug 22, 2009  16:20 +0200, Andreas Schlick wrote:
> I'd like to try it. It looks like a nice starting project. 
> Following your outline the first version of the patch tries to remove an
> empty  block at the end of a non-htree directory.
> I'd appreciate it if you checked it and gave me suggestions for improving it. 

Adding the extra "dc" to each of the functions probably isn't necessary,
as this makes the API messier.  Probably a better approach would be to
just do this within ext4_delete_entry(), analogous to how ext4_add_entry()
might add a new block at any time.

It would be even better if this could be done repeatedly if there are
more empty blocks at the end (i.e. they were not previously at the end
of the file), but that gets into trouble with the transactions.  It isn't
easy to remove an intermediate block, because this will result in a hole
in the directory (a no-no), and there is no safe way to reorder the
blocks in the directory.

> At the moment I am looking at the dir_index code, so I can extend it to htree 
> directories. Please let me know if you want me to port it to ext3, although 
> personally I think it is better to do so at later point.

For dir_index what is important is that you don't have any holes in the
hash space, nor in the logical directory blocks.  One possibility is in
the case where the direntry being removed is the last one[*] to remove
the block it resides in, move the last block to the current logical
offset, and update the htree index to reflect this.

Note that the htree index only records the starting hash value for each
block, so all that would need to be done to remove any mention of the
deleted block is to memmove() the entries to cover the deleted block and
the hash buckets will still be correct.  Also, the logical block number
of the last entry would need to be changed to reflect its new position.

[*] This is easily determined in ext4_delete_entry() because it always
    walks the block until it finds the entry, and if there are valid
    entries before the one being deleted the block is not empty.  Tracking
    this takes basically no extra effort.  If no valid entries are before
    the one being deleted, and if the length of the entry after it fills
    the rest of the space in the block then the block is empty.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

