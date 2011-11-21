From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: Increase xattr space by allocating contiguous xattr blocks
Date: Mon, 21 Nov 2011 10:08:25 -0500
Message-ID: <401CC4FF-8955-4D5F-B620-5C39AF566123@mit.edu>
References: <4EC10664.1080501@tuxadero.com> <CAO47_-9nfO32nwOAQMVdqw6iWGWK+FWb+MD=WeOz_vr4YrrKmw@mail.gmail.com> <20111115142246.GA7516@thunk.org> <246EA1CC-3C33-4D41-80C0-2331C426EBB0@whamcloud.com> <4ECA4282.5020908@whamcloud.com>
Mime-Version: 1.0 (Apple Message framework v1251.1)
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: Theodore Tso <tytso@mit.edu>,
	Andreas Dilger <adilger@whamcloud.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Yu Jian <yujian@whamcloud.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from DMZ-MAILSEC-SCANNER-1.MIT.EDU ([18.9.25.12]:62447 "EHLO
	dmz-mailsec-scanner-1.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752427Ab1KUPI1 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 21 Nov 2011 10:08:27 -0500
In-Reply-To: <4ECA4282.5020908@whamcloud.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


On Nov 21, 2011, at 7:22 AM, Yu Jian wrote:

> Now, I've the same question as that in the above thread:
> In xattr.{h,c}, all of the macros and functions assume the xattr space is contiguous with entries growing downwards and values growing upwards (aligned to the end of the space). Especially, the create, replace, remove and shift operations of xattrs are all performed inside a contiguous buffer. This is no problem with in-inode xattr space and single external xattr block which is associated with one block buffer. But for multiple xattr blocks, since the data of them would be read into different block buffers, which are not contiguous, most of the existing macros and functions need to be changed. Is this way acceptable?

It depends on how cleanly you can implement it, and if you can create some better xfstests to exercise xattr operations --- especially if deleting xattrs will cause existing xattrs to get moved around for better packing, we need to be absolutely sure that the code is completely reliable and doesn't end up corrupting some xattr other than the one that is being inserted, deleted, or replaced.

Currently, one of the primary xattr tests that is in xfstests (#62) doesn't work on ext4 at all, since it assumes that files are returned by readdir in file creation order for newly created directory.   So the lack of test coverage is something that would have to be addressed if we want to do major surgery to the xattr code.  I'd suggest creating a new series of test from scratch, since I don't believe test #62 can be easily reworked so that it will work under ext4.

> In order to make most of the codes remain as-is, we could allocate a contiguous large buffer (up to 64kB in size) to handle all of the data. However, we have to memcpy the data from block buffers to the large buffer, and after the data are changed, we need memcpy the data back to block buffers to make the data written into the block device. Is this way reasonable?

This is no doubt the simpler way to go.   The downsides of doing this are pretty obvious: overhead to do the copy, the extra memory pressure, the need to do the memory allocation (vmalloc is slow, since it requires messing with page tables; if you need to count on contiguous free pages, you may end up stalling while you wait for the pressure on the mm defrag routines).   Also, if there are people who want to do large amounts of xattr operations on PCIe attached flash, the extra overhead of doing the copy will definitely show up on the benchmarks.

The first is approach is no doubt he better one, but it at the same time it would be tricker to implement.   If it would be totally up to me, I'd suggest the first approach, but it would need to be approached with care (and a lot of testing).

Regards,

-- Ted

