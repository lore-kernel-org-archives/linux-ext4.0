From: Tahsin Erdogan <tahsin@google.com>
Subject: Re: [PATCH 06/12] e2fsck: update i_blocks accounting for ea_inode feature
Date: Thu, 29 Jun 2017 18:39:37 -0700
Message-ID: <CAAeU0aM7MGcVkAkY5oDzGDDCdTHiARm_ykjPKbJz7Y=YnT5Xgg@mail.gmail.com>
References: <20170626134348.1240-1-tahsin@google.com> <20170626134348.1240-6-tahsin@google.com>
 <866E2967-833B-4CC9-A990-835F5DB291B6@dilger.ca> <CAAeU0aMYYuXBUm_3GALUAQhqQBN9XtdSwrzqP--dRpDZx7+VRg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: "Darrick J . Wong" <darrick.wong@oracle.com>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yw0-f178.google.com ([209.85.161.178]:34022 "EHLO
        mail-yw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751625AbdF3Bji (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 29 Jun 2017 21:39:38 -0400
Received: by mail-yw0-f178.google.com with SMTP id l21so35373154ywb.1
        for <linux-ext4@vger.kernel.org>; Thu, 29 Jun 2017 18:39:38 -0700 (PDT)
In-Reply-To: <CAAeU0aMYYuXBUm_3GALUAQhqQBN9XtdSwrzqP--dRpDZx7+VRg@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

>> This makes it all the more important that the "fast symlink" checking be
>> divorced from i_blocks, and instead depend on i_size.  Otherwise, we will
>> have yet another bunch of problems as large xattrs on a fast symlink will
>> incorrectly result in problems with the symlink.
>>
> Totally agree. The changes to i_blocks accounting for ea_inode feature
> likely broke ext4_inode_is_fast_symlink() in kernel. I will try to fix
> that first.

FYI, I sent out a patch to fix e2fsprogs part too: ("[PATCH]
e2fsprogs: add ext2fs_is_fast_symlink() function")
