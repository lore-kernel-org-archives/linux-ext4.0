From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] e2fsprogs: remove misleading argument from	ext2fs_bg_flags_clear
Date: Wed, 02 Sep 2009 22:00:14 -0500
Message-ID: <4A9F313E.8030605@redhat.com>
References: <4A9EE6E4.2000307@redhat.com> <20090902232811.GG4197@webber.adilger.int> <20090902234243.GC30497@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger@sun.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sandeen.net ([209.173.210.139]:12832 "EHLO mail.sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753963AbZICDAN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 2 Sep 2009 23:00:13 -0400
In-Reply-To: <20090902234243.GC30497@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso wrote:
> On Wed, Sep 02, 2009 at 05:28:11PM -0600, Andreas Dilger wrote:
>> On Sep 02, 2009  16:43 -0500, Eric Sandeen wrote:
>>> ext2fs_bg_flags_clear shouldn't take an unused bg_flags argument
>>> if its purpose is to clear -all- flags.  That just makes people
>>> like me call it for the wrong purpose ;)
>> I'd pointed this out when the code was originally submitted.
>> That said, I'd prefer a function which allows clearing
>> individual flags, rather than all of them.  It is possible to
>> call it with ~0 to clear all of the flags.

ext2fs_bg_flag_clear(fs, group, flag) does just that...

TBH "ext2fs_bg_clear_flags(fs, group, ~0)" seems a bit tortured to me.

> Agreed; if we want to have a function which clears all of the flags,
> it should be named something like ext2fs_bg_flags_zap(), or some such.
> It would be confusing for ext2fs_bg_flags_clear() and
> ext2fs_bg_flags_set() not to be symmetric.
> 
> 						- Ted

But they are symmetric; just a bit odd in usage, esp. since the argument 
is ignored.

Ok should have looked closer; we have these which overwrite bg_flags:

void ext2fs_bg_flags_set(ext2_filsys fs, dgrp_t group, __u16 bg_flags);
void ext2fs_bg_flags_clear(ext2_filsys fs, dgrp_t group,__u16 bg_flags);

(_set sets exactly bg_flags; _clear clears all and ignores bg_flags)

and these, which can twiddle individual bits in bg_flags:

void ext2fs_bg_flag_set(ext2_filsys fs, dgrp_t group, __u16 bg_flag);
void ext2fs_bg_flag_clear(ext2_filsys fs, dgrp_t group, __u16 bg_flag);

hrmph.  Ok, not the most obvious.  I still don't think that an unused 
variable to "ext2fs_bg_flags_clear" is helpful, regardless of the name.

Oh, and ext2fs_bg_flags_set is unused it seems.

What about perhaps just these 3:

ext2fs_bg_flags_zero(fs, group) /* zeros bg_flags */

ext2fs_bg_flags_set(fs, group, flags) /* adds flags to bg_flags */
ext2fs_bg_flags_clear(fs, group, flags) /* clears flags in bg_flags */

and remove the original ext2fs_bg_flags_set / ext2fs_bg_flags_clear.

-Eric

