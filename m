From: Jan Kara <jack@suse.cz>
Subject: Re: block allocation for ext2_mkdir
Date: Thu, 18 Dec 2008 23:39:28 +0100
Message-ID: <20081218223928.GA20092@atrey.karlin.mff.cuni.cz>
References: <2d08ef090812181042k2b15f27fke39076cc72453797@mail.gmail.com> <2d08ef090812181152r53fa9d18j1b21310c4e592f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Kernelnewbies <kernelnewbies@nl.linux.org>,
	ext4 <linux-ext4@vger.kernel.org>
To: Rohit Sharma <imreckless@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:58814 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752601AbYLRWja (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 18 Dec 2008 17:39:30 -0500
Content-Disposition: inline
In-Reply-To: <2d08ef090812181152r53fa9d18j1b21310c4e592f@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> On Fri, Dec 19, 2008 at 12:12 AM, Rohit Sharma <imreckless@gmail.com> wrote:
> > How does ext2 allocate blocks for directory.
> >
> > ext2_mkdir               calls            ext2_make_empty
> >
> > ext2_make_empty     calls           __ext2_write_begin
> >
> > __ ext2_write_begin   calls           block_write_begin
> >
> > my query is that how does this function allocates blocks for directories. ??
> >
> 
> Does ext2 uses ext2_get_block to allocate blocks for both files and
> directories. ??
  Yes, exactly. Ext2 (unlike ext3 or ext4) treats directories the same
ways as ordinary files and thus ext2_get_block is used for block
allocation.

								Honza

-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
