From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH] exofs: simple fsync race fix
Date: Thu, 03 Feb 2011 13:44:51 +0200
Message-ID: <4D4A9533.4090304@panasas.com>
References: <20101125074909.GA4160@amd> <4CEE2C2E.4010003@panasas.com> <20101125100603.GA3164@amd> <4CEE3F9F.9070108@panasas.com> <4CEE3FD8.6080202@panasas.com> <20101125115033.GA3643@amd>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, Roman Zippel <zippel@linux-m68k.org>,
	"Tigran A. Aivazian" <tigran@aivazian.fsnet.co.uk>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
	Bob Copeland <me@bobcopeland.com>,
	reiserfs-devel@vger.kernel.org,
	Christoph Hellwig <hch@infradead.org>,
	Evgeniy Dushistov <dushistov@mail.ru>, Jan Kara <jack@suse.cz>
To: Nick Piggin <npiggin@kernel.dk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from daytona.panasas.com ([67.152.220.89]:10683 "EHLO
	daytona.panasas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756289Ab1BCLoz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 3 Feb 2011 06:44:55 -0500
In-Reply-To: <20101125115033.GA3643@amd>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 11/25/2010 01:50 PM, Nick Piggin wrote:
> This is fine, we'll get it merged before 2.6.37, just give a couple of
> days for review, I haven't had much confirmation from other vfs people
> about these problems.
> 
> Thanks,
> Nick
> 

Hi Dear Nick.

So I was cleaning the table and I fell on this patch. What ever happened
to it? should I push it through my tree?

Thanks
Boaz

> On Thu, Nov 25, 2010 at 12:52:08PM +0200, Boaz Harrosh wrote:
>> From: Nick Piggin <npiggin@kernel.dk>
>>
>> It is incorrect to test inode dirty bits without participating in the inode
>> writeback protocol. Inode writeback sets I_SYNC and clears I_DIRTY_?, then
>> writes out the particular bits, then clears I_SYNC when it is done. BTW. it
>> may not completely write all pages out, so I_DIRTY_PAGES would get set
>> again.
>>

