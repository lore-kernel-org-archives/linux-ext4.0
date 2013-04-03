From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: s390x: kernel BUG at fs/ext4/inode.c:1591! (powerpc too!)
Date: Wed, 03 Apr 2013 20:50:31 +0400
Message-ID: <87r4irpnhk.fsf@openvz.org>
References: <2133129347.8273339.1364549222854.JavaMail.root@redhat.com> <87ip46ss0o.fsf@openvz.org> <1211053180.322948.1364797847717.JavaMail.root@redhat.com> <87fvzaspr8.fsf@openvz.org> <874841142.414482.1364875584266.JavaMail.root@redhat.com> <alpine.DEB.2.10.1304012249440.5874@trent.utfs.org> <877gkls1q7.fsf@openvz.org> <alpine.DEB.2.10.1304021430480.13746@trent.utfs.org> <87r4isd1vn.fsf@openvz.org> <alpine.DEB.2.10.1304021611020.13746@trent.utfs.org> <87li90q9mx.fsf@openvz.org> <87hajoq6s2.fsf@openvz.org> <87eherri5i.fsf@openvz.org> <alpine.DEB.2.10.1304030935230.13746@trent.utfs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: CAI Qian <caiqian@redhat.com>, Theodore Ts'o <tytso@mit.edu>,
	LKML <linux-kernel@vger.kernel.org>,
	linux-s390 <linux-s390@vger.kernel.org>,
	Steve Best <sbest@redhat.com>, linux-ext4@vger.kernel.org,
	Zheng Liu <gnehzuil.liu@gmail.com>
To: Christian Kujau <lists@nerdbynature.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lb0-f178.google.com ([209.85.217.178]:43768 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760213Ab3DCQuh (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 3 Apr 2013 12:50:37 -0400
In-Reply-To: <alpine.DEB.2.10.1304030935230.13746@trent.utfs.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 3 Apr 2013 09:46:56 -0700 (PDT), Christian Kujau <lists@nerdbynature.de> wrote:
> On Wed, 3 Apr 2013 at 15:02, Dmitry Monakhov wrote:
> > Good news big endian cpu owners
> > Please try following patches(second is most important):
> > http://patchwork.ozlabs.org/patch/233396/
> > http://patchwork.ozlabs.org/patch/233397/
> > I hope this should fix all known issues
> 
> Zheng Liu also sent a patch:
> 
>   [PATCH] ext4: fix a big-endian bug when an extent is zeroed out
> 
> When I try to apply all three of those to 3.9-4c4, the 2nd one from Dmitry 
> fails:
Yes. becase my patch was against ext4.git/dev so just ignore it.
Teodore have sent a patch http://patchwork.ozlabs.org/patch/233555/
This is most probable candidate for final fix.
> 
> $ cat ~/dev/002-ext4_fix-cpu_vs_disk-conversions.diff | patch --dry-run -p1
> patching file fs/ext4/extents.c
> Hunk #2 FAILED at 2999.
> Hunk #3 FAILED at 3272.
> Hunk #4 FAILED at 4639.
> 3 out of 4 hunks FAILED -- saving rejects to file fs/ext4/extents.c.rej
> patching file fs/ext4/indirect.c
> Hunk #1 succeeded at 1539 (offset 215 lines).
> patching file fs/ext4/inode.c
> patching file fs/ext4/mmp.c
> patching file fs/ext4/namei.c
> patching file fs/ext4/super.c
> Hunk #1 succeeded at 1951 (offset -3 lines).
> patching file fs/ext4/xattr.c
> patching file include/trace/events/ext4.h
> Hunk #1 succeeded at 1956 (offset 8 lines).
> Hunk #2 succeeded at 2060 (offset 8 lines).
> Hunk #3 succeeded at 2079 (offset 8 lines).
> 
> With only Dimitry's patchesm this happens, to -rc4:
> 
> $ cat ~/dev/001-ext4_fix-usless-declarations.diff | patch -p1
> patching file fs/ext4/ialloc.c
> patching file fs/ext4/ioctl.c
> Hunk #1 succeeded at 359 (offset 4 lines).
> patching file fs/ext4/mballoc.c
> patching file fs/ext4/move_extent.c
> 
> $ cat ~/dev/002-ext4_fix-cpu_vs_disk-conversions.diff | patch --dry-run -p1
> patching file fs/ext4/extents.c
> Hunk #4 FAILED at 4639.
> 1 out of 4 hunks FAILED -- saving rejects to file fs/ext4/extents.c.rej
> patching file fs/ext4/indirect.c
> Hunk #1 succeeded at 1539 (offset 215 lines).
> patching file fs/ext4/inode.c
> patching file fs/ext4/mmp.c
> patching file fs/ext4/namei.c
> patching file fs/ext4/super.c
> Hunk #1 succeeded at 1951 (offset -3 lines).
> patching file fs/ext4/xattr.c
> patching file include/trace/events/ext4.h
> Hunk #1 succeeded at 1956 (offset 8 lines).
> Hunk #2 succeeded at 2060 (offset 8 lines).
> Hunk #3 succeeded at 2079 (offset 8 lines).
> 
> 
> Christian.
> -- 
> BOFH excuse #451:
> 
> astropneumatic oscillations in the water-cooling
