Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 892883128B8
	for <linux-ext4@vger.kernel.org>; Wed, 18 Mar 2026 05:04:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773810255; cv=none; b=XYNSGQV6ikAIcHMT/YsPmKGmKsPZ8CjjAd0EKilrgFwGZIworql6Jh2XRjURcdveOLbUe8tt024QYCE+L0kdnc+ar9SkgbVNwRBaNsTm4uEW//cnH2xdTu88/Pil9eDRvcHsZUmooqRsV0SNuA+2JUIZIiEIARTe1NmDCJVFhHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773810255; c=relaxed/simple;
	bh=bOy+37rT6bb3EF5UYuiTAPk9D/QEKHV9u4Pox0N0hWY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KJMSuCAzRwyGjzwNCkVQ8K6xiSIoTmYrtJc2mffaA/I/hos0VGCYzP+KvmPt+iAgRigRzLLlYIb7HzRCUuUcu2e7nLnoCMjbG0IFTmgIrNyrzPs6jVTDu1dUzu3M6ElIXrC7KlqFYfIBVUQhZToTjj0KspzxNlYmLDYre2p8LjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=m73YOIOR; arc=none smtp.client-ip=95.215.58.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="m73YOIOR"
Message-ID: <4a102211-2039-46ac-bc54-81f1c5eda42a@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773810250;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=E9f3OWOAbIKMVnvfOXwCkRyhLWKrOuMmNH+hyMpThmw=;
	b=m73YOIORA/zHzdegYMocIiLgCW/iXIfo7p50lW8FPutfaqqOW+fs/3xk72roh8dP2oek4s
	UC1eO3DbRee9mkcbz8mD+xGz+kZkpbOrAFsimkuUY2KTXkfq85p5mkGVky11Eghjxpv9zP
	MbjhmBtmAkpUGdgxQvEodQBpvuMZzW8=
Date: Wed, 18 Mar 2026 13:04:03 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v1] ext4: fix use-after-free in update_super_work when
 racing with umount
To: Jan Kara <jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
 Andreas Dilger <adilger.kernel@dilger.ca>,
 Ritesh Harjani <riteshh@linux.ibm.com>, Ye Bin <yebin10@huawei.com>,
 linux-kernel@vger.kernel.org
References: <20260313065206.152645-1-jiayuan.chen@linux.dev>
 <jn23562fj73siqgtlzqknce34eqiazitghu55pyvczustuey32@zhx3wpu5eciy>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Jiayuan Chen <jiayuan.chen@linux.dev>
In-Reply-To: <jn23562fj73siqgtlzqknce34eqiazitghu55pyvczustuey32@zhx3wpu5eciy>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT


On 3/17/26 7:38 PM, Jan Kara wrote:
> On Fri 13-03-26 14:52:04, Jiayuan Chen wrote:
>> Commit b98535d09179 ("ext4: fix bug_on in start_this_handle during umount filesystem")
>> moved ext4_unregister_sysfs() before flushing s_sb_upd_work to prevent new
>> error work from being queued via /proc/fs/ext4/xx/mb_groups reads during
>> unmount. However, this introduced a use-after-free because
>> update_super_work calls ext4_notify_error_sysfs() -> sysfs_notify() which
>> accesses the kobject's kernfs_node after it has been freed:
>>
>>    update_super_work                ext4_put_super
>>    -----------------                --------------
>>                                     ext4_unregister_sysfs(sb)
>>                                       kobject_del(&sbi->s_kobj)
>>                                         __kobject_del()
>>                                           sysfs_remove_dir()
>>                                             kobj->sd = NULL
>>                                           sysfs_put(sd)
>>                                             kernfs_put()  // RCU free
>>    ext4_notify_error_sysfs(sbi)
>>      sysfs_notify(&sbi->s_kobj)
>>        kn = kobj->sd              // stale pointer
>>        kernfs_get(kn)             // UAF on freed kernfs_node
>>                                     ext4_journal_destroy()
>>                                       flush_work(&sbi->s_sb_upd_work)
>>
>> The original blamed commit needed procfs removal before the work
>> flush to prevent /proc/fs/ext4/xx/mb_groups reads from queuing new error
>> work. But it bundled procfs removal and kobject_del together in
>> ext4_unregister_sysfs(), causing the sysfs kobject to be torn down too
>> early.
>>
>> The correct teardown ordering has three constraints:
>>
>>    1. procfs removal must happen before flushing s_sb_upd_work, to prevent
>>       /proc reads from queuing new error work that would BUG_ON.
>>    2. sysfs kobject removal must happen after flushing s_sb_upd_work, since
>>       the work calls sysfs_notify() which accesses the kernfs_node.
>>    3. sysfs kobject removal must happen before jbd2_journal_destroy(), since
>>       userspace could read the journal_task sysfs attribute and dereference
>>       j_task after the journal thread has been killed.
>>
>> Fix this by:
>>    - Adding ext4_sb_release_proc() to remove procfs entries early.
>>    - Splitting ext4_journal_destroy() into ext4_journal_stop_work() and
>>      ext4_journal_finish(), so that ext4_unregister_sysfs() can be placed
>>      between them to satisfy all three ordering constraints.
>>
>> Fixes: b98535d09179 ("ext4: fix bug_on in start_this_handle during umount filesystem")
>> Cc: Jiayuan Chen <jiayuan.chen@linux.dev>
>> Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>
> Thanks for the analysis and the patch! I fully agree with your analysis but
> I think your solution shows that the teardown sequence is just too subtle
> (too many different dependencies). Ideally, we'd instead modify
> ext4_notify_error_sysfs() to detect sysfs is already torn down by
> ext4_unregister_sysfs() and do nothing. We can check
> sbi->s_kobj.state_in_sysfs for that. The only trouble with this is that
> sysfs_notify() could still race with kobject_del() so we also need some
> locking in ext4_unregister_sysfs() locking out parallel
> ext4_notify_error_sysfs() and we probably need to introduce a separate
> mutex for that. What do you think?
>
> 								Honza
>


Hi Honza,

Thanks for the suggestion !

I tried the approach you described — having ext4_notify_error_sysfs() 
check s_kobj.state_in_sysfs and using a
dedicated mutex to serialize against kobject_del() in
ext4_unregister_sysfs(). It is indeed much simpler than my original
approach of reordering the teardown sequence.

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index b76966dc06c0..c012e85d2515 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1574,6 +1574,7 @@ struct ext4_sb_info {
         struct proc_dir_entry *s_proc;
         struct kobject s_kobj;
         struct completion s_kobj_unregister;
+       struct mutex s_error_notify_mutex; /* protects sysfs_notify vs 
kobject_del */
         struct super_block *s_sb;
         struct buffer_head *s_mmp_bh;

diff --git a/fs/ext4/sysfs.c b/fs/ext4/sysfs.c
index d2ecc1026c0c..f2505988e010 100644
--- a/fs/ext4/sysfs.c
+++ b/fs/ext4/sysfs.c
@@ -597,7 +597,10 @@ static const struct kobj_type ext4_feat_ktype = {

  void ext4_notify_error_sysfs(struct ext4_sb_info *sbi)
  {
-       sysfs_notify(&sbi->s_kobj, NULL, "errors_count");
+       mutex_lock(&sbi->s_error_notify_mutex);
+       if (sbi->s_kobj.state_in_sysfs)
+               sysfs_notify(&sbi->s_kobj, NULL, "errors_count");
+       mutex_unlock(&sbi->s_error_notify_mutex);
  }

  static struct kobject *ext4_root;
@@ -610,6 +613,7 @@ int ext4_register_sysfs(struct super_block *sb)
         int err;

         init_completion(&sbi->s_kobj_unregister);
+       mutex_init(&sbi->s_error_notify_mutex);
         err = kobject_init_and_add(&sbi->s_kobj, &ext4_sb_ktype, ext4_root,
                                    "%s", sb->s_id);
         if (err) {
@@ -644,7 +648,10 @@ void ext4_unregister_sysfs(struct super_block *sb)

         if (sbi->s_proc)
                 remove_proc_subtree(sb->s_id, ext4_proc_root);
+
+       mutex_lock(&sbi->s_error_notify_mutex);
         kobject_del(&sbi->s_kobj);
+       mutex_unlock(&sbi->s_error_notify_mutex);
  }

  int __init ext4_init_sysfs(void)

