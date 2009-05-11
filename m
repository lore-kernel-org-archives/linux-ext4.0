From: Andreas Dilger <adilger@sun.com>
Subject: Re: [Q] ext3 mkfs: zeroing journal blocks
Date: Mon, 11 May 2009 12:20:50 -0600
Message-ID: <20090511182050.GA3209@webber.adilger.int>
References: <71a0d6ff0905110803t1a6b34ccq91d5494f95fe1f34@mail.gmail.com>
 <4A086763.9090907@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: Alexander Shishkin <alexander.shishckin@gmail.com>,
	linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:64961 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755209AbZEKSV0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 11 May 2009 14:21:26 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n4BILP10014339
	for <linux-ext4@vger.kernel.org>; Mon, 11 May 2009 11:21:25 -0700 (PDT)
Content-disposition: inline
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.02 64bit (built Apr 16 2009))
 id <0KJH00200RCR1P00@fe-sfbay-10.sun.com> for linux-ext4@vger.kernel.org; Mon,
 11 May 2009 11:21:25 -0700 (PDT)
In-reply-to: <4A086763.9090907@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On May 11, 2009  12:58 -0500, Eric Sandeen wrote:
> Alexander Shishkin wrote:
> > As far as I could tell from brief looking at jbd code, it seemed to
> > me that the only thing that has to be reset during the filesystem
> > creation time is journal superblock (talking about the default case
> > when journal resides within an ext3 partition). However, currently 
> > mke2fs -j would zero every journal block no matter what. So, the 
> > question is: can this zeroing really be avoided in mkfs? I tried
> > commenting-out ext2fs_zero_block() in mkjournal_proc() and it seems
> > to speed up mkfs a great deal while the kernel is still able to mount
> > the partition afterwards. Also, for the sake of experiment, I filled
> > the partition with urandom's contents before doing the modified mkfs
> > and it still works. My next step in this direction would be to go 
> > through jbd code, but before doing that, I thought, I'd ask here.
> 
> Looks like commit 16ed5b3af43c72f60991222b9d7ab65cf53f203d added the
> block zeroing at the same time as external journal support went in way
> back in 2001 ... IOW, it wasn't added later to fix anything in
> particular.  Also even at that time, internal journals were not zeroed,
> so it's not like that was removed in the meantime.  Seems extraneous to
> me, but ... maybe Ted knows more ...

The reason that the journal is zeroed is because there is some chance
that old (valid at the time) transaction headers and commit blocks might
be in the journal and could accidentally be "recovered" and cause bad
corruption of the filesystem.

That said, the chance of this is relatively low, so if you are feeling
lucky the zeroing of the journal could be skipped.  This accidental
journal recovery could only happen if a valid transaction completed at
block X, then there was a stale transaction from the filesystem's
previous life starting at block X+1 with the next consecutive transaction
number.  It is pretty unlikely I think.

We could avoid this problem entirely if the journal checksum was computed
to include the JBD UUID or something in the checksum value, since even
old transactions with the correct location and transaction ID would fail
the checksum because the new JBD UUID would be different.  This could
be implemented as part of the "V2 per-block journal checksum", if anyone
had time to work on that.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

