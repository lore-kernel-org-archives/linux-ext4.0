From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: torrent hash failures since 3.9.0-rc1
Date: Mon, 11 Mar 2013 23:30:54 -0400
Message-ID: <20130312033054.GB18595@thunk.org>
References: <20130311171824.GA434@x4>
 <20130311191753.GA439@x4>
 <20130311194159.GB3579@redhat.com>
 <20130311201334.GA444@x4>
 <20130311203738.GB15478@thunk.org>
 <20130311204625.GA433@x4>
 <20130311211833.GC15478@thunk.org>
 <20130311213837.GA438@x4>
 <20130311231227.GA319@x4>
 <20130312030057.GA6142@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Markus Trippelsdorf <markus@trippelsdorf.de>,
	Dave Jones <davej@redhat.com>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:52717 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754718Ab3CLDbB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 11 Mar 2013 23:31:01 -0400
Content-Disposition: inline
In-Reply-To: <20130312030057.GA6142@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Mar 12, 2013 at 11:00:58AM +0800, Zheng Liu wrote:
> 
> Thanks for reporting this problem.  My deepest apologies.
> 
> As Ted suggested, could you please try to use ext4 git tree?  I want to
> make sure whether this bug has been fixed by my lastest patch series or
> not.

It's definitely worth a try to compile the master branch of the ext4
tree and see if it reproduces or not.

However, I suspect the problem will still be there.  Based on the
commit which Markus has identified, I'm guessing it's a race between
the extents_status shrinker and writing into uninitialized region of
the file (since apprently compiling rtorrent with
--with-posix-fallocate is required).

Markus, how much memory do you have in your system?  That may be the
other reason why I haven't been able to reproduce it to date; I had a
lot of free memory when I tried to reproduce the problem, so the slab
shrinker didn't engage.

Regards,

						- Ted
