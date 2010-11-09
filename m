From: Jiaying Zhang <jiayingz@google.com>
Subject: Re: [PATCH] ext4: Don't call sb_issue_discard() in ext4_free_blocks()
Date: Tue, 9 Nov 2010 10:01:06 -0800
Message-ID: <AANLkTikRenXHnTqyYBY3mH=-q_Rasa5ZWx68T+cpKMre@mail.gmail.com>
References: <1289196382-31239-1-git-send-email-tytso@mit.edu>
	<4CD97875.6050703@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:55537 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753279Ab0KISBJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 9 Nov 2010 13:01:09 -0500
Received: from kpbe19.cbf.corp.google.com (kpbe19.cbf.corp.google.com [172.25.105.83])
	by smtp-out.google.com with ESMTP id oA9I18fn012066
	for <linux-ext4@vger.kernel.org>; Tue, 9 Nov 2010 10:01:08 -0800
Received: from gwaa20 (gwaa20.prod.google.com [10.200.27.20])
	by kpbe19.cbf.corp.google.com with ESMTP id oA9I0usZ022117
	for <linux-ext4@vger.kernel.org>; Tue, 9 Nov 2010 10:01:07 -0800
Received: by gwaa20 with SMTP id a20so5159589gwa.38
        for <linux-ext4@vger.kernel.org>; Tue, 09 Nov 2010 10:01:06 -0800 (PST)
In-Reply-To: <4CD97875.6050703@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I would like to spend some time to see whether we can add
sb_issue_discard() somewhere else for non-journaled mode.
It is a useful feature to be included for both modes.

Jiaying

On Tue, Nov 9, 2010 at 8:36 AM, Eric Sandeen <sandeen@redhat.com> wrote=
:
>
> On 11/8/10 12:06 AM, Theodore Ts'o wrote:
> > Commit 5c521830cf (ext4: Support discard requests when running in
> > no-journal mode) attempts to add sb_issue_discard() for data blocks
> > (in data=3Dwriteback mode) and in no-journal mode. =A0Unfortunately=
, this
> > no longer works, because in commit dd3932eddf (block: remove
> > BLKDEV_IFL_WAIT), sb_issue_discard() only presents a synchronous
> > interface, and there are times when we call ext4_free_blocks() when=
 we
> > are are holding a spinlock, or are otherwise in an atomic context.
> >
> > For now, I've removed the call to sb_issue_discard() to prevent a
> > deadlock or (if spinlock debugging is enabled) failures like this:
>
> perhaps mount should fail with the combination of -o discard and no
> journal present?
>
> -Eric
>
> > BUG: scheduling while atomic: rc.sysinit/1376/0x00000002
> > Pid: 1376, comm: rc.sysinit Not tainted 2.6.36-ARCH #1
> > Call Trace:
> > [<ffffffff810397ce>] __schedule_bug+0x5e/0x70
> > [<ffffffff81403110>] schedule+0x950/0xa70
> > [<ffffffff81060bad>] ? insert_work+0x7d/0x90
> > [<ffffffff81060fbd>] ? queue_work_on+0x1d/0x30
> > [<ffffffff81061127>] ? queue_work+0x37/0x60
> > [<ffffffff8140377d>] schedule_timeout+0x21d/0x360
> > [<ffffffff812031c3>] ? generic_make_request+0x2c3/0x540
> > [<ffffffff81402680>] wait_for_common+0xc0/0x150
> > [<ffffffff81041490>] ? default_wake_function+0x0/0x10
> > [<ffffffff812034bc>] ? submit_bio+0x7c/0x100
> > [<ffffffff810680a0>] ? wake_bit_function+0x0/0x40
> > [<ffffffff814027b8>] wait_for_completion+0x18/0x20
> > [<ffffffff8120a969>] blkdev_issue_discard+0x1b9/0x210
> > [<ffffffff811ba03e>] ext4_free_blocks+0x68e/0xb60
> > [<ffffffff811b1650>] ? __ext4_handle_dirty_metadata+0x110/0x120
> > [<ffffffff811b098c>] ext4_ext_truncate+0x8cc/0xa70
> > [<ffffffff810d713e>] ? pagevec_lookup+0x1e/0x30
> > [<ffffffff81191618>] ext4_truncate+0x178/0x5d0
> > [<ffffffff810eacbb>] ? unmap_mapping_range+0xab/0x280
> > [<ffffffff810d8976>] vmtruncate+0x56/0x70
> > [<ffffffff811925cb>] ext4_setattr+0x14b/0x460
> > [<ffffffff811319e4>] notify_change+0x194/0x380
> > [<ffffffff81117f80>] do_truncate+0x60/0x90
> > [<ffffffff811e08fa>] ? security_inode_permission+0x1a/0x20
> > [<ffffffff811eaec1>] ? tomoyo_path_truncate+0x11/0x20
> > [<ffffffff81127539>] do_last+0x5d9/0x770
> > [<ffffffff811278bd>] do_filp_open+0x1ed/0x680
> > [<ffffffff8140644f>] ? page_fault+0x1f/0x30
> > [<ffffffff81132bfc>] ? alloc_fd+0xec/0x140
> > [<ffffffff81118db1>] do_sys_open+0x61/0x120
> > [<ffffffff81118e8b>] sys_open+0x1b/0x20
> > [<ffffffff81002e6b>] system_call_fastpath+0x16/0x1b
> >
> > https://bugzilla.kernel.org/show_bug.cgi?id=3D22302
> >
> > Reported-by: Mathias Bur=E9n <mathias.buren@gmail.com>
> > Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> > Cc: jiayingz@google.com
> > ---
> > =A0fs/ext4/mballoc.c | =A0 =A02 --
> > =A01 files changed, 0 insertions(+), 2 deletions(-)
> >
> > diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> > index c58eba3..5b4d4e3 100644
> > --- a/fs/ext4/mballoc.c
> > +++ b/fs/ext4/mballoc.c
> > @@ -4640,8 +4640,6 @@ do_more:
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* with group lock held. generate_bud=
dy look at
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* them with group lock_held
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
> > - =A0 =A0 =A0 =A0 =A0 =A0 if (test_opt(sb, DISCARD))
> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_issue_discard(sb, bl=
ock_group, bit, count);
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_lock_group(sb, block_group);
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 mb_clear_bits(bitmap_bh->b_data, bit, c=
ount);
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 mb_free_blocks(inode, &e4b, bit, count)=
;
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
