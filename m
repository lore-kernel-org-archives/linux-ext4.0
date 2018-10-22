Return-Path: <SRS0=Lb0t=NC=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail-40133.protonmail.ch ([185.70.40.133]:16650 "EHLO
        mail-40133.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728144AbeJVSwx (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 22 Oct 2018 14:52:53 -0400
Date: Mon, 22 Oct 2018 10:34:48 +0000
To: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
From: Fisher <fisherthepooh@protonmail.com>
Reply-To: Fisher <fisherthepooh@protonmail.com>
Subject: Why not always do copy-out in jbd2_journal_write_metadta_buffer
Message-ID: <usGdshd4UQ6wFx4jVDkzY1xddFnUnT7NXj6IWA-uVczdSc5_TmczQvtmULxNVQ3reUPTmyQd2YeLhPa_L2uPbaNdfBPVlLz7rQQ9oC7aSkw=@protonmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

Recently I was testing my storage's performance and found that there were

periodic performance drops when I ran sequential write benchmark.

After profiling the duration in each step, I found that the dropping

performance was due to wait_on_bit_io(&bh->b_state, BH_Shadow, TASK_UNINTER=
RUPTIBLE)

in do_get_write_access(). And this is what made me confused, if my understa=
nding was right,

I thought buffer_shadow(bh) stands for buffer not being copied-out that's w=
hy we should wait.

But why don't we do copy-out in jbd2_journal_write_metadta_buffer()? and if=
 we do

do the copy-out, does that mean we don't have to set_buffer_shadow because =
it refers to

buffer not copied-out?

I made a test, when a buffer_head goes into jbd2_journal_write_metadta_buff=
er(), as long as

it belongs to metadata, then force it to do copy-out and do not set_buffer_=
shadow, then there

will be no periodic performance drops. Is this test reasonable?

Thanks,
