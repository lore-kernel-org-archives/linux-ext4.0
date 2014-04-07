From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [GIT PULL] ext4 changes for 3.15
Date: Mon, 7 Apr 2014 15:15:36 +0200
Message-ID: <CAJfpegv_Ng1cXbpCqicG4e3UdGK3uiDtVB4KzfRQOhDq_uhZOw@mail.gmail.com>
References: <20140403191558.GA8745@thunk.org>
	<CA+55aFxoA-iDdmbbgmJiYVvskrtca5aGgUAW=3CR47rM9NEMLA@mail.gmail.com>
	<20140404035308.GC2525@thunk.org>
	<20140404134429.GB26806@quack.suse.cz>
	<CAJfpegsJd9d8NTmwozJ+u_ZS-SnUwAQFwAne6P1KqG=VZeZSTA@mail.gmail.com>
	<20140404234358.GE10275@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: "Theodore Ts'o" <tytso@mit.edu>,
	Miklos Szeredi <miklos@szeredi.hu>, Jan Kara <jack@suse.cz>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qa0-f53.google.com ([209.85.216.53]:42356 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754821AbaDGNPh (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 7 Apr 2014 09:15:37 -0400
Received: by mail-qa0-f53.google.com with SMTP id w8so5773665qac.26
        for <linux-ext4@vger.kernel.org>; Mon, 07 Apr 2014 06:15:36 -0700 (PDT)
In-Reply-To: <20140404234358.GE10275@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Apr 5, 2014 at 1:43 AM, Theodore Ts'o <tytso@mit.edu> wrote:
> On Fri, Apr 04, 2014 at 07:16:25PM +0200, Miklos Szeredi wrote:
>>
>> http://marc.info/?l=linux-kernel&m=139523745403081&w=2
>
> I tried applying this patch on top of xfstests commit 3948694eb1, but
> running on ext4.git's test branch, which has the your cross-rename
> patches applied:
>
> http://git.kernel.org/cgit/linux/kernel/git/tytso/ext4.git/commit/?h=test&id=b7bcc46d4f80139930c2e6bd04ff8ebbff121bc9
>
> I see the following:
>
> BEGIN TEST: Ext4 4k block Fri Apr  4 23:21:50 UTC 2014
> Device: /dev/vdb
> mk2fs options: -q
> mount options: -o block_validity
> FSTYP         -- ext4
> PLATFORM      -- Linux/i686 candygram 3.14.0-00061-gb7bcc46
> MKFS_OPTIONS  -- -q /dev/vdc
> MOUNT_OPTIONS -- -o acl,user_xattr -o block_validity /dev/vdc /vdc
>
> generic/323             [23:22:03] [23:22:04] [not run]
>         generic/323 -- kernel doesn't support renameat2 syscall
> generic/324             [23:22:04] [23:22:05] [not run]
>         generic/324 -- kernel doesn't support renameat2 syscall
> generic/325             [23:22:05] [23:22:06] [not run]
>         generic/325 -- kernel doesn't support renameat2 syscall
> Not run: generic/323 generic/324 generic/325
>
> Is there anything obvious that I might be doing wrong?

I only wired up the syscall for x86_64.   Who's responsible for adding
all the syscall tables for the various architectures?

Thanks,
Miklos
