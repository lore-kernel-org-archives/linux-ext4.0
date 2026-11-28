Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=113.46.200.224
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795837761;
	b=s5OjLdBnM2eNyDmY4oEvuy/EheO2hKo8zEb4sMykBD/L3cA516zvGmiYUql9V7L7oUns
	 niZHpic/0ti6QFTPVJ8c7cfjUdO+C3g5hhiJSRi05Wr4qO6Hz7lUI03qF9Fd+Kn+lNweS
	 demKUkl+JMMpDDHbtQWkb/JkZyiAh79EPoDh40vF3F4FMCJpUoGHN89g6qpFm+fEm5fos
	 ILo1oHq/70I9Ym1gvJaBFo6H/t8khKPs3f5pRsIls59hA3dqUtsD2Fcq/pUzKAioi8lnb
	 T+k8PNCR+cTuU8hUCzpTfUKr37ScCoWCGDTixLomnSGeoE2BZrPlZLD/ChkKTuVyahQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795837761;
	h=DMARC-Filter:dkim-signature:Received:Received:Received:Subject:To:
	 References:CC:From:Message-ID:Date:User-Agent:MIME-Version:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding:X-Originating-IP:
	 X-ClientProxiedBy;
	bh=dllRbTMVq6Yk7nxAQmnso9xqaA/qesTKd7XYM2DO9YY=;
	b=rafFzNPIMj+X5eV4kizkYKlo0YwSFtwtF0CvQMQZPFeMHp5Pe7ipLfB0mktARDtCr1HJ
	 mE7wf89TVisHEk5/VA1pp3OSPPAD5shcZnbmEKONx2uJ2ZocwAwIcqRf3nn3fEjYVUAkx
	 FaVRUW/Vn0ML4f8jgOeFX2tpCKLLxmUuOWXiIh8an3Em1Ts1nVL18v07xG5E6pBFldRmQ
	 Q0fdb8luG7NYJvtsA5ffYE5o06YgmKO8AgYGJaxSUFJMS4dounRSb6II6pNHJn5AZ0edM
	 5PYSPULpWkkcoMtHSPm6MP/x9iwPcDEIExvNPOynWrIKPOztZFVM+zUgFGxZiiJyZlA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=huawei.com;
	spf=pass smtp.mailfrom=huawei.com;
	dkim=pass header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=kWExh6R0;
	arc=none smtp.remote-ip=113.46.200.224
Received: from canpmsgout09.his.huawei.com (canpmsgout09.his.huawei.com [113.46.200.224])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2775D606A31C
	for <linux-ext4@vger.kernel.org>; Sat, 28 Nov 2026 03:49:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2775D606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=kWExh6R0
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=dllRbTMVq6Yk7nxAQmnso9xqaA/qesTKd7XYM2DO9YY=;
	b=kWExh6R0u/FsJtzvmkxtlH7oQGO5/EtYccguDAAm/64oUi84v9rkrx1uOz4+83LIudpWtcQuU
	NJXwF82XvPSsgprI31tGjra0fO60fL1aeq0ztI12HfAI61VHgwzzFcaIhBXo1EUFM4m7Z5zad7K
	lJqxnbGS6vfMC778uHKO5cI=
Received: from mail.maildlp.com (unknown [172.19.162.92])
	by canpmsgout09.his.huawei.com (SkyGuard) with ESMTPS id 4jbx8k3vtHz1cyQl;
	Sat, 28 Nov 2026 11:48:38 +0800 (CST)
Received: from kwepemk300010.china.huawei.com (unknown [7.202.195.128])
	by mail.maildlp.com (Postfix) with ESMTPS id 75CAD40565;
	Sat, 28 Nov 2026 11:49:04 +0800 (CST)
Received: from [10.174.178.185] (10.174.178.185) by
 kwepemk300010.china.huawei.com (7.202.195.128) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Sat, 28 Nov 2026 11:49:03 +0800
Subject: Re: [PATCH v3 2/2] ext4: protect ext4_acquire_dquot against freezing
To: Jan Kara <jack@suse.cz>, <linux-ext4@vger.kernel.org>
References: <20261126123611.2517017-1-yebin@huaweicloud.com>
 <20261126123611.2517017-3-yebin@huaweicloud.com>
 <sashiko-outbox-235531@kernel.org>
CC: <tytso@mit.edu>
From: "yebin (H)" <yebin10@huawei.com>
Message-ID: <6B0A4F2F.60203@huawei.com>
Date: Sat, 28 Nov 2026 11:49:03 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:38.0) Gecko/20100101
 Thunderbird/38.1.0
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
In-Reply-To: <sashiko-outbox-235531@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemk300010.china.huawei.com (7.202.195.128)



On 2026/11/26 20:50, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential
> issue to consider:
> - [High] ext4: s_umount vs SB_FREEZE_FS deadlock in ext4_acquire_dquot()
>    via vfs_ustat()
> --
>
> commit 5d68ea2752fdd861a0ff07e25a26ec6f31917f7a
> Author: Ye Bin <yebin10@huawei.com>
>
> ext4: protect ext4_acquire_dquot against freezing
>
> This commit takes sb_start_intwrite() in ext4_acquire_dquot() when no
> transaction is running so that quota acquisition during file open does not
> start a transaction on a frozen filesystem.
>
>> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
>> index 880f664d6c04b..af965cab32e7f 100644
>> --- a/fs/ext4/super.c
>> +++ b/fs/ext4/super.c
>> @@ -7168,11 +7168,25 @@ static int ext4_acquire_dquot(struct dquot *dquot)
>>   {
>>   	int ret, err;
>>   	handle_t *handle;
>> +	bool freeze_protected = false;
>> +
>> +	/*
>> +	 * Trying to sb_start_intwrite() in a running transaction
>> +	 * can result in a deadlock. Further, running transactions
>> +	 * are already protected from freezing.
>> +	 */
>> +	if (!ext4_journal_current_handle()) {
>> +		sb_start_intwrite(dquot->dq_sb);
>> +		freeze_protected = true;
>> +	}
>
> [Severity: High]
> Can this cause an ABBA deadlock between sb->s_umount and SB_FREEZE_FS when
> ustat(2) runs on a frozen filesystem?
>
> Commit "quota: Forbid Q_XGETQUOTA and Q_XGETNEXTQUOTA for frozen filesystem"
> blocks quotactl from reaching ext4_acquire_dquot() on a frozen superblock,
> but vfs_ustat() also acquires s_umount for reading via user_get_super()
> without checking whether the filesystem is frozen:
>
> fs/statfs.c:vfs_ustat() {
> 	struct super_block *s = user_get_super(dev, false);
> 	int err;
> 	if (!s)
> 		return -EINVAL;
>
> 	err = statfs_by_dentry(s->s_root, sbuf);
> 	drop_super(s);
> 	return err;
> }
>
> When project quota limits are enabled and the root directory inode has
> EXT4_INODE_PROJINHERIT set, ext4_statfs() calls ext4_statfs_project() ->
> dqget().  Because the root inode is a directory, its project dquot is not
> kept attached in i_dquot[PRJQUOTA], so if no other inode holds an active
> reference to that project dquot when the filesystem is frozen, dqget()
> invokes ext4_acquire_dquot() with no running transaction:
>
> CPU0                              CPU1
> ----                              ----
>                                    freeze_super()
>                                      /* freezes at SB_FREEZE_COMPLETE */
> vfs_ustat()
>    user_get_super()
>      down_read(&sb->s_umount)
>    ...
>    ext4_acquire_dquot()
>      sb_start_intwrite(sb)
>                                    thaw_super()
>                                      super_lock_excl(sb)
>                                        down_write(&sb->s_umount)
>
>   *** DEADLOCK ***
>
> CPU0: vfs_ustat() -> statfs_by_dentry() -> ext4_statfs() ->
>        ext4_statfs_project() -> dqget() -> ext4_acquire_dquot()
> CPU1: thaw_super() -> super_lock_excl()
>
> CPU0 blocks in sb_start_intwrite() waiting for SB_FREEZE_FS while holding
> s_umount for reading, and thaw_super() cannot unlock SB_FREEZE_FS until it
> acquires s_umount exclusively, leaving the filesystem permanently frozen.
>
This path indeed also has the ABBA deadlock issue.

(1) Could it be simply addressed by adding a check within the ext4 file system:
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index b021cbeb5f3a..c1d6fec2481a 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -7132,8 +7132,16 @@ static int ext4_statfs(struct dentry *dentry, struct kstatfs *buf)
         buf->f_fsid = uuid_to_fsid(es->s_uuid);

  #ifdef CONFIG_QUOTA
+       /*
+        * Instantiating a not-yet-cached project dquot takes freeze
+        * protection in ext4_acquire_dquot().  statfs can be called with
+        * s_umount held (ustat(2)), so doing that on a frozen filesystem
+        * would deadlock with thaw_super().  Skip the project limits while
+        * frozen instead; statfs must not write at that point anyway.
+        */
         if (ext4_test_inode_flag(dentry->d_inode, EXT4_INODE_PROJINHERIT) &&
-           sb_has_quota_limits_enabled(sb, PRJQUOTA))
+           sb_has_quota_limits_enabled(sb, PRJQUOTA) &&
+           READ_ONCE(sb->s_writers.frozen) == SB_UNFROZEN)
                 ext4_statfs_project(sb, EXT4_I(dentry->d_inode)->i_projid, buf);
  #endif
         return 0;

However, what's strange about this approach is that it cannot obtain PRJQUOTA
data when in a frozen state.If modifications are made to the VFS layer, it could
affect the behavior of other file systems. It seems unreasonable to just block
the query operation.In addition, this will also change the behavior of other
system calls of the ext4 file system.The process of calling ext4_statfs() does
not always hold the sb->s_umount lock. It seems difficult to wait for the file
system to unfreeze.

(2) Another solution is to obtain only cached data during the freezing process.
In other cases, data is obtained normally.
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index b021cbeb5f3a..84d9942b7e2b 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -7063,7 +7063,20 @@ static int ext4_statfs_project(struct super_block *sb,
         u64 curblock;

         qid = make_kqid_projid(projid);
-       dquot = dqget(sb, qid);
+       /*
+        * A frozen filesystem must not be written to.  Instantiating a dquot
+        * that is not cached yet would start a transaction, and statfs may run
+        * with s_umount held (ustat(2)), where taking freeze protection in
+        * ext4_acquire_dquot() would deadlock with thaw_super().  In that case
+        * only use an already cached dquot and skip the project limits if there
+        * is none.
+        */
+       if (READ_ONCE(sb->s_writers.frozen) != SB_UNFROZEN)
+               dquot = dqget_cached(sb, qid);
+       else
+               dquot = dqget(sb, qid);
+       if (!dquot)
+               return 0;
         if (IS_ERR(dquot))
                 return PTR_ERR(dquot);
         spin_lock(&dquot->dq_dqb_lock);
(3) The ustat system call transfers the dentry of the root. Can the root's quota
be resident in each path, and the root be specially processed in ext4_statfs().

Hello Jan, do you have any good suggestions or better solutions for fixing this issue?

According to the check, syncfs can be triggered when the file system is frozen.In this
case, the following two processes may cause deadlocks.
ext4_sync_fs()->dquot_writeback_dquots()->flush_delayed_work(&quota_release_work) // hold sb->s_umount lock
quota_release_workfn()->ext4_release_dquot()->sb_start_intwrite()  // wait unfreeze

ext4_evict_inode()->if (inode->i_nlink) goto no_delete;->ext4_clear_inode()->dquot_drop(inode)
...->dqput()->queue_delayed_work(quota_unbound_wq, &quota_release_work, 1);

In ext4_sync_fs(), it is more reasonable to call dquot_writeback_dquots() only when
(sb->s_writers.frozen!= SB_FREEZE_COMPLETE)?





