From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: [PATCH] Add largedir feature
Date: Mon, 1 May 2017 11:58:24 -0700
Message-ID: <20170501185824.GB30027@gmail.com>
References: <1489657877-34478-1-git-send-email-artem.blagodarenko@seagate.com>
 <20170430005953.m74yjettitj7mzr6@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Artem Blagodarenko <artem.blagodarenko@gmail.com>,
        linux-ext4@vger.kernel.org, adilger.kernel@dilger.ca,
        alexey.lyashkov@gmail.com, Yang Sheng <yang.sheng@intel.com>,
        Artem Blagodarenko <artem.blagodarenko@seagate.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:36520 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751224AbdEAS6c (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 1 May 2017 14:58:32 -0400
Received: by mail-pg0-f68.google.com with SMTP id v1so17276758pgv.3
        for <linux-ext4@vger.kernel.org>; Mon, 01 May 2017 11:58:32 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20170430005953.m74yjettitj7mzr6@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Apr 29, 2017 at 08:59:53PM -0400, Theodore Ts'o wrote:
> On Thu, Mar 16, 2017 at 05:51:17AM -0400, Artem Blagodarenko wrote:
> > From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
> > 
> > This INCOMPAT_LARGEDIR feature allows larger directories to be created
> > in ldiskfs, both with directory sizes over 2GB and and a maximum htree
> > depth of 3 instead of the current limit of 2. These features are needed
> > in order to exceed the current limit of approximately 10M entries in a
> > single directory.
> > 
> > Signed-off-by: Yang Sheng <yang.sheng@intel.com>
> > Signed-off-by: Artem Blagodarenko <artem.blagodarenko@seagate.com>
> 
> Thanks, applied.
> 
> 					- Ted

FYI, this patch is causing a problem when creating many files in a directory
(without the largedir feature enabled).  I haven't looked into it but maybe it
will ring a bell for someone.

seq -f "abcdefghijklmnopqrstuvwxyz012345%.0f" 100000 | xargs touch

[   42.726480] EXT4-fs error (device vdc): dx_probe:840: inode #2: block 508: comm touch: Directory index failed checksum
[   42.729472] EXT4-fs error (device vdc): dx_probe:840: inode #2: block 508: comm touch: Directory index failed checksum
[   42.731689] EXT4-fs error (device vdc): dx_probe:840: inode #2: block 508: comm touch: Directory index failed checksum
[   42.734303] EXT4-fs error (device vdc): dx_probe:840: inode #2: block 508: comm touch: Directory index failed checksum
[   42.736383] EXT4-fs error (device vdc): dx_probe:840: inode #2: block 508: comm touch: Directory index failed checksum
[   42.739133] EXT4-fs error (device vdc): dx_probe:840: inode #2: block 508: comm touch: Directory index failed checksum
[   42.741307] EXT4-fs error (device vdc): dx_probe:840: inode #2: block 508: comm touch: Directory index failed checksum
[   42.743963] EXT4-fs error (device vdc): dx_probe:840: inode #2: block 508: comm touch: Directory index failed checksum
[   42.745998] EXT4-fs error (device vdc): dx_probe:840: inode #2: block 508: comm touch: Directory index failed checksum
...
