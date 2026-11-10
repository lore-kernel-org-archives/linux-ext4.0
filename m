Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794351302;
	b=a7PtAF7KUr/icAJAfTYsskjMA/mz9EcjMFpX7e/4lgmKXw2AHQDsJBm2Pp182k2GC7kC
	 vf8A5c/tpipMIMwMO43luwTDPOyW6U+QwiDJnRUPjc095gCJ1ZjUnV+rQEEu9rW0Za4jI
	 8ofdwGINBMXB41fEMbHHdAANU/JO7ejGcfo7DZQCBKQ9NjE37eVncoTEdlVf9/3ilyxF6
	 WbFM0g0fA3EsisDPn0qGo6cyhUDwUFoMMdOmnbWEx7ZWjS/JcPCjjrmTUws/Da8QbGWnk
	 jmfMME8/vujvX8o7Ic++xThwE5uOP2ZDBA0uVoZo/e7aKXKo9Q0Tf75idE1lPQ8ND+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794351302;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:Autocrypt:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=NLay0fAaS8K8zpYlT5J4F/CgngIHcMA7Bk+zXI74j1E=;
	b=mKrOkPA7qHLgiDQ+lG43u/F4OVnDqvE8ZpxoB4cQVgG5qZ0EqydyA1jh3tKUT8j1L5n+
	 zCYqBtS2VJnM/1jteENbN9klngSy2wV30Vn/Abu5GvAEmUy97eworO0qXrFvmEDZ6z8WS
	 lFLMEq5oDnZ1wGiU/tzUbPVB/2QOmonZ0TZWe+FY43qI9zpJDvh9jMInV0tztTwkepHpr
	 hs+eTFONdBSQjSJgkVKt3Ai9/0VOESy8dU2ejdmESyjIjceJT0v/jxsjOoYJtWTI3xn/w
	 v65KNSsah9mGpLQVjiSSTDKXixcPVOeS0D3DH8LeqsxpWcNT0D6ZpZfIK4BYI9Rhxjg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=b13yqpXV;
	arc=none smtp.remote-ip=209.85.128.45
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AC0B606A31C
	for <linux-ext4@vger.kernel.org>; Tue, 10 Nov 2026 22:55:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6AC0B606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=b13yqpXV
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4a35db1f202so20734545e9.3
        for <linux-ext4@vger.kernel.org>; Tue, 10 Nov 2026 14:55:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1794351301; x=1794956101; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=NLay0fAaS8K8zpYlT5J4F/CgngIHcMA7Bk+zXI74j1E=;
        b=b13yqpXVA87T0Iqc0WaWkPTbKxiy1PrVpDcBZMEt0b5/aRczxDZhWiwfDaM8Xlm2eT
         Nnbqqawq4BZYFLL9P+YVPrraYktok7z6C2QMPhWDk/i9gLFx5yi7a6HbAPJRZT7U34DN
         lv74lmiiD8OivwqN4w/oSZpl26yt95/iHARkl0Gqs55Eo2QIo0P5jt+XKnHVZdO7R/FC
         IFo8HrmAg+lvLzE/93pQ/HUeRuPJDTakTSZWa5GVwZqHDRr512Ag+R5ZEKLfCPIQvJ6H
         ZK+p1VpTGUXxkE3B+leNfxozI7RYOXMTeWkLa5O2G566Q9ZLqRWaaEXcXYzODt2g3b/i
         B4Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794351301; x=1794956101;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NLay0fAaS8K8zpYlT5J4F/CgngIHcMA7Bk+zXI74j1E=;
        b=dZM3MGXwL3+EyN3TZZpiHpap1QvqvjVNle1c6FRJ475/SztG6fF2te/O1BFzzKpDLx
         qo5G0ILVzHVOJ2FTJ63dgoogukmWKx86XxEcOkl8swfx6HT1KWb6GlnhRxMPsTsVIQp2
         yNAvt5ztozGc5ylvgy95SQuR5xUnkyoud5unL/+jrhaY8JnjExjSszpulbcXXnLocPxC
         OAmWdiVg3fiW4qKakuKtvpOpChVTzNZNYIF6hExUiBHit0Cgvifjl09ngIlHSX5F4fn6
         fSUBC3tl2V2BhiS4UhvREViFAcfho7rShRmv3tBl5xQRkUO+6Pkb1TsmlgXANyhy+zsj
         JJkA==
X-Forwarded-Encrypted: i=1; AL+hErEWYR5wjSOKtgq9Ar4ZPLyPxta/pAVxTvBoqVeKKE6eeix5kHusxebERVRz9PV2rG2YUT8KI2dQtKOy@vger.kernel.org
X-Gm-Message-State: APuU4Z9y75ue2MRvSbFk+VQc/w2XqPHS65riOZDcqsnx5Z+Cf2r3nea8
	gtKzKitfhN6vSdHRXJLF1mtOMXLaRPUcnEJML+xNm+5pQvrUrPVJKwvS7ck45OF81DA=
X-Gm-Gg: AYBFou3g0LUSs6cuNsCrSSn4If+TYBw0uUoemS6hSsn0cGs9CB9cLW+AEjBQCo25WAw
	WAS1KPoXVgbC9/9MIUYsg82Q/mlp8Vc4zYn2Ltp5DBJu742u1zKF724RlGcxNS/HMi8aXY+YT4x
	CIsRvigG9fTYTQvixVS2dEn7zZm+50xL3Xtdli/+gUJ2ZPp4bD5xZ2mm6cVC/xA24CBJnRv3pQs
	SU3Kvmi/hLmCkauw/ca94DR8Cnq2COUdge21/PgU+2vNGzMqortsfM/nWdjWIKXTboGs6rN77Ya
	e3s/B1F76pEZoC88H/+O/fA6Rt/q00WRvbFZrIJj+viA7AA/H7W7B/lpw3CD9JipGvcUua1rMIJ
	DeafuwRNTz/uGcd7XHx6Khsrq1tagHk61VrPRMe1+4VcQ4JXGpH5nt7mrWh6qERMAfrA0lHUxGd
	1FUJYBzMFVu/0whGTv0UZJxj6yRRje4KlrnZoYOuSxVILI5cLZuXgPYaM+0qAxF03WxyN/Vt7aV
	M4GnLbdeDqDOOflok6SHpUksKflR2e0/c87xm1urIMEE3uh5gJJbNM9T9EVX1QysaR9irWUlEOe
	Fl7sXtFohhK26e636eNDrw==
X-Received: by 2002:a05:600c:3c87:b0:4b8:fdd8:f2c9 with SMTP id 5b1f17b1804b1-4ba093c1c0bmr7546615e9.35.1794351300895;
        Tue, 10 Nov 2026 14:55:00 -0800 (PST)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8baaae3e582sm1412409b3a.39.2026.11.10.14.54.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Nov 2026 14:54:59 -0800 (PST)
Message-ID: <c5c47eed-c927-4ee5-9841-7631674bf6a8@suse.com>
Date: Wed, 11 Nov 2026 09:24:52 +1030
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 23/34] btrfs: check BTRFS_FS_STATE_RO instead of
 SB_RDONLY at runtime
To: Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org,
 Jan Kara <jack@suse.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, ecryptfs@vger.kernel.org,
 linux-ext4@vger.kernel.org, jfs-discussion@lists.sourceforge.net,
 linux-nilfs@vger.kernel.org, exfat@lists.linux.dev, linux-mm@kvack.org,
 ntfs@lists.linux.dev, ocfs2-devel@lists.linux.dev,
 linux-btrfs@vger.kernel.org, gfs2@lists.linux.dev,
 linux-efi@vger.kernel.org, linux-mtd@lists.infradead.org,
 linux-xfs@vger.kernel.org
References: <20261029-work-fs-sb_rdonly-v2-0-2f44f64f0b66@kernel.org>
 <20261029-work-fs-sb_rdonly-v2-23-2f44f64f0b66@kernel.org>
 <c88e4e9c-6b86-4fbb-94bf-909522badf83@suse.com>
 <20261110-kursniveau-zeltlager-quintessenz-36b26debabe3@brauner>
Content-Language: en-US
From: Qu Wenruo <wqu@suse.com>
Autocrypt: addr=wqu@suse.com; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNGFF1IFdlbnJ1byA8d3F1QHN1c2UuY29tPsLAlAQTAQgAPgIbAwULCQgHAgYVCAkKCwIE
 FgIDAQIeAQIXgBYhBC3fcuWlpVuonapC4cI9kfOhJf6oBQJq3ujyBQkUpLw5AAoJEMI9kfOh
 Jf6o8OIH/0mqW+TQM4m2x3hCsnK+oB4yJH1qnGvIhFF/Lhs48wI02sGh6/4aA0hkCDfd9LHQ
 +ci4FUepZ9y4VS01+oIExbg/8ytzGYTzLtb44jK2GBOBVSJkMiha6jp22XFt7WUkT/tvbreu
 WWdGsaJIRQaZChy7xsMI8lqQ2WdmluZJ4LT0wD3l/l6QU1ZseMGySebdY9sVOQEOJNV7Qj92
 /KOAFNmeZshV/qDI8Iw1RTs6TvLqCcqmlZLCmJkYSVhT1RonWRren8xIRcFEgMe004IDnt7V
 qdQhk/nhTS9x9MBAhMRl0TTE1VKDLvVALsud3iZLrmmtYvwPApzGJk052f0m28vOwE0EWdWB
 rwEIAKpT62HgSzL9zwGe+WIUCMB+nOEjXAfvoUPUwk+YCEDcOdfkkM5FyBoJs8TCEuPXGXBO
 Cl5P5B8OYYnkHkGWutAVlUTV8KESOIm/KJIA7jJA+Ss9VhMjtePfgWexw+P8itFRSRrrwyUf
 E+0WcAevblUi45LjWWZgpg3A80tHP0iToOZ5MbdYk7YFBE29cDSleskfV80ZKxFv6koQocq0
 vXzTfHvXNDELAuH7Ms/WJcdUzmPyBf3Oq6mKBBH8J6XZc9LjjNZwNbyvsHSrV5bgmu/THX2n
 g/3be+iqf6OggCiy3I1NSMJ5KtR0q2H2Nx2Vqb1fYPOID8McMV9Ll6rh8S8AEQEAAcLAfAQY
 AQgAJgIbDBYhBC3fcuWlpVuonapC4cI9kfOhJf6oBQJq3ukKBQkUzDspAAoJEMI9kfOhJf6o
 SNsH/1ysUWOKmzY0rGS3ZdS61QgqMGhSWD/EJ4UiPw+xO4l4+GtX0fOAqxqsmBKqje3vyhBa
 Z5o/1Y+gNiN+E6RBcSz4b1TAd78sQ2bvT5DWOvBjeeVxHdiuQMIn4S8xk5ZpySBw5ifjoiuL
 0M33UVtJOzM8yfAeL+d/Rp4leJw72SutjkLyZTG/gJIp4pJGD/kFHn24OLL0IxEcO0gOekNZ
 os5e1R6jAJ2ILk7+MDnvU8wXHcCiVzuDhJLI1tih1uUIE50muHQJWbYuVBbdJeu8WlIDDssx
 UOCxLylNG3gDXV5MhLubPTOpp9OiFc/XC37nvkgEcrlmlOFBv4/NJCbECpo=
In-Reply-To: <20261110-kursniveau-zeltlager-quintessenz-36b26debabe3@brauner>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/11/11 08:24, Christian Brauner 写道:
> On Sun, Nov 01, 2026 at 01:26:22PM +1030, Qu Wenruo wrote:
>> I love the idea. This reminds me exactly why for btrfs_force_shutdown(),
>> we have to manually set the fs error without marking the fs RO, to avoid
>> exactly the same problem.
>>
>> With that said, can you also a set_bit() call in btrfs_force_shutdown()
>> to also set that flag instead of the exsting setting fs_info->fs_error?
> 
> I think so. I'd set BTRFS_FS_STATE_RO in addition to fs_error though.
> start_transaction(), join_transaction() and btrfs_remount_rw() key off
> BTRFS_FS_ERROR().
> 
> Note that this changes some error codes after a shutdown.
> btrfs_permission() returns EROFS for MAY_WRITE once btrfs_fs_rdonly() is
> true so opening a file for writing fails with EROFS instead of the EIO
> from btrfs_file_open().

That should be fine. A lot of other call sites also return EROFS instead 
of EIO on a fs with aborted transaction.

And I think for fs shut down, EROFS or EIO is really the last time end 
users should care.

Thanks,
Qu

