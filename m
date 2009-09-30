From: Andreas Dilger <adilger@sun.com>
Subject: Re: Question on fallocate/ftruncate sequence
Date: Wed, 30 Sep 2009 02:10:44 -0600
Message-ID: <20090930081044.GG3384@webber.adilger.int>
References: <20090830025250.GA25768@mit.edu>
 <5df78e1d0908311240s3205b4bcrb65b2552b4ed579c@mail.gmail.com>
 <20090831215612.GG4197@webber.adilger.int>
 <5df78e1d0908311633k1f16a096t701e0cdab54b174c@mail.gmail.com>
 <20090902084134.GO4197@webber.adilger.int>
 <5df78e1d0909022220m1152b313o92f6cb7cc8858298@mail.gmail.com>
 <5df78e1d0909232227y2cb52abew827d7732a3bc9040@mail.gmail.com>
 <4AC25CCB.8050805@redhat.com>
 <5df78e1d0909291238q44bbf9e8q98205ffa9b6b2518@mail.gmail.com>
 <4AC26630.6030509@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: Jiaying Zhang <jiayingz@google.com>, Theodore Tso <tytso@mit.edu>,
	Frank Mayhar <fmayhar@google.com>,
	Curt Wohlgemuth <curtw@google.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:58269 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405AbZI3IKy (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 30 Sep 2009 04:10:54 -0400
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n8U8Auqb017858
	for <linux-ext4@vger.kernel.org>; Wed, 30 Sep 2009 01:10:58 -0700 (PDT)
Content-disposition: inline
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.04 64bit (built Jul  2 2009))
 id <0KQR00K00YMF7Z00@fe-sfbay-09.sun.com> for linux-ext4@vger.kernel.org; Wed,
 30 Sep 2009 01:10:56 -0700 (PDT)
In-reply-to: <4AC26630.6030509@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sep 29, 2009  14:55 -0500, Eric Sandeen wrote:
> Jiaying Zhang wrote:
> > As Andreas suggested, I think the main purpose is to allow users
> > to scan for any files with EOF flag with the getflag ioctl. We may
> > not allow users to clear it with the setflag ioctl but just rely on
> > the truncate interface, but supporting the setflag ioctl interface
> > doesn't seem to do any harm.
> 
> I like the idea of being able to find them, but adding the clearing
> interface seems redundant to me.  All filesystems would need to
> implement this, and I don't see that we gain anything.

I hadn't originally thought about being able to clear the flag, but
now that it is implemented, I don't have a big objection to it.
The one useful feature is that this could be done without changing
the timestamps on the files, and it can be done easily from a script.

We don't even have an fallocate() or other truncate() interface that
can do this without changing the timestamps today.  Even if we did
use truncate(), that is racy with an application writing to the file,
so it is not as safe as a call which is guaranteed to only discard
the unused preallocated blocks.

I don't think all other filesystems need to support it, that is up
to them.

As to whether applications use this or not remains to be seen.  I
doubt most applications will be written to be ext4-specific, but
I like the ability to scan/clear preallocated space without writing
a binary to do that, if I need it in the future.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

