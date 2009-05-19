From: Thierry Vignaud <tvignaud@mandriva.com>
Subject: Re: More ext4 acl/xattr corruption - 4th occurence now
Date: Tue, 19 May 2009 12:00:56 +0200
Message-ID: <m2iqjx5s4n.fsf@vador.mandriva.com>
References: <20090513062634.GE4972@kulgan> <20090514044011.GC11352@mit.edu>
	<20090514110659.GA5146@kulgan> <20090514132506.GD5146@kulgan>
	<20090514140732.GI11352@mit.edu> <20090514143014.GH5146@kulgan>
	<20090514161254.GJ11352@mit.edu> <20090514210244.GL5146@kulgan>
	<20090514212325.GG21316@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Kevin Shanahan <kmshanah@ucwb.org.au>,
	Andreas Dilger <adilger@sun.com>, Alex Tomas <bzzz@sun.com>,
	linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.moondrake.net ([212.85.150.166]:52541 "EHLO
	mx1.mandriva.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752020AbZESKA6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 19 May 2009 06:00:58 -0400
In-Reply-To: <20090514212325.GG21316@mit.edu> (Theodore Tso's message of "Thu\, 14 May 2009 17\:23\:25 -0400")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso <tytso@mit.edu> writes:

> So here's the final fix (it replaces the short circuit i_cached_extent
> patch) which I plan to push to Linus.  It should be much less of a
> performance hit than simply short-circuiting i_cached_extent...
> 
> Thanks so much for helping to find track this down!!!  If ever someone
> deserved an "Ext4 Baker Street Irregulars" T-shirt, it would be
> you....
> 
>        	       	   	      	   	      - Ted
> 
> commit 039ed7a483fdcb2dbbc29f00cd0d74c101ab14c5
> Author: Theodore Ts'o <tytso@mit.edu>
> Date:   Thu May 14 17:09:37 2009 -0400
> 
>     ext4: Fix race in ext4_inode_info.i_cached_extent
>     
>     If one CPU is reading from a file while another CPU is writing to the
>     same file different locations, there is nothing protecting the
>     i_cached_extent structure from being used and updated at the same
>     time.  This could potentially cause the wrong location on disk to be
>     read or written to, including potentially causing the corruption of
>     the block group descriptors and/or inode table.
>     
>     Many thanks to Ken Shannah for helping to track down this problem.
>     
>     Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

I wonder if that would explain the corruption I reported a couple weeks
ago.

Now I remember I wrongly got 2 parallel cp from the same source
directory to the same target directory.
Could this be the cause?
