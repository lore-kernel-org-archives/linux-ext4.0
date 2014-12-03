From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] tune2fs: disable csum verification before resizing inode
Date: Wed, 3 Dec 2014 09:34:22 -0500
Message-ID: <20141203143422.GX13618@thunk.org>
References: <1415785780-3832-3-git-send-email-wangxg.fnst@cn.fujitsu.com>
 <1415956537-11212-1-git-send-email-wangxg.fnst@cn.fujitsu.com>
 <1415956537-11212-2-git-send-email-wangxg.fnst@cn.fujitsu.com>
 <20141114231010.GK10043@birch.djwong.org>
 <20141117191039.GL10043@birch.djwong.org>
 <20141203034649.GS13618@thunk.org>
 <20141203053951.GB10059@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Xiaoguang Wang <wangxg.fnst@cn.fujitsu.com>,
	linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:37134 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752935AbaLCOef (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 3 Dec 2014 09:34:35 -0500
Content-Disposition: inline
In-Reply-To: <20141203053951.GB10059@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Dec 02, 2014 at 09:39:51PM -0800, Darrick J. Wong wrote:
> 
> The patches "e2fsck: only complain about no-checksum directory blocks once" and
> "e2fsck: don't complain about root dir csum failures when getting lnf" fix fsck
> not to print these unnecessary error messages.  They both pre-date the creation
> of this patch, which is why the test is failing.  You can safely amend the
> /expect file, but it'll be necessary to un-amend it if you take those two older
> patches.

Ah, I figured it was something like that.  OK, I'll find those patches
and get them into my tree; so I'll fix it on my end.

Thanks!!

    	     	     	      	       	  - Ted
