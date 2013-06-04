From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Question on delalloc
Date: Tue, 4 Jun 2013 15:01:50 -0400
Message-ID: <20130604190150.GR3030@thunk.org>
References: <CAJ1XODTmBmdOu+EL8OZy8ZRU4DbT7F179U7BrNDrQJQGtYQuWw@mail.gmail.com>
 <51ADF914.6070209@redhat.com>
 <CAJ1XODRNm6RyCNdQrUTKe2hOvECDVmxuzv6BUFY8eSX_MVSWSQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org
To: =?utf-8?B?5a6L5p+P57+w?= <solarispika@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:54840 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750784Ab3FDTBy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 4 Jun 2013 15:01:54 -0400
Content-Disposition: inline
In-Reply-To: <CAJ1XODRNm6RyCNdQrUTKe2hOvECDVmxuzv6BUFY8eSX_MVSWSQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jun 05, 2013 at 01:30:22AM +0800, =E5=AE=8B=E6=9F=8F=E7=BF=B0 w=
rote:
> Though what I tried to
> said is that delalloc'd data will stop kjournald from writing them
> back when it would like to do so, therefore those delalloc'd data wil=
l
> stay in memory more longer than those non-delalloc'd ones.=20

That's not why when you enable delayed allocation data can stay in
memory longer than when delalloc is disabled (or when ext3 is used).
So you were wrong about why this happens, although the observation is
correct.

> As described in http://lwn.net/Articles/322823/.=20

Please note that the current behaviour vis-a-vis buffered writes and
when you they will written to disk is generally true for all modern
file systems: xfs, btrfs, and ext4.  The workaround described at the
end of the above article has been adopted by all of the modern file
systems, as a workaround for buggy user space applications (which at
one point included core libraries for both GNOME and KDE); this
workaround however is __not__ guaranteed by POSIX, and there are other
operationg systems, such as MacOS X, where you can't guarantee on
these semantics.

(In fact with MacOS, by default fsync() is even weaker than what POSIX
guarantees; you need use fcntl(F_FULLSYNC) to get POSIX guarantees.)

More context can be found here:

     http://blahg.josefsipek.net/?p=3D364

							- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
