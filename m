From: Christian Kujau <christian@nerdbynature.de>
Subject: Re: ext4_ext_check_inode: bad header/extent in inode
Date: Fri, 24 Apr 2009 02:40:58 -0700 (PDT)
Message-ID: <alpine.DEB.2.01.0904240235020.6162@bogon.housecafe.de>
References: <alpine.DEB.2.01.0904191934320.6162@bogon.housecafe.de> <49F0642A.4000704@redhat.com> <alpine.DEB.2.01.0904231156460.6162@bogon.housecafe.de> <20090423204059.GM2723@mit.edu> <alpine.DEB.2.01.0904231442350.6162@bogon.housecafe.de>
 <20090424032028.GB7949@mit.edu> <alpine.DEB.2.01.0904240153310.6162@bogon.housecafe.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.177]:49521 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751288AbZDXJk7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 24 Apr 2009 05:40:59 -0400
In-Reply-To: <alpine.DEB.2.01.0904240153310.6162@bogon.housecafe.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 24 Apr 2009, Christian Kujau wrote:
> On Thu, 23 Apr 2009, Theodore Tso wrote:
> > It's been fixed in e2fpsrogs 1.41.5, which I've only just released.
> > It's available on git, sourceforge, and all of the other usual places.
> > This should fix the problem for you.

I got it from sourceforge now and it did indeed "do" something:

sid:~# /opt/e2fsprogs/sbin/fsck.ext4 -v /dev/md0
e2fsck 1.41.5 (23-Apr-2009)
/dev/md0 contains a file system with errors, check forced.
Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
i_file_acl_hi for inode 12042 (/lost+found/#12042) is 64578, should be zero. Clear? yes
i_file_acl_hi for inode 12207 (/lost+found/#12207) is 5, should be zero Clear? yes
i_file_acl_hi for inode 12249 (/lost+found/#12249) is 5, should be zero.Clear? yes
i_file_acl_hi for inode 12090 (/t/#12090) is 5932, should be zero. Clear? yes

...but the "Input/output error" persist :-\

Full scriptlog: http://nerdbynature.de/bits/2.6.30-rc2/scriptlog2.txt

Maybe the repair with 1.41.{3,4} before did something wrong and I should 
use 1.41.5 from the beginning? This issue is somewhat reproducible (given 
the fs holds enough files), so I could start over, corrupt the fs again 
and let e2fsprogs-1.41.5 do the whole job.

Christian.
-- 
Bruce Schneier does not leak information on the EM spectrum: he emits the theme
to The Good, The Bad, and The Ugly.
