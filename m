From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH v1 0/5] ext4: Shut down block groups when damage is
 detected
Date: Tue, 30 Jul 2013 08:31:09 +0800
Message-ID: <20130730003109.GE3648@gmail.com>
References: <20130719235532.24017.31896.stgit@blackbox.djwong.org>
 <20130721143226.GA13473@gmail.com>
 <x49txjdbd21.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>,
	Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Jeff Moyer <jmoyer@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f42.google.com ([209.85.160.42]:63254 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752364Ab3G3AbJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 29 Jul 2013 20:31:09 -0400
Received: by mail-pb0-f42.google.com with SMTP id un1so5309036pbc.15
        for <linux-ext4@vger.kernel.org>; Mon, 29 Jul 2013 17:31:08 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <x49txjdbd21.fsf@segfault.boston.devel.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Jeff,

On Mon, Jul 29, 2013 at 11:28:38AM -0400, Jeff Moyer wrote:
> Zheng Liu <gnehzuil.liu@gmail.com> writes:
> 
> > My idea is to let file system can ignore the currurted block.  Namely,
> > when we meet a currupted block, we will track it as bad block in bad
> > block inode and find another block to save data.  This currupted block
> > will never be used.  The first step in my mind is to detect a currpted
> > block and mark it as bad block.  After reading the thread and Darrick's
> > original patch, I think Darrick's patch is a good start.
> 
> I think it's important to call out the exact failure scenario you're
> trying to address.  For hard disks, if you get a read error, it can
> typically be recovered by re-writing the block.  I imagine this is what
> fsck would be doing for metadata repair.  So, I'm not at all sure why
> you'd want to track bad blocks in the file system itself.  Could you
> elaborate, please?

In our product system at Taobao, we have a large CDN system around the
country.  These servers cache the most of web pages, images, etc....
These servers have some disks, and the disk must break down at some
time.  Now we need to umount this disk, and the whole disk just be left
in server until the whole server is dropped.  But as you have pointed
out, when we meet a disk failure, the whole disk might still works.  So
we hope that the file system could track the bad block, doesn't allocate
them, and the rest of spaces also can be used.  This can help us to
reduce the cost.

As you said above, some faliure scenarios are hard to be addressed.
E.g., we couldn't read any data from the disk.  But most scenarios are
that the disk just has some bad sectors.  So that would be great if the
disk still can be used.  In addition, we don't care about whether fsck
can fix these bad blocks because we don't want to reboot the server.  As
I describe before, these servers are as a cache of web site.  If they
are rebooted, they must take some time to preload the content from the
other servers and can not provide service.  This is not better than what
we do now (umount the disk).

Certainly, this might makes no sense to SSD/Flash device because when we
get an error from these devices, it is possible that they couldn't be
used.

Regards,
                                                - Zheng
