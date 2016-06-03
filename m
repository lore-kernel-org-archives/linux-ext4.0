From: Jan Kara <jack@suse.cz>
Subject: Re: xfstests generic/130 hang with non-4k block size ext4 on 4.7-rc1
 kernel
Date: Fri, 3 Jun 2016 13:58:44 +0200
Message-ID: <20160603115844.GB2470@quack2.suse.cz>
References: <20160531140922.GM5140@eguan.usersys.redhat.com>
 <20160531154017.GC5357@thunk.org>
 <20160601063822.GH10350@eguan.usersys.redhat.com>
 <20160601165800.GI10350@eguan.usersys.redhat.com>
 <20160602085840.GH19636@quack2.suse.cz>
 <20160602121750.GC32574@quack2.suse.cz>
 <20160603101612.GJ10350@eguan.usersys.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Theodore Ts'o <tytso@mit.edu>,
	Eryu Guan <eguan@redhat.com>, linux-ext4@vger.kernel.org
To: Eryu Guan <guaneryu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33642 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751727AbcFCL6r (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 3 Jun 2016 07:58:47 -0400
Content-Disposition: inline
In-Reply-To: <20160603101612.GJ10350@eguan.usersys.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri 03-06-16 18:16:12, Eryu Guan wrote:
> On Thu, Jun 02, 2016 at 02:17:50PM +0200, Jan Kara wrote:
> > 
> > So I was trying but I could not reproduce the hang either. Can you find out
> > which page is jbd2 thread waiting for and dump page->index, page->flags and
> > also bh->b_state, bh->b_blocknr of all 4 buffer heads attached to it via
> > page->private? Maybe that will shed some light...
> 
> I'm using crash on live system when the hang happens, so I got the page
> address from "bt -f"
> 
>  #6 [ffff880212343b40] wait_on_page_bit at ffffffff8119009e
>     ffff880212343b48: ffffea0002c23600 000000000000000d 
>     ffff880212343b58: 0000000000000000 0000000000000000 
>     ffff880212343b68: ffff880213251480 ffffffff810cd000 
>     ffff880212343b78: ffff88021ff27218 ffff88021ff27218 
>     ffff880212343b88: 00000000c1b4a75a ffff880212343c68 
>     ffff880212343b98: ffffffff811901bf

Thanks for debugging! In the end I was able to reproduce the issue on my
UML instance as well and I'm debugging what's going on.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
