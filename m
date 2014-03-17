From: tytso@mit.edu
Subject: Re: [PATCH 0/6 v2] Introduce FALLOC_FL_ZERO_RANGE flag for fallocate
Date: Mon, 17 Mar 2014 09:29:01 -0400
Message-ID: <20140317132901.GA2773@thunk.org>
References: <1393355679-11160-1-git-send-email-lczerner@redhat.com>
 <20140316190820.GB14162@thunk.org>
 <20140317021909.GD14162@thunk.org>
 <alpine.LFD.2.00.1403171346280.30625@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: =?utf-8?B?THVrw6HFoSBDemVybmVyIDxsY3plcm5lckByZWRoYXQuY29tPg==?=@thunk.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:42553 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756691AbaCQN3K (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 17 Mar 2014 09:29:10 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1403171346280.30625@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 17, 2014 at 01:50:46PM +0100, Luk=C3=A1=C5=A1 Czerner wrote=
:
> > Running the tests with the dev2 branch, which includes all of the
> > ext4-specific ZERO_RANGE patches, we see a regression with shared/2=
43
> > with 4k and 1k block sizes (as well as 4k in no-journal mode):
>=20
> Oh, right. This fails because the test really should be deprecated
> since we already removed the check in e2fsck - see e2fsprogs commit
> 010dc7b90d97b93907cbf57b3b44f1c1cad234f6.
>=20
> In this patch I removed setting the EXT4_INODE_EOFBLOCKS, however I
> forgot the mention that in the description. Sorry about that.

I'm not sure how removing setting the EXT4_INODE_EOFBLOCKS flag would
result in shared/243 failing in this particular way.  The EOFBLOCKS
flag never influenced how the userspace-visible behavior of the
kernel; it only set a flag which told e2fsck that it was OK to have
blocks mapped beyond i_size.=20

So removing EOFBLOCKS could potentially cause false positives by
e2fsck for e2fsprogs previous to 1.42.2 (or which do not have the
above mentioned commit pulled on).  That's the main reason to keep
support for setting EOFBLOCKS in the kernel --- to avoid causing user
help desk reports if they try using a newer kernel w/o updating the
version of e2fsprogs on their enterprise kernel distro (not that users
_ever_ upgrade the kernel on their own ;-).

But I'm not sure how this would cause the xfstests failure detailed
below?  And how would just updating the commit description deal with
the fact that shared/243 is failing?

    	      				- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
