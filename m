From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: [PATCH -v2] mke2fs: fix hugefile creation so the hugefile(s) are
 contiguous
Date: Fri, 23 Jun 2017 12:19:25 -0700
Message-ID: <20170623191925.GC84943@gmail.com>
References: <20170623000009.27984-1-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:34056 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754327AbdFWTTj (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 23 Jun 2017 15:19:39 -0400
Received: by mail-pf0-f196.google.com with SMTP id d5so8690727pfe.1
        for <linux-ext4@vger.kernel.org>; Fri, 23 Jun 2017 12:19:39 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20170623000009.27984-1-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,

On Thu, Jun 22, 2017 at 08:00:09PM -0400, Theodore Ts'o wrote:
>  .I make_hugefiles
>  This boolean relation enables the creation of pre-allocated files as
> -part of formatting the file system.
> +part of formatting the file system.  If the file system is configured so
> +that the block group descriptors are located at beginning file system
> +space (by using the packed_meta_blocks option), the data blocks of the
> +huge files will be contiguous, with the extent tree blocks allocated
> +near the beginning of the file system space.

It's not quite that simple.  The presence of backup superblocks can also cause a
discontinuity.  If I remove 'num_backup_sb = 0' from mke2fs.conf, I see:

	PHYSICAL DISCONTINUITY between extents:
		  2  2 219 220 1073545216  1073577983 1073676288  1073709055  32768 
		  2  2 220 220 1073577984  1073610398 1073709409  1073741823  32415 

Also, for packed_meta_blocks to take effect, flex_bg must be enabled.  This is
documented in mke2fs(8) but not in mke2fs.conf(5).

There could be other issues as well; those are just the ones I found.

Perhaps there should be an option hugefiles_contiguous which makes the mke2fs
command fail if the hugefiles can't be allocated contiguously?

Eric
