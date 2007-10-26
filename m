From: Valerie Clement <valerie.clement@bull.net>
Subject: problem with delayed allocation option
Date: Fri, 26 Oct 2007 14:28:36 +0200
Message-ID: <4721DD74.20806@bull.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Alex Tomas <alex@clusterfs.com>,
	Andreas Dilger <adilger@clusterfs.com>
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:46787 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751890AbXJZM3G (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 26 Oct 2007 08:29:06 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi all,

I ran a small test which creates one directory and 2O 8-KB size files i=
n it.

When the filesystem is mounted without the delalloc option, here is the
output of the command dumpe2fs for the group in which the directory and=
=20
the files are created:

Group 532 : (Blocks 17432576-17465343)
   Block bitmap at 17432576 (+0), Inode bitmap at 17432577 (+1)
   Inode table at 17432578-17433089 (+2)
   32213 free blocks, 16363 free inodes, 1 directories
   Free blocks : 17433090-17459199, 17459241-17465343
   Free inodes : 8716310-8732672


When the filesystem is mounted with the delalloc option, the same test
gives a different result:

Group 395 : (Blocks 12943360-12976127)
   Block bitmap at 12943360 (+0), Inode bitmap at 12943361 (+1)
   Inode table at 12943362-12943873 (+2)
   32213 free blocks, 16363 free inodes, 1 directories
   Free blocks : 12943874-12955647, 12955650-12955655,=20
12955658-12955663, 12955666-12955671, 12955674-12955679,=20
12955682-12955687, 12955690-12955695, 12955698-12955703,=20
12955706-12955711, 12955714-12955719, 12955722-12955727,=20
12955730-12955735, 12955738-12955743, 12955746-12955751,=20
12955754-12955759, 12955762-12955767, 12955770-12955775,=20
12955778-12955783, 12955786-12955791, 12955794-12955799,=20
12955802-12961791, 12961793-12976127
   Free inodes : 6471702-6488064

In the first case, the allocated blocks are contiguous whereas they are
not in the second case.

After adding traces in the code to understand why the behavior is
different with the delalloc option, I found that the problem is related
to the inode reservation window.

To simplify, without the delalloc option we have the following scenario=
:
=46or each inode,
  - call alloc_new_reservation() to allocate a new reservation window
  - allocate blocks for data
  - write data to disk
  - ext4_discard_reservation() when the inode is closed.

With the delalloc option, when the data are written to disk we have:
=46or each inode,
  - call alloc_new_reservation() to allocate a new reservation window
  - allocate blocks for data
  - write data to disk


I think a call to ext4_discard_reservation() is missing somewhere and
the question is where.

I tried to add this call at the end of the ext4_da_get_block_write()
function. This seems to fix the problem as the blocks are allocated
contiguously on disk but the function seems to be called too many times
so I think it is perhaps not the right place to call it.

Who could look into this problem?
I've got a few days off so I couldn't help more next days, but the
problem is easily reproductible.

Wouldn't this also explain why the compilebench results posted by Chris
Mason are bad in some cases?

   Val=E9rie
