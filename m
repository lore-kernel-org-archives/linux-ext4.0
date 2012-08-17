From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: NULL pointer dereference in ext4_ext_remove_space on 3.5.1
Date: Fri, 17 Aug 2012 09:15:58 -0400
Message-ID: <20120817131558.GA11439@thunk.org>
References: <CABRT9RAOhaxcYdCxMn5neJ9WT85r=h=7WgZ2dmLaOs-MMqDW9A@mail.gmail.com>
 <20120816024654.GB3781@thunk.org>
 <20120816111051.GA16036@localhost>
 <20120816152513.GA31346@thunk.org>
 <20120817060110.GA28786@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Marti Raudsepp <marti@juffo.org>,
	Kernel hackers <linux-kernel@vger.kernel.org>,
	ext4 hackers <linux-ext4@vger.kernel.org>, maze@google.com
To: Fengguang Wu <fengguang.wu@intel.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:45231 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751829Ab2HQNQE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 17 Aug 2012 09:16:04 -0400
Content-Disposition: inline
In-Reply-To: <20120817060110.GA28786@localhost>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Thanks Fengguang:

For the record, I was able to find my own easy repro, last night using
only a 220 meg partition:

# mke2fs -t ext4 -b 1024 -J size=1 /dev/vdc
# mount -t ext2 /dev/vdc /vdc
# mkdir /vdc/a
# cd /vdc/a
# seq 1 210000  | xargs -n 1 fallocate -l 1m
# seq 1 2 210000  | xargs /bin/rm
# mkdir /vdc/b
# cd /vdc/b
# seq 1 103 | xargs -n 1 fallocate -l 1g
# cd /
# umount /vdc
# mount -t ext4 -o commit=10000 /dev/vdc /vdc
# rm -rf /vdc/b

For future reference, there are a couple of things that are of
interest to ext4 developers when trying to create repro's:

1)  The use of mounting with ext2 to speed up the setup.

2)  The first two "seq ... | xargs ..." commands to create a very
fragmented file system.

3) Using a 1k block size file system to stress the extent tree code
and htree directory (since its easier to make larger tree structure).

4)  The use of the mount option commit=10000 to test what happens when
the journal is full (without using a nice, fast device such as RAID array
or without burning write cycles on an expensive flash device.)

						- Ted
