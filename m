From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: mkfs.ext4 vs. e2fsck discard oddities
Date: Wed, 29 Feb 2012 23:47:51 -0500
Message-ID: <34CA4C93-194F-45F3-9A94-E181A7DFEBCE@mit.edu>
References: <4F4D1020.5060204@redhat.com> <alpine.LFD.2.00.1202290801510.4926@dhcp-27-109.brq.redhat.com>
Mime-Version: 1.0 (Apple Message framework v1257)
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Theodore Tso <tytso@mit.edu>, Eric Sandeen <sandeen@redhat.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from DMZ-MAILSEC-SCANNER-8.MIT.EDU ([18.7.68.37]:52262 "EHLO
	dmz-mailsec-scanner-8.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754542Ab2CAErp convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 29 Feb 2012 23:47:45 -0500
In-Reply-To: <alpine.LFD.2.00.1202290801510.4926@dhcp-27-109.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


On Feb 29, 2012, at 2:12 AM, Lukas Czerner wrote:
>=20
> The reason is (as I commented in the patch #2) that we will not disca=
rd
> BLOCK_UNINIT groups. We use BLOCK_UNINIT as a optimization measure to
> skip groups which are likely to be non-provisioned, because we have
> never written there anything since the mkfs.
>=20
> If you create file system without discard, then obviously nothing is
> discarded, image is fully provisioned and e2fsck discard *only* initi=
alized
> groups. So you'll end up with the bigger image, in case that your ima=
ge was
> not sparse.

i still think it makes sense to have an option where we discard everyth=
ing
including BLOCK_UNINIT blocks.   Mke2fs doesn't discard blocks by defau=
lt
because of a fear of crappy SSD drives, and while that fear may be
overstated, assuming that all of the unused blocks will *always* have b=
een
discarded at mkfs time isn't necessarily a good thing to assume.   I'll=
 grant
that it might be a fine default, but there needs to be *some* way to di=
scard
everything that's unused=85.

-- Ted

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
