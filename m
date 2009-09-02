From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] libext2fs: use proper functions to set/clear block group
 flags
Date: Wed, 02 Sep 2009 16:15:23 -0500
Message-ID: <4A9EE06B.5010500@redhat.com>
References: <4A9ED75A.7030406@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Ric Wheeler <rwheeler@redhat.com>,
	Justin Maggard <jmaggard10@gmail.com>
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39509 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752045AbZIBVPZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 2 Sep 2009 17:15:25 -0400
In-Reply-To: <4A9ED75A.7030406@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Eric Sandeen wrote:
> As Justin & Ric reported, something like this on a
> 22T (sparse) bigfile:
> 
> 	e2fsprogs/misc/mke2fs -E lazy_itable_init=1 \
> 			      -O uninit_bg -b 4096 bigfile
> 	mount -o loop bigfile mnt/
> 	for I in `seq 1 5`; do mkdir mnt/$I; done
> 	umount mnt/
> 	e2fsprogs/e2fsck/e2fsck -f bigfile
> 
> would give us corrupted block group checksums:
> 
> 	<other problems related to uninit snipped>
> 	One or more block group descriptor checksums are invalid.  Fix<y>? yes
> 
> 	Group descriptor 6301 checksum is invalid.  FIXED.
> 	Group descriptor 7799 checksum is invalid.  FIXED.
> 
> There wer=re a few places which accessed bg_flags directly 
> rather than using the helper functions; fixing these seems
> to resolve the problem.

Well, it resolves that problem, but further testing reveals another
lurking behind it, so expect more patches ;)

-Eric
