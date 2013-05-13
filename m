From: Tony Luck <tony.luck@gmail.com>
Subject: Re: Re: EXT4 panic at jbd2_journal_put_journal_head() in 3.9+
Date: Sun, 12 May 2013 19:04:45 -0700
Message-ID: <CA+8MBbLY1jQCQmBrKdVpihkqFBf93iJKZ7J8E_JXcu9NVeff_w@mail.gmail.com>
References: <6719519.5821368147110937.JavaMail.weblogic@epml17>
	<CA+8MBbKHJgnueAurRV1aeeV-NdzRTz_gVwYcJuyDrjJLErtcfg@mail.gmail.com>
	<871u9e6ji1.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: eunb.song@samsung.com, "Theodore Ts'o" <tytso@mit.edu>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-oa0-f54.google.com ([209.85.219.54]:49658 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752535Ab3EMCEq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 12 May 2013 22:04:46 -0400
In-Reply-To: <871u9e6ji1.fsf@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, May 11, 2013 at 12:52 AM, Dmitry Monakhov <dmonakhov@openvz.org> wrote:.
> What was page_size and fsblock size?

CONFIG_IA64_PAGE_SIZE_64KB=y

fsblock size is whatever is the default for SLES11SP2 on ia64 - which
tool will tell me?

My git bisect finally competed and points the a finger at:

bisect> git bisect good
ae4647fb7654676fc44a97e86eb35f9f06b99f66 is first bad commit
commit ae4647fb7654676fc44a97e86eb35f9f06b99f66
Author: Jan Kara <jack@suse.cz>
Date:   Fri Apr 12 00:03:42 2013 -0400

    jbd2: reduce journal_head size

    Remove unused t_cow_tid field (ext4 copy-on-write support doesn't seem
    to be happening) and change b_modified and b_jlist to bitfields thus
    saving 8 bytes in the structure.

    Signed-off-by: Jan Kara <jack@suse.cz>
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
    Reviewed-by: Zheng Liu <wenqing.lz@taobao.com>

:040000 040000 c39ece4341894b3daf84764ba425a87ffb90fe50
d4e8d9185c2a1b740c235ca8ed05d496a442fce3 M      include

-Tony
