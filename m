From: Li Xi <pkuelelixi@gmail.com>
Subject: Re: [PATCH] ext4: fix deadlock of i_data_sem in ext4_mark_inode_dirty()
Date: Fri, 5 Sep 2014 10:29:16 +0800
Message-ID: <CAPTn0cBcy+hHeC0oUk8eVrqHUTF8N05puKmZPBOKrafvaQHhxA@mail.gmail.com>
References: <CAPTn0cAPYMMDx-_RvL22Mf8YMcGib65YbiwfzDhCkEO7-OtHjw@mail.gmail.com>
	<20140905015935.GF4364@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Andreas Dilger <adilger@dilger.ca>, Jan Kara <jack@suse.cz>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-oi0-f51.google.com ([209.85.218.51]:47802 "EHLO
	mail-oi0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132AbaIEC3Q (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 4 Sep 2014 22:29:16 -0400
Received: by mail-oi0-f51.google.com with SMTP id e131so180114oig.24
        for <linux-ext4@vger.kernel.org>; Thu, 04 Sep 2014 19:29:16 -0700 (PDT)
In-Reply-To: <20140905015935.GF4364@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Sep 5, 2014 at 9:59 AM, Theodore Ts'o <tytso@mit.edu> wrote:
> On Thu, Sep 04, 2014 at 04:49:58PM +0800, Li Xi wrote:
>> There are multiple places where ext4_mark_inode_dirty() is called holding
>> write lock of EXT4_I(inode)->i_data_sem. However, if
>> ext4_mark_inode_dirty() needs to expand inode size, this will cause
>> deadlock when ext4_xattr_block_set() tries to get read lock of
>> EXT4_I(inode)->i_data_sem.
>
> This was with inline data enabled, right?
I hit this problem when starting a kernel with project quota support for ext4.
The ext4 file system was not formated with project quota feature so it tried
to extend the space for project ID. And this problem happened every time
when the kernel was rebooted. Inline data was not enable on that file
system. I am not sure whether this problem will happen under other
circumstances. :)
>
>
> So I think we need to find another way to fix this problem.  There are
> a limited number of places before we call ext4_mark_inode_dirty()
> where i_size will grow such that the inline data code might need to
> move the data out from i_blocks[].
>
> It might make more sense to have a helper function which checks to see
> if this condition holds, and do the converation away from using
> inline_data for that inode *before* we call ext4_mark_inode_dirty().
>
> Does that make sense to you?
Sure, I agree there should be other better solution for this problem.
