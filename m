From: "George Spelvin" <linux@horizon.com>
Subject: Re: metadata_csum + e4defrag seems to cause problems
Date: 29 Apr 2013 11:57:15 -0400
Message-ID: <20130429155715.23219.qmail@science.horizon.com>
References: <20130426025753.GA21659@gmail.com>
Cc: linux-ext4@vger.kernel.org
To: gnehzuil.liu@gmail.com, linux@horizon.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from science.horizon.com ([71.41.210.146]:63605 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757253Ab3D2P5Q (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 29 Apr 2013 11:57:16 -0400
In-Reply-To: <20130426025753.GA21659@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> Yes, metatdata_csum + e4defrag could corrupt ext4 file system.  We have
> found this bug and it has been fixed by this commit (2656497b, it is in
> dev branch of ext4 tree).  I am not sure whether you use dev branch.
> Could you please tell me your kernel version?  If you don't use dev
> branch, could you please try dev branch of ext4 tree?  Here is the git
> link:
>   https://git.kernel.org/cgit/linux/kernel/git/tytso/ext4.git/log/?h=dev

I was running 3.8-rc7 at the time of the corruption; I rebooted to -rc8
as part of the recovery.

Yes, I already have the ext4 repository cloned, but that was just
for pulling a particular fix Ted recommended a while ago.  I've been
reluctant to use a branch labelled "dev" more routinely without more
reassurance that it's believed to be "brave" rather than "stupid" to
use in something other than a dedicated test environment.

I'll try v3.9 + ext4/dev.  Thank you!

(Current head is 0d606e2c9fcc:
"ext4: fix type-widening bug in inode table readahead code")
