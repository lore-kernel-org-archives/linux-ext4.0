From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Metadata reservation for unwritten extent conversion
Date: Wed, 13 Mar 2013 23:21:18 -0400
Message-ID: <20130314032118.GA11821@thunk.org>
References: <alpine.LFD.2.00.1303131629350.7128@dhcp-1-104.brq.redhat.com>
 <alpine.LFD.2.00.1303131706180.18319@dhcp-1-104.brq.redhat.com>
 <20130313172521.GC5604@thunk.org>
 <alpine.LFD.2.00.1303131830570.18319@dhcp-1-104.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:53298 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755675Ab3CNDVW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 13 Mar 2013 23:21:22 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1303131830570.18319@dhcp-1-104.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Mar 13, 2013 at 06:31:25PM +0100, Luk=C3=A1=C5=A1 Czerner wrote=
:
> > That sounds like the best thing to do.  I assume you will be simply
> > taking the da_reserve_metadata() function introduced in the
> > to-be-dropped commit:
> >=20
> > > ext4: Reserve metadata if writing into uninitialized
> >=20
> > ... and moving it into the "reserve metadata block for every delaye=
d
> > write" patch?

I wnated to kick off some testing tonight, so I've made this change to
the git tree.  So the new version of "reserve metadata block for every
delayed write" is here:

https://git.kernel.org/cgit/linux/kernel/git/tytso/ext4.git/commit/?h=3D=
dev&id=3Dc7cf7abbf754f16b78a8b9641d06baac6be60524

=2E.. and the dev branch has been modified to drop the "reserve metadat=
a
if writing into unitialized.." commit.

						- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
