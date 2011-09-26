From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH] Add better example about how to compress e2image raw
 image
Date: Mon, 26 Sep 2011 16:36:08 -0300
Message-ID: <20110926193608.GC3486@andromeda.usersys.redhat.com>
References: <1316803672-25550-1-git-send-email-cmaiolino@redhat.com>
 <BAB1C1C4-D0BB-4398-89A5-EC8B1E20801B@dilger.ca>
 <20110923205124.GD26962@andromeda.usersys.redhat.com>
 <20110924163153.GB2779@thunk.org>
 <4E80A73F.2070205@redhat.com>
 <20110926192358.GC3282@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>,
	Andreas Dilger <adilger@dilger.ca>, linux-ext4@vger.kernel.org
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56400 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752904Ab1IZThP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 26 Sep 2011 15:37:15 -0400
Content-Disposition: inline
In-Reply-To: <20110926192358.GC3282@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

> If we decide that we're OK with not compressing qcow2, we could use
> qcow2.  But note that the qcow2 format is still very compressible ---
> it looks like it could do a better job removing zero blocks.  (I had a
> 256meg qcow2 e2image file compress down to 9 megs.)  Unfortunately we
> can't do stream compression with qcow2.
> 
> Long run I think we should make the qcow2 support better (by dropping
> all-zero blocks, and adding support for qcow2 to
> debugfs/dumpe2fs/e2fsck, and perhaps adding support for native
> compression).  Anyone looking for a project?  :-)
> 
> 						- Ted

Actually I'm pretty interested in contribute more to ExtFS, although I'm
not pretty much familiar with all Ext internals.
I've been contributing to GFS2 only. If you're not hurry to get it asap
and don't mind to receive some (maybe lots of) questions I can get this 
project (will need to learn more about ExtFS first :).

I can take sometime to implement it since my poor knowledge on ExtFS internals,
but, if you're ok with the above, I'm in.

-- 
--Carlos
