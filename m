From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [RESEND][PATCH 2/2 v2] ext4: let us fully support punching hole
 feature in fallocate
Date: Thu, 24 Jan 2013 23:21:22 -0500
Message-ID: <20130125042122.GG28908@thunk.org>
References: <1358493381-20150-1-git-send-email-wenqing.lz@taobao.com>
 <1358493381-20150-2-git-send-email-wenqing.lz@taobao.com>
 <20130125033201.GD28908@thunk.org>
 <20130125035912.GA15806@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:45397 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751065Ab3AYEV0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 24 Jan 2013 23:21:26 -0500
Content-Disposition: inline
In-Reply-To: <20130125035912.GA15806@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jan 25, 2013 at 11:59:12AM +0800, Zheng Liu wrote:
> 
> I wonder that maybe we need to submit a patch to let xfstest understand
> that a filesystem supports extents or not because after applied this
> patch indirect-based file in ext4 has supported seek_data/hole and hole
> punching.  I usually run xfstest automatically, and every time I need
> to check the result of #255 and #285 manually.  That is annoying for me.

I would think the right thing to do is to have xfstests make sure it
understands that fallocate working with FALLOC_FL_PUNCH_HOLE does not
imply that fallocate without the FALLOC_FL_PUNCH_HOLE flag OR'ed in
will work.  It should test for support for preallocation and hole
punching separately, and do tests accordingly.

That way we don't have to add explicit ext4 knowledge/logic to
xfstests.  (Maybe in the future there will be some other file system
which supports punch hole but not preallocate, and it might not be
based on whether or not the file is using ext4 extents or not.)

Cheers,

						- Ted
