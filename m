From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: Re: EXT4 panic at jbd2_journal_put_journal_head() in 3.9+
Date: Mon, 13 May 2013 16:43:42 +0800
Message-ID: <20130513084342.GA7809@gmail.com>
References: <6719519.5821368147110937.JavaMail.weblogic@epml17>
 <CA+8MBbKHJgnueAurRV1aeeV-NdzRTz_gVwYcJuyDrjJLErtcfg@mail.gmail.com>
 <871u9e6ji1.fsf@openvz.org>
 <CA+8MBbLY1jQCQmBrKdVpihkqFBf93iJKZ7J8E_JXcu9NVeff_w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dmitry Monakhov <dmonakhov@openvz.org>, eunb.song@samsung.com,
	Theodore Ts'o <tytso@mit.edu>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: Tony Luck <tony.luck@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-da0-f45.google.com ([209.85.210.45]:55325 "EHLO
	mail-da0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753875Ab3EMIZ7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 13 May 2013 04:25:59 -0400
Content-Disposition: inline
In-Reply-To: <CA+8MBbLY1jQCQmBrKdVpihkqFBf93iJKZ7J8E_JXcu9NVeff_w@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, May 12, 2013 at 07:04:45PM -0700, Tony Luck wrote:
> On Sat, May 11, 2013 at 12:52 AM, Dmitry Monakhov <dmonakhov@openvz.org> wrote:.
> > What was page_size and fsblock size?
> 
> CONFIG_IA64_PAGE_SIZE_64KB=y
> 
> fsblock size is whatever is the default for SLES11SP2 on ia64 - which
> tool will tell me?
> 
> My git bisect finally competed and points the a finger at:
> 
> bisect> git bisect good
> ae4647fb7654676fc44a97e86eb35f9f06b99f66 is first bad commit
> commit ae4647fb7654676fc44a97e86eb35f9f06b99f66
> Author: Jan Kara <jack@suse.cz>
> Date:   Fri Apr 12 00:03:42 2013 -0400
> 
>     jbd2: reduce journal_head size
> 
>     Remove unused t_cow_tid field (ext4 copy-on-write support doesn't seem
>     to be happening) and change b_modified and b_jlist to bitfields thus
>     saving 8 bytes in the structure.
> 
>     Signed-off-by: Jan Kara <jack@suse.cz>
>     Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
>     Reviewed-by: Zheng Liu <wenqing.lz@taobao.com>
> 
> :040000 040000 c39ece4341894b3daf84764ba425a87ffb90fe50
> d4e8d9185c2a1b740c235ca8ed05d496a442fce3 M      include

Hi all,

First of all I couldn't reproduce this regression in my sand box.  So
the following speculation is only my guess.  I suspect that the commit
(ae4647fb) isn't root cause.  It just uncover a potential bug that has
been there for a long time.  I look at the code, and found two
suspicious stuff in jbd2.  The first one is in do_get_write_access().
In this function we forgot to lock bh state when we check b_jlist ==
BJ_Shadow.  I generate a patch to fix it, and I really think it is the
root cause.  Further, in __journal_remove_journal_head() we check
b_jlist == BJ_None.  But, when this function is called, bh state won't
be locked sometimes.  So I suspect this is why we hit a BUG in
jbd2_journal_put_journal_head().  But I don't have a good solution to
fix this until now because I don't know whether we need to lock bh state
here, or maybe we should remove this assertation.

So, generally, Tony, Eunbong, could you please try the following patch?

Thanks in advance,
                                                - Zheng


Subject: [PATCH] jbd2: lock bh state when check b_jlist == BJ_Shadow

From: Zheng Liu <wenqing.lz@taobao.com>

When we try to check b_jlist's value we need to lock bh state.  But in
do_get_write_access when we check b_jlist == BJ_Shadow we won't lock bh
state.  So fix it.

Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 fs/jbd2/transaction.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
index 10f524c..a800513 100644
--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -761,16 +761,18 @@ repeat:
 			wqh = bit_waitqueue(&bh->b_state, BH_Unshadow);
 
 			JBUFFER_TRACE(jh, "on shadow: sleep");
-			jbd_unlock_bh_state(bh);
 			/* commit wakes up all shadow buffers after IO */
-			for ( ; ; ) {
-				prepare_to_wait(wqh, &wait.wait,
-						TASK_UNINTERRUPTIBLE);
+			do {
 				if (jh->b_jlist != BJ_Shadow)
 					break;
+				prepare_to_wait(wqh, &wait.wait,
+						TASK_UNINTERRUPTIBLE);
+				jbd_unlock_bh_state(bh);
 				schedule();
-			}
-			finish_wait(wqh, &wait.wait);
+				finish_wait(wqh, &wait.wait);
+				jbd_lock_bh_state(bh);
+			} while (1);
+			jbd_unlock_bh_state(bh);
 			goto repeat;
 		}
 
-- 
1.7.12.rc2.18.g61b472e

