Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795104500;
	b=V8IQoLddDgnx2YNC3aEl2+QNQruQx8QTVNb70LnSffAAA0JUU34MVebxKkZaUAodb1eX
	 1plRnb3l0kVxH8Cv60DN6Q5HOF6llWf3qBLJVS5NZbz11ZYmAlLJMnHAV6JfwRpM099KH
	 SSQKrtMfOBGUGLEzLKsuzrRUs0KYSa1r9KBY89jA3uH6XPzPEqJlB3yHNEhQB2nQrTNOz
	 EXa7uunrTfglWOqf38mttIV5rpt8G5v7V78AkCKLOGmjxxwDE/wp5fYg03YJhyYvFy0NA
	 lMNMu+rr73FuBvicPy52bLZvbQ0ShRtb2Zox/KPuowrC766CRoaeeTia0/Powv1hALg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795104500;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=vFW5wCDQsUs+MnXsSV7xUdm21FuFHfROO1tSO0Ss6Jg=;
	b=DMgryfdttrNUTaJ3WaLVvkgJaIsEROPGnHPsK4vyrcpTXY1bPjTITtcz02E1jqbXs3r4
	 BQz2hT5LnXYGiS3XYvwauT921te6kfOOIpl4gwtHdF6KWzSoHNRhTrut4JLJGKQvUOCfN
	 YhMjCHa2Rj7uqaTS0+WJKiPFS17v71Fsb5VvkbaEyZ+dc5B0y6Cj+mSNs4DtD+0B/vksZ
	 xpKW4Cd6zvNAU22o3zQXrGu3KJq3KfszAZRMca3T6MjHD1XV7ukOxugMQUV76dSyVWrjL
	 lgWUkceK4Hr2XG1r9fnmx2wyki2A3P5siGZl6pUdBQtbjDiq+pXWhu2D5XR121LbfHQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Otb9Jl08;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7D0C606A320
	for <linux-ext4@vger.kernel.org>; Thu, 19 Nov 2026 16:08:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Otb9Jl08
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22DB61F000C8;
	Thu, 19 Nov 2026 16:08:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795104500;
	bh=vFW5wCDQsUs+MnXsSV7xUdm21FuFHfROO1tSO0Ss6Jg=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=Otb9Jl08/1ZDZZeW4cIvUeu9tb73X3zr2KhRDOsHCcomk+J0qSoeBTJumLar9cQ5I
	 NR80rjJuw55n0kQhqa0BTDT1pugEM4aRVt++IGDCczTUErmJKPPYr0yjrkyz5GQQ8Q
	 ADxPT4D336+lb7IRw1xuaSglOOnFcEIRRNIRIKc8TgdGLhgyOMg9NVo0eqOnpx9g1F
	 DHITtzZMv3HRC8smyXy0Sr/g1PpR6947guPqwV+oJNMJmPlBBXKUcXb8KX0/K3rKJI
	 5lsVy9qWUYionLF0BB46NkFVLH7m1MVY8d0KGLdgvg9Rve3t6EsLlklRGSNu3tlHh4
	 5A4NpoV5sD3YQ==
Message-ID: <sashiko-outbox-223477@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH -v2 16/26] ext4: add KUnit tests for fs/ext4/sysfs.c
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?VGhlb2RvcmUgVHMnbw==?= <tytso@mit.edu>, "Ext4 Developers List" <linux-ext4@vger.kernel.org>
In-Reply-To: <20261119155658.1940864-17-tytso@mit.edu>
References: <20261119155658.1940864-1-tytso@mit.edu>
 <20261119155658.1940864-17-tytso@mit.edu>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 19 Nov 2026 16:08:19 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Add a KUnit test suite (ext4_sysfs_test) covering ext4 sysfs attribute
> show/store handlers, feature capability attributes, and sysfs/procfs
> registration in fs/ext4/sysfs.c:
>=20
> - Generic pointer attributes across sbi, superblock, and explicit
>   targets (attr_pointer_ui, attr_pointer_ul, attr_pointer_pi negative
>   value rejection, attr_pointer_u8, attr_pointer_u64 LE64 decoding,
>   attr_pointer_string 32-byte bounding, and attr_pointer_atomic).
> - Range-checked read-write attributes: inode_readahead_blks power-of-2
>   and upper-bound enforcement, reserved_clusters bounds against total
>   clusters, mb_best_avail_max_trim_order <=3D 64, mb_group_prealloc <=3D
>   s_clusters_per_group, and err_report_sec <=3D 1 year.
> - Computed read-only attributes: delayed_allocation_blocks cluster-to-
>   block scaling, session_write_kbytes and lifetime_write_kbytes sector
>   accounting, sra_exceeded_retry_limit percpu summation, 40-bit error
>   timestamps (first_error_time / last_error_time), and journal_task.
> - Feature capability attributes under /sys/fs/ext4/features, error
>   injection via trigger_fs_error, and lifecycle coverage of
>   ext4_register_sysfs(), ext4_notify_error_sysfs(), and
>   ext4_unregister_sysfs().
>=20
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261119155658.1940=
864-1-tytso@mit.edu?part=3D16

