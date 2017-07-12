From: Tahsin Erdogan <tahsin@google.com>
Subject: Re: Fast symlinks stored slow
Date: Wed, 12 Jul 2017 14:36:23 -0700
Message-ID: <CAAeU0aM-57TcFC2792zkZmXsUaUqajL72EWKUPAAxowSkuDYfg@mail.gmail.com>
References: <20170712170711.GA19996@redhat.com> <20170712205230.GC19996@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Richard W.M. Jones" <rjones@redhat.com>,
        Andreas Dilger <adilger@dilger.ca>,
        "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yw0-f178.google.com ([209.85.161.178]:34146 "EHLO
        mail-yw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753369AbdGLVgZ (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 12 Jul 2017 17:36:25 -0400
Received: by mail-yw0-f178.google.com with SMTP id l21so15302279ywb.1
        for <linux-ext4@vger.kernel.org>; Wed, 12 Jul 2017 14:36:24 -0700 (PDT)
In-Reply-To: <20170712205230.GC19996@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

>> To cut a long story short, we were using libext2fs to create
>> filesystems where short symlinks (< 60 bytes) were stored the same way
>> as long symlinks, ie. stored as an ordinary file instead of being
>> stored in the inode.
>
> As a further data point, e2fsck does not complain about these
> filesystems.

This sounds bad. We may have to revert back to i_blocks based logic.

As an example, lets say inode's EXT4_INODE_EXTENTS flag is clear,
i_size is 2 and i_data[0] contains 0x00004141. Without inspecting
xattrs and i_blocks, we can't determine whether a) the target is "AA"
or b) block 0x4141 contains two bytes that is the actual symlink
target.
