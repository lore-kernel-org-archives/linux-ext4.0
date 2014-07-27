From: Azat Khuzhin <a3at.mail@gmail.com>
Subject: Re: [PATCH] resize2fs: fix 32bit overflow during minimal size
 calculation for 64bit fs.
Date: Sun, 27 Jul 2014 22:21:44 +0400
Message-ID: <20140727182028.GE24045@azat>
References: <1406359167-13610-1-git-send-email-a3at.mail@gmail.com>
 <20140726215341.GU6725@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, lists2009@fnarfbargle.com
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lb0-f172.google.com ([209.85.217.172]:59153 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752186AbaG0SVz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 27 Jul 2014 14:21:55 -0400
Received: by mail-lb0-f172.google.com with SMTP id z11so5040653lbi.17
        for <linux-ext4@vger.kernel.org>; Sun, 27 Jul 2014 11:21:53 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20140726215341.GU6725@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Jul 26, 2014 at 05:53:41PM -0400, Theodore Ts'o wrote:
> On Sat, Jul 26, 2014 at 11:19:27AM +0400, Azat Khuzhin wrote:
> > calculate_minimum_resize_size() multiplying two 32bit numbers, however the
> > result must be 64bit, but it will be truncated to 32bit, and because of this
> > data_blocks will be zero, and it will never leave loop...
> 
> There is a much more general patch which solves a number of other
> instances where this bug exists which I've already committed into my
> tree:
> 
> https://git.kernel.org/cgit/fs/ext2/e2fsprogs.git/commit/?h=maint&id=1e33a8b408123a4e02a6b9135807f6fd61f3e235

Yeah, I didn't thought about fixing *all* places of this bug.
Thanks,
Azat.
