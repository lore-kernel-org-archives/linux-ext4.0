From: Xiaoguang Wang <wangxg.fnst@cn.fujitsu.com>
Subject: Re: [PATCH 1/4] e2fsprogs/libext2fs: replace ext2fs_free_inode_cache()
 argument
Date: Wed, 12 Nov 2014 17:38:46 +0800
Message-ID: <54632AA6.7000107@cn.fujitsu.com>
References: <1415689169-19393-1-git-send-email-wangxg.fnst@cn.fujitsu.com> <20141111081451.GD10043@birch.djwong.org> <20141111161211.GB17027@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>,
	<linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:34795 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752314AbaKLJlB (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 12 Nov 2014 04:41:01 -0500
In-Reply-To: <20141111161211.GB17027@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

On 11/12/2014 12:12 AM, Theodore Ts'o wrote:
> On Tue, Nov 11, 2014 at 12:14:51AM -0800, Darrick J. Wong wrote:
>> Ideally you'd change the old function to return an error code, but it returns
>> void... sigh.  I guess client programs are on their own.
>>
>> Really, free_inode_cache is a poor interface since the ctor doesn't return a
>> struct ext2_inode_cache * directly, preferring to attach it to fs->icache
>> instead.  Why are the inode cache ctor/dtor exported in ext2fs.h anyway?
>> Nobody seems to use them.  Ted?
> 
> Looking at the history, the change happened in commit 603e5ebc, which
> changed the internal representation of the ext2_inode_cache.  At that
> point, I moved the inode cache freeing function from
> lib/ext2fs/freefs.c to lib/ext2fs/inode.c, on the theory that it made
> more sense to keep all of the code that handled the representation of
> the inode cache was kept in the same place.
> 
> I agree I should have declared the function in ext2fsP.h instead of
> ext2fs.h; the interface was not great, but that was probably because
> it was originally intended as an internal interface, and I didn't
> bother to fix it up before moving it function to another .c file.
> 
> At this point, we have a couple of choices.  
> 
> (1) define a new interface with a new name (ext2fs_free_inode_cache2)
> 
> (2) move the function back to freefs.c and make it be static, so that
> the function signature disappears from the shared library.
> 
> (3) ignore the problem because it's highly unlikely anyone outside of
> libext2fs will need to use it, and improving the API/ABI doesn't
> really matter all that much.  Instead, just change the callers to
> clear fs->icache after calling ext2fs_free_inode_cache().
> 
> My preference is (2) or (3).

OK, I'll choose (3) :) thanks!
Version 2 will be sent soon.

Regards,
Xiaoguang Wang
> 
> Cheers,
> 
> 						- Ted
> .
> 

