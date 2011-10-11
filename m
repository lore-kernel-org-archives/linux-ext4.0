From: Kyungmin Park <kmpark@infradead.org>
Subject: Re: [patch]ext4: add block plug for .writepages
Date: Tue, 11 Oct 2011 19:40:34 +0900
Message-ID: <CAH9JG2X9Hik6Qs8BHKS1WqJmiB9=Ve-W0XiZ+-dfHFnN1GmXKg@mail.gmail.com>
References: <1317004226.29510.172.camel@sli10-conroe>
	<20110926073025.GB21079@infradead.org>
	<1317022727.29510.175.camel@sli10-conroe>
	<20110926094554.GA30827@infradead.org>
	<1317179380.22361.8.camel@sli10-conroe>
	<20111010165116.GX7948@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: "Ted Ts'o" <tytso@mit.edu>, Shaohua Li <shaohua.li@intel.com>,
	Christoph Hellwig <hch@infradead.org>,
	Jens Axboe <axboe@kernel.dk>,
	Andrew Morton <akpm@linux-foundation.org>,
	lkml <l
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:41245 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754258Ab1JKKkf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 11 Oct 2011 06:40:35 -0400
In-Reply-To: <20111010165116.GX7948@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Oct 11, 2011 at 1:51 AM, Ted Ts'o <tytso@mit.edu> wrote:
> On Wed, Sep 28, 2011 at 11:09:40AM +0800, Shaohua Li wrote:
>> I searched a little bit, looks only ext4 need it. here is the patch.
>>
>>
>> Add block plug for ext4 .writepages. Though ext4 .writepages
>> already handles request merge very well, block plug is still
>> helpful to reduce block lock contention.
>>
>> Signed-off-by: Shaohua Li <shaohua.li@intel.com>

Does it require to add blk_finish_plug(&plug) when error case?

+        blk_start_plug(&plug);
         while (!ret && wbc->nr_to_write > 0) {

                ...
                /* start a new transaction*/
                handle = ext4_journal_start(inode, needed_blocks);
                if (IS_ERR(handle)) {
                        ret = PTR_ERR(handle);
                        ext4_msg(inode->i_sb, KERN_CRIT, "%s: jbd2_start: "
                               "%ld pages, ino %lu; err %d", __func__,
                                wbc->nr_to_write, inode->i_ino, ret);
+                      blk_finish_plug(&plug);
                        goto out_writepages;
                }

Thank you,
Kyungmin Park-
