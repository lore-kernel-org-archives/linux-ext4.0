From: Tahsin Erdogan <tahsin@google.com>
Subject: Re: [PATCH 04/12] e2fsck: do not early terminate extra space check
Date: Mon, 26 Jun 2017 16:57:17 -0700
Message-ID: <CAAeU0aPDmBF5kp3JoiY0=vveyNe0i4rUmhrO40iPF5AuKU-B4g@mail.gmail.com>
References: <20170626134348.1240-1-tahsin@google.com> <20170626134348.1240-4-tahsin@google.com>
 <CF22DC39-678F-420D-BD6D-28C90CB7D6E3@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: "Darrick J . Wong" <darrick.wong@oracle.com>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yb0-f171.google.com ([209.85.213.171]:36832 "EHLO
        mail-yb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751440AbdFZX5T (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 26 Jun 2017 19:57:19 -0400
Received: by mail-yb0-f171.google.com with SMTP id s9so4956434ybe.3
        for <linux-ext4@vger.kernel.org>; Mon, 26 Jun 2017 16:57:18 -0700 (PDT)
In-Reply-To: <CF22DC39-678F-420D-BD6D-28C90CB7D6E3@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

>> @@ -582,7 +582,6 @@ static void check_inode_extra_space(e2fsck_t ctx, struct problem_context *pctx)
>>                       inode->i_extra_isize = (inode->i_extra_isize + 3) & ~3;
>>               e2fsck_write_inode_full(ctx, pctx->ino, pctx->inode,
>>                                       EXT2_INODE_SIZE(sb), "pass1");
>> -             return;
>>       }
>>
>>       /* check if there is no place for an EA header */
>
> The problem is that if i_extra_isize is changed, then the EA magic and data
> will no longer be aligned properly, so there isn't anything to check?
>
In the rest of the function, inline extended attributes and
i_*time_extra fields are checked. If i_extra_size moves from its
original location, magic field won't be found and inline extended
attribute check will be skipped. But if it happens to be corrected to
its original location, then we should check the ea contents. Also, we
should check the time extra fields.

I don't really see a good reason to return early. Please let me know
if I missing something.
