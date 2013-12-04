From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2 01/28] libext2fs: support modifying arbitrary extended
 attributes
Date: Wed, 4 Dec 2013 12:30:28 -0800
Message-ID: <20131204203028.GT9535@birch.djwong.org>
References: <1386072715-9869-1-git-send-email-wenqing.lz@taobao.com>
 <1386072715-9869-2-git-send-email-wenqing.lz@taobao.com>
 <20131203195457.GD9535@birch.djwong.org>
 <20131204145343.GC17008@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Zheng Liu <gnehzuil.liu@gmail.com>, linux-ext4@vger.kernel.org,
	Zheng Liu <wenqing.lz@taobao.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:21482 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932420Ab3LDUag (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 4 Dec 2013 15:30:36 -0500
Content-Disposition: inline
In-Reply-To: <20131204145343.GC17008@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Dec 04, 2013 at 09:53:43AM -0500, Theodore Ts'o wrote:
> On Tue, Dec 03, 2013 at 11:54:57AM -0800, Darrick J. Wong wrote:
> > Ok, so inline_data implies ext_attr.  I think we should change the test to
> > check for either feature flag, because with no test, we could accidentally
> > read/write EAs on a FS with ^ext_attr,^inline_data.  Or maybe provide a helper
> > predicate to hide those details.
> > 
> > Also, I'd ask you to send broken out changes to my patches... but I haven't
> > posted my monster patchset recently. :)
> > 
> > (I think I might work up the courage to patchbomb the mailing list tonight.)
> 
> Zheng's patchset includes some of your patches.  Does it include all
> of them?  If you are going to patchbomb the mailing list, do you have
> any suggestions for the best way for me to figure out which patches
> I should take from him and which from you?

It doesn't include all of them.  At the moment there are 83 of them(!) which I
haven't figured out how to release in a reviewable manner.  Roughly speaking,
the patches can be grouped:

 1. The unapplied patches from the October submission (fuse2fs, 64bit
    conversion, xattr editing part 1, metadata checksumming tests)
 2. The xattr-editing patches
 3. Fixes for uninit extent handling
 4. Patches to test and turn on block_validity
 5. A bunch of coverity fixes
 6. Fixes for bugs I found by running xfstests atop fuse2fs
 7. Fixes for that thing about block_uninit groups that Akira Fujita and I were
    discussing
 8. Fixes for 1k block filesystems with meta_bg
 9. Patches to prevent too-high lblk mapping

I could collapse all the post-October fuse2fs and xattr-editing patches into
the original submissions, but that seems like it would be harder for people to
review the new changes.

As for resolving the inlinedata vs djwong-patchbomb sets, I'm trying to
maintain the situation that you should be able to apply them at any point after
applying the original xattr patch + group 2.

--D
> 
> Thanks,
> 
> 					- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
