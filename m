Received: from cse.ust.hk (cssvr7.cse.ust.hk [143.89.41.157])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEF2C2D97B7;
	Thu, 23 Apr 2026 17:37:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=143.89.41.157
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776965861; cv=fail; b=S22OQnjHtzOtTkkyJZuQFASYXbzoU/J9vqd1zbeXgfrMqoduJ1cZFuWGCy16oG17477om6Xw79htifW92C1tuPFg3Ynw/hUW6imipmM2uviksPh3ZkqidM5NyDqq/wI5EwLu3JpCdhPwxuy9HmZtBJjZ6Ge4HZ1T+RBaXZ9h7CI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776965861; c=relaxed/simple;
	bh=0x/auHbOhhE+j/6Df10ZM/NGURUzqWqfjC2ekyvD5HY=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=C9ZPayjCCx3sscT/SlfUy+DNs4fBQjHm+y6J+z5LMu/OGn1BghGwWUrMZoD4Jnx8STQD42zNVU6Yd8WDY2mC7rOiWki7VCufz8QDo+PKi5QZgrjc7hkrKmWuSENToNjMYu2ASiMMPgoNqoCrds3e3btxt8aeqbGs/pUiYPSJcDY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cse.ust.hk; spf=pass smtp.mailfrom=cse.ust.hk; dkim=fail (1024-bit key) header.d=cse.ust.hk header.i=@cse.ust.hk header.b=lePdqm4q reason="signature verification failed"; arc=fail smtp.client-ip=143.89.41.157
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cse.ust.hk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cse.ust.hk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=cse.ust.hk header.i=@cse.ust.hk header.b="lePdqm4q"
ARC-Seal: i=1; d=cse.ust.hk; s=arccse; a=rsa-sha256; cv=none; t=1776965848;
	b=AjAF/AUxsrDhjwvI6hRS7wW0fNQGqfwdHdlGfnbSWlODoNBFi7eCunougQj7njU9Srmh
	 Aph11WHgAkMeJjCxSfm07htXs+OyYtX+EtUsqrT8l49NiRV03b/HBR11417ucfa+2u8Zj
	 CSrkCILafu0ooYCTC/h4K/Uc3vIgpPsN7k=
ARC-Message-Signature: i=1; d=cse.ust.hk; s=arccse; a=rsa-sha256;
	c=relaxed/relaxed; t=1776965848;
	h=DKIM-Signature:Date:From:To:Subject:Message-ID:MIME-Version;
	bh=ooBVeHO5BNHGyWf9t7ZufVl29d6IT3b4Z7fohAbfVwc=;
	b=ZbWEHSL0T/fII8NM4r/zhxiWvhf6D2UYNsBUabgJfepQpQpZPtEJ4B/egsb8mOX9xnFn
	 028uS9esS5+iz+9lcXNauKtpde6grj8I9F3VItQpF0gNTgQOFkPOvvWPPRViaQ0zGERPh
	 eUKbexZBOi+vPQt890sADqcc4J4pE1Y5l8=
ARC-Authentication-Results: i=1; cse.ust.hk; arc=none smtp.remote-ip=143.89.191.45
Received: from chcpu16 (191host045.mobilenet.cse.ust.hk [143.89.191.45])
	(authenticated bits=0)
	by cse.ust.hk (8.18.1/8.12.5) with ESMTPSA id 63NHbL7v1768571
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 24 Apr 2026 01:37:28 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cse.ust.hk;
	s=cseusthk; t=1776965848;
	bh=ooBVeHO5BNHGyWf9t7ZufVl29d6IT3b4Z7fohAbfVwc=;
	h=Date:From:To:Cc:Subject:From;
	b=lePdqm4qB7eWJYQqIPHt9brQXb3SuRd91nj6sGelvFEovd3IICbaMLCqYMUwOfDnd
	 DZh1/AOXe3Uek/B2JI3o56S9yIaY7VcaoTDxinZi8E/Ite3YXlkps61XDv1OkefZtM
	 p+QyBDqYU0kvXG5tO2FM/0pfJ8wHv8ZzV9mZ3XLk=
Date: Fri, 24 Apr 2026 01:37:16 +0800
From: Shuhao Fu <sfual@cse.ust.hk>
To: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [BUG] ext4: KCSAN: lockless i_es_all_nr reads in es_shrinker_info
Message-ID: <20260423173700.GA2187084@chcpu16>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Env-From: sfual

Hi,

Reading /proc/fs/ext4/<sb>/es_shrinker_info can overlap with extent-status
updates and trigger KCSAN reports on the per-inode ES counters (I saw this on
i_es_all_nr; i_es_shk_nr is read the same way in this proc path). From what I
can see, the user-visible impact appears limited to stale/inconsistent procfs
stats output (I do not have evidence of corruption or crash from this path).

I reproduced this on a local KCSAN-instrumented tree based on linux commit
d8a9a4b11a13, using an x86_64 QEMU workload with userspace reader/writer loops.
To increase the race window, I added small debug-only hooks in my local tree:
after the writer updates the counter, it briefly delays and records which inode
it just touched; the proc reader then samples that inode's counters during the
s_es_list walk. I also wrapped the i_es_all_nr load in a local helper
ext4_es_shrinker_read_all_nr() so the read-side stack has a stable symbol;
upstream reads happen directly in ext4_seq_es_shrinker_info_show().

With that setup, KCSAN prints the following summary line (naming the two
racing functions):

  BUG: KCSAN: data-race in ext4_es_init_extent / ext4_es_shrinker_read_all_nr

The first clean hit in my local log was:

  read to 0xffff917cc15222c8 of 4 bytes by task 107 on cpu 0:
   ext4_es_shrinker_read_all_nr+0x26/0x50
   ext4_es_kcsan_probe_hot_inode+0x2b9/0x400
   ext4_seq_es_shrinker_info_show+0x9b/0xd40
   ...
   __x64_sys_sendfile64+0xc2/0x100
   do_syscall_64+0x13f/0x3c0

  write (reordered) to 0xffff917cc15222c8 of 4 bytes by task 108 on cpu 2:
   ext4_es_init_extent+0x6aa/0xa00
   __es_insert_extent+0x477/0xaa0
   ...
   ext4_do_fallocate+0x127/0x310
   __x64_sys_fallocate+0x75/0xb0

I then saw the same pair again later in the same run (for example around
129.529391 and 129.579938), still on the same 4-byte address.

It looks like i_es_all_nr and i_es_shk_nr are documented as protected by
i_es_lock, and writers update them under i_es_lock, but
ext4_seq_es_shrinker_info_show() reads them while walking the list under
s_es_lock (the list lock), not i_es_lock.

The reproducer shape from normal userspace APIs is one reader loop running
cat /proc/fs/ext4/<sb>/es_shrinker_info while a writer loop runs fallocate,
buffered writes, punch-hole, and truncate on the same filesystem.

Since this appears to be an observational procfs stats path, would you prefer
marking these loads with data_race(...) so the intentionally approximate reads
are explicit and this path stops generating repeated KCSAN warnings?

The rough change I had in mind is:

diff --git a/fs/ext4/extents_status.c b/fs/ext4/extents_status.c
index ... .. ...
--- a/fs/ext4/extents_status.c
+++ b/fs/ext4/extents_status.c
@@
 int ext4_seq_es_shrinker_info_show(struct seq_file *seq, void *v)
 {
 	...
 	list_for_each_entry(ei, &sbi->s_es_list, i_es_list) {
 		inode_cnt++;
 		ei_all_nr = data_race(ei->i_es_all_nr);
 		ei_shk_nr = data_race(ei->i_es_shk_nr);
 		...
  }

If this direction is preferred, I can send a formal patch.

Thanks,
Shuhao
