From: Mark Lord <kernel@teksavvy.com>
Subject: Re: CONFIG_EXT4_USE_FOR_EXT23:  rootfs shows as ext2 instead of ext4
Date: Wed, 13 Apr 2011 21:34:19 -0400
Message-ID: <4DA64F1B.4070803@teksavvy.com>
References: <4DA48AF4.5080803@teksavvy.com> <20110413004938.GE3682@thunk.org> <4DA5AEBE.6060705@teksavvy.com> <5A35771F-49B6-491E-B012-DBE68907E382@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ironport2-out.teksavvy.com ([206.248.154.181]:30297 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754601Ab1DNBeV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 13 Apr 2011 21:34:21 -0400
In-Reply-To: <5A35771F-49B6-491E-B012-DBE68907E382@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 11-04-13 05:00 PM, Theodore Tso wrote:
>
> It's not dangerous at all.   Again, as you can tell if you were to actually
> look at your .config carefully, the ext2 file system was not compiled
> into your kernel at all.   Ext4 will only try masquerading as ext2 if
> CONFIG_EXT2_FS is disabled.  So it couldn't have possibly been
> using ext2 code, if you thought about it for a second.
>
> I can write up a patch which explicitly tests for feature flags that go
> beyond ext2 as of a particular version, and if so, refuse the mount
> when ext4 is masquerading as ext2, and do the same for ext3.   I
> probably will do this to avoid user questions, when I have some
> spare time.
>
> However, please note that this will have no actual effect on how
> anything int he kernel will behave --- none ---- except for a one
> character change in /proc/mounts: s/2/4/.   (This is because the
> kernel will now try ext2, and fail, try ext3 and fail, and then succeed
> when the exact same file system driver is used.  Oh, it might also
> extend the boot time by a few milliseconds.)
>
> Have I made it clear enough now to assuage your fears?

No, very much the contrary, despite the condescending
attempt at "explanation".

    config EXT4_USE_FOR_EXT23
        bool "Use ext4 for ext2/ext3 file systems"
        depends on EXT4_FS
        depends on EXT3_FS=n || EXT2_FS=n
        default y
        help
          Allow the ext4 file system driver code to be used for ext2 or
          ext3 file system mounts.  This allows users to reduce their
          compiled kernel size by using one file system driver for
          ext2, ext3, and ext4 file systems.

So the option is supposed to allow ext4 code to be used
to access ext2 and ext3 filesystems, saving some space
in the binary kernel.  That much is obvious.

But far far less obvious is why the kernel reports
having mounted my ext4 filesystem as "ext2",
and what exactly it means by that.

And I've been a kernel developer as long as you have, Ted,
so just imagine the confusion this might be causing lots
of other less experienced people.

Thanks.
