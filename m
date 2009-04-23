From: Christian Kujau <lists@nerdbynature.de>
Subject: Re: ext4_ext_check_inode: bad header/extent in inode
Date: Thu, 23 Apr 2009 12:04:38 -0700 (PDT)
Message-ID: <alpine.DEB.2.01.0904231156460.6162@bogon.housecafe.de>
References: <alpine.DEB.2.01.0904191934320.6162@bogon.housecafe.de> <49F0642A.4000704@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:64301 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754736AbZDWTEm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 23 Apr 2009 15:04:42 -0400
In-Reply-To: <49F0642A.4000704@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 23 Apr 2009, Eric Sandeen wrote:
> I'd have expected fsck to find that, I think.  I'd first suggest using
> 1.41.4 or 1.41.5 (probably released very soon) and see if that catches
> it (I don't remember offhand if there is a relevant change since 1.41.3
> but the check should be easy...)

Yes, in fact I _did_ have the latest e2fsprogs.git checkout [0] in 
place, but did not use it. OK, compiled that, e2fsck still present itself 
as "1.41.4" (which tree do I have to follow to get the 1.41.5 one?) but
was not able to fix the errors either. Again, I do not expect e2fsck to 
actuall fix it, because the damage I did to the fs was probably too 
severe. But when fsck exits with code 0, I'd "expect" it to be clean. So, 
I guess what I want is fsck to tell me to get my backups ready, as the fs 
is damaged too heavily...

Christian.

[0] git://git.eu.kernel.org/pub/scm/fs/ext2/e2fsprogs.git
-- 
The Phaistos Disc had a hieroglyph that translates to "Bruce Schneier".
