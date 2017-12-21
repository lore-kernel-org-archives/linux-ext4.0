From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 4/5] Add missing information to various man pages and
 usage texts.
Date: Thu, 21 Dec 2017 11:11:32 -0500
Message-ID: <20171221161132.GB27177@thunk.org>
References: <cover.1513233071.git.tgnottingham@gmail.com>
 <fb7064572732b5921783c2743577435bd714c73f.1513233071.git.tgnottingham@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Tyson Nottingham <tgnottingham@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:45872 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754859AbdLUQLe (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 21 Dec 2017 11:11:34 -0500
Content-Disposition: inline
In-Reply-To: <fb7064572732b5921783c2743577435bd714c73f.1513233071.git.tgnottingham@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Dec 13, 2017 at 11:13:12PM -0800, Tyson Nottingham wrote:
> badblocks.c: Add -B and -X to usage text.
> 
> chattr.1.in: Add P to list of settable attributes.
> 
> e2image.8.in, e2image.c: Remove superfluous mention of -r option.
> 
> e2undo.8.in, e2undo.c: Add description for -z to man page and add -o and
>   -z to synopsis and usage text.
> 
> e4crypt.8.in: Add -p pad option to relevant command descriptions.
> 
> lsattr.1.in: Fix typo.
> 
> mke2fs.8.in: Add -C to synopsis. Add MKE2FS_DEVICE_PHYS_SECTSIZE
>   description and update MKE2FS_DEVICE_SECTSIZE description.
> 
> mke2fs.conf.5.in: Add devices stanza summary. Remove base_features and
>   default_features descriptions from defaults section, as they are
>   already described in fs_types section. Move enable_periodic_fsck and
>   force_undo to fs_types section, as they can be set per filesystem
>   type. Add missing lazy_journal_init and hugefiles_dir descriptions.
> 
> tune2fs.8.in: Remove unsupported -p option and deprecated -s option.
>   Add 64bit, ea_inode, large_dir, and metadata_csum_seed descriptions.
> 
> tune2fs.c: Remove unsupported -p option from usage text.
>   Add mmp_update_interval to extended option usage text.
> 
> resize/main.c: Add -S option to usage text.
> 
> Signed-off-by: Tyson Nottingham <tgnottingham@gmail.com>

Applied to the maint branch, thanks.

				- Ted
