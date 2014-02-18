From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 0/6][RFC] Introduce FALLOC_FL_ZERO_RANGE flag for
 fallocate
Date: Tue, 18 Feb 2014 09:23:05 -0500
Message-ID: <20140218142305.GN26580@thunk.org>
References: <1392649703-10772-1-git-send-email-lczerner@redhat.com>
 <20140218010138.GE13997@dastard>
 <20140218083324.GB28666@dastard>
 <alpine.LFD.2.00.1402181006250.2216@localhost.localdomain>
 <20140218094142.GC28666@dastard>
 <alpine.LFD.2.00.1402181302230.2216@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Dave Chinner <david@fromorbit.com>, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:59518 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754917AbaBROXL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 18 Feb 2014 09:23:11 -0500
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1402181302230.2216@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Feb 18, 2014 at 01:04:24PM +0100, Luk=C3=A1=C5=A1 Czerner wrote=
:
>
> > Ok, so it's a "fallocate" test group, then?
>=20
> More like "fsx_fsstress" group, which might sound as a terrible name
> for the group but it explains it quite well. So if you do not have
> anything against that I'll call the new group "fsx_fsstress"

How about "block_map" group?  I like Dave's suggestion about naming
the group after what it is trying to test, as opposed to how it does
that testing.  This is also consistent with how the other tests groups
are named in xfstests.

However, extents are an implementation strategy, and you might just as
easily use this test to verify whether or not the punch hole
functionality for indirect block maps worked correctly.

What I think using fsx and fstress together have in common is that
it's a great way of stress testing whatever the file system uses for
creating and maintaining the translation map between (inode, logical
block) to physical block, so that's why perhaps "block_map" might be a
good test group name.

Regards,

						- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
