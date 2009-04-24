From: Christian Kujau <lists@nerdbynature.de>
Subject: Re: ext4_ext_check_inode: bad header/extent in inode
Date: Fri, 24 Apr 2009 13:41:04 -0700 (PDT)
Message-ID: <alpine.DEB.2.01.0904241338110.6162@bogon.housecafe.de>
References: <alpine.DEB.2.01.0904191934320.6162@bogon.housecafe.de> <49F0642A.4000704@redhat.com> <alpine.DEB.2.01.0904231156460.6162@bogon.housecafe.de> <20090423204059.GM2723@mit.edu> <alpine.DEB.2.01.0904231442350.6162@bogon.housecafe.de>
 <20090424032028.GB7949@mit.edu> <alpine.DEB.2.01.0904240153310.6162@bogon.housecafe.de> <alpine.DEB.2.01.0904240235020.6162@bogon.housecafe.de> <20090424120004.GD7949@mit.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:59830 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751188AbZDXUlG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 24 Apr 2009 16:41:06 -0400
In-Reply-To: <20090424120004.GD7949@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 24 Apr 2009, Theodore Tso wrote:
> Note that because there was garbage written into the inode table,
> there was going to be data loss; there's not much that can be done
> about that.

Of course, I realize that there will be dataloss, but I assumed that fsck 
would repair the filesystem to be intact again. However, even with 
e2fsprogs-1.41.5 the I/O errors persist:

  http://nerdbynature.de/bits/2.6.30-rc3/

Thanks,
Christian.
-- 
Bruce Schneier has built a non-deterministic Turing machine, so he doesn't care
whether P=NP.
