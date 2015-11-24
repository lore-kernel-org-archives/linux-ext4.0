From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext4: fix race aio-dio vs freeze_fs
Date: Tue, 24 Nov 2015 14:31:46 +0100
Message-ID: <20151124133146.GH25232@quack.suse.cz>
References: <1448294568-20892-1-git-send-email-dmonakhov@openvz.org>
 <87a8q4k6xn.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, jack@suse.cz, tytso@mit.edu
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57246 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753480AbbKXNbt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 24 Nov 2015 08:31:49 -0500
Content-Disposition: inline
In-Reply-To: <87a8q4k6xn.fsf@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 23-11-15 19:37:56, Dmitry Monakhov wrote:
> Dmitry Monakhov <dmonakhov@openvz.org> writes:
> 
> > After freeze_fs was revoked (from Jan Kara) pages's write-back completion
> > is deffered before unwritten conversion, so explicit flush_unwritten_io()
> > was removed here: c724585b62411
> > But we still may face deferred conversion for aio-dio case
> > # Trivial testcase
> > for ((i=0;i<60;i++));do fsfreeze -f /mnt ;sleep 1;fsfreeze -u /mnt;done &
> > fio --bs=4k --ioengine=libaio --iodepth=128 --size=1g --direct=1 \
> >     --runtime=60 --filename=/mnt/file --name=rand-write --rw=randwrite
> > NOTE: Sane testcase should be integrated to xfstests, but it requires
> > changes in common/* code, so let's use this this test at the moment.
> >
> > In order to fix this race we have to guard journal transaction with explicit
> > sb_{start,end}_intwrite()  as we do with ext4_evict_inode here:8e8ad8a5
> Fairly to say I'm not very happy with the fix because it continues bad
> practice of ad-hock fixes for generic journal vs freeze synchronization
> 
> Ideal fix would be to move sb_start_intwrite/sb_end_intwrite() to
> ext4_journal_start()/ext4_journal_stop() but this is not possible due to
> limitations introduced by nojournal mode (described here:8e8ad8a5)
> So let's fix nojournal instead. In order to do that we somehow have
> store ref_count and pointer to sb inside nojournal_handle.
> There are two possible ways to do that.
> 1) Embed second journal related field to task_struct and guard it with
>    compile macros definition.
> void *journal_info;
> + #ifdef CONFIG_EXTRA_JOURNAL_INFO
> +   void *journal_info2;
> + #endif
> 
> 2) Encode ref and sb in to single long. This can be done by aligning
>    ext4_sb_info pointer to 4096. So we can embed ref count to lower bits
>    like follows.
> #define EXT4_NOJOURNAL_SHIFT 12
> #define EXT4_NOJOURNAL_MAX_REF_COUNT 1 << (EXT4_NOJOURNAL_SHIFT-1)
> #define EXT4_NOJOURNAL_MASK  (1 << EXT4_NOJOURNAL_SHIFT) -1
> #define NOJOURNAL_SB(handle) (handle & ~EXT4_NOJOURNAL_MASK)
> #define NOJOURNAL_REF(handle) ((handle & ~EXT4_NOJOURNAL_MASK) >> 1)
> static int ext4_handle_valid(handle_t *handle)
> {
>         return !(handle & 0x1);
> }
> static handle_t *get_nojournal_handle(struct super_block *sb)
> {
>         handle_t *handle = current->journal_info;
>         struct super_block *old_sb  = NOJOURNAL_SB(handle);
>         unsigned long ref_cnt = NOJOURNAL_REF(handle);
>         BUG_ON(old_sb && old_sb != sb);
>         ref++;
>         current->journal_info = NOJOURNAL_SB(handle);
> }
> 
> What do you think about this? Are where any better way to fix this?

Well, we do have:

WARN_ON(sb->s_writers.frozen == SB_FREEZE_COMPLETE);

in ext4_journal_check_start() so we should get a warning for each
unexpected transaction started on frozen filesystem. The idea really is
there should be no write activity happening on frozen fs and the few cases
like MMP are handled by explicit sb_start_intwrite() calls. I'd prefer to
keep those cases special and don't add general freeze protection in
transaction handling code since that may only result in deadlocks instead
of the warning when starting transaction in unexpectected places...

								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
