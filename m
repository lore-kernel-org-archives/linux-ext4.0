From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Set file system to read-only by I/O error
 threshold
Date: Tue, 21 Jun 2011 10:48:56 -0400
Message-ID: <20110621144856.GH32133@thunk.org>
References: <1308312516-14252-1-git-send-email-wangshaoyan.pt@taobao.com>
 <alpine.LFD.2.00.1106181015180.4602@dhcp-27-109.brq.redhat.com>
 <BANLkTim-1FfCZAm449zp5PpApbq027HGwYhoZBF0soZpJon9tQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org,
	Wang Shaoyan <wangshaoyan.pt@taobao.com>,
	Jan Kara <jack@suse.cz>
To: Wang Shaoyan <stufever@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:58320 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750935Ab1FUOtD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 21 Jun 2011 10:49:03 -0400
Content-Disposition: inline
In-Reply-To: <BANLkTim-1FfCZAm449zp5PpApbq027HGwYhoZBF0soZpJon9tQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Ugh.  This is really, really, *really* ugly.  If you really want to
have hadoop shut down when there are too many errors, it's much better
to expose the number of EIO errors via sysfs, and then have some kind
of system daemon do the right thing.

But actually converting EIO's to file system errors isn't really a
good idea.  Consider that most of the time, when you get a read error
from the disk, if you rewrite that block, all will be will.  So taking
the entire disk off-line, and setting the errors fs bit won't really
help.  (a) Until the block is rewritten, the next time you try to read
it, you'll get an error, and (b) running fsck will be a waste of time,
since it will only scan the metadata blocks, and so the data block
will still have an error.

I assume you're using hadoopfs as your cluster file system, which has
redundancy at the file system level, right?  So getting an EIO won't
be the end of the world, since you can always read data chunk from a
redundant copy, or perform a reed-solomon reconstruction.  In fact,
disabling the entire file system is the worst thing you can do, since
you lose access to the rest of the files, which increases network
track to your cluster interconnect, especially if you have to do a R-S
reconstruction.

(In fact I've recently written up a plan to turn metadata errors into
EIO's, without bringing down the entire file system as containing
errors, to make the file system more resiliant to I/O errors --- the
exact reverse of what you're trying to do.)

For data I/O errors, what you in fact what to do is to handle them in
userspace, and just have HDFS delete the local copy of the file.  The
next time you allocate the space and rewrite the block, the disk will
do a bad block remap, and you'll be OK.

Now, you may want to do different things if the disk has completely
disappeared, or has completely died, so this is a case where it would
be desirable to get finer grained error reporting from the block I/O
layer --- there's a big difference between what you do for an error
caused by an unreadable block, and one caused by disk controller
bursting into flame.  But in general, remounting the file system
read-only should be a last-resort thing, and not the first thing you
should try doing.

Regards,

						- Ted
