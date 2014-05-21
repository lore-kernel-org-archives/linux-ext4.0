From: chrubis@suse.cz
Subject: Re: OpenPosix test case mmap_11-4 fails in ext4 filesystem
Date: Wed, 21 May 2014 17:06:19 +0200
Message-ID: <20140521150619.GA5459@rei.suse.cz>
References: <537C4A2F.8040402@cn.fujitsu.com>
 <alpine.LFD.2.00.1405211413370.2114@localhost.localdomain>
 <20140521141203.GB1501@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Luk???? Czerner <lczerner@redhat.com>,
	Xiaoguang Wang <wangxg.fnst@cn.fujitsu.com>,
	linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:48526 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751395AbaEUPGb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 21 May 2014 11:06:31 -0400
Content-Disposition: inline
In-Reply-To: <20140521141203.GB1501@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi!
> This is a valid bug report which applies to upstream ext4.  It also
> applies to tmpfs, by the way.
> 
> It would be good to get this test case (thank you very much for
> writing it!) imported into xfstests, since the lack of this test is
> why we didn't notice the bug when we added the fs/ext4/page_io.c code
> paths.

It has been in LTP for ages. Maybe it's a time developers should start
to use LTP :) (We managed to fix most of the problems that are credible
for the bad LTP reputation...)

> BTW, there is one interesting thing about that changed when we moved
> to page based I/O (years and years ago).  The requirement in mmap is
> as Xiaoguang stated:
> 
>        A file is mapped in multiples of the page size.  For a file
>        that is not a multi??? ple of the page size, the remaining memory
>        is zeroed when mapped, and writes to that region are not
>        written out to the file.  The effect of changing the size of
>        the underlying file of a mapping on the pages that correspond
>        to added or removed regions of the file is unspecified.
> 
> Previously in Linux 2.2 (or was it 2.0; my memory is a bit fuzzy about
> when we unified the buffer and page caches), when we copied the data
> from the page cache to the buffer cache, we stopped at EOF.  This
> implies that if the program modified the portion of the page mapped
> beyond EOF, it would remain modified until the page was released and
> the page was dropped from the page cache.
> 
> Now, when we call writepage() --- assuming the file system wasn't
> buggy --- the bytes after EOF will get cleared.  If the user doesn't
> call msync(), when this happens is unpredictable to the userspace
> program, since it happens when writeback daemons decide to write back
> the data.

This is exacly what we concluded when we were fixing the testacase (I
talked about this I think with Jan Kara and Michal Hocko). And the
result was to add the msync() to the testcase. We also agreed that
fixing this for tmpfs is not worth the effort although when interpreting
POSIX strictly it should work with shm memory as well.

-- 
Cyril Hrubis
chrubis@suse.cz
