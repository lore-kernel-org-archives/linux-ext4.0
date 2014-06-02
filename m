From: Ian Nartowicz <ian@nartowicz.co.uk>
Subject: Re: [RFC][PATCH] ext4: handle fast symlink properly with
 inline_data
Date: Mon, 2 Jun 2014 12:06:35 +0100
Message-ID: <20140602120635.6d49ba12@crunchbang>
References: <1392275237-6998-1-git-send-email-wenqing.lz@taobao.com>
	<20140218015231.GF26580@thunk.org>
	<292627A0-B8C3-4B49-9795-E5DA18462A4B@dilger.ca>
	<20140530232633.GE17413@birch.djwong.org>
	<20140602064251.GA17061@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>,
	Andreas Dilger <adilger@dilger.ca>,
	Theodore Ts'o <tytso@mit.edu>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Ian Nartowicz <claws@nartowicz.co.uk>, Tao Ma <tm@tao.ma>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Zheng Liu <wenqing.lz@taobao.com>
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from know-smtprelay-omc-8.server.virginmedia.net ([80.0.253.72]:43422
	"EHLO know-smtprelay-omc-8.server.virginmedia.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753007AbaFBLMY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 2 Jun 2014 07:12:24 -0400
In-Reply-To: <20140602064251.GA17061@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 2 Jun 2014 14:42:51 +0800
Zheng Liu <gnehzuil.liu@gmail.com> wrote:

>Hi all,
>
>On Fri, May 30, 2014 at 04:26:33PM -0700, Darrick J. Wong wrote:
>> On Tue, Feb 18, 2014 at 11:07:24AM -0800, Andreas Dilger wrote:
>> > I suspect that the stats for symlinks > 60 but < ~150 chars is only a very
>> > small fraction of files. If the code complexity of handling this is very
>> > small (i.e. it is just handled as a natural consequence of writing "data" 
>> > of this size) then I would be OK with it. 
>> > 
>> > Otherwise, I expect the code and maintenance overhead of supporting
>> > the 0.01% (?) of symlinks that are this size is probably lot worth it. 
>> > 
>> > People could check what the actual usage is via the "fsstats" tool at:
>> > 
>> > http://www.pdsi-scidac.org/fsstats/
>> > 
>> > There is also data there already that reports stats on symlink length, but
>> > it is mostly HPC filesystems and it might be better to redo this with a
>> > desktop-type workload. 
>> 
>> I think we should either put in this kernel patch so that we can read inline
>> data fast symlinks, or remove the ability to write inline data fast symlinks.
>> It's a bit surprising that I can do:
>> 
>> # mke2fs -t ext4 -O inline_data /dev/sdb         
>> # mount /dev/sdb /mnt/
>> # ln -s "Fuzzy Wuzzy was a bear. Fuzzy Wuzzy had no hair. I guess he wasn't
>> fuzzy, was he?" /mnt/biglink # readlink /mnt/biglink
>> Fuzzy Wuzzy was a bear. Fuzzy Wuzzy had no hair. I guess he wasn't fuzzy,
>> was he? # umount /mnt
>> # mount /dev/sdb /mnt/
>> # readlink /mnt/biglink
>> Fuzzy Wuzzy was a bear. Fuzzy Wuzzy had no hair. I guess he
>> 
>> What happened to the punchline of the limerick? ------------^^^^^^^ ???? :)
>
>Do *not* apply this patch, please.  I revise this patch and I think it
>is not right solution, although it can fix the bug.
>
>The root cause is in ext4_inode_is_fast_symlink() function that it
>doesn't check whether or not an inode has inline data.  After creating
>a normal symlink, the symlink will be stored in ->i_block and extra
>space if the length of symlink is greater than 60 bytes and less than
>extra space in inline data.  In the mean time, this inode has inline
>data flag.  If the file system is remounted, ext4_inode_is_fast_symlink
>thinks this inode is a fast symlink, and the data in ->i_block is copied
>to user.  I will send a new patch to fix this bug.
>
>> 
>> e2fsck still seems to think that you can't have inline_data fast symlinks.  I
>> don't see a downside to continuing to allow them.
>
>Meanwhile another patch for e2fsck also will be sent out soon in order
>to handle symlink properly with inline data in e2fsck.
>
>Regards,
>                                                - Zheng

fsstats on root on my desktop, percentage of symlink targets 64 - 150
characters long is 22%, almost all in the 64-71 char bucket.  Lots of them are
theme icons and python packages, some shared library objects, nothing that
many people won't have.

--ian
