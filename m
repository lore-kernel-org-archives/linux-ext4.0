From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [RESEND] [PATCH 2/2 v2] e2fsck: Do not forget to discard last
 block group
Date: Fri, 24 Feb 2012 15:57:19 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1202241550520.13074@dhcp-27-109.brq.redhat.com>
References: <1330072490-26833-1-git-send-email-lczerner@redhat.com> <1330072490-26833-2-git-send-email-lczerner@redhat.com> <4F47A2BC.50307@ubuntu.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org,
	tytso@mit.edu, sandeen@redhat.com
To: Phillip Susi <psusi@ubuntu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43450 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754230Ab2BXO50 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 24 Feb 2012 09:57:26 -0500
In-Reply-To: <4F47A2BC.50307@ubuntu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 24 Feb 2012, Phillip Susi wrote:

> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> On 2/24/2012 3:34 AM, Lukas Czerner wrote:
> > Previously when running e2fsck with '-E discard' argument the end
> > of the last group has not been discarded. This patch fixes it so
> > we always discard the end of the last group if needed.
> > 
> > This commit also removes unneeded argument from the 
> > e2fsck_discard_blocks(). Simultaneously the commit causes the
> > block groups with BLOCK_UNINIT flag not to be discarded, which
> > makes since because we do not need to reclaim the space since so
> > far there has not been written anything.
> 
> I don't see where this patch changes anything to do with uninitialized
> block bitmaps.  It also is still a good idea to discard them since
> they may have been initialized at some point in the past and become
> uninitialized again.

I do not see how the group would become UNINIT again, so there is not
reason to discard it. Previously we could count free block through out
several groups (accounting or BLOCK_UNINIT groups as well. We do not do
that now, because we discard every group separately.

Thanks!
-Lukas

> 
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v2.0.17 (MingW32)
> Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/
> 
> iQEcBAEBAgAGBQJPR6K8AAoJEJrBOlT6nu75Ad8H/A4sfRF7GGqNMpfKOHMOxwE3
> gjHAQNP3anFJ8aa5vkHwDEsDPBMSYlOtNWYBSY1DmaBPm0AHyrFUyWN1Q9FtcOp3
> bDdsx7SXHa0NIzcguTsjw33Ln+3jiqI3vPk7gJkZyOkRw3JNcmM1MMlu/83Vaeaa
> p2uQc8OzNfsuFoN62kkBj502p4/pFhfN1TCFf2EEFgw7HlS0Z4xqx0Mq3JTDJH0u
> 2GrYMz8ulwuYfRa2WUy5A11Oi/iLFVm0J+mI+gR94Li1zRqnwBaF99TGvEhzB0SF
> MS6kykvgPU2D+n2YL9fFChQDLvyyW+zSXxYjgqrrU0DjCjVkycTQ5GsvnKoEu6c=
> =FeTy
> -----END PGP SIGNATURE-----
> 

-- 
