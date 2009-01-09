From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] block: Add Kconfig help which notes that ext4 needs CONFIG_LSF
Date: Fri, 9 Jan 2009 09:04:16 +0100
Message-ID: <20090109080414.GH32491@kernel.dk>
References: <1231262490-15594-1-git-send-email-tytso@mit.edu> <20090108113915.GL13721@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from brick.kernel.dk ([93.163.65.50]:1897 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753352AbZAIIF0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 9 Jan 2009 03:05:26 -0500
Content-Disposition: inline
In-Reply-To: <20090108113915.GL13721@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jan 08 2009, Andreas Dilger wrote:
> On Jan 06, 2009  12:21 -0500, Theodore Ts'o wrote:
> > @@ -64,6 +64,12 @@ config LSF
> > +	  The ext4 filesystem requires that this feature be enabled in
> > +	  order to support filesystems that have the huge_file feature
> > +	  enabled.    Otherwise, it will refuse to mount any filesystems
> > +	  that use the huge_file feature, which is enabled by default
> > +	  by mke2fs.ext4.
> 
> Wouldn't it make sense to just enable this by default if ext4 is enabled?

Agree, since it'll prevent the fs from mounting, using a select makes a
lot more sense.

-- 
Jens Axboe

