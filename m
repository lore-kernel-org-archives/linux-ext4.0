From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Why clear the orphan list when mounting a fs with errors?
Date: Tue, 04 Sep 2012 14:33:45 -0500
Message-ID: <50465799.9050906@redhat.com>
References: <503BC685.7090707@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:25890 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757568Ab2IDTdk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 4 Sep 2012 15:33:40 -0400
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q84JXdgS022524
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Tue, 4 Sep 2012 15:33:40 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id q84JXc62004166
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Tue, 4 Sep 2012 15:33:39 -0400
In-Reply-To: <503BC685.7090707@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 8/27/12 2:12 PM, Eric Sandeen wrote:
> in ext3_orphan_cleanup (same for ext4) we do:
> 
>         if (EXT3_SB(sb)->s_mount_state & EXT3_ERROR_FS) {
>                 if (es->s_last_orphan)
>                         jbd_debug(1, "Errors on filesystem, "
>                                   "clearing orphan list.\n");
>                 es->s_last_orphan = 0;
>                 jbd_debug(1, "Skipping orphan recovery on fs with errors.\n");
>                 return;
>         }
> 
> I can sort of understand not processing the orphan inode list if the
> fs is already known to be potentially corrupted, but actually clearing
> the list seems to go too far.  This means that a subsequent e2fsck
> will find even more problems as a result of the orphan list not being
> available.
> 
> It's been this way for a while though, so the original reason for the
> behavior may be lost.  Does anyone know?
> 
> I've been alerted to a somewhat odd behavior where a filesystem with
> an orphan inode list *and* in error state behaves differently if:
> 
> 1) e2fsck -p is done: e2fsck fixes things and exits happily
> 
> vs.
> 
> 2) mount is done first, then e2fsck -p: due to the orphan inode
>    list being gone, enough errors are found that e2fsck exits with
>    UNEXPECTED INCONSISTENCY.
> 
> The 2nd case above has the tendency to halt the boot process, which
> is unfortunate.

Just for posterity, replying to this first email rather than just down-thread.

I was testing a version of e2fsck which was missing one or both of these fixes (sorry):

63b3913dbc0bc7cdf8a63f3bdb0c8d7d605e9a40 e2fsck: correctly propagate error from journal to superblock
6d75685e2b76f4099589ad33732cf59f279b5d65 e2fsck: handle an already recovered journal with a non-zero s_error field

which are present in 1.42.4.  With error state properly propagated, e2fsck *also* junks the orphan inode list, and stops the preen pass:

        /* Deal with inodes that were part of corrupted orphan linked
           list (latch question) */
        { PR_1_ORPHAN_LIST_REFUGEES,
          N_("@is that were part of a corrupted orphan linked list found.  "),
          PROMPT_FIX, 0 },

So there is no inconsistency here between kernel & e2fsck behavior; neither trusts the orphan list in this case.  I guess the only remaining question is whether it's really necessary to stop the preen pass, but I suppose it is.

-Eric

