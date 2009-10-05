From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] e2fsprogs: clean up ext2fs_bg_flags_ interfaces
Date: Mon, 5 Oct 2009 07:51:02 -0400
Message-ID: <20091005115102.GC13512@mit.edu>
References: <4AA7FC13.6060109@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:38764 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932498AbZJELvn (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 5 Oct 2009 07:51:43 -0400
Content-Disposition: inline
In-Reply-To: <4AA7FC13.6060109@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Sep 09, 2009 at 02:03:47PM -0500, Eric Sandeen wrote:
> The ext2fs_bg_flag* functions were confusing.
>
> Currently we have this:
>
> void ext2fs_bg_flags_set(ext2_filsys fs, dgrp_t group, __u16 bg_flags);
> void ext2fs_bg_flags_clear(ext2_filsys fs, dgrp_t group,__u16 bg_flags);
>
> (_set (unused) sets exactly bg_flags; _clear clears all and ignores bg_flags)
>
> and these, which can twiddle individual bits in bg_flags:
>
> void ext2fs_bg_flag_set(ext2_filsys fs, dgrp_t group, __u16 bg_flag);
> void ext2fs_bg_flag_clear(ext2_filsys fs, dgrp_t group, __u16 bg_flag);
>
> A better interface, after the patch below, is just:
>
> ext2fs_bg_flags_zap(fs, group) /* zeros bg_flags */
> ext2fs_bg_flags_set(fs, group, flags) /* adds flags to bg_flags */
> ext2fs_bg_flags_clear(fs, group, flags) /* clears flags in bg_flags */
>

Applied.  I also (for consistency's sake) converted
ext2fs_bg_flag_test() to ext2fs_bg_flags_test() in a separate commit.

							- Ted
