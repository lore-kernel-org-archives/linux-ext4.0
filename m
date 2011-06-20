From: Wang Shaoyan <stufever@gmail.com>
Subject: Re: [PATCH] ext4: Set file system to read-only by I/O error threshold
Date: Mon, 20 Jun 2011 09:32:56 +0800
Message-ID: <BANLkTim-1FfCZAm449zp5PpApbq027HGwYhoZBF0soZpJon9tQ@mail.gmail.com>
References: <1308312516-14252-1-git-send-email-wangshaoyan.pt@taobao.com>
	<alpine.LFD.2.00.1106181015180.4602@dhcp-27-109.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-ext4@vger.kernel.org,
	Wang Shaoyan <wangshaoyan.pt@taobao.com>,
	Ted Tso <tytso@mit.edu>, Jan Kara <jack@suse.cz>
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:55877 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751540Ab1FTBc5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 19 Jun 2011 21:32:57 -0400
Received: by pzk9 with SMTP id 9so3100148pzk.19
        for <linux-ext4@vger.kernel.org>; Sun, 19 Jun 2011 18:32:56 -0700 (PDT)
In-Reply-To: <alpine.LFD.2.00.1106181015180.4602@dhcp-27-109.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2011/6/18 Lukas Czerner <lczerner@redhat.com>:

> Hi,
>
> so you're saying that you encounter I/O error on access(2) only with
> Ext3/4 with journal. So given that you're checking the error count in
> ext4_handle_error() which is called when I/O error happens I fail to see
> how this helps your case. Am I missing something ?
>
Only when access(2) return "Read-only file system", hadoop will mark
the disk as offline. For Ext4 no-journal mode, there is no jdb2 to set
the file system as
read-only when I/O error happens, so we set an threshold, when io
error number reach this number, we change the filesystem to read-only.
I use ext4_abort(), maybe it is wrong?
> Also I do not understand how this is helpful at all ? Usually when we
> hit I/O error we want to have predictable behavior set by the error=
> mount option, but with this patch we have absolutely unpredictable
> behaviour on errors, which is bad! Also we can end up with read-only
> file system even when errors=continue has been set.
>
In ext4 without journal, when the disk drops, the fs can't be
readonly. But in ext3/4 with journal, jbd2 will abort the filesystem,
change fs to be read-only. So we don't care what kind of error happen,
we just want to change fs to be read-only when there are too many
errors

> You can use atomic_t and get rid of the spinlock maybe ?
>
Yes, thanks

> The name for this function should rather be inc_sb_error_count().
Thanks

> I am not sure, but given that it it a "threshold" should not we trigger
> it when we hit the threshold and not threshold+1 ?
Thanks, I should use ">="

> Could you use better error message ? This does not say nothing about why
> it happened. Something about IO errors count reached the threshold ?
Yes,  IO errors count reached the threshold, we need change fs to be readonly

> Maybe you can use atomic operations and get rid of the spin_lock.
spin_lock is just a "lazy approach"

-- 
Wang Shaoyan
