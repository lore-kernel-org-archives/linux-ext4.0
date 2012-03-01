From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: mkfs.ext4 vs. e2fsck discard oddities
Date: Thu, 1 Mar 2012 08:12:44 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1203010804410.6491@dhcp-27-109.brq.redhat.com>
References: <4F4D1020.5060204@redhat.com> <alpine.LFD.2.00.1202290801510.4926@dhcp-27-109.brq.redhat.com> <34CA4C93-194F-45F3-9A94-E181A7DFEBCE@mit.edu>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-140617535-1330585967=:6491"
Cc: Lukas Czerner <lczerner@redhat.com>,
	Eric Sandeen <sandeen@redhat.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36785 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758131Ab2CAHMt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 1 Mar 2012 02:12:49 -0500
In-Reply-To: <34CA4C93-194F-45F3-9A94-E181A7DFEBCE@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-140617535-1330585967=:6491
Content-Type: TEXT/PLAIN; charset=windows-1252
Content-Transfer-Encoding: 8BIT

On Wed, 29 Feb 2012, Theodore Tso wrote:

> 
> On Feb 29, 2012, at 2:12 AM, Lukas Czerner wrote:
> > 
> > The reason is (as I commented in the patch #2) that we will not discard
> > BLOCK_UNINIT groups. We use BLOCK_UNINIT as a optimization measure to
> > skip groups which are likely to be non-provisioned, because we have
> > never written there anything since the mkfs.
> > 
> > If you create file system without discard, then obviously nothing is
> > discarded, image is fully provisioned and e2fsck discard *only* initialized
> > groups. So you'll end up with the bigger image, in case that your image was
> > not sparse.
> 
> i still think it makes sense to have an option where we discard everything
> including BLOCK_UNINIT blocks.   Mke2fs doesn't discard blocks by default
> because of a fear of crappy SSD drives, and while that fear may be
> overstated, assuming that all of the unused blocks will *always* have been
> discarded at mkfs time isn't necessarily a good thing to assume.   I'll grant
> that it might be a fine default, but there needs to be *some* way to discard
> everything that's unused….
> 
> -- Ted
> 
> 

Hi Ted,

actually mke2fs does discard block by default. It has been like that
since the beginning. Back then we only had '-K' argument to 'keep'
blocks and do not attempt to discard. Nowadays user can do '-E
nodiscard', but it is users choice. That one of the premiss of my patch
to skip BLOKC_UNINIT.

I hope that the 'age' of crappy SSD's is over now, and even though
there are surely some of them still running we do not want to optimize
for them, but rather for the better quality SSD's right ?

Thanks!
-Lukas

--8323328-140617535-1330585967=:6491--
