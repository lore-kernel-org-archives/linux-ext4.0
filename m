From: Andrew Perepechko <anserper@yandex.ru>
Subject: Re: quota: dqio_mutex design
Date: Thu, 03 Aug 2017 15:24:05 +0300
Message-ID: <8584759.E72qcEIvA1@panda>
References: <10928956.Fla3vXZ7d9@panda> <1691224.ooLB1CWbbI@panda> <CAP9B-QmBKVOfmT3=5wR9_P23+r6KGW_rfzJES4Y6pkjSofvPGg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Shuichi Ihara <sihara@ddn.com>, Wang Shilong <wshilong@ddn.com>,
        Li Xi <lixi@ddn.com>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>,
        Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org
To: Wang Shilong <wangshilong1991@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from forward2m.cmail.yandex.net ([5.255.216.20]:49033 "EHLO
        forward2m.cmail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751953AbdHCNQB (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 3 Aug 2017 09:16:01 -0400
In-Reply-To: <CAP9B-QmBKVOfmT3=5wR9_P23+r6KGW_rfzJES4Y6pkjSofvPGg@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> 
> I don't think this is right, as far as i understand, journal quota need go
> together with quota space change update inside same transaction, this will
> break consistency if power off or RO happen.
> 

Hello Wang!

There is no transaction change in this case because all callers of this
function have open handles for the same transaction.

If you enter that DQ_MOD_B check, you are guaranteed to reference
the SAME transaction as the thread that's in between of mark_dirty
and clear_dirty.

Thank you,
Andrew
