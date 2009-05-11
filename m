From: Andreas Dilger <adilger@sun.com>
Subject: Re: [Q] ext3 mkfs: zeroing journal blocks
Date: Mon, 11 May 2009 13:35:22 -0600
Message-ID: <20090511193522.GD3209@webber.adilger.int>
References: <71a0d6ff0905110803t1a6b34ccq91d5494f95fe1f34@mail.gmail.com>
 <4A086763.9090907@redhat.com> <20090511182050.GA3209@webber.adilger.int>
 <4A087202.4010601@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: Alexander Shishkin <alexander.shishckin@gmail.com>,
	linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:36166 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754025AbZEKTgA (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 11 May 2009 15:36:00 -0400
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n4BJZxvf023674
	for <linux-ext4@vger.kernel.org>; Mon, 11 May 2009 12:35:59 -0700 (PDT)
Content-disposition: inline
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.02 64bit (built Apr 16 2009))
 id <0KJH00B00VB7K400@fe-sfbay-09.sun.com> for linux-ext4@vger.kernel.org; Mon,
 11 May 2009 12:35:59 -0700 (PDT)
In-reply-to: <4A087202.4010601@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On May 11, 2009  13:44 -0500, Eric Sandeen wrote:
> Andreas Dilger wrote:
> > The reason that the journal is zeroed is because there is some chance
> > that old (valid at the time) transaction headers and commit blocks might
> > be in the journal and could accidentally be "recovered" and cause bad
> > corruption of the filesystem.
> 
> But I guess the question is, why isn't a normal internal log zeroed?
> 
> If I'm reading it right only external logs get this treatment, and I
> think that's what generated the original question from Alexander.

Hmm, possibly because when ext3 was first allocated the internal journal
created was "dd if=/dev/zero of=/mnt/fs/.journal bs=1M count={jnl_size}"
on the filesystem mounted as ext2, so normal filesystem IO would handle
the zeroing of the blocks.  Even today if tune2fs adds a journal to a
filesystem it does the zero filling of the journal.

Looking at the mke2fs code it also appears to be doing zeroing of the
journal inode in:

      mke2fs
        ->ext2fs_add_journal_inode
	  ->write_journal_inode
	    ->ext2fs_block_iterate
	      ->mkjournal_proc (increment zero_count)
	  ->ext2fs_zero_blocks

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

