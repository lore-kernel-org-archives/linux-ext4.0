From: Grant Coady <grant_lkml@dodo.com.au>
Subject: Re: [PATCH 42/42] ext4: Rename ext4dev to ext4
Date: Sun, 12 Oct 2008 10:08:06 +1100
Message-ID: <rcc2f45o6tq3r052ftbousrvmfkm9m89uh@4ax.com>
References: <1223525160-9887-37-git-send-email-tytso@mit.edu> <1223525160-9887-38-git-send-email-tytso@mit.edu> <1223525160-9887-39-git-send-email-tytso@mit.edu> <1223525160-9887-40-git-send-email-tytso@mit.edu> <1223525160-9887-41-git-send-email-tytso@mit.edu> <1223525160-9887-42-git-send-email-tytso@mit.edu> <1223525160-9887-43-git-send-email-tytso@mit.edu> <48F122FC.6040107@goop.org> <48F12427.5090801@redhat.com> <20081011225826.GD12662@mit.edu>
Reply-To: Grant Coady <gcoady.lk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Eric Sandeen <sandeen@redhat.com>,
	Jeremy Fitzhardinge <jeremy@goop.org>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from relay03.mail-hub.dodo.com.au ([123.2.6.238]:32838 "EHLO
	relay03.mail-hub.dodo.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754178AbYJKXI2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sat, 11 Oct 2008 19:08:28 -0400
In-Reply-To: <20081011225826.GD12662@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, 11 Oct 2008 18:58:26 -0400, Theodore Tso <tytso@mit.edu> wrote:

>On Sat, Oct 11, 2008 at 05:09:43PM -0500, Eric Sandeen wrote:
>> 
>> Yep, we've discussed that and I think it'll get added.
>> 
>
>It did get added in the final version that I pushed to Linus (and was
>accepted into mainline this afternoon).  It's enabled via a new
>Kconfig option:
>
>config EXT4DEV_COMPAT
>	bool "Enable ext4dev compatibility"
>	depends on EXT4_FS
>	help
>	  Starting with 2.6.28, the name of the ext4 filesystem was
>	  renamed from ext4dev to ext4.  Unfortunately there are some
>	  lagecy userspace programs (such as klibc's fstype) have

dyslexic vowels? --> s/lagecy/legacy/  :o)

Grant.
