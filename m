From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: s390x: kernel BUG at fs/ext4/inode.c:1591! (powerpc too!)
Date: Thu, 04 Apr 2013 00:52:29 +0800
Message-ID: <515C5E4D.3090403@gmail.com>
References: <2133129347.8273339.1364549222854.JavaMail.root@redhat.com> <87ip46ss0o.fsf@openvz.org> <1211053180.322948.1364797847717.JavaMail.root@redhat.com> <87fvzaspr8.fsf@openvz.org> <874841142.414482.1364875584266.JavaMail.root@redhat.com> <alpine.DEB.2.10.1304012249440.5874@trent.utfs.org> <877gkls1q7.fsf@openvz.org> <alpine.DEB.2.10.1304021430480.13746@trent.utfs.org> <87r4isd1vn.fsf@openvz.org> <alpine.DEB.2.10.1304021611020.13746@trent.utfs.org> <87li90q9mx.fsf@openvz.org> <87hajoq6s2.fsf@openvz.org> <87eherri5i.fsf@openvz.org> <alpine.DEB.2.10.1304030935230.13746@trent.utfs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Dmitry Monakhov <dmonakhov@openvz.org>,
	CAI Qian <caiqian@redhat.com>, Theodore Ts'o <tytso@mit.edu>,
	LKML <linux-kernel@vger.kernel.org>,
	linux-s390 <linux-s390@vger.kernel.org>,
	Steve Best <sbest@redhat.com>, linux-ext4@vger.kernel.org
To: Christian Kujau <lists@nerdbynature.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f45.google.com ([209.85.160.45]:43241 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760213Ab3DCQwg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 3 Apr 2013 12:52:36 -0400
In-Reply-To: <alpine.DEB.2.10.1304030935230.13746@trent.utfs.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 04/04/2013 12:46 AM, Christian Kujau wrote:
> On Wed, 3 Apr 2013 at 15:02, Dmitry Monakhov wrote:
>> Good news big endian cpu owners
>> Please try following patches(second is most important):
>> http://patchwork.ozlabs.org/patch/233396/
>> http://patchwork.ozlabs.org/patch/233397/
>> I hope this should fix all known issues
> 
> Zheng Liu also sent a patch:
> 
>   [PATCH] ext4: fix a big-endian bug when an extent is zeroed out
> 
> When I try to apply all three of those to 3.9-4c4, the 2nd one from Dmitry 
> fails:
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

I guess that is because Dmitry's patch is against dev branch of ext4
tree.  Please applied my patch.  I think it could fix the bug.  That
would be great if you could give this patch a try [1].

1. http://patchwork.ozlabs.org/patch/233555/

Thanks,
						- Zheng
