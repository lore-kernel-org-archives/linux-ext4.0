From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: fix deadlock of i_data_sem in
 ext4_mark_inode_dirty()
Date: Thu, 4 Sep 2014 23:30:54 -0400
Message-ID: <20140905033054.GE1971@thunk.org>
References: <CAPTn0cAPYMMDx-_RvL22Mf8YMcGib65YbiwfzDhCkEO7-OtHjw@mail.gmail.com>
 <20140905015935.GF4364@thunk.org>
 <CAPTn0cBcy+hHeC0oUk8eVrqHUTF8N05puKmZPBOKrafvaQHhxA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Andreas Dilger <adilger@dilger.ca>, Jan Kara <jack@suse.cz>
To: Li Xi <pkuelelixi@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:39200 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752812AbaIEDw4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 4 Sep 2014 23:52:56 -0400
Content-Disposition: inline
In-Reply-To: <CAPTn0cBcy+hHeC0oUk8eVrqHUTF8N05puKmZPBOKrafvaQHhxA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Sep 05, 2014 at 10:29:16AM +0800, Li Xi wrote:
> On Fri, Sep 5, 2014 at 9:59 AM, Theodore Ts'o <tytso@mit.edu> wrote:
> > On Thu, Sep 04, 2014 at 04:49:58PM +0800, Li Xi wrote:
> >> There are multiple places where ext4_mark_inode_dirty() is called holding
> >> write lock of EXT4_I(inode)->i_data_sem. However, if
> >> ext4_mark_inode_dirty() needs to expand inode size, this will cause
> >> deadlock when ext4_xattr_block_set() tries to get read lock of
> >> EXT4_I(inode)->i_data_sem.
> >
> > This was with inline data enabled, right?
> I hit this problem when starting a kernel with project quota support for ext4.
> The ext4 file system was not formated with project quota feature so it tried
> to extend the space for project ID. And this problem happened every time
> when the kernel was rebooted. Inline data was not enable on that file
> system. I am not sure whether this problem will happen under other
> circumstances. :)

I'm not understanding why expanding the inode size would result in
needing to call ext4_xattr_block_set.  Was that becuse you were
storing the project quota in the xattr?  I'm just trying to understand
the context.

Please also note that a recent set of patches (sent to the ext4 list
and in the ext4 git tree) has removed the need for taking i_data_sem
in xattr.c:

http://patchwork.ozlabs.org/patch/385347
http://patchwork.ozlabs.org/patch/385348
http://patchwork.ozlabs.org/patch/385346

(It's the 2/3 patch that removes taking i_data_sem read lock in xattr.c.)

Regards,

						- Ted
