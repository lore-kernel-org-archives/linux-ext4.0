From: Christian Kujau <lists@nerdbynature.de>
Subject: Re: ext4_ext_check_inode: bad header/extent in inode
Date: Fri, 24 Apr 2009 14:02:15 -0700 (PDT)
Message-ID: <alpine.DEB.2.01.0904241359380.6162@bogon.housecafe.de>
References: <alpine.DEB.2.01.0904191934320.6162@bogon.housecafe.de> <49F0642A.4000704@redhat.com> <alpine.DEB.2.01.0904231156460.6162@bogon.housecafe.de> <20090423204059.GM2723@mit.edu> <alpine.DEB.2.01.0904231442350.6162@bogon.housecafe.de>
 <20090424032028.GB7949@mit.edu> <alpine.DEB.2.01.0904240153310.6162@bogon.housecafe.de> <alpine.DEB.2.01.0904240235020.6162@bogon.housecafe.de> <20090424120004.GD7949@mit.edu> <49F1B24B.7080308@redhat.com> <alpine.DEB.2.01.0904241318460.6162@bogon.housecafe.de>
 <49F22244.5040407@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.188]:64989 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754155AbZDXVDB (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 24 Apr 2009 17:03:01 -0400
In-Reply-To: <49F22244.5040407@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 24 Apr 2009, Eric Sandeen wrote:
> They don't actually have any blocks,

So, they could be just deleted anyway? While I cannot do so with "rm", 
debugfs was able to (thanks for the hint!):

http://nerdbynature.de/bits/2.6.30-rc3/screenlog2.txt

Now I have only 2 files left triggering the "Input/output error" - I could 
kill these off with debugfs as well, then the filesystem should be clean 
again. Still, I wish fsck had done this for me :-)

Christian.
-- 
Bruce Schneier has built a non-deterministic Turing machine, so he doesn't care
whether P=NP.
