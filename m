From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] fs/jbd2: fix data races in jbd2_journal_set_features
Date: Tue, 22 Sep 2015 12:07:00 +0200
Message-ID: <20150922100700.GH9028@quack.suse.cz>
References: <1442833039-55373-1-git-send-email-dvyukov@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, jack@suse.com, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, kcc@google.com, glider@google.com,
	andreyknvl@google.com, ktsan@googlegroups.com,
	paulmck@linux.vnet.ibm.com
To: Dmitry Vyukov <dvyukov@google.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1442833039-55373-1-git-send-email-dvyukov@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

  Hello,

On Mon 21-09-15 12:57:19, Dmitry Vyukov wrote:
> jbd2_journal_set_features() uses complex logic to update
> various feature flags while they are being concurrently read.
> This gives compiler whole lot of possibilities to temporary
> set features to unexpected values and break readers.
> For example, compiler can speculatively set or reset some flag
> and then restore the old value if assumptions does not hold.
> 
> Use WRITE_ONCE() to update feature flags in jbd2_journal_set_features().
> 
> The data race was found with KernelThreadSanitizer (KTSAN).

OK, I agree that there's a potential problem when jbd2_journal_revoke()
sets INCOMPAT_REVOKE feature. But I don't like your fix. I agree it fixes
the immediate problem with INCOMPAT_REVOKE handling (since it is the only
feature that gets set while journal is used) but if we allow
modifying journal features while the journal is used, read-modify-write
cycle in jbd2_journal_set_features() can cause issues and lose
modifications.

So first we have to decide whether we actually want to allow modifications
of journal features while the journal is used. We could quite easily set /
clear INCOMPAT_REVOKE feature when mounting the filesystem and thus avoid
modifying journal features while journal is used. Anyone has opinion?

And if we decide it should be possible to call jbd2_journal_set_features()
while journal is used, we have to use atomic operations to modify journal
feature fields (or spinlock).

								Honza
> 
> Signed-off-by: Dmitry Vyukov <dvyukov@google.com>
> ---
> For the record here is KTSAN report on 4.2 rc2:
> 
> ThreadSanitizer: data-race in journal_tag_bytes
> 
> Read at 0xffff8800bba31028 of size 4 by thread 961 on CPU 6:
>  [<ffffffff813c9982>] journal_tag_bytes+0x42/0x90 fs/jbd2/journal.c:2191 (discriminator 1)
>  [<ffffffff813ba682>] jbd2_journal_commit_transaction+0x42/0x3190 fs/jbd2/commit.c:390
>  [<ffffffff813c698b>] kjournald2+0x13b/0x430 fs/jbd2/journal.c:223
>  [<ffffffff810bba40>] kthread+0x150/0x170 kernel/kthread.c:209
>  [<ffffffff81ee420f>] ret_from_fork+0x3f/0x70 arch/x86/entry/entry_64.S:529
> 
> Previous write at 0xffff8800bba31028 of size 4 by thread 2865 on CPU 2:
>  [<ffffffff813c7406>] jbd2_journal_set_features+0x166/0x370 fs/jbd2/journal.c:1872
>  [<ffffffff813c106b>] jbd2_journal_revoke+0x4b/0x1b0 fs/jbd2/revoke.c:337
>  [<ffffffff8138e2fe>] __ext4_forget+0x13e/0x240 fs/ext4/ext4_jbd2.c:228
>  [<ffffffff8139d778>] ext4_free_blocks+0x168/0x10f0 fs/ext4/mballoc.c:4698
>  [<ffffffff81381a01>] ext4_ext_rm_idx+0x1e1/0x340 fs/ext4/extents.c:2385
>  [<     inline     >] ext4_ext_rm_leaf fs/ext4/extents.c:2771
>  [<ffffffff81387844>] ext4_ext_remove_space+0x1604/0x1ad0 fs/ext4/extents.c:2932
>  [<ffffffff8138b07f>] ext4_ext_truncate+0xcf/0x150 fs/ext4/extents.c:4656
>  [<ffffffff81341bdf>] ext4_truncate+0x64f/0x690 fs/ext4/inode.c:3767
>  [<ffffffff81342bff>] ext4_evict_inode+0x63f/0x6f0 fs/ext4/inode.c:261
>  [<ffffffff8128d2e0>] evict+0x180/0x2c0 fs/inode.c:544
>  [<     inline     >] iput_final fs/inode.c:1465
>  [<ffffffff8128e6b4>] iput+0x274/0x3c0 fs/inode.c:1492
>  [<ffffffff8127b1a6>] do_unlinkat+0x2b6/0x4a0 fs/namei.c:3864
>  [<     inline     >] SYSC_unlink fs/namei.c:3905
>  [<ffffffff8127c172>] SyS_unlink+0x22/0x40 fs/namei.c:3903
>  [<ffffffff81ee3e11>] entry_SYSCALL_64_fastpath+0x31/0x95 arch/x86/entry/entry_64.S:188
> 
> Mutexes locked by thread 2865:
> Mutex 469497 is locked here:
>  [<ffffffff81ee0d45>] down_write+0x65/0x80 kernel/locking/rwsem.c:62
>  [<ffffffff81341b09>] ext4_truncate+0x579/0x690 fs/ext4/inode.c:3762
>  [<ffffffff81342bff>] ext4_evict_inode+0x63f/0x6f0 fs/ext4/inode.c:261
>  [<ffffffff8128d2e0>] evict+0x180/0x2c0 fs/inode.c:544
>  [<     inline     >] iput_final fs/inode.c:1465
>  [<ffffffff8128e6b4>] iput+0x274/0x3c0 fs/inode.c:1492
>  [<ffffffff8127b1a6>] do_unlinkat+0x2b6/0x4a0 fs/namei.c:3864
>  [<     inline     >] SYSC_unlink fs/namei.c:3905
>  [<ffffffff8127c172>] SyS_unlink+0x22/0x40 fs/namei.c:3903
>  [<ffffffff81ee3e11>] entry_SYSCALL_64_fastpath+0x31/0x95 arch/x86/entry/entry_64.S:188
> ---
>  fs/jbd2/journal.c | 19 +++++++++++--------
>  1 file changed, 11 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
> index 8270fe9..cfc5127 100644
> --- a/fs/jbd2/journal.c
> +++ b/fs/jbd2/journal.c
> @@ -1849,8 +1849,8 @@ int jbd2_journal_set_features (journal_t *journal, unsigned long compat,
>  	/* If enabling v3 checksums, update superblock */
>  	if (INCOMPAT_FEATURE_ON(JBD2_FEATURE_INCOMPAT_CSUM_V3)) {
>  		sb->s_checksum_type = JBD2_CRC32C_CHKSUM;
> -		sb->s_feature_compat &=
> -			~cpu_to_be32(JBD2_FEATURE_COMPAT_CHECKSUM);
> +		WRITE_ONCE(sb->s_feature_compat, sb->s_feature_compat &
> +			~cpu_to_be32(JBD2_FEATURE_COMPAT_CHECKSUM));
>  
>  		/* Load the checksum driver */
>  		if (journal->j_chksum_driver == NULL) {
> @@ -1872,13 +1872,16 @@ int jbd2_journal_set_features (journal_t *journal, unsigned long compat,
>  
>  	/* If enabling v1 checksums, downgrade superblock */
>  	if (COMPAT_FEATURE_ON(JBD2_FEATURE_COMPAT_CHECKSUM))
> -		sb->s_feature_incompat &=
> +		WRITE_ONCE(sb->s_feature_incompat, sb->s_feature_incompat &
>  			~cpu_to_be32(JBD2_FEATURE_INCOMPAT_CSUM_V2 |
> -				     JBD2_FEATURE_INCOMPAT_CSUM_V3);
> -
> -	sb->s_feature_compat    |= cpu_to_be32(compat);
> -	sb->s_feature_ro_compat |= cpu_to_be32(ro);
> -	sb->s_feature_incompat  |= cpu_to_be32(incompat);
> +				     JBD2_FEATURE_INCOMPAT_CSUM_V3));
> +
> +	WRITE_ONCE(sb->s_feature_compat,
> +		sb->s_feature_compat | cpu_to_be32(compat));
> +	WRITE_ONCE(sb->s_feature_ro_compat,
> +		sb->s_feature_ro_compat | cpu_to_be32(ro));
> +	WRITE_ONCE(sb->s_feature_incompat,
> +		sb->s_feature_incompat | cpu_to_be32(incompat));
>  
>  	return 1;
>  #undef COMPAT_FEATURE_ON
> -- 
> 2.6.0.rc0.131.gf624c3d
> 
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
