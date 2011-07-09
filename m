From: Ted Ts'o <tytso@mit.edu>
Subject: Re: broken commit 25567a7b0fa98b390fd1ff0d4702b29c23a75bbb
Date: Fri, 8 Jul 2011 20:41:51 -0400
Message-ID: <20110709004151.GL3331@thunk.org>
References: <7EF281B4-882D-4F81-AEF8-404D2C3C0B76@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:54812 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750904Ab1GIAlz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 8 Jul 2011 20:41:55 -0400
Content-Disposition: inline
In-Reply-To: <7EF281B4-882D-4F81-AEF8-404D2C3C0B76@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jul 08, 2011 at 06:07:14PM -0600, Andreas Dilger wrote:
> In my pull from e2fsprogs git "master" branch, it contains commit
> 25567a7b0fa98b390fd1ff0d4702b29c23a75bbb "support for bigalloc
> file systems with a blocksize of 1024" that deletes the initialization
> of the flexbg_size variable from lib/ext2fs/alloc_tables.c::flexbg_offset():
> 
> -       flexbg_size = 1 << fs->super->s_log_groups_per_flex;
> -       flexbg = group / flexbg_size;
> +       size = rem_grp * elem_size;
> 
> but it continues to use flexbg_size later on in this function:

Yeah, sorry, fixed in the next branch.  I thought I had advanced the
master branch enough to fix it, but I didn't advance it enough.  Try a
pull now.

						- Ted
