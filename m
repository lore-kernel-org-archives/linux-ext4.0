From: Tahsin Erdogan <tahsin@google.com>
Subject: Re: [PATCH 06/12] e2fsck: update i_blocks accounting for ea_inode feature
Date: Tue, 27 Jun 2017 04:37:43 -0700
Message-ID: <CAAeU0aMYYuXBUm_3GALUAQhqQBN9XtdSwrzqP--dRpDZx7+VRg@mail.gmail.com>
References: <20170626134348.1240-1-tahsin@google.com> <20170626134348.1240-6-tahsin@google.com>
 <866E2967-833B-4CC9-A990-835F5DB291B6@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: "Darrick J . Wong" <darrick.wong@oracle.com>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yb0-f179.google.com ([209.85.213.179]:36531 "EHLO
        mail-yb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752142AbdF0Lhp (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 27 Jun 2017 07:37:45 -0400
Received: by mail-yb0-f179.google.com with SMTP id s9so8377676ybe.3
        for <linux-ext4@vger.kernel.org>; Tue, 27 Jun 2017 04:37:44 -0700 (PDT)
In-Reply-To: <866E2967-833B-4CC9-A990-835F5DB291B6@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jun 26, 2017 at 2:36 PM, Andreas Dilger <adilger@dilger.ca> wrote:
> On Jun 26, 2017, at 7:43 AM, Tahsin Erdogan <tahsin@google.com> wrote:
>>
>> With ea_inode feature, i_blocks include the disk space used by
>> referenced xattr inodes. Make e2fsck aware of that.
>
> This makes it all the more important that the "fast symlink" checking be
> divorced from i_blocks, and instead depend on i_size.  Otherwise, we will
> have yet another bunch of problems as large xattrs on a fast symlink will
> incorrectly result in problems with the symlink.
>
Totally agree. The changes to i_blocks accounting for ea_inode feature
likely broke ext4_inode_is_fast_symlink() in kernel. I will try to fix
that first.
