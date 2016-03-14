From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH] ext4: fix extent cache fragmentation
Date: Mon, 14 Mar 2016 18:18:44 +0300
Message-ID: <87h9g9ulyj.fsf@openvz.org>
References: <1455010041-23082-1-git-send-email-dmonakhov@openvz.org> <20160222143741.GA10531@quack.suse.cz> <874mcy1hnv.fsf@openvz.org> <20160310043513.GC4937@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lb0-f169.google.com ([209.85.217.169]:35928 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934381AbcCNPSs (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 14 Mar 2016 11:18:48 -0400
Received: by mail-lb0-f169.google.com with SMTP id x1so243505974lbj.3
        for <linux-ext4@vger.kernel.org>; Mon, 14 Mar 2016 08:18:47 -0700 (PDT)
In-Reply-To: <20160310043513.GC4937@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Ts'o <tytso@mit.edu> writes:

> On Wed, Feb 24, 2016 at 03:17:40PM +0400, Dmitry Monakhov wrote:
>> > So in principle this patch is fine but I hate how handling of extent status
>> > tree is proliferating to fs/ext4/extent.c to handle some cases especially
>> > through special function flags. So looking into the code, probably it would
>> > make sense to move all updates of the extent status tree handling down into
>> > ext4_ext_map_blocks() and ext4_ind_map_blocks(). Thoughts?
>>
>> Agree. This was my initial diea but patch was too big for stable
>> releases. In fact this is not critical fix so we can simply make is
>> in good way and simply ignore @stable. Will send updated version shortly.
>
> Hi Dmitry,
>
> Have you had a chance to come up with an updated patch?
Not yet. But I plan to do it this week.
>
> Thanks,
>
> 						- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
