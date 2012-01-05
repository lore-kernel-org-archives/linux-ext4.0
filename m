From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: 3.2.0-rc5 NULL dereference BUG
Date: Thu, 5 Jan 2012 10:23:13 +0800
Message-ID: <CAGBYx2ZyiKrbsQmiC3YxB7sKjhEQVeznUM2cGrXMyQuXPZ5o1Q@mail.gmail.com>
References: <20111218055359.GA17182@localhost>
	<20111218063054.GA4979@localhost>
	<CAGBYx2bxdnkXcZF+A1iOvnsW=xdtDJR7Fx3Rz-HWeWH5n0ByKg@mail.gmail.com>
	<20111218113237.GA1359@localhost>
	<20120105015609.GA7913@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:63681 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757709Ab2AECXN convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 4 Jan 2012 21:23:13 -0500
In-Reply-To: <20120105015609.GA7913@localhost>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Fengguang,

> [ =A0646.051405] =A0ffff880004ee1978 0000000000000000 000000000000017=
0 0000000000000000
> [ =A0646.051405] Call Trace:
> [ =A0646.051405] =A0[<ffffffff81099aa3>] ? sched_clock_local+0x12/0x7=
5
> [ =A0646.051405] =A0[<ffffffff810a5a16>] lock_acquire+0xdd/0x10a
> [ =A0646.051405] =A0[<ffffffff81175de4>] ? create_empty_buffers+0x4a/=
0xc1
> [ =A0646.051405] =A0[<ffffffff8199f623>] _raw_spin_lock+0x36/0x69
> [ =A0646.051405] =A0[<ffffffff81175de4>] ? create_empty_buffers+0x4a/=
0xc1
> [ =A0646.051405] =A0[<ffffffff81175de4>] create_empty_buffers+0x4a/0x=
c1
> [ =A0646.051405] =A0[<ffffffff811efd2f>] ext4_discard_partial_page_bu=
ffers_no_lock+0x9f/0x406
> [ =A0646.051405] =A0[<ffffffff8199ffeb>] ? _raw_spin_unlock+0x2b/0x2f
> [ =A0646.051405] =A0[<ffffffff81170c26>] ? __mark_inode_dirty+0x1ac/0=
x1cc
> [ =A0646.051405] =A0[<ffffffff811767f3>] ? generic_write_end+0x6d/0x7=
f
> [ =A0646.051405] =A0[<ffffffff811f15e5>] ext4_da_write_end+0x244/0x2e=
d
> [ =A0646.051405] =A0[<ffffffff810ffeec>] generic_file_buffered_write+=
0x183/0x22d
It seems that you are running in to several problems related to
discard_page_buffers_no_lock in write_end.  The problems had been
fixed by following patches [ext4: avoid potential hang in
mpage_submit_io() when blocksize < pagesize], [ext4: correctly handle
pages w/o buffers in ext4_discard_partial_buffers()] and [ext4: handle
EOF correctly in ext4_bio_write_page()].   The patches had been merged
to rc6.


Yongqiang.
>
> The test case is about running 100 dd tasks on each of the 10 JBOD di=
sks:

>
> =A0 =A0 =A0 =A0lkp-st02-x8664/JBOD-10HDD-thresh=3D100M/ext4-100dd-1-3=
=2E2.0-rc5-ioless-full+
>
> Thanks,
> Fengguang



--=20
Best Wishes
Yongqiang Yang
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
