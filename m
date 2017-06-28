From: Tahsin Erdogan <tahsin@google.com>
Subject: Re: [PATCH v2 03/12] e2fsck: ea_inode hash validation
Date: Tue, 27 Jun 2017 18:47:46 -0700
Message-ID: <CAAeU0aNbtEipVxs4uOCXg0djTb_+sD5uxFCmTr4z=4OsiNwTOA@mail.gmail.com>
References: <842B76D1-7759-4FA7-85A8-1E79B72C69EE@dilger.ca> <20170628014155.24475-1-tahsin@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Tahsin Erdogan <tahsin@google.com>
To: Andreas Dilger <adilger@dilger.ca>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yb0-f178.google.com ([209.85.213.178]:34583 "EHLO
        mail-yb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753288AbdF1Brs (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 27 Jun 2017 21:47:48 -0400
Received: by mail-yb0-f178.google.com with SMTP id e201so14835551ybb.1
        for <linux-ext4@vger.kernel.org>; Tue, 27 Jun 2017 18:47:48 -0700 (PDT)
In-Reply-To: <20170628014155.24475-1-tahsin@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

>> +                             if (fix_problem(ctx, PR_1_ATTR_HASH, pctx))
>> +                                     goto clear_extattr;
>
> Shouldn't this be "if (!fix_problem(...))" ?

Unfortunately here "fix" means clearing all entries so it is as
intended. This is the way it was before, I haven't changed the logic.


>> -#define PR_1_ATTR_SET_EA_INODE_FL            0x010086
>> +#define PR_1_ATTR_SET_EA_INODE_FL            0x010085
>
> It would also be OK to keep the old values, and just skip 0x10084.

Done.

>> +                             err = ext2fs_read_inode(handle->fs, handle->ino,
>> +                                                     &parent);
>
> Rather than reading the inode again here, it would make more sense to pass the
> parent inode from the caller.

Done.
