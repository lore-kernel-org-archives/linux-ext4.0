From: Eric Sandeen <sandeen@redhat.com>
Subject: Why clear the orphan list when mounting a fs with errors?
Date: Mon, 27 Aug 2012 14:12:05 -0500
Message-ID: <503BC685.7090707@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48992 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752403Ab2H0TMG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 27 Aug 2012 15:12:06 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q7RJC6so021694
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Mon, 27 Aug 2012 15:12:06 -0400
Received: from Liberator-563.local (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id q7RJC5A3019484
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Mon, 27 Aug 2012 15:12:06 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

in ext3_orphan_cleanup (same for ext4) we do:

        if (EXT3_SB(sb)->s_mount_state & EXT3_ERROR_FS) {
                if (es->s_last_orphan)
                        jbd_debug(1, "Errors on filesystem, "
                                  "clearing orphan list.\n");
                es->s_last_orphan = 0;
                jbd_debug(1, "Skipping orphan recovery on fs with errors.\n");
                return;
        }

I can sort of understand not processing the orphan inode list if the
fs is already known to be potentially corrupted, but actually clearing
the list seems to go too far.  This means that a subsequent e2fsck
will find even more problems as a result of the orphan list not being
available.

It's been this way for a while though, so the original reason for the
behavior may be lost.  Does anyone know?

I've been alerted to a somewhat odd behavior where a filesystem with
an orphan inode list *and* in error state behaves differently if:

1) e2fsck -p is done: e2fsck fixes things and exits happily

vs.

2) mount is done first, then e2fsck -p: due to the orphan inode
   list being gone, enough errors are found that e2fsck exits with
   UNEXPECTED INCONSISTENCY.

The 2nd case above has the tendency to halt the boot process, which
is unfortunate.

The situation might be improved by at least not clearing the orphan
inode list when the fs is mounted readonly.  What do folks think?

Thanks,
-Eric
