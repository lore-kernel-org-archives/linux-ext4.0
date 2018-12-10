Return-Path: <SRS0=P4kf=OT=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail-io1-f65.google.com ([209.85.166.65]:32902 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727313AbeLJPog (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 10 Dec 2018 10:44:36 -0500
Received: by mail-io1-f65.google.com with SMTP id t24so9133710ioi.0
        for <linux-ext4@vger.kernel.org>; Mon, 10 Dec 2018 07:44:35 -0800 (PST)
Subject: Re: [PATCH 2/2] fs/ext4,jbd2: Add support for passing write-hint with
 journal.
To: Jan Kara <jack@suse.cz>
Cc: Kanchan Joshi <joshi.k@samsung.com>, linux-ext4@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, tytso@mit.edu,
        adilger.kernel@dilger.ca, jack@suse.com, viro@zeniv.linux.org.uk,
        darrick.wong@oracle.com, jrdr.linux@gmail.com, ebiggers@google.com,
        jooyoung.hwang@samsung.com, chur.lee@samsung.com,
        prakash.v@samsung.com
References: <1544446204-5291-1-git-send-email-joshi.k@samsung.com>
 <CGME20181210125256epcas1p1e4142cfefb9b21dfb8dad927fbd49143@epcas1p1.samsung.com>
 <1544446204-5291-3-git-send-email-joshi.k@samsung.com>
 <20181210141226.GM29289@quack2.suse.cz>
 <9f693dd1-3c29-cdb4-90cd-83a27e21df4a@kernel.dk>
 <20181210154121.GO29289@quack2.suse.cz>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <11da6cc1-0276-7842-a036-671241edf6fd@kernel.dk>
Date: Mon, 10 Dec 2018 08:44:32 -0700
MIME-Version: 1.0
In-Reply-To: <20181210154121.GO29289@quack2.suse.cz>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 12/10/18 8:41 AM, Jan Kara wrote:
> On Mon 10-12-18 08:17:18, Jens Axboe wrote:
>> On 12/10/18 7:12 AM, Jan Kara wrote:
>>> On Mon 10-12-18 18:20:04, Kanchan Joshi wrote:
>>>> This patch introduces "j_writehint" in JBD2 journal,
>>>> which is set based by Ext4 depending on "journal_writehint"
>>>> mount option (inspired from "journal_ioprio").
>>>
>>> Thanks for the patch! It would be good to provide the explanation you have
>>> in the cover letter in this patch as well so that it gets recorded in git
>>> logs.
>>>
>>> Also I don't like the fact that users have to set the hint via a mount
>>> option for this to be enabled. OTOH the WRITE_FILE_<foo> hints defined in
>>> fs.h are generally supposed to be used by userspace so it's difficult to
>>> pick anything if we don't know what the userspace is going to do. I'd argue
>>> it's even difficult for the sysadmin to pick any good value even if he
>>> actually knows that he might benefit from setting some. Jens, is there
>>> some reasonable way for fs to automatically pick some stream value for its
>>> journal?
>>
>> I think we have two options here:
>>
>> 1) It's _probably_ safe to assume that journal data is short lived. While
>>    hints are all relative to the specific use case, the size of the journal
>>    compared to the rest of the drive is most likely very small. Hence a
>>    default of WRITE_LIFE_SHORT is probably a good idea.
> 
> That's what I was thinking as well. But there are some exceptions like
> heavy DB load where there's very little of metadata modified (and thus
> almost no journal IO) compared to the DB data. So journal blocks may have
> actually longer life time than data blocks. OTOH if there's little journal
> IO there's no big benefit in specifying a stream for it so WRITE_LIFE_SHORT
> is probably a good default anyway.

Right, that's my probably, it would definitely not work for all cases. But
it only really fails if two uses of the same life time ends up being vastly
different. It doesn't matter if LIFE_SHORT ends up being the longest life
time of them all.

>> 2) We add a specific internal life time hint for fs journals.
>>
>> #2 makes the most sense to me, but requires a bit more work...
> 
> Yeah, #2 would look more natural to me but I guess it needs some mapping to
> what the drive offers, doesn't it?

We only used 4 streams, drives generally offer a lot more. So we can expand
it quite easily.

-- 
Jens Axboe
