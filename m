From: Ted Ts'o <tytso@mit.edu>
Subject: Re: Extent Depth Histogram Fsck
Date: Tue, 26 Jun 2012 16:00:26 -0400
Message-ID: <20120626200026.GA28831@thunk.org>
References: <0408C81F72528E40A0D3235A1F67FFC804A37F@SN2PRD0202MB144.namprd02.prod.outlook.com>
 <55654AE5-17FE-44EC-B7FE-A8D5FAAB3560@dilger.ca>
 <0408C81F72528E40A0D3235A1F67FFC804A3B3@SN2PRD0202MB144.namprd02.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: "Nelson, John R" <John_Nelson@student.uml.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:52882 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753375Ab2FZUAf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 26 Jun 2012 16:00:35 -0400
Content-Disposition: inline
In-Reply-To: <0408C81F72528E40A0D3235A1F67FFC804A3B3@SN2PRD0202MB144.namprd02.prod.outlook.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jun 26, 2012 at 06:07:10PM +0000, Nelson, John R wrote:
> ok i see!
> So when there are like
> 3/3/4 that means double index blocks?? How many extents can a single extent index hold in a block?

You can put 4 entries in the inode, and then there can be 340 entries
in each 4k extent tree block.  Each entry can either be a leaf entry
or an index entry (i.e., pointing to another extent tree block).

So it's pretty rare for there extent tree to have a depth greater than
1.  In order to actually test the code, what I do is use a 1k block
size (so you can only fit 84 entries in each ETB), and then use a
small file system, and then do something like this:

touch /tmp/test.img
mke2fs -t ext4 -O ^has_journal -F -b 1024 -N 131084 /tmp/test.img 150M
mount -o loop /tmp/test.img /mnt
cd /mnt
seq 1 131072 | xargs -n 1 fallocate -l 1024
seq 1 2 131072 | xargs rm
fallocate -l 64M test-file
cd ..
umount /mnt

i.e., create a maximally fragmented file system, and then create a
large file.  But this is very rare in real-life workloads.

      	     	      	      - Ted
