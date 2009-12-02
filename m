From: James Y Knight <foom@fuhm.net>
Subject: Re: writev data loss bug in (at least) 2.6.31 and 2.6.32pre8 x86-64
Date: Wed, 2 Dec 2009 16:24:01 -0500
Message-ID: <A352FA76-1107-42CF-95D3-FE97D71EF7D9@fuhm.net>
References: <1F5364AE-321E-44E9-8B0D-B8E17597A0DA@fuhm.net> <907888CC-F4B2-448F-8F48-B96A566D323B@fuhm.net> <1259667765.9614.19.camel@marge.simson.net> <20091201143558.GB12730@quack.suse.cz> <20091201160324.GA25873@quack.suse.cz>
Mime-Version: 1.0 (Apple Message framework v1077)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Mike Galbraith <gleep@gmx.de>, LKML <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org, npiggin@suse.de
To: Jan Kara <jack@suse.cz>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754572AbZLBVYI@vger.kernel.org>
In-Reply-To: <20091201160324.GA25873@quack.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Dec 1, 2009, at 11:03 AM, Jan Kara wrote:
> On Tue 01-12-09 15:35:59, Jan Kara wrote:
>> On Tue 01-12-09 12:42:45, Mike Galbraith wrote:
>>> I bisected it this morning.  Bisected cleanly to...
>>> 
>>> 9eaaa2d5759837402ec5eee13b2a97921808c3eb is the first bad commit
>>  OK, I've debugged it. This commit is really at fault. The problem is
>> following:
>>  When using writev, the page we copy from is not paged in (while when we
>> use ordinary write, it is paged in). This difference might be worth
>> investigation on its own (as it is likely to heavily impact performance of
>> writev) but is irrelevant for us now - we should handle this without data
>> corruption anyway. Because the source page is not available, we pass 0 as
>> the number of copied bytes to write_end and thus ext3_write_end decides to
>> truncate the file to original size. This is perfectly fine. The problem is
>> that we do this by ext3_truncate() which just frees corresponding block but
>> does not unmap buffers. So we leave mapped buffers beyond i_size (they
>> actually never were inside i_size) but the blocks they are mapped to are
>> already free. The write is then retried (after mapping the page),
>> block_write_begin() sees the buffer is mapped (although it is beyond
>> i_size) and thus it does not call ext3_get_block() anymore. So as a result,
>> data is written to a block that is no longer allocated to the file. Bummer
>> - welcome filesystem corruption.
>>  Ext4 also has this problem but delayed allocation mitigates the effect to
>> an error in accounting of blocks reserved for delayed allocation and thus
>> under normal circumstances nothing bad happens.
>>  The question is how to solve this in the cleanest way. We can call
>> vmtruncate() instead of ext3_truncate() as we used to do but Nick wants to
>> get rid of that (that's why I originally changed the code to what it is
>> now). So probably we could just manually call truncate_pagecache() instead.
>> Nick, I think your truncate calling sequence patch set needs similar fix
>> for all filesystems as well.
>  The patch below fixes the issue for me...

Thank you! I can confirm that the patch fixes the issue in my real application as well.

James