From: Phillip Susi <psusi@ubuntu.com>
Subject: Re: [RESEND] [PATCH 2/2 v2] e2fsck: Do not forget to discard last
 block group
Date: Fri, 24 Feb 2012 09:46:20 -0500
Message-ID: <4F47A2BC.50307@ubuntu.com>
References: <1330072490-26833-1-git-send-email-lczerner@redhat.com> <1330072490-26833-2-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, sandeen@redhat.com
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:12159 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753114Ab2BXOqW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 24 Feb 2012 09:46:22 -0500
In-Reply-To: <1330072490-26833-2-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 2/24/2012 3:34 AM, Lukas Czerner wrote:
> Previously when running e2fsck with '-E discard' argument the end
> of the last group has not been discarded. This patch fixes it so
> we always discard the end of the last group if needed.
> 
> This commit also removes unneeded argument from the 
> e2fsck_discard_blocks(). Simultaneously the commit causes the
> block groups with BLOCK_UNINIT flag not to be discarded, which
> makes since because we do not need to reclaim the space since so
> far there has not been written anything.

I don't see where this patch changes anything to do with uninitialized
block bitmaps.  It also is still a good idea to discard them since
they may have been initialized at some point in the past and become
uninitialized again.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQEcBAEBAgAGBQJPR6K8AAoJEJrBOlT6nu75Ad8H/A4sfRF7GGqNMpfKOHMOxwE3
gjHAQNP3anFJ8aa5vkHwDEsDPBMSYlOtNWYBSY1DmaBPm0AHyrFUyWN1Q9FtcOp3
bDdsx7SXHa0NIzcguTsjw33Ln+3jiqI3vPk7gJkZyOkRw3JNcmM1MMlu/83Vaeaa
p2uQc8OzNfsuFoN62kkBj502p4/pFhfN1TCFf2EEFgw7HlS0Z4xqx0Mq3JTDJH0u
2GrYMz8ulwuYfRa2WUy5A11Oi/iLFVm0J+mI+gR94Li1zRqnwBaF99TGvEhzB0SF
MS6kykvgPU2D+n2YL9fFChQDLvyyW+zSXxYjgqrrU0DjCjVkycTQ5GsvnKoEu6c=
=FeTy
-----END PGP SIGNATURE-----
