From: Andreas Dilger <adilger@Sun.COM>
Subject: Re: [PATCH] building e2fsprogs-interim
Date: Thu, 14 Feb 2008 15:47:04 -0700
Message-ID: <20080214224704.GS3029@webber.adilger.int>
References: <47B487C4.8010602@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:41416 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753089AbYBNWrJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 14 Feb 2008 17:47:09 -0500
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m1EMl83E012465
	for <linux-ext4@vger.kernel.org>; Thu, 14 Feb 2008 14:47:08 -0800 (PST)
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0JW900B0136LB400@fe-sfbay-10.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Thu, 14 Feb 2008 14:47:08 -0800 (PST)
In-reply-to: <47B487C4.8010602@redhat.com>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Feb 14, 2008  12:26 -0600, Eric Sandeen wrote:
> I needed this patch to build e2fsprogs-interim, to fix a parallel make problem

Thanks, I've added to our CVS in case we ever have to re-submit the patch.

> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> Index: e2fsprogs-1.40.6/lib/ext2fs/Makefile.in
> ===================================================================
> --- e2fsprogs-1.40.6.orig/lib/ext2fs/Makefile.in
> +++ e2fsprogs-1.40.6/lib/ext2fs/Makefile.in
> @@ -518,7 +518,7 @@ mkdir.o: $(srcdir)/mkdir.c $(srcdir)/ext
>   $(top_builddir)/lib/ext2fs/ext2_types.h $(srcdir)/ext2fs.h \
>   $(srcdir)/ext2_fs.h $(srcdir)/ext3_extents.h $(top_srcdir)/lib/et/com_err.h \
>   $(srcdir)/ext2_io.h $(top_builddir)/lib/ext2fs/ext2_err.h $(srcdir)/bitops.h
> -mmp.o: $(srcdir)/ext2_fs.h $(srcdir)/ext2fs.h
> +mmp.o: $(srcdir)/ext2_fs.h $(srcdir)/ext2fs.h $(top_builddir)/lib/ext2fs/ext2_err.h
>  mkjournal.o: $(srcdir)/mkjournal.c $(srcdir)/ext2_fs.h \
>   $(top_builddir)/lib/ext2fs/ext2_types.h $(top_srcdir)/lib/e2p/e2p.h \
>   $(srcdir)/ext2_fs.h $(srcdir)/ext2fs.h $(srcdir)/ext3_extents.h \
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.
