From: Vegard Nossum <vegard.nossum@oracle.com>
Subject: Re: Open bugs found by fuzzing as of 2016-07-30
Date: Mon, 1 Aug 2016 09:33:37 +0200
Message-ID: <579EFB51.6090602@oracle.com>
References: <579CA5EB.1070707@oracle.com> <20160801045521.GF12853@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:18457 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750740AbcHAHei (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 1 Aug 2016 03:34:38 -0400
In-Reply-To: <20160801045521.GF12853@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 08/01/2016 06:55 AM, Theodore Ts'o wrote:
> On Sat, Jul 30, 2016 at 03:04:43PM +0200, Vegard Nossum wrote:
>> Hi,
>>
>> It's been two weeks since I posted the first list of bugs found using
>> AFL: https://www.spinics.net/lists/linux-ext4/msg53022.html
>>
>> With a bunch of ext4 patches going into 4.8 we're down from 15 to 6
>> with current linus/master...
>
> Does this patch bring things down further?  I expect it should at the
> very list address
>
>> 6. WARNING: CPU: 0 PID: 58 at fs/ext4/ext4.h:2748
>> ext4_block_bitmap_csum_set+0x358/0x600
>> http://139.162.151.198/f/ext4/9628c19aff0bbaaae4149a03486305c7f6cd7523
>
> ... and possibly others.

I applied the patch, but I didn't see any of the bugs go away,
unfortunately.

IIRC there were still bugs in ext4_init_block_bitmap() where the
ext4_set_bit() calls for the block bitmap + inode bitmap + inode table
were writing beyond the end of bh->b_data. I think tmp < start or
something and then the ext4_set_bit() calls actually end up writing
into the superblock itself, causing either ext4_inode_table() or
sbi->s_itb_per_group to start returning bogus values and further corrupt
things. I'll have another look, maybe add some printks.

> If there are any remaining of these bugs where the superblock is
> sufficiently corrupt that dumpe2fs refuses to print anything, could
> you print a hex dump of the superblock (located at offset 1024) so we
> could see what is going on?

I've added the hex dumps and updated the pages.


Vegard
