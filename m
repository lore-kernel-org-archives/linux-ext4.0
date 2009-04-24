From: Theodore Tso <tytso@mit.edu>
Subject: Re: ext4_ext_check_inode: bad header/extent in inode
Date: Fri, 24 Apr 2009 08:00:04 -0400
Message-ID: <20090424120004.GD7949@mit.edu>
References: <alpine.DEB.2.01.0904191934320.6162@bogon.housecafe.de> <49F0642A.4000704@redhat.com> <alpine.DEB.2.01.0904231156460.6162@bogon.housecafe.de> <20090423204059.GM2723@mit.edu> <alpine.DEB.2.01.0904231442350.6162@bogon.housecafe.de> <20090424032028.GB7949@mit.edu> <alpine.DEB.2.01.0904240153310.6162@bogon.housecafe.de> <alpine.DEB.2.01.0904240235020.6162@bogon.housecafe.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org
To: Christian Kujau <christian@nerdbynature.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:60243 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757529AbZDXMAI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 24 Apr 2009 08:00:08 -0400
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.01.0904240235020.6162@bogon.housecafe.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Apr 24, 2009 at 02:40:58AM -0700, Christian Kujau wrote:
> 
> Maybe the repair with 1.41.{3,4} before did something wrong and I should 
> use 1.41.5 from the beginning? This issue is somewhat reproducible (given 
> the fs holds enough files), so I could start over, corrupt the fs again 
> and let e2fsprogs-1.41.5 do the whole job.

I doubt it; the problem was that the repair performed by e2fsck 1.41.3
was simply imcomplete.  You can try to reproduce the corrupted
filesystem again, but it should result in the same result.

Note that because there was garbage written into the inode table,
there was going to be data loss; there's not much that can be done
about that.  This just simple does a better job cleaning up after the
mess, that's all.

						- Ted

