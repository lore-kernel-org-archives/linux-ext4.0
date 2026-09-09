Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5442C377023
	for <linux-ext4@vger.kernel.org>; Wed,  9 Sep 2026 05:59:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788933582; cv=none; b=kTTdbtAxVzWVzTapl6/4AbVudKZYNio3wLUJ0OEzmrSCWozRs8mCA8THYabhjVDFYgY+gSFmsRIWSWYjNprbh/j4fZNEl4b6t6m9ZK8WtvYYDmmUxNciF5pxyWC/F3bvOo9AAB6me9iVzqTwj86AMaL+TpRAMTLpSqjvLdmaJeE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788933582; c=relaxed/simple;
	bh=hjj7KKDHZVh6EV6XqeMFkGI/4x7lZFSejbbRoctBndo=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Wc2sr8BboI1Ae8P1TuofbwdynzohvePuiODPyF5sUqRVebnjJIqKhQtIBUzdquvahA9YRyD1cgOW1tmCPGAyKz7gbvl3OXYqLVeY60w/fH/eWZUA8SHIHqGrHQmmKrYWegY98ghlK0kLnwuMom5FIeX/WeudZmUiQ3JB2Blc1YY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LBNKErFf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LBNKErFf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFB311F00A3D;
	Wed,  9 Sep 2026 05:59:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788933579;
	bh=/biw0FRIMzCgQrvY+k6pXldsfnv7PDkHKceX4NVN2MM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=LBNKErFf7c2dlGIamO7Wsp8sTVaKcCaQjWXRP+XnFDq3BWVfEQxs2TkdIn5IFzquq
	 LarorFEQRduFlPCDoMx8IEnaO7WjxKKBiwDBXHaB77RMuXMQnbotmPNwnNi77XrDoB
	 trlKcQzbQOV+xHfpdOhY/xrOTv8ugYhvU1FcW/2L6NjnCBOmsTUUCskku8TzO5hplu
	 f+4w4SJ+O8JQqNp3TTUDu+1FyuQhhf4Uo9xrEW03YKziyOhPCvOU62JWFxNb88Q9bw
	 HA17iL6oDmSfTemfBm8O1oiZm08Ad2uNEgjflW1ksrj8Zcx1aFGpUvpZIiS1i/puPi
	 frgPp+9MdJgPA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] ext4: fix discard work use-after-free on failed
 mount
Reply-To: sashiko-reviews@lists.linux.dev
To: "Fan Wu" <fanwu01@zju.edu.cn>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20260909054124.657782-1-fanwu01@zju.edu.cn>
References: <20260909054124.657782-1-fanwu01@zju.edu.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 09 Sep 2026 05:59:39 +0000
Message-Id: <20260909055939.AFB311F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] disable_work_sync() on s_discard_work leaks ext4_free_data entri=
es due to a race with the JBD2 commit callback
--

commit ed64edc319791fc718daf68ae4f355888a8e7de0
Author: Fan Wu <fanwu01@zju.edu.cn>

ext4: fix discard work use-after-free on failed mount

This commit fixes a use-after-free of sbi->s_discard_work on failed mounts.
It forces a journal commit before ext4_mb_release() and uses
disable_work_sync() to prevent the journal teardown from requeueing the
discard work.

> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index bca0dc87d0b7c..672aec4c3616f 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -5776,6 +5776,15 @@ failed_mount8: __maybe_unused
>  failed_mount7:
>  	ext4_unregister_li_request(sb);
>  failed_mount6:
> +	/*
> +	 * Flush any running transaction: its commit callback may queue
> +	 * s_discard_work, which the flush_work() in ext4_mb_release()
> +	 * below drains; disable_work_sync() there also drains an
> +	 * instance queued after that, and keeps the journal destroy
> +	 * further down the unwind from requeueing the work.
> +	 */
> +	if (sbi->s_journal)
> +		ext4_force_commit(sb);
>  	ext4_mb_release(sb);
>  	ext4_flex_groups_free(sbi);
>  failed_mount5:

[Severity: Medium]
Can ext4_force_commit() return before the JBD2 commit callback fully
completes?

If JBD2 updates j_commit_sequence before executing the callback, it appears
ext4_force_commit() can return early. This would allow the mount thread to
proceed to ext4_mb_release() while the JBD2 thread is concurrently running
the commit callback.

> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> index 06171a11db125..3f99efe5e2d5c 100644
> --- a/fs/ext4/mballoc.c
> +++ b/fs/ext4/mballoc.c
> @@ -3898,6 +3898,8 @@ void ext4_mb_release(struct super_block *sb)
>  	 * wait the discard work to drain all of ext4_free_data
>  	 */
>  	flush_work(&sbi->s_discard_work);
> +	/* Prevent the later journal teardown from requeueing discard work. */
> +	disable_work_sync(&sbi->s_discard_work);
>  	WARN_ON_ONCE(!list_empty(&sbi->s_discard_list));

[Severity: Medium]
Does this sequence leak ext4_free_data structures if it races with the
JBD2 commit callback?

If flush_work() returns immediately (because the work isn't queued yet),
and disable_work_sync() is called while the JBD2 thread is executing
ext4_process_freed_data():

fs/ext4/mballoc.c:ext4_process_freed_data() {
	...
		list_splice_tail(&freed_data_list, &sbi->s_discard_list);
		spin_unlock(&sbi->s_md_lock);
		if (wake)
			queue_work(system_dfl_wq, &sbi->s_discard_work);
	...
}

Since the work is now disabled, queue_work() fails. Are the ext4_free_data
items spliced onto sbi->s_discard_list permanently stranded, leaking memory
and triggering the WARN_ON_ONCE() immediately following disable_work_sync()?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260909054124.6577=
82-1-fanwu01@zju.edu.cn?part=3D1
