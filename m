From: Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: 3.2.0-rc5 NULL dereference BUG
Date: Thu, 5 Jan 2012 10:25:25 +0800
Message-ID: <20120105022525.GA9408@localhost>
References: <20111218055359.GA17182@localhost>
 <20111218063054.GA4979@localhost>
 <CAGBYx2bxdnkXcZF+A1iOvnsW=xdtDJR7Fx3Rz-HWeWH5n0ByKg@mail.gmail.com>
 <20111218113237.GA1359@localhost>
 <20120105015609.GA7913@localhost>
 <CAGBYx2ZyiKrbsQmiC3YxB7sKjhEQVeznUM2cGrXMyQuXPZ5o1Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:33127 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751467Ab2AECZ2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 4 Jan 2012 21:25:28 -0500
Content-Disposition: inline
In-Reply-To: <CAGBYx2ZyiKrbsQmiC3YxB7sKjhEQVeznUM2cGrXMyQuXPZ5o1Q@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jan 05, 2012 at 10:23:13AM +0800, Yongqiang Yang wrote:
> Hi Fengguang,
>=20
> > [ =C2=A0646.051405] =C2=A0ffff880004ee1978 0000000000000000 0000000=
000000170 0000000000000000
> > [ =C2=A0646.051405] Call Trace:
> > [ =C2=A0646.051405] =C2=A0[<ffffffff81099aa3>] ? sched_clock_local+=
0x12/0x75
> > [ =C2=A0646.051405] =C2=A0[<ffffffff810a5a16>] lock_acquire+0xdd/0x=
10a
> > [ =C2=A0646.051405] =C2=A0[<ffffffff81175de4>] ? create_empty_buffe=
rs+0x4a/0xc1
> > [ =C2=A0646.051405] =C2=A0[<ffffffff8199f623>] _raw_spin_lock+0x36/=
0x69
> > [ =C2=A0646.051405] =C2=A0[<ffffffff81175de4>] ? create_empty_buffe=
rs+0x4a/0xc1
> > [ =C2=A0646.051405] =C2=A0[<ffffffff81175de4>] create_empty_buffers=
+0x4a/0xc1
> > [ =C2=A0646.051405] =C2=A0[<ffffffff811efd2f>] ext4_discard_partial=
_page_buffers_no_lock+0x9f/0x406
> > [ =C2=A0646.051405] =C2=A0[<ffffffff8199ffeb>] ? _raw_spin_unlock+0=
x2b/0x2f
> > [ =C2=A0646.051405] =C2=A0[<ffffffff81170c26>] ? __mark_inode_dirty=
+0x1ac/0x1cc
> > [ =C2=A0646.051405] =C2=A0[<ffffffff811767f3>] ? generic_write_end+=
0x6d/0x7f
> > [ =C2=A0646.051405] =C2=A0[<ffffffff811f15e5>] ext4_da_write_end+0x=
244/0x2ed
> > [ =C2=A0646.051405] =C2=A0[<ffffffff810ffeec>] generic_file_buffere=
d_write+0x183/0x22d
> It seems that you are running in to several problems related to
> discard_page_buffers_no_lock in write_end.  The problems had been
> fixed by following patches [ext4: avoid potential hang in
> mpage_submit_io() when blocksize < pagesize], [ext4: correctly handle
> pages w/o buffers in ext4_discard_partial_buffers()] and [ext4: handl=
e
> EOF correctly in ext4_bio_write_page()].   The patches had been merge=
d
> to rc6.

That's great! I'll test rc7+.

Thanks,
=46engguang
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
