From: Christian Kujau <lists@nerdbynature.de>
Subject: Re: ext4_ext_check_inode: bad header/extent in inode
Date: Thu, 23 Apr 2009 15:15:10 -0700 (PDT)
Message-ID: <alpine.DEB.2.01.0904231442350.6162@bogon.housecafe.de>
References: <alpine.DEB.2.01.0904191934320.6162@bogon.housecafe.de> <49F0642A.4000704@redhat.com> <alpine.DEB.2.01.0904231156460.6162@bogon.housecafe.de> <20090423204059.GM2723@mit.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.177]:62777 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758498AbZDWWPP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 23 Apr 2009 18:15:15 -0400
In-Reply-To: <20090423204059.GM2723@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 23 Apr 2009, Theodore Tso wrote:
> Eventually I might need a raw e2image dump, i.e.:
> 
> 	   e2image -r /dev/md0 - | bzip2 > /var/tmp/md0.e2i.bz2

I've put the raw e2image dump on http://nerdbynature.de/bits/2.6.30-rc2/
Do you still need the dump without the "-r"?

I could even delete all the intact files on the filesystem, fill the free 
space will zeros and try to dump the whole image if that would be helpful. 

Thanks,
Christian.
-- 
Bruce Schneier only smiles when he finds an unbreakable cryptosystem. Of
course, Bruce Schneier never smiles.
