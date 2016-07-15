From: Vegard Nossum <vegard.nossum@oracle.com>
Subject: Re: kernel BUG at fs/ext4/inode.c:3709! (Re: open bugs found by
 fuzzing)
Date: Fri, 15 Jul 2016 19:57:03 +0200
Message-ID: <578923EF.1020305@oracle.com>
References: <5787FFBA.70406@oracle.com> <5788E787.106@oracle.com>
 <20160715172453.GA18010@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, Michael Halcrow <mhalcrow@google.com>,
	Ildar Muslukhov <ildarm@google.com>,
	Jaegeuk Kim <jaegeuk@kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:47468 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241AbcGOR5M (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 15 Jul 2016 13:57:12 -0400
In-Reply-To: <20160715172453.GA18010@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 07/15/2016 07:24 PM, Theodore Ts'o wrote:
> On Fri, Jul 15, 2016 at 03:39:19PM +0200, Vegard Nossum wrote:
>>
>> I'm a bit puzzled that we're actually creating a mapping and trying to
>> decrypt here in the first place, since if this is an orphan inode that
>> is being recovered at mount time it means that we know _for sure_ that
>> there is no existing memory mappings and we're truncating it to 0.
>
> There are times when we need to make sure i_size is truncated down
> (and/or blocks are removed) if we crash in the middle of an operation
> that for whatever reason, spans multiple trnsactions.
>
> The simplest such example is truncating down to a non-zero i_size.
>
> If your proposed patch to ext4_block_zero_page_range() helps, then
> presumably we're *not* truncating down to zero, but instead truncating
> to some non-zero size.

You're right; I just checked, it's truncating it to 4 bytes.

I thought all the inodes on the orphan list were completely unreachable,
but that's obviously not true following your explanations (thanks!) and
another peek at the cleanup function which only does the truncate in the
first place if ->i_nlink is non-zero, I missed that earlier. I guess
this comment confused me:

/* ext4_orphan_cleanup() walks a singly-linked list of inodes (starting at
  * the superblock) which were deleted from all directories, but held 
open by
  * a process at the time of a crash.

But in any case my simple patch is definitely the wrong thing to do.

Thanks,


Vegard
