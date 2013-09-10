From: "Yan, Zheng" <ukernel@gmail.com>
Subject: Re: [PATCH] ext4: fix dirty pages writback regression.
Date: Tue, 10 Sep 2013 19:01:16 +0800
Message-ID: <CAAM7YAmJYWC0O+0jg4rw4xWACm8MzW4L8Ybs9bJPySc7Op4JDg@mail.gmail.com>
References: <1378778578-5000-1-git-send-email-zheng.z.yan@intel.com>
	<20130910090044.GB894@quack.suse.cz>
	<522EE1F5.1080505@intel.com>
	<20130910091715.GA3046@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: "Yan, Zheng" <zheng.z.yan@intel.com>, linux-ext4@vger.kernel.org,
	"Theodore Ts'o" <tytso@mit.edu>, lkp@linux.intel.com
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-la0-f42.google.com ([209.85.215.42]:62161 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075Ab3IJLBS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 10 Sep 2013 07:01:18 -0400
Received: by mail-la0-f42.google.com with SMTP id ep20so6111517lab.29
        for <linux-ext4@vger.kernel.org>; Tue, 10 Sep 2013 04:01:17 -0700 (PDT)
In-Reply-To: <20130910091715.GA3046@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Sep 10, 2013 at 5:17 PM, Jan Kara <jack@suse.cz> wrote:
> On Tue 10-09-13 17:10:13, Yan, Zheng wrote:
>> On 09/10/2013 05:00 PM, Jan Kara wrote:
>> > On Tue 10-09-13 10:02:58, Yan, Zheng wrote:
>> >> From: "Yan, Zheng" <zheng.z.yan@intel.com>
>> >>
>> >> Our Linux Kernel Performance project found that commit 4e7ea81db5
>> >> (ext4: restructure writeback path) indroduced regression. After
>> >> the commit, ext4 does not merge adjacent mapped dirty pages during
>> >> writeback. The "!buffer_delay(bh) && !buffer_unwritten(bh)" check
>> >> in mpage_add_bh_to_extent() prevents the merging.
>> >>
>> >> Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
>> >> ---
>> >>  fs/ext4/inode.c | 3 +--
>> >>  1 file changed, 1 insertion(+), 2 deletions(-)
>> >>
>> >> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
>> >> index c79fd7d..bfeb8b2 100644
>> >> --- a/fs/ext4/inode.c
>> >> +++ b/fs/ext4/inode.c
>> >> @@ -1944,8 +1944,7 @@ static bool mpage_add_bh_to_extent(struct mpage_da_data *mpd, ext4_lblk_t lblk,
>> >>    struct ext4_map_blocks *map = &mpd->map;
>> >>
>> >>    /* Buffer that doesn't need mapping for writeback? */
>> >> -  if (!buffer_dirty(bh) || !buffer_mapped(bh) ||
>> >> -      (!buffer_delay(bh) && !buffer_unwritten(bh))) {
>> >> +  if (!buffer_dirty(bh) || !buffer_mapped(bh)) {
>> >   Sadly it isn't that easy. The condition is there for a reason... The
>> > reason is that we are looking for an extent to map. When we already have
>> > some buffer to map and then there is buffer which doesn't need mapping we
>> > cannot just add it to the extent because then we would allocate too many
>> > blocks.
>>
>> the "(b_state & BH_FLAGS) == map->m_flags)" check in
>> mpage_add_bh_to_extent() should prevent delayed and non-delayed dirty
>> pages from merging. What am I missing here?
>   Yes, that is true. Sorry, I didn't realize this originally. But what
> difference would then your patch make?
>

Continuous dirty pages that are "!buffer_delay(bh) && !buffer_unwritten(bh)"
can be merged during writeback. I think the change will reduce number of
bio for workload that re-writes existing data.

Regards
Yan, Zheng

>                                                                 Honza
>
>> > Also the transaction credits we have reserved are just for
>> > allocation of one extent and its possible conversion from unwritten to
>> > written extent. So that's another reason why you cannot arbitrarily merge
>> > allocated and unallocated buffers or written and unwritten buffers.
>> >
>> > Now also I'm somewhat surprised that this condition is causing a regression
>> > because it was also present in the previous version of the code although it
>> > was there in a different place and in a slightly different form. I'll try to
>> > reproduce results using your fio script and will have a look at what is
>> > causing the problem.
>> >
>> >                                                             Honza
>> >
>> >>            /* So far no extent to map => we write the buffer right away */
>> >>            if (map->m_len == 0)
>> >>                    return true;
>> >> --
>> >> 1.8.1.4
>> >>
>>
> --
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
