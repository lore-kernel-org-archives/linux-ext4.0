From: Namjae Jeon <namjae.jeon@samsung.com>
Subject: RE: memory leak: data=journal and {collapse,insert,zero}_range
Date: Tue, 24 Nov 2015 13:21:17 +0900
Message-ID: <007a01d1266f$903765b0$b0a63110$@samsung.com>
References: <009301d10b2f$b410e6b0$1c32b410$@samsung.com>
 <20151020155443.GM2972@thunk.org>
 <011f01d10be5$099d38d0$1cd7aa70$@samsung.com>
 <20151021145214.GC2165@thunk.org>
 <004301d11aae$72683a40$5738aec0$@samsung.com>
 <20151110144946.GB3156@quack.suse.cz>
 <005901d120f3$1d880410$58980c30$@samsung.com>
 <20151118213651.GI6097@quack.suse.cz> <20151119094240.GB18581@quack.suse.cz>
 <000001d1234c$c37079b0$4a516d10$@samsung.com>
 <20151123135342.GJ23418@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: 'Theodore Ts'o' <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: 'Jan Kara' <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:48395 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751139AbbKXEVY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 23 Nov 2015 23:21:24 -0500
Received: from epcpsbgr1.samsung.com
 (u141.gpu120.samsung.co.kr [203.254.230.141])
 by mailout3.samsung.com (Oracle Communications Messaging Server 7.0.5.31.0
 64bit (built May  5 2014))
 with ESMTP id <0NYA01IW0XFHERC0@mailout3.samsung.com> for
 linux-ext4@vger.kernel.org; Tue, 24 Nov 2015 13:21:17 +0900 (KST)
In-reply-to: <20151123135342.GJ23418@quack.suse.cz>
Content-language: ko
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> 
> On Fri 20-11-15 13:34:36, Namjae Jeon wrote:
> > Actually, I can quickly create memleak with simple testcase like:
> > while(1000)
> > {
> > Random seek(max 500M) -> write 1M -> fsync ->truncate(random size)
> > }
> >
> > As there is significant memleak in this situation also, I started focusing
> > on this simple testcase only. When use this testcase, I never saw EBUSY path
> > in jbd2_journal_invalidatepage() -> journal_unmap_buffer().
> >
> > On the other hand(), for memleak pages jbd2_journal_invalidatepage() ->
> > journal_unmap_buffer() was almost bailing out every time from
> >                 if (!buffer_dirty(bh)) {
> >                         /* bdflush has written it.  We can drop it now */
> >                         goto zap_buffer;
> >                 }
> >
> > As per debugging, NULL mapping page or buffer is created in below scenario:
> > Write(or Kjournald) -> jbd2_journal_commit_transaction
> >                     -> BH_JBDDirty buffer is added to forget list.
> >                     -> Buffer is added to new checkpoint,
> >                        additional reference count is taken on b_jcount which
> >                        keeps buffer busy until remove checkpoint.
> >                     -> Buffer is unfiled, removed from forget list, BH_JBDDirty
> >                        is cleared and BH_Dirty is set, it is exposed to VM.
> 
> Ah, I see! Thanks for the easy reproduction testcase and for the debugging.
> Attached patch fixes the issue (at least the simple truncate case) for me.
> Can you check whether it fixes the issue for you as well? Thanks!
This patch looks good to me! I checked that all leak issues are fixed
with your patch.
Thanks for your help!
> 
> 								Honza
> --
> Jan Kara <jack@suse.com>
> SUSE Labs, CR

