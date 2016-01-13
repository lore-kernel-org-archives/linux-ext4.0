From: Li Xi <pkuelelixi@gmail.com>
Subject: Re: [v16 0/4] ext4: add project quota support
Date: Wed, 13 Jan 2016 09:15:51 +0800
Message-ID: <CAPTn0cCSzqKfS5g7Y9ESmw4wMnD2H7XCepA3drRvXH_+PN85AA@mail.gmail.com>
References: <1452588970-18309-1-git-send-email-lixi@ddn.com>
	<20160112174556.GA22719@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Andreas Dilger <adilger@dilger.ca>, Jan Kara <jack@suse.cz>,
	"viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
	"hch@infradead.org" <hch@infradead.org>,
	Dmitry Monakhov <dmonakhov@openvz.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-vk0-f44.google.com ([209.85.213.44]:34552 "EHLO
	mail-vk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750746AbcAMBPw (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 12 Jan 2016 20:15:52 -0500
Received: by mail-vk0-f44.google.com with SMTP id a123so222962004vkh.1
        for <linux-ext4@vger.kernel.org>; Tue, 12 Jan 2016 17:15:51 -0800 (PST)
In-Reply-To: <20160112174556.GA22719@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,

Thanks for merging it.

That is true, there is no other change beyong rebasing it to 4.4 kernel (master
branch of linux git). I ran regression tests of project quota on
current patches.

Sure, I will check the patches in the git tree. And also, I'd like to
build the kernel
and test it again together with the latest e2fsprogs patches to make
sure everything
works, just in case.

BTW, I have a patch of quota-tools.git that adds project quota support
for quota tools.
Do you know which mail list should I send that patch to?

Regards
Li Xi

On Wed, Jan 13, 2016 at 1:45 AM, Theodore Ts'o <tytso@mit.edu> wrote:
> Hi Li,
>
> The ext4 project quota patches are in the ext4.git tree and are
> planned to be merged during this merge window.  I've already made some
> changes to fix problems that were reported by zero day testting
> service (when CONFIG_QUOTA was not enabled, for example).  Since
> you've reported that the only changes in this patch series was to
> rebase it to the 4.4 kernel, I don't plan to be taking a close look at
> this version of the patches; please let me know if there were any
> changes beyond just the rebasing changes.
>
> Also, if you could take a look at the project quota patches in the
> ext4.git tree, please let me know if you have changes you would like
> since this is what I plan to be sending to Linus in the next few days.
>
> Many thanks!
>
>                                                 - Ted
>
