Return-Path: <SRS0=J55O=OU=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55788 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726250AbeLKKT4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 11 Dec 2018 05:19:56 -0500
Date: Tue, 11 Dec 2018 11:19:53 +0100
From: Jan Kara <jack@suse.cz>
To: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
        fisherthepooh@protonmail.com, tytso@mit.edu
Subject: Re: jbd2 bh_shadow issue
Message-ID: <20181211101953.GB19614@quack2.suse.cz>
References: <871f4cbf-f7bc-35d8-bd42-32721b44c458@linux.alibaba.com>
 <20181129180439.GA11089@quack2.suse.cz>
 <ff170504-2c35-a8c6-69fc-a930e4bdec96@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ff170504-2c35-a8c6-69fc-a930e4bdec96@linux.alibaba.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

On Tue 04-12-18 18:49:49, Xiaoguang Wang wrote:
> > On Tue 27-11-18 19:48:28, Xiaoguang Wang wrote:
> > > I also meet this issue in our server, sometimes we got big latency for
> > > buffered writes. Using fio, I have done some tests to reproduce this issue,
> > > Please see test results in this mail:
> > > https://www.spinics.net/lists/linux-ext4/msg62885.html
> > > 
> > > I agree that doing buffer copy-out for every journaled buffer wastes cpu
> > > time, so here I wonder whether we can only do buffer copy-out when buffer
> > > is BH_SHADOW state. The core idea is simple:
> > >      In do_get_write_access(), if buffer has already been in BH_SHADOW state,
> > >      we allocate a new page, make buffer's b_page point to this new page, and
> > >      following journal dirty work can be done in this patch. When transaction
> > >      commits, in jbd2_journal_write_metadata_buffer(), we copy new page's conten
> > >      to primary page, make buffer point to primary page and free the temporary
> > >      page.
> > 
> > This isn't going to work. That are places in the kernel that assume that
> > the page bh points to is the page stored in the page cache. Also you need
> > to make sure that functions like sb_getblk() are going to return your new
> > bh etc. So it is not really simple. On the other hand if we speak only
> > about metadata buffers, the potential for breakage is certainly much
> > smaller (but you'd have to then make sure data=journal case does not use
> > your optimization) and there aren't that many ways how bh can be accessed
> > so maybe you could make something like this working. But it certainly isn't
> > going to work in the form you've presented here...
> I had thought some of your mentioned cases and only just considered meta
> buffer before, thanks you for pointing more cases. Do you have any suggestions
> for this bh_shadow issue, sometimes it really caused app's long tail latency.

I was thinking for some time about this but I don't have a good solution to
this problem. Additionally I have realized that you will face the same
latency hit not only when the block is written out to the journal but also
when it is being checkpointed. So the solution could not be just some
special journalling hack but would need to provide a general way how to
modify metadata buffer heads that are being written out.

One solution that looks at least remotely sane to me is that you could do
an equivalent of page migration (it is somewhat similar to what you've
suggested) - allocate new page, copy there data from the old page, replace
original page in the address space with this page, move buffer heads over
from the old page to the new page. You can check what buffer_migrate_page()
is doing. And then you can let processes modify this new page and when the
IO completes the old page would get released.  But you'd have to be extra
careful with the locking and also make sure buffer heads you migrate don't
have extra references so that you do not move buffer heads under someone's
hands (as that could cause data corruption)...

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
