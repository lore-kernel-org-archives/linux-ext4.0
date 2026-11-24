Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=113.46.200.221
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795492552;
	b=LNtALeEcMLIrv1yR+33rDx0LuTUIXTjJ/KKfxuc2arYPVwX+V3fqEC0vSnqD4+GMx4D+
	 +ZV7j7S09xu61Dx6fYhSm4C5A1x0x2anWw1jlyyhPLO6tdjVf1f2IJIa6risebRFfn0Pf
	 a++Qyz1j5rwdpOeLF+2hUmUVMdHAuBpbmAc+Th+itSVUzaKMCBdq5dP5jmxvHSdT24rO/
	 WjTlYSjD0mvt7AYWgoY3DDWoV26LrlfVzfJcs9DZY3BvvbT9Jskoz2eF8CxcIbbc24nZQ
	 K1McVAg5NUqlXVBQ7GWdY35iBYlFQYNTJ0y+EKPKKgW3ceFUiAoBmT5gbGfSSMoC2Gw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795492552;
	h=DMARC-Filter:dkim-signature:Received:Received:Received:Subject:To:
	 References:From:Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Originating-IP:
	 X-ClientProxiedBy;
	bh=mmxMnertG636p6pUDvVEmCeB8REQKCy01Ed1AqftoHs=;
	b=p7mEeBdR/ukYEoSMPIsTH9VvlLpx2pxpPaa5ySodi1yZBEQHyqjko+pm4cg8WacHQMrw
	 H+NLMmsnC6ReIlXtOEgexLcKnDamIx7Y0mC9XXg+eWKNK0Tt2WI8xd3V1xp2DXoLEckMk
	 lZpR2AHDmwmOmGLnv5YU2OxqFwKpsv7yluLqTQx5XHr4O0rljlYgmhzoKDUr8NuUY0sSW
	 jN2/dv8q3FDhX73mCmh0gYlnFdnOiNkTiaQF3IcTbdcd/YoTf6j6VSoDd9T6UGz+EDa39
	 mf9P7z2bJ8sr8j56Mrq2E4f8B9DirB94jtuME6jCdKl5wozb4MMBB2SLs2V0lBHu5Ag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=huawei.com;
	spf=pass smtp.mailfrom=huawei.com;
	dkim=pass header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=ofZVOboQ;
	arc=none smtp.remote-ip=113.46.200.221
Received: from canpmsgout06.his.huawei.com (canpmsgout06.his.huawei.com [113.46.200.221])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20DBB606A31E
	for <linux-ext4@vger.kernel.org>; Tue, 24 Nov 2026 03:55:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 20DBB606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=ofZVOboQ
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=mmxMnertG636p6pUDvVEmCeB8REQKCy01Ed1AqftoHs=;
	b=ofZVOboQwl7WqGJBp0Or1L7IGKmO6G8I77cmpc0kwTSd3gdKTu2B65AVWj0ByD5KSOl+HQrys
	7n9YONan8xgIgLnRu5YNs1qMGpwmalROjMVDdYgH1AOw7HNTLLhAg2pnvem5wABSIydlp1yv27f
	PUIC56LF3Lrwcpe4UxlYqxM=
Received: from mail.maildlp.com (unknown [172.19.162.197])
	by canpmsgout06.his.huawei.com (SkyGuard) with ESMTPS id 4jYTVK6GQmzRhTJ;
	Tue, 24 Nov 2026 11:55:21 +0800 (CST)
Received: from kwepemk300010.china.huawei.com (unknown [7.202.195.128])
	by mail.maildlp.com (Postfix) with ESMTPS id CE6884057D;
	Tue, 24 Nov 2026 11:55:39 +0800 (CST)
Received: from [10.174.178.185] (10.174.178.185) by
 kwepemk300010.china.huawei.com (7.202.195.128) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Tue, 24 Nov 2026 11:55:39 +0800
Subject: Re: [PATCH] ext4: protect ext4_acquire_dquot against freezing
To: Jan Kara <jack@suse.cz>, <linux-ext4@vger.kernel.org>, <tytso@mit.edu>
References: <20261123114602.66520-1-yebin@huaweicloud.com>
 <sashiko-outbox-229179@kernel.org>
From: "yebin (H)" <yebin10@huawei.com>
Message-ID: <6B050ABA.1050808@huawei.com>
Date: Tue, 24 Nov 2026 11:55:38 +0800
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
In-Reply-To: <sashiko-outbox-229179@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemk300010.china.huawei.com (7.202.195.128)



On 2026/11/23 20:02, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential
> issue to consider:
> - [High] ext4: deadlock with thaw_super() in ext4_acquire_dquot() via
>    Q_XGETQUOTA
> --
>
> commit f23e3eb68e6a88d3c8dec26c7efee607385b6388
> Author: Ye Bin <yebin10@huawei.com>
>
> ext4: protect ext4_acquire_dquot against freezing
>
> This commit wraps ext4_acquire_dquot() with sb_start_intwrite() and
> sb_end_intwrite() when no journal transaction is currently active to
> protect quota acquisition against filesystem freezing.
>
> Link: https://patchwork.kernel.org/project/linux-fsdevel/patch/20261112135245.3347102-1-yebin@huaweicloud.com/
>
>> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
>> index 359f9d4ed4479..a06d5f298c849 100644
>> --- a/fs/ext4/super.c
>> +++ b/fs/ext4/super.c
>> @@ -7118,11 +7118,25 @@ static int ext4_acquire_dquot(struct dquot *dquot)
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
> Can calling sb_start_intwrite() here cause an ABBA deadlock between
> sb->s_umount and SB_FREEZE_FS when Q_XGETQUOTA or Q_XGETNEXTQUOTA runs on
> a frozen filesystem?
>
> quotactl_cmd_write() returns 0 for Q_XGETQUOTA and Q_XGETNEXTQUOTA, so
> quotactl_block() and quotactl_fd() acquire down_read(&sb->s_umount)
> without waiting for the filesystem to thaw.  If the queried dquot is not
> yet active in memory, dquot_get_dqblk() calls dqget() ->
> ext4_acquire_dquot() with no running transaction and blocks in
> sb_start_intwrite() while holding s_umount:
>
> CPU0                              CPU1
> ----                              ----
> down_read(&sb->s_umount)
>                                    sb_freeze_unlock(sb, SB_FREEZE_FS)
> sb_start_intwrite(sb)
>                                    down_write(&sb->s_umount)
>
>   *** DEADLOCK ***
>
> CPU0: do_quotactl() -> quota_getxquota() -> dquot_get_dqblk() ->
>        dqget() -> ext4_acquire_dquot()
> CPU1: thaw_super() -> super_lock_excl() -> thaw_super_locked()
>
> Once this happens, thaw_super() cannot acquire s_umount to unfreeze the
> filesystem, leaving the filesystem permanently wedged.
>
Hi Jan,

Sashiko reported a deadlock with thaw_super() when Q_XGETQUOTA or
Q_XGETNEXTQUOTA runs on a frozen filesystem.

Looking at this, I think the same reasoning as commit ccf370e43e08
("quota: Forbid Q_GETQUOTA and Q_GETNEXTQUOTA for frozen filesystem")
also applies to Q_XGETQUOTA/Q_XGETNEXTQUOTA, since these can likewise
end up in ->acquire_dquot().

So my question is: would it be acceptable to also forbid these two
commands on a frozen filesystem, i.e. add them to quotactl_cmd_write()?

My concern is the resulting behavior change for read-only mounts.
quotactl_fd() would then call mnt_want_write() for these commands, which
returns -EROFS on a read-only mount.  So Q_XGETQUOTA on a read-only
mounted filesystem (e.g. via xfs_quota) would change from working to
failing with -EROFS.

Alternatively, I can keep them as read-only commands and only make both
quotactl() and quotactl_fd() wait for the filesystem to thaw without
taking write access, which keeps read-only mount queries working and
only waits while the filesystem is frozen.

Which approach would you prefer?

Thanks,
Ye Bin


