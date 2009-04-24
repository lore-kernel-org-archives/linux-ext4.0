From: Christian Kujau <lists@nerdbynature.de>
Subject: Re: ext4_ext_check_inode: bad header/extent in inode
Date: Fri, 24 Apr 2009 01:57:27 -0700 (PDT)
Message-ID: <alpine.DEB.2.01.0904240153310.6162@bogon.housecafe.de>
References: <alpine.DEB.2.01.0904191934320.6162@bogon.housecafe.de> <49F0642A.4000704@redhat.com> <alpine.DEB.2.01.0904231156460.6162@bogon.housecafe.de> <20090423204059.GM2723@mit.edu> <alpine.DEB.2.01.0904231442350.6162@bogon.housecafe.de>
 <20090424032028.GB7949@mit.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:51625 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753013AbZDXI52 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 24 Apr 2009 04:57:28 -0400
In-Reply-To: <20090424032028.GB7949@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 23 Apr 2009, Theodore Tso wrote:
> It's been fixed in e2fpsrogs 1.41.5, which I've only just released.
> It's available on git, sourceforge, and all of the other usual places.
> This should fix the problem for you.

I'm pulling from git.eu.kernel.org and thought that it hasn't been sync'ed 
yet. But git.kernel.org still lists 8203fe506a06524587c18940b6cd19a0592a4bd2
as the last commit.

How do I checkout the latest version? I thought "git pull" would just do 
that.

Thanks,
Christian.
-- 
Bruce Schneier can change most random distributions. With his fists.
