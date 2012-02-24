From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [RESEND] [PATCH 2/2 v2] e2fsck: Do not forget to discard last
 block group
Date: Fri, 24 Feb 2012 17:13:20 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1202241710190.13074@dhcp-27-109.brq.redhat.com>
References: <1330072490-26833-1-git-send-email-lczerner@redhat.com> <1330072490-26833-2-git-send-email-lczerner@redhat.com> <4F47A2BC.50307@ubuntu.com> <alpine.LFD.2.00.1202241550520.13074@dhcp-27-109.brq.redhat.com> <4F47B32B.5020006@ubuntu.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org,
	tytso@mit.edu, sandeen@redhat.com
To: Phillip Susi <psusi@ubuntu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:17524 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757660Ab2BXQN2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 24 Feb 2012 11:13:28 -0500
In-Reply-To: <4F47B32B.5020006@ubuntu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 24 Feb 2012, Phillip Susi wrote:

> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> On 2/24/2012 9:57 AM, Lukas Czerner wrote:
> >> I do not see how the group would become UNINIT again, so there is
> >> not reason to discard it. Previously we could count free block
> >> through out several groups (accounting or BLOCK_UNINIT groups as
> >> well. We do not do that now, because we discard every group
> >> separately.
> 
> Simple; delete some files.  Once all blocks in the block group are
> free again, it can go back to UNINIT.  Also the fs may have been
> formatted without discard, or moved with dd, or any number of ways
> that the bock allocation bitmap could still use a discard despite
> being uninitialized.

It does not work that way, uinit is never set back. If it has been
formated without discard it is user choice, moving the image to the
thinly provisioned device, or ssd with dd is really bad idea anyway.
That said, UNINIT means that it has not been used and hence there
should be nothing to reclaim.

-Lukas

> 
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v2.0.17 (MingW32)
> Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/
> 
> iQEcBAEBAgAGBQJPR7MrAAoJEJrBOlT6nu751oMIAN4YsKxC5XjHOTyif0U4Pffj
> x0TCcXW+0BS6bOfwvGq/3DLO9oCJXOh6mCIPxNNJZJ0NQt0t6yLmpnuZIw7AXzJT
> +WCxduNxnu9e/bIy1vzKlwcUkzd+lb8XIljEcO9RBDj+3LUFT4YYlCE8yiITze8V
> EZiE81U1IJtguhWzqFQmOsJrH0KP5kb7BE36yn5I+yfs5YYc3CyMrqi4SVpdv4gX
> /+YoroJCEa89nsk6pluk+uAGPd/gxeSC6w32YjJqaM5bVLpiD6yhKsqIXNQK8HzB
> uXNxZvvrHLBBQtp31+r0yy90K3eQmc2ycwn54DKkK+vOioH7Q2AB+s8YTxr/Hq0=
> =DOVr
> -----END PGP SIGNATURE-----
> 
