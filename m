From: Theodore Tso <tytso@mit.edu>
Subject: Re: Journal file fragmentation
Date: Wed, 27 Aug 2008 17:06:36 -0400
Message-ID: <20080827210636.GC26987@mit.edu>
References: <1219858567.3591.64.camel@frecb007923.frec.bull.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: =?iso-8859-1?Q?Fr=E9d=E9ric_Boh=E9?= <frederic.bohe@bull.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:60890 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752635AbYH0VGj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 27 Aug 2008 17:06:39 -0400
Content-Disposition: inline
In-Reply-To: <1219858567.3591.64.camel@frecb007923.frec.bull.fr>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Aug 27, 2008 at 07:36:07PM +0200, Fr=E9d=E9ric Boh=E9 wrote:
> While playing with filesystems using flex bg, I noticed that the jour=
nal
> file may be fragmented when there are a lots of meta-data in  the fir=
st
> flex-group.
> For example, with this command : mkfs.ext4 -t ext4dev -G512 /dev/sdb1
> The journal file is reported by "stat <8>" in debugfs to be like this=
 :

Yeah, we really want to put the journal in the middle of the
filesystem; that not only avoids the metadata at the very beginning of
the filesystem, especially when flex_bg is enabled, but also because
it eliminates the worst case seek times when the file data is at the
end of the disk, and the journal is at the beginning of the disk, and
we are using a very fsync-intensive workload.

With the following patches the journal inode now looks like this:

Inode: 8   Type: regular    Mode:  0600   Flags: 0x80000
Generation: 0    Version: 0x00000000
User:     0   Group:     0   Size: 134217728
=46ile ACL: 0    Directory ACL: 0
Links: 1   Blockcount: 262144
=46ragment:  Address: 0    Number: 0    Size: 0
ctime: 0x48b5b982 -- Wed Aug 27 16:30:58 2008
atime: 0x00000000 -- Wed Dec 31 19:00:00 1969
mtime: 0x48b5b982 -- Wed Aug 27 16:30:58 2008
Size of extra inode fields: 0
BLOCKS:
(0-32767):2588672-2621439
TOTAL: 32768

This also creates the journal using extents, which eliminates the
indirect block overhead, and means that the 128MB journal conveniently
takes up a single block group:

Group 79: (Blocks 2588672-2621439) [INODE_UNINIT, ITABLE_ZEROED]
  Checksum 0x441d, unused inodes 8192
  Block bitmap at 2097167, Inode bitmap at 2097183
  Inode table at 2104864-2105375
  0 free blocks, 8192 free inodes, 0 directories, 8192 unused inodes
  Free blocks:=20
  Free inodes:=20

						- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
