Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26E5E226D05
	for <linux-ext4@vger.kernel.org>; Thu, 24 Sep 2026 15:07:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790262423; cv=none; b=uCcUzsnDrLhY54tPBpYnT9AnTjrDY6sphsigCjXw98FJby+j4KQIpTT81PtlhDfhCJ1jgQ44K26o0uIJrl+/B6a76N4f7xd5dFazg2vrz+Sc+26owbYTAhrc+Pk1RRJxuxmTKSqnMfghGlgzdADZByio9yiBrYAYu7BlvmMsL/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790262423; c=relaxed/simple;
	bh=fSuUVW92FmxQMAyhBvOHILUAuM8kGkQU5SxBF99mTMM=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=m5HG66t6C5u98/SH9XsThuZqL3sZy46E5ynuyPyTUTlWhWpuApRWdftRb50o6N0ifUT6DKeazMUy/Kxq5PoDuvbFL+yNoQo8fGSmLF93GGCwCn14raeec5Hsfeu5KjD8hAyMmfgmV0tMJlh2S4vnBvDxL+FI0N/7aXK0upSeYaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T/ylYATW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T/ylYATW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98C7C1F000FF;
	Thu, 24 Sep 2026 15:07:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790262421;
	bh=iZac/lZYvC6fdXjUFeTgPa/BBqzphEcKNqewlxXT65A=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=T/ylYATW3Codsc0rqY5feOX8+96sI/uZsD6DwZnxSgyUKT7nnLREDtScZZR14jwWW
	 QCSsmv57dguCzfaW8IPLaqCwaIGLii9QZWPHKdwrs4vvrVgzXqDiX8pHO35MT1xgSq
	 kX+vGZYHtQOUWBPd00G+v4XupbzwA+dvEnbBQZpamF0RJY5afZtmC47sGEfz4C6NQF
	 QWJCz+NNXoH6D3eYHQNWGczpPyofkU5BJghgwxBB+BpWzZCDN5NKJqknHzX0WXMmrn
	 NmMuvQKzsjnYhVjBWduOxHkQ7MpTVdhYbFlIjME2GZ8mhPhNU6DikYICShb7o+uBpD
	 P47hZMaI6zn0Q==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] ext4: mark data=journal as deprecated and will be
 removed in January 2028.
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?VGhlb2RvcmUgVHMnbw==?= <tytso@mit.edu>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20260924145924.341425-1-tytso@mit.edu>
References: <20260924145924.341425-1-tytso@mit.edu>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 24 Sep 2026 15:07:01 +0000
Message-Id: <20260924150701.98C7C1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] ext4: missing device name in data=3Djournal deprecation warning
--

commit 268d23e9918bb20498a07197e8ffc2af5574d8ca
Author: Theodore Ts'o <tytso@mit.edu>

ext4: mark data=3Djournal as deprecated and will be removed in January 2028.

This commit marks the data=3Djournal mount option as deprecated. It updates
the admin guide documentation and adds a warning during mount indicating
that support will be removed in January 2028.

> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index bca0dc87d0b7c..d636b89090a24 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -5057,6 +5057,7 @@ static int ext4_load_and_init_journal(struct super_=
block *sb,
>  static int ext4_check_journal_data_mode(struct super_block *sb)
>  {
>  	if (test_opt(sb, DATA_FLAGS) =3D=3D EXT4_MOUNT_JOURNAL_DATA) {
> +		printk(KERN_WARNING "EXT4-fs: The data=3Djournal mount option is depre=
cated and support will be removed in January 2028\n");

[Severity: Low]
Does this code omit the filesystem device name from the log message?

Using printk() instead of the standard ext4_msg() helper means that the
superblock's device identifier (e.g., sda1) is not included in the warning.
Should this use ext4_msg(sb, KERN_WARNING, "The data=3Djournal...") so that
administrators managing multiple ext4 filesystems can determine which
specific device is using the deprecated option?

>  		printk_once(KERN_WARNING "EXT4-fs: Warning: mounting with "
>  			    "data=3Djournal disables delayed allocation, "
>  			    "dioread_nolock, O_DIRECT and fast_commit support!\n");

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260924145924.3414=
25-1-tytso@mit.edu?part=3D1
