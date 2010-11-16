From: Markus Trippelsdorf <markus@trippelsdorf.de>
Subject: [PATCH] ext4 Fix setting random pages PageUptodate
Date: Tue, 16 Nov 2010 12:13:39 +0100
Message-ID: <20101116111339.GA1544@arch.trippelsdorf.de>
References: <20101110152519.GA1626@arch.trippelsdorf.de>
 <20101110154057.GA2191@arch.trippelsdorf.de>
 <alpine.DEB.2.00.1011101534370.30164@router.home>
 <20101112122003.GA1572@arch.trippelsdorf.de>
 <20101115123846.GA30047@arch.trippelsdorf.de>
 <20101115195439.GA1569@arch.trippelsdorf.de>
 <AANLkTikWaADzUrqKhZ9gviW8sk8mPjC9kKFJyitvzQmx@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Christoph Lameter <cl@linux.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
	linux-ext4@vger.kernel.org
To: Hugh Dickins <hughd@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out-143.synserver.de ([212.40.180.143]:1083 "HELO
	smtp-out-142.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with SMTP id S1755965Ab0KPLNn (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 16 Nov 2010 06:13:43 -0500
Content-Disposition: inline
In-Reply-To: <AANLkTikWaADzUrqKhZ9gviW8sk8mPjC9kKFJyitvzQmx@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2010.11.15 at 13:23 -0800, Hugh Dickins wrote:
> On Mon, Nov 15, 2010 at 11:54 AM, Markus Trippelsdorf
> <markus@trippelsdorf.de> wrote:
> > On 2010.11.15 at 13:38 +0100, Markus Trippelsdorf wrote:
> >> On 2010.11.12 at 13:20 +0100, Markus Trippelsdorf wrote:
> >> >
> >> > Yes. Fortunately the BUG is gone since I pulled the upcoming drm=
 fixes
> >>
> >> No. I happend again today (with those fixes already applied):
> >>
> >> BUG: Bad page state in process knode =A0pfn:7f0a8
> >> page:ffffea0001bca4c0 count:0 mapcount:0 mapping: =A0 =A0 =A0 =A0 =
=A0(null) index:0x0
> >> page flags: 0x4000000000000008(uptodate)
> >> Pid: 18310, comm: knode Not tainted 2.6.37-rc1-00549-gae712bf-dirt=
y #16
> >> Call Trace:
> >> =A0[<ffffffff810a9022>] ? bad_page+0x92/0xe0
> >> =A0[<ffffffff810aa240>] ? get_page_from_freelist+0x4b0/0x570
> >> =A0[<ffffffff8102e50e>] ? apic_timer_interrupt+0xe/0x20
> >> =A0[<ffffffff810aa413>] ? __alloc_pages_nodemask+0x113/0x6b0
> >> =A0[<ffffffff810a2dd4>] ? file_read_actor+0xc4/0x190
> >> =A0[<ffffffff810a4a70>] ? generic_file_aio_read+0x560/0x6b0
> >> =A0[<ffffffff810bdf8d>] ? handle_mm_fault+0x6bd/0x970
> >> =A0[<ffffffff8104b1d0>] ? do_page_fault+0x120/0x410
> >> =A0[<ffffffff810c3d85>] ? do_brk+0x275/0x360
> >> =A0[<ffffffff81452d8f>] ? page_fault+0x1f/0x30
> >> Disabling lock debugging due to kernel taint
> >
> > And another one. But this time it seems to point to ext4:
> >
> > BUG: Bad page state in process rm =A0pfn:52e54
> > page:ffffea0001222260 count:0 mapcount:0 mapping: =A0 =A0 =A0 =A0 =A0=
(null) index:0x0
> > page flags: 0x4000000000000008(uptodate)
> > Pid: 2084, comm: rm Not tainted 2.6.37-rc1-00549-gae712bf-dirty #23
> > Call Trace:
> > =A0[<ffffffff810a9022>] ? bad_page+0x92/0xe0
> > =A0[<ffffffff810aa240>] ? get_page_from_freelist+0x4b0/0x570
> > =A0[<ffffffff81142ae6>] ? ext4_ext_put_in_cache+0x46/0x90
> > =A0[<ffffffff810aa413>] ? __alloc_pages_nodemask+0x113/0x6b0
> > =A0[<ffffffff8118f0c7>] ? number.clone.2+0x2b7/0x2f0
> > =A0[<ffffffff810a38d5>] ? find_get_page+0x75/0xb0
> > =A0[<ffffffff810a4011>] ? find_or_create_page+0x51/0xb0
> > =A0[<ffffffff810ff4d7>] ? __getblk+0xd7/0x260
> > =A0[<ffffffff8113158f>] ? ext4_getblk+0x8f/0x1e0
> > =A0[<ffffffff811316ed>] ? ext4_bread+0xd/0x70
> > =A0[<ffffffff811369f4>] ? htree_dirblock_to_tree+0x34/0x190
> > =A0[<ffffffff8113870f>] ? ext4_htree_fill_tree+0x9f/0x250
> > =A0[<ffffffff810e109d>] ? do_filp_open+0x12d/0x5e0
> > =A0[<ffffffff811289ed>] ? ext4_readdir+0x14d/0x5a0
> > =A0[<ffffffff810e4e80>] ? filldir+0x0/0xd0
> > =A0[<ffffffff810e50a8>] ? vfs_readdir+0xa8/0xd0
> > =A0[<ffffffff810e4e80>] ? filldir+0x0/0xd0
> > =A0[<ffffffff810e51b1>] ? sys_getdents+0x81/0xf0
> > =A0[<ffffffff8102dc2b>] ? system_call_fastpath+0x16/0x1b
> > Disabling lock debugging due to kernel taint
> >
> > I don't know. Could a possible bug in linux/fs/ext4/page-io.c be
> > responsible for something like this?
>=20
> I do think you're right: every one of your "Bad page state" reports
> has been complaining only about the PageUptodate bit being set, and
> that SetPageUpdate() in ext4_end_bio() does look suspicious, coming
> after the put_page().
>=20
> The more suspicious given that other races have been noticed in
> precisely that area, and fixed with put_io_page() in the current git
> tree.
>=20
> Perhaps that fixes your problem, but my guess would be not: I suspect
> the "if (!partial_write) SetPageUpdate(page);" should be done before
> the block (or put_io_page) which does the put_page().

ext4_end_bio calls put_page and kmem_cache_free before calling
SetPageUpdate(). This can result in setting the PageUptodate bit on
random pages and causes the following BUG:

 BUG: Bad page state in process rm  pfn:52e54
 page:ffffea0001222260 count:0 mapcount:0 mapping:          (null) inde=
x:0x0
 arch kernel: page flags: 0x4000000000000008(uptodate)

=46ix the problem by moving put_io_page() after the SetPageUpdate() cal=
l.

Thanks to Hugh Dickins for analyzing this problem.

Reported-and-tested-by: Markus Trippelsdorf <markus@trippelsdorf.de>
Signed-off-by: Markus Trippelsdorf <markus@trippelsdorf.de>

---
 fs/ext4/page-io.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
index 7f5451c..beacce1 100644
--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -237,8 +237,6 @@ static void ext4_end_bio(struct bio *bio, int error=
)
 			} while (bh !=3D head);
 		}
=20
-		put_io_page(io_end->pages[i]);
