From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH] ext4: Prevent race while waling extent tree
Date: Fri, 9 Nov 2012 10:19:52 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1211091018340.19842@dhcp-1-104.brq.redhat.com>
References: <1352372929-18513-1-git-send-email-lczerner@redhat.com> <20121108215233.GB1282@lenny.home.zabbo.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org,
	tytso@mit.edu
To: Zach Brown <zab@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58825 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750881Ab2KIJT7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 9 Nov 2012 04:19:59 -0500
In-Reply-To: <20121108215233.GB1282@lenny.home.zabbo.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 8 Nov 2012, Zach Brown wrote:

> Date: Thu, 8 Nov 2012 13:52:33 -0800
> From: Zach Brown <zab@redhat.com>
> To: Lukas Czerner <lczerner@redhat.com>
> Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
> Subject: Re: [PATCH] ext4: Prevent race while waling extent tree
> 
> On Thu, Nov 08, 2012 at 12:08:49PM +0100, Lukas Czerner wrote:
> > +		down_read(&EXT4_I(inode)->i_data_sem);
> >  		error = ext4_ext_walk_space(inode, start_blk, len_blks,
> >  					  ext4_ext_fiemap_cb, fieinfo);
> > +		up_read(&EXT4_I(inode)->i_data_sem);
> 
> Can this deadlock?  ext4_ext_fiemap_cb() seems to be doing all kinds of
> exciting things that might also try and acquire the i_data_sem, like
> GFP_KERNEL allocs (reclaim -> writepage) and copying to userspace (mmap
> fault -> readpage -> get blocks).
> 
> It seems like the safer fix is to broaden the sampling lock coverage to
> include referencing all the extent data but to release it around the
> callback.
> 
> No?
> 
> - z

Yeah, you're right. Having the lock around the whole
ext4_ext_walk_space() might deadlock. I'll fix this.

Thanks for noticing this!
-Lukas
