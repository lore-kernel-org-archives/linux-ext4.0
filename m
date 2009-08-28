From: Theodore Tso <tytso@mit.edu>
Subject: Re: >16TB issues
Date: Fri, 28 Aug 2009 08:40:13 -0400
Message-ID: <20090828124013.GB16732@mit.edu>
References: <20090721192123.GK4231@webber.adilger.int> <150c16850907221527l3060aa85h883656bcc7d7e1c4@mail.gmail.com> <20090730222349.GC31141@shell> <150c16850907311824n71e36f66i86b508bc25d0c4bb@mail.gmail.com> <20090811213947.GA11100@shell> <20090811220511.GC31342@mit.edu> <20090812012538.GD11100@shell> <20090812020439.GE31342@mit.edu> <20090812175916.GE11100@shell> <150c16850908271930x277daa95sdea8c34868f2ce36@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Valerie Aurora <vaurora@redhat.com>,
	Andreas Dilger <adilger@sun.com>, linux-ext4@vger.kernel.org,
	Nick Dokos <nicholas.dokos@hp.com>,
	Julia Lawall <julia@diku.dk>
To: Justin Maggard <jmaggard10@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:37708 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752382AbZH1MkX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 28 Aug 2009 08:40:23 -0400
Content-Disposition: inline
In-Reply-To: <150c16850908271930x277daa95sdea8c34868f2ce36@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Aug 27, 2009 at 07:30:47PM -0700, Justin Maggard wrote:
> I've been testing the latest 64-bit e2fsprogs from the git pu branch
> (kernel.org 2.6.30.5/x86_64) on a 64-bit (~22TB) filesystem for a
> couple days, since it seems like 32-bit e2fsprogs on a 64-bit
> filesystem is going to take a while longer.  I'm able to create and
> check a filesystem without any problem.  I've also run Andreas'
> llverfs utility for a few hours and not had any complaints.  But, I'm
> running into another strange issue.  Here's what I'm doing:
> # mkfs.ext4 /dev/md0
> # mount /dev/md0 /mnt
> # mkdir /mnt/1 /mnt/2 /mnt/3 /mnt/4 /mnt/5
> # umount /mnt
> # fsck.ext4 -C0 -fy /dev/md0
> ** No errors at all at this point.  fsck returns 0. **
> # mount /dev/md0 /mnt
> The last mount command fails, and the kernel log contains:
> EXT4-fs: ext4_check_descriptors: Checksum for group 0 failed (3412!=9428)
> EXT4-fs: group descriptors corrupted!

Um, that's interesting.  What happens if run fsck.ext4 twice?  i.e:

# mkfs.ext4 /dev/md0
# mount /dev/md0 /mnt
# mkdir /mnt/1 /mnt/2 /mnt/3 /mnt/4 /mnt/5
# umount /mnt
# fsck.ext4 -C0 -fy /dev/md0
# fsck.ext4 -C0 -fy /dev/md0

						- Ted

