Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 912EE33A6E9
	for <linux-ext4@vger.kernel.org>; Tue, 24 Mar 2026 00:55:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=170.10.129.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774313716; cv=pass; b=Ee+iT7uFRYVTAqpleFbCMeAneHs654U9lFcFsfcfSvYZi9FMgFgDmFg+uuiSKBRUnd57MYjuRg0QVgI4e7epNngtcmIyeDgSgLx02zkRzmo1LrYxFrmpWZogtzSyKUF1FX14a7TORJmAP7xWQA7MQTYKPL1oVwujJIx+EZ5Ajo8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774313716; c=relaxed/simple;
	bh=HxtuXJovGdFtvO/g0aPG6G8S4ZGyC235+Any0lZK9I0=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=KS+Fkt/hqp1tZvki9kF8vevO6uDbLrGd8wR1sUYXEQI4CR8Pn2TqmPnScjSyb8yrK54XJDHljFYh68LC9CLGbaTDj34oKO3vWuUUqSep7j2qsgVIVtwHE0izgQsucPXK6xc9tZZG6P9JapxhVAi33V5s+fsoRBXV3hG7cen4YEY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=f49R+u40; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=Tj6hEuik; arc=pass smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="f49R+u40";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="Tj6hEuik"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774313714;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=rNMnhbVlcAruOYvlrOijLU6TL16d6X5j1YTOGwOu/KA=;
	b=f49R+u40dX08T0rgqwAPzCYfMP00LfbgmmL7ZdIb0lXG823GyZI3+c7q5vqfQPYAir5BxS
	XR2J+qqDPCePnR0Aj+joUiCyqrdU7TO3QEwyre1u5AAuN+y48VHtx7SzfrppTjSTVCzIEv
	i/7VppePeQJEjB6bVRunjeYSVoYvAXE=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-301-Y8Z4JGA0MSCArJrTyjKd0w-1; Mon, 23 Mar 2026 20:55:12 -0400
X-MC-Unique: Y8Z4JGA0MSCArJrTyjKd0w-1
X-Mimecast-MFC-AGG-ID: Y8Z4JGA0MSCArJrTyjKd0w_1774313711
Received: by mail-lj1-f198.google.com with SMTP id 38308e7fff4ca-38a326b8fa0so30847181fa.0
        for <linux-ext4@vger.kernel.org>; Mon, 23 Mar 2026 17:55:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774313709; cv=none;
        d=google.com; s=arc-20240605;
        b=DcD17BU/y/utQSy6E95w2QzIUhbEBjALEWVGRYZCv4XsO15gYt3W0E9RQ38jfkDxcn
         z50n5W/MsaI1d1ldvB0olRCCh7J6TROzw7mPYhqVM8Y2VCNVUb7v/95ZtkWtH/pGisaR
         6ovySzxh38NoMKtgaTpBj6fisfL8mQao5Gxxxbdk3uXUkgPUHjrK7CWeG8F/Z1Cwwdhn
         OqhaTn327sa9V51dl0oyImsOj2m9LjQQjTjiAiFwn1QiXQLbHZvOqJ6PZ17dZE+hZBn/
         Jr9bQXIKGHpv6hTPsKfmUjuODTy3bopCWvw2uRb2NNf6OKOB+DZIHkxbINh9QzQsTbiW
         wO2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=rNMnhbVlcAruOYvlrOijLU6TL16d6X5j1YTOGwOu/KA=;
        fh=+Ppf4gSXSg96w0vgjwnoa6EUvMZXRxgVaX7VoLlFcIM=;
        b=Dfl5wF+1EtqA0lMwKdxBQ7z/H7s+Aul66YJrQeDzTDrdyPiYNmlXMwRMMRL7mMIHyw
         LaULrZXul+Qd1VgMIA9mSVZUXUZ1Njk9BQSn39qcyHg3davEbl2n0iYh5uzusnTubT6h
         n7Nb6sw74uE12rtOcKFOQGRgLlmEOzXkPZ9sisXi3KgER4IzIafMzG3sSgpmQHu18kkg
         dRFk7EJn+RwHvY2gVIBtBA8Fy7EDPK5dqYLez7J8qt33+9aVqJrir4lS26bx/qYGpOh8
         qSpdJQPLsXbWmRNeTFbyVmO7tAiplKVYtBfmr9Qmizf83mwXZyuQH6JGLe3Yxzmbw1cX
         n4ZA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1774313709; x=1774918509; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=rNMnhbVlcAruOYvlrOijLU6TL16d6X5j1YTOGwOu/KA=;
        b=Tj6hEuikFfxLnm9u+TBZ7n3iJtywqc66f2JWMMkw50t/U9UPPaKCUT+edIyOmVvojG
         fjFeIMPJOfxifdJEhX9el5luv2nyCpVIgI+xzM2/jYrgR/brVJhgQtaXl0eiqzZj5RTt
         9tijGkXnHoVpsE2jhjb10V4JN2ij5qYB0i8lVNCnQDhjbT6APkay/m7i8AJCJ4TKIzmp
         05SBN8D2Wvua1J98f0H3Pd+ROjHbrEXS5uBWmZUpCn475Gpq820qfvxNjyqcgqjFmfCI
         KoDg6tnC9Awv6wdvDhTCaK2anRDK2v3fNQWDJAKWGz6b0OXATvO2EpM3HZmEblnpkpk4
         JD0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774313709; x=1774918509;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rNMnhbVlcAruOYvlrOijLU6TL16d6X5j1YTOGwOu/KA=;
        b=KN41cGw9OAIM4Freg1grx02iK+fE65FJeJG/rUM55JvsBfxwcpDT/whw4UAsDASqzu
         q/0P2aE7RddSCZO46FgnOaNrRRtXAn9D/yAkLWQgShqVM1faT+Qax+sfqyhmijUyOssY
         xGOTCHuw/Q32Omz5F2EHJ1Wo+0czRC7mcI3P9g6jDRJZZ3mm+8UCkUBTEHHhf6HJYSJi
         h3xasRKs4XkfVfxDSzHePXhKdFMdtAVa4k3hH7azfhAGkTsu2TyJ6v5LptM1JvtOYVur
         ulFTTQAS/fPBM0RbUu024fe9j2V6ZimpIKgpM6llD4anecbyEBTAsWaiwGrTje4YzBih
         XVzA==
X-Gm-Message-State: AOJu0YyIvYj9Jgc9ZskV3kdkWjasLb4vMr5Z4ENhImJP4pb7yZRYqqGX
	JpLa64x/ccg2sCs83LtBKHQLhHPsd+GHPHFwXj6JIIaoQOGsoywkKJbDFGYL67qgYOhECS3Vpzq
	bBa4zgLic56OQibKowpE+gqS54+D5bDHCjv0A9f1Y/LWuXz/fv+OXuJ/T1d2Y/rLuVGyyf/is9a
	euygoSwDiOLzGlxdVrhu4TSkiZsAWnsb32uJz7AiYtx0yK3EiaXjI=
X-Gm-Gg: ATEYQzx5bKzmvce1OpIYFhaaZ8LMYqRZ8C5nq0EugfLaJZJFt/0SRLd7aJxVZdeLCh0
	YHUydoGvtl835PP2rAYdi24bpQvESs5+wqn2G0D+odE7ezYNUCMgTGjl8pJxWK3v+HhdpFN5Gzr
	mtH2rw1suWj8yVhL3vvRhODtBGv0HW555VB4OkVaY4bayyWyeNdjk6pIgtVafSTtVgA+ew22bq2
	6e4ivQ4odsHVhmM88dZbpklfJYXk76gWW8/9wk1KP0PZ9YLvJE=
X-Received: by 2002:a2e:a9a3:0:b0:38a:61ce:78d5 with SMTP id 38308e7fff4ca-38c328af794mr4892181fa.11.1774313709467;
        Mon, 23 Mar 2026 17:55:09 -0700 (PDT)
X-Received: by 2002:a2e:a9a3:0:b0:38a:61ce:78d5 with SMTP id
 38308e7fff4ca-38c328af794mr4892021fa.11.1774313709013; Mon, 23 Mar 2026
 17:55:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Yi Zhang <yi.zhang@redhat.com>
Date: Tue, 24 Mar 2026 08:54:55 +0800
X-Gm-Features: AQROBzCd2X0HSqrZkZ5_gPcp4_zLBh3e0B2dNGJJen5DEuw_a4XyQymmGvSP9sg
Message-ID: <CAHj4cs8o5HExeOX2YCYrWH86iz4xwL52YtsJNV2YOyDPbyEffg@mail.gmail.com>
Subject: [bug report] e2fsprogs 1.47.4: mke2fs creates oversized orphan file
 for 1k blocksize (breaks mount)
To: linux-ext4@vger.kernel.org
Cc: linux-block <linux-block@vger.kernel.org>, 
	Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>, Baokun Li <libaokun1@huawei.com>, 
	"Theodore Ts'o" <tytso@mit.edu>
Content-Type: text/plain; charset="UTF-8"

Hi

I'm reporting a regression in e2fsprogs-1.47.4 where mke2fs creates an
orphan file[2] that exceeds the kernel's maximum allowed size for
filesystems with a 1KB block size[1]. This causes subsequent mount
operations to fail.

This issue is currently causing blktests loop/007 to fail on latest
Fedora. Downgrading to e2fsprogs 1.47.3 resolves the issue.
And revert [3] fixed this issue, here is the reproducer[4].

[1]
Kernel limit for 1KB blocks: 512 * 1024 = 512 KB
[2]
Orphan file created by e2fsprogs 1.47.4: 1024 KB (1 MB)
[3]
6f03c698 libext2fs: fix orphan file size > kernel limit with large blocksize
[4]
# dd if=/dev/zero of=test.img bs=1M count=1024
# mkfs.ext4 -b 1024 test.img  -F
mke2fs 1.47.4 (6-Mar-2025)
test.img contains a ext4 file system
        last mounted on Mon Mar 23 20:32:40 2026
Discarding device blocks: done
Creating filesystem with 1048576 1k blocks and 65536 inodes
Filesystem UUID: 16683060-ed47-46cc-a040-c5e049785831
Superblock backups stored on blocks:
        8193, 24577, 40961, 57345, 73729, 204801, 221185, 401409, 663553,
        1024001

Allocating group tables: done
Writing inode tables: done
Creating journal (16384 blocks): done
Writing superblocks and filesystem accounting information: done
# mount test.img /mnt
mount: /mnt: fsconfig() failed: Structure needs cleaning.
       dmesg(1) may have more information after failed mount system call.

# dmesg
[ 5985.339637] loop0: detected capacity change from 0 to 2097152
[ 5985.347473] EXT4-fs (loop0): orphan file too big: 1048576
[ 5985.352939] EXT4-fs (loop0): mount failed


-- 
Best Regards,
  Yi Zhang

