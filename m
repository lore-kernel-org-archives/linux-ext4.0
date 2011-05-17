From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: proposed ext4 test matrix
Date: Mon, 16 May 2011 23:10:32 -0600
Message-ID: <5226EFB9-FD65-4BD1-A5DB-68B68FE0AD60@dilger.ca>
References: <E1QM1uy-00070D-KR@tytso-glaptop> <1305596159.9671.8.camel@keith-laptop>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Keith Mannthey <kmannth@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:34881 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751842Ab1EQFKd (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 17 May 2011 01:10:33 -0400
In-Reply-To: <1305596159.9671.8.camel@keith-laptop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On May 16, 2011, at 19:35, Keith Mannthey wrote:
> On Mon, 2011-05-16 at 13:49 -0400, Theodore Ts'o wrote:
>> Per the discusison on the ext4 concall, here's a proposed ext4 test
>> matrix.
>> 
>> 						- Ted
>> 
>> P.S.  There was something else I said I would send out, but I didn't
>> write it down and I can't remember what it was.  Can someone remind me?
>> Thanks!!
>> 
>> 
>> 4k blocksize, no journal, nodealloc, noextents (-t ext2)
>> 1k blocksize, no journal, nodealloc, noextents (-t ext2)
>> 4k blocksize, journal, nodealloc, noextents (-t ext3)
>> 1k blocksize, journal, nodealloc, noextents (-t ext3)
>> 4k blocksize, journal, delalloc, extents (-t ext4)
>> 1k blocksize, journal, delalloc, extents (-t ext4)
>> 4k blocksize, nojournal, delalloc, extents
>> 4k blocksize, journal, 64bits(*), delalloc, extents (-t ext4)
>> 1k blocksize, journal, 64bits(*), delalloc, extents (-t ext4)
>> 4k blocksize, nojournal, 64bits(*), delalloc, extents
>> 4k blocksize, journal, delalloc, extents, quota enabled (-t ext4)
>> 1k blocksize, journal, delalloc, extents, quota enabled (-t ext4)
> 
> What tests are we wanting to run? 

On the call Ted said it would be desirable to run xfstests for all of these
configurations.  Since xfstests already runs quite a number of smaller tests
like fsx, etc, this would definitely be a very good smoke test for the most
common configurations.

I added "-t" to the ext2/ext3/ext4 configs above, since without those options
the features enabled for the various filesystems will not be the same as they
are formatted by default.  For example, with the default "-t ext4" a number
of other features like "flex_bg", "uninit_bg", "huge_file", "dir_nlink" and
"extra_isize" are enabled, but they shouldn't be enabled for ext2/ext3.

Cheers, Andreas





