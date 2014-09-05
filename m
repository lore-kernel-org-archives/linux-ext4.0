From: Li Xi <pkuelelixi@gmail.com>
Subject: Re: [PATCH] ext4: fix deadlock of i_data_sem in ext4_mark_inode_dirty()
Date: Fri, 5 Sep 2014 12:44:49 +0800
Message-ID: <CAPTn0cCk2LGxOQxxYXDHCAM2Whnh38Dg-pxRduQeik1DDG5aeQ@mail.gmail.com>
References: <CAPTn0cAPYMMDx-_RvL22Mf8YMcGib65YbiwfzDhCkEO7-OtHjw@mail.gmail.com>
	<20140905015935.GF4364@thunk.org>
	<CAPTn0cBcy+hHeC0oUk8eVrqHUTF8N05puKmZPBOKrafvaQHhxA@mail.gmail.com>
	<20140905033054.GE1971@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Andreas Dilger <adilger@dilger.ca>, Jan Kara <jack@suse.cz>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ie0-f171.google.com ([209.85.223.171]:43664 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711AbaIEEou (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 5 Sep 2014 00:44:50 -0400
Received: by mail-ie0-f171.google.com with SMTP id rp18so13119660iec.30
        for <linux-ext4@vger.kernel.org>; Thu, 04 Sep 2014 21:44:49 -0700 (PDT)
In-Reply-To: <20140905033054.GE1971@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Sep 5, 2014 at 11:30 AM, Theodore Ts'o <tytso@mit.edu> wrote:
> On Fri, Sep 05, 2014 at 10:29:16AM +0800, Li Xi wrote:
>> On Fri, Sep 5, 2014 at 9:59 AM, Theodore Ts'o <tytso@mit.edu> wrote:
>> > On Thu, Sep 04, 2014 at 04:49:58PM +0800, Li Xi wrote:
>> >> There are multiple places where ext4_mark_inode_dirty() is called holding
>> >> write lock of EXT4_I(inode)->i_data_sem. However, if
>> >> ext4_mark_inode_dirty() needs to expand inode size, this will cause
>> >> deadlock when ext4_xattr_block_set() tries to get read lock of
>> >> EXT4_I(inode)->i_data_sem.
>> >
>> > This was with inline data enabled, right?
>> I hit this problem when starting a kernel with project quota support for ext4.
>> The ext4 file system was not formated with project quota feature so it tried
>> to extend the space for project ID. And this problem happened every time
>> when the kernel was rebooted. Inline data was not enable on that file
>> system. I am not sure whether this problem will happen under other
>> circumstances. :)
>
> I'm not understanding why expanding the inode size would result in
> needing to call ext4_xattr_block_set.  Was that becuse you were
> storing the project quota in the xattr?  I'm just trying to understand
> the context.
Yeah, you are right. The problem happened when the project ID was
saved as xattr. And I can't reproduce the same problem with the new
patches.
>
> Please also note that a recent set of patches (sent to the ext4 list
> and in the ext4 git tree) has removed the need for taking i_data_sem
> in xattr.c:
>
> http://patchwork.ozlabs.org/patch/385347
> http://patchwork.ozlabs.org/patch/385348
> http://patchwork.ozlabs.org/patch/385346
>
> (It's the 2/3 patch that removes taking i_data_sem read lock in xattr.c.)
>
Great! Please ignore this patch since it won't be a problem
any more.

 Regards,

                                                 - Li Xi
