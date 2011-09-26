From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH] Add better example about how to compress e2image raw
 image
Date: Mon, 26 Sep 2011 09:13:45 -0300
Message-ID: <20110926121345.GA3486@andromeda.usersys.redhat.com>
References: <1316803672-25550-1-git-send-email-cmaiolino@redhat.com>
 <BAB1C1C4-D0BB-4398-89A5-EC8B1E20801B@dilger.ca>
 <20110923205124.GD26962@andromeda.usersys.redhat.com>
 <20110924163153.GB2779@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>, linux-ext4@vger.kernel.org
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39953 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753216Ab1IZMOx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 26 Sep 2011 08:14:53 -0400
Content-Disposition: inline
In-Reply-To: <20110924163153.GB2779@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> The problem with using tar is that it requires extra disk space by the
> user --- somewhere a bit more than double the extra disk space
> (because you need to have space for the hda1.e2i file before it gets
> compressed).  For very large file systems, this can be quite
> significant.  My general philosophy has been to make things easy as
> possible for the users as being more important for the developers.
> 
> For the developers, we do have contrib/make-sparse.c.  All we have to do is:
> 
>     bunzip2 < hda1.e2i.bz2 | make-sparse hda1.e2i
> 
> ... and this creates a sparse file in hda1.e2i.
> 

Nice to know this Ted. I'll use this instead. Thanks 

-- 
--Carlos
