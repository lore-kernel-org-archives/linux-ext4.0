From: Ruslan Bilovol <ruslan.bilovol@ti.com>
Subject: Re: [PATCH 1/2] jbd2: check bh->b_data for NULL in
 jbd2_journal_get_descriptor_buffer before memset()
Date: Thu, 6 Jun 2013 11:02:55 +0300
Message-ID: <CAB=otbTdCjpm9Hnbb-gbc_=rsy0Dkd6LcfqoQtptRYWhXv8Ggg@mail.gmail.com>
References: <1370253616-8173-1-git-send-email-ruslan.bilovol@ti.com>
	<1370253616-8173-2-git-send-email-ruslan.bilovol@ti.com>
	<20130603153323.GB20009@thunk.org>
	<CAB=otbT15wLGkb_A9pa7-U=wH-_gOPgOR9Ee4uSL7_P0BmXt4Q@mail.gmail.com>
	<20130604133749.GB23132@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: "Theodore Ts'o" <tytso@mit.edu>,
	Ruslan Bilovol <ruslan.bilovol@ti.com>,
	adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-oa0-f54.google.com ([209.85.219.54]:50897 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932235Ab3FFIC4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 6 Jun 2013 04:02:56 -0400
In-Reply-To: <20130604133749.GB23132@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,

On Tue, Jun 4, 2013 at 4:37 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> On Tue, Jun 04, 2013 at 02:15:57PM +0300, Ruslan Bilovol wrote:
>> > Have you actually seen a case where bh is non-NULL, but bh->b_data is
>> > NULL?  If not, it might be better to do something like this:
>>
>> Yes, this is exactly the situation I observe (bh is non-NULL, but
>> bh->b_data is NULL)
>
> Hmm... so the stack trace you sent in the commit description was one
> where bh->b_data was NULL?  I'm trying to make sure there isn't
> something else going on that we don't understand.
>
> Could you put some instrumentation in __find_get_block()?  Something like this:
>
> struct buffer_head *
> __find_get_block(struct block_device *bdev, sector_t block, unsigned size)
> {
>         struct buffer_head *bh = lookup_bh_lru(bdev, block, size);
>
>         if (bh == NULL) {
>                 bh = __find_get_block_slow(bdev, block);
>                 if (bh->b_data == NULL) {
>                    pr_crit("b_data NULL after find_get_block_slow\n);
>                    WARN_ON(1);
>                 }
>                 if (bh)
>                         bh_lru_install(bh);
>         } else {
>                 if (bh->b_data == NULL) {
>                         pr_crit("b_data NULL after lookup_bh_lru\n");
>                         WARN_ON(1);
>                 }
>         }
>         if (bh)
>                 touch_buffer(bh);
>         return bh;
> }
>
> ... and then send me the stack trace after running your reproduction
> case.  If it turns out the problem is in __find_get_block_slow(),
> could you put in similar debugging checks there and try to track it
> down?
>
> I'm pretty sure the case of bh non-NULL and bh->b_data NULL is never
> supposed to happen, and while we could just put a check where you
> suggested, there are plenty of other places which use __getblk(), and
> there may be other bugs that are hiding here.

Yes agree, that's what I told about in my cover letter fir this patch series.
I will debug it with code you mentioned, but the issue appears
very rarely, so I need at lease few days for catching this..

Regards,
Ruslan

>
> Regards,
>
>                                                 - Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



-- 
Best regards,
Ruslan Bilvol
