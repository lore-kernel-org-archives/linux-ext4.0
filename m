From: Andreas Dilger <adilger@sun.com>
Subject: Re: How to fix up mballoc
Date: Thu, 23 Jul 2009 20:30:51 -0600
Message-ID: <20090724023051.GO4231@webber.adilger.int>
References: <20090721001750.GD4231@webber.adilger.int>
 <20090722074352.GA21869@mit.edu> <4A67EE3F.4090909@redhat.com>
 <20090723134538.GC8040@mit.edu> <4A68A153.8030804@redhat.com>
 <20090724002317.GA14052@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:44748 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751009AbZGXCbY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 23 Jul 2009 22:31:24 -0400
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n6O2VIBO027446
	for <linux-ext4@vger.kernel.org>; Thu, 23 Jul 2009 19:31:18 -0700 (PDT)
Content-disposition: inline
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.02 64bit (built Apr 16 2009))
 id <0KN900I00LG16H00@fe-sfbay-09.sun.com> for linux-ext4@vger.kernel.org; Thu,
 23 Jul 2009 19:31:18 -0700 (PDT)
In-reply-to: <20090724002317.GA14052@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Jul 23, 2009  20:23 -0400, Theodore Ts'o wrote:
> On Thu, Jul 23, 2009 at 12:43:47PM -0500, Eric Sandeen wrote:
> > > 1) In ext4_mb_normalize_request(), if the inode that we are allocating
> > > does not have any open file descriptors for write (i.e., it's already
> > > closed and we're allocating via delalloc) _and_ the inode was
> > > previously opened with O_CREAT and without O_APPEND (checked via a
> > > flag in EXT4_I(inode)), then do not normalize the size to a power of
> > > two, but rather to the filesystem blocksize.
> > 
> > I'm sort of woefully ignorant of a lot of the mballoc stuff.
> > 
> > When you say once a file is written that's probably the final size... do
> > you mean when writes are done and it's closed, or when the first write
> > to the file is complete?
> > 
> > I think an awful lot of normal cases write to a file in sub-file-sized
> > chunks (think mp3 or flac encoding, file downloading, etc).
> 
> I meant when the writes are done and the files are closed; hence my
> proposal that we do this do #1 above only if there are no open file
> descriptors for write.  That is, if the file can be written and closed
> by the userspace process before any delayed allocation blocks are
> attempted to be written by the filesystem, we can probably safely
> assume that the file won't grown in size later on.

Right, this is a reasonable default I think.

> > Also, I get the !O_APPEND test, but is O_CREAT necessary?  I wonder how
> > much of a hint that really gives us.
> 
> Well, it probably should be O_CREAT || O_TRUNC.  The basic idea here is
> to distinguish between a file which gets appended to via syslog, or
> via a mail delivery program that writes 4k of data to the end of a
> mail spool file.  In some cases, such as the mail delivery program, it
> might not use O_APPEND, but instead it might lock the file, seek to
> end of the file, and then right the 4k worth of e-mail.  So if the
> file wasn't freshly created (or truncated) at the last open, maybe we
> should use a more aggressive preallocation --- and in the case of
> /var/mail spool delivery, perhaps the preallocation should persist
> beyond the file getting closed.  (In the future we might want to have
> some hueristics where if we notice that the pattern of file writes is
> a repeated open, write-causing-block-allocation, close, maybe we
> should do some kind of block reservation style scheme while the
> filesystem is mounted and the inode stays in the inode cache.)

I think you are on the right track with the !O_TRUNC check.  Namely,
any file which is a non-zero size and gets an extending write at a
non-zero offset should probably get some persistent preallocation
(fallocate).

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

