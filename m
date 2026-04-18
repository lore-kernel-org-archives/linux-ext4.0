Received: from mail-yw1-f169.google.com (mail-yw1-f169.google.com [209.85.128.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC1E135CB88
	for <linux-ext4@vger.kernel.org>; Sat, 18 Apr 2026 22:24:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.169
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776551085; cv=pass; b=Ye+hy1N6NVOLkDPfAsCDBAgRmuDvZZXO+BsN1KZ7h29pKno+DtjxfbgZ6sAUgJVeMhx/hsNQsTSs/O+iloZdun7OJ7VSXDX/qXxJdbYmAIeddC+dKvmRyjXRs/KScVG1nZW2/gFNXiuEtzFM4caGjWI4tDXFX7MO7ksdhEb0OGk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776551085; c=relaxed/simple;
	bh=Li27SfiqjBEfs8qDCoYZ3kI+0cfHt3v2Ums2nUuVszs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=C8Mbt3vsom+yg8iAeb1o7tSYPASPChSBdqoglZWAPfN83K4txVxyOh9fOezdt+V4F2I1eQ+/Q48XSB6wgeSLbz0oZsOUJtia/27CqAWVK+37XKC0+lgnZgWcex/tlfQ2Cr0otrNzISve9+DNAOR5Upx5zH9H6XbJuRluXQOvfRo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XAQIdWnL; arc=pass smtp.client-ip=209.85.128.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XAQIdWnL"
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-7b6ae2ea4a1so16788617b3.2
        for <linux-ext4@vger.kernel.org>; Sat, 18 Apr 2026 15:24:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776551083; cv=none;
        d=google.com; s=arc-20240605;
        b=QTiJcVpwhM6ULC2ASf/MDVrHjVE+HNVeZsChqrofDT6LEOgxGUW24BFU3STJUN1cHr
         IbL6kW0uP3KszLnuq5K660K7yUQi8ys5JaSyrVGb9UL2QxiPevWSihoISN2CQCVGbBM3
         T2pkNWivPK67wO/TIKsnsns5j2qVwCakNLq2tzDDI4PIRU+k7Zu8+dkseX01aQ1rKEzG
         pD6B6ZVWp4zQJ9ZskrOSWGeonDV0yTZ7j8IYCqlbAij8L/CJs0Qq4PQz17sVpyY5ayHm
         PSbt7uX1EakK2/j40b55hYSd4Ouy1NLkRb/4qHmghQ+8E9mhcmEZtmIbWv9dhijLKQ7m
         gN/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=Li27SfiqjBEfs8qDCoYZ3kI+0cfHt3v2Ums2nUuVszs=;
        fh=ZXzCTLP96GQ9s1mkoT8A/6ykle3yuM7Qc12HgK20yBc=;
        b=RwGc+97EjFSlQt79IYIbXkqyTWtkVzp71ffkbYO6oaRVnod8dJh/4nppviaepEXMid
         y1Nm+Rx4bCWCHHF6QdjqT48wm6lgXZpGqEw+gKULW1fp8tna8zTFa7jVxc896F1rEkRn
         DiUKx4HTRm2PjyVVlFCvWJnzWv+4q+uKe5Ch1AecMAbp4jr3ay1Y046QO2oo38yTWw41
         H1IrmdzXstkAH5UVnQlt/qSqUhIzcVfhCppyVgIEIfMPcZUG8ZijsdOCY9WnYa0UbfYp
         xH4E5kcRawOb0gUILdYOdDmR1uF9IeylB8SR8GFFFhBjeuim+HpC7WPrs6WZIh5YSTWr
         nWsQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776551083; x=1777155883; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Li27SfiqjBEfs8qDCoYZ3kI+0cfHt3v2Ums2nUuVszs=;
        b=XAQIdWnL5tE8gkNQHOXjqq/nYUbL57gbkkbNABy4IkGjstJb6YixSCcGRZe7b8kLrp
         14T5QNNS6PUUo9GnArYcv2zuEPoMQ6AspYZtOosbPgxu4L3gRigonBMm2AKbWnR0VwbD
         v+AVX9TcnI6NQV96W/a2qeBQ9aWNQgGwGAyVE/bRdSljxawEfHNZyE76LgSa+WTcgFOf
         N2a3IETwiICBc0IYuxHsgq+o+RHlgTpPx4uYGDIA0Oi4tpz3+QLIcuN8s4sMi0vTs5ok
         zOedN2BQCPo9D24e2W44Wp64x65MQ+haaQ8zL4+1X+LFxzbaeRAc0PM0j43wRZd649Xf
         BIRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776551083; x=1777155883;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Li27SfiqjBEfs8qDCoYZ3kI+0cfHt3v2Ums2nUuVszs=;
        b=OQyqH5KUJ+uxyORBC1bcFoiyCaRN885XNhDMSk9FG6PAApOy0nF+v+Mh4QvxHTgxmP
         q10WoCxXmRHv6zvHG1R1/P4gzd+ccy9A8EAgU0PWgm4j1HhYqk6M3hVqVfGKjs1TOIMp
         17MIrKj6BPEHNzpTo88z1emXFqXan+5Cz0BwzZNM7kOTJ9GqBwZretvuHVrzi3cTvBDo
         OBWWTdqi00ci/CymWLfVKsbU475KldXyfKSjwbbZi6q9Gh0nyv8aCHdXPCWx+2IqjQqX
         KO0G8/fv/13tCAA7ZfBTO8i5g/t1iJqP4F4pNMQgkVRXJc70ok4JRlTP1O4QDMQ+rkqs
         OiMg==
X-Gm-Message-State: AOJu0Yz3Qa3/gTqXPYLdVFvK321m44sjnbWWiphtPU2kJ2otA002IlyA
	0IxSV6fSK0ZtIaHDmwrSdpTuvJIg9uabDpRoFBMxq1nHDksJezlemDbO2XcPmXEna1hBqulnymo
	YdCNcF7YP3+yH3RQVeahVS1xxRpasMKtzNzE7nY8=
X-Gm-Gg: AeBDietOUVpNkYSKm3YAtvIcijGJGb04kb8CBWdLhePr8lZOj/jUAbB1zlNmfIy1jxW
	d8p84OwdMGU/9wFm7kHq/h/9mja+UjneB5MbWQ6IFtTW4tDf9Lu/CTjc/Ct/N2wu0/1APEnNlOC
	etqp2L7em3EBzqHcy7RndkwiqjCssPzjPLYh6xM1qcXMXc/1fyzgDOISv+1MY/xqo/DXk0X3jmd
	k70PFDoxJJhGbr8uCpWv9TrJre88axrblHCwGImc7fCEXaEi0gW79zCWHwV/cfnjNpe79Y5x8Gj
	dzR6zoAr9DKJ73u3E7ok4p1tccuF8npJTUyD3CO2fk0c+MokrWWW
X-Received: by 2002:a05:690c:1d:b0:79c:1984:3114 with SMTP id
 00721157ae682-7b9ecee5e35mr87919097b3.13.1776551082862; Sat, 18 Apr 2026
 15:24:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260417213723.74204-1-artem.blagodarenko@gmail.com> <20260418214359.GA58909@macsyma-wired.lan>
In-Reply-To: <20260418214359.GA58909@macsyma-wired.lan>
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
Date: Sat, 18 Apr 2026 23:24:32 +0100
X-Gm-Features: AQROBzAuTud1nvs4Wdq2cneGLO_7-unQs1WtITjpZzU3GfsMR-qVq3YzPXu4DRk
Message-ID: <CA+rD4x8uk7h7dv_Mg1tMXXiVZZD1YAj5WAw+6GNuMKQAAMueuQ@mail.gmail.com>
Subject: Re: [PATCH 0/3] Data in direntry (dirdata) feature
To: Theodore Tso <tytso@mit.edu>
Cc: linux-ext4@vger.kernel.org, adilger.kernel@dilger.ca
Content-Type: text/plain; charset="UTF-8"

Hi Theodore,

Thank you for the quick response.

Upstream perspectives are aligned with having a unified way to store
additional data that can be useful for:

- storing hash for encryption + casefold
- storing LUFID for Lustre FS
- storing the high part of the inode number (64-bit inode number)
- potentially other extensions to overcome current limitations

There is now a way to set dirdata. Following the decisions from [1]
the patches provided change how the encryption + casefold
hash is stored. If the dirdata feature is enabled,
the hash is stored as dirdata. Therefore, to test dirdata, it is
sufficient to test the combination of encryption + casefold + dirdata.

At the same time, if some hashes were stored before the dirdata era, the
old hash format continues to be used without issues.

I will send xfstests soon:

ext4/064: encryption + casefold (WITHOUT dirdata)

This test verifies that files created in directories with both
encryption and case-insensitive (casefold) attributes work correctly.

ext4/065: encryption + casefold + dirdata

This test verifies that files created in directories with encryption,
case-insensitive (casefold), and dirdata attributes work correctly.

Regarding the rename functions, I will follow your suggestions and
rewrite the fixes.

LUFID is an optimization that allows Lustre to store file identifiers
efficiently directly in directory entries, avoiding additional I/O
operations to look them up separately.

I am open to adding mechanisms to access LUFID outside the Lustre
filesystem. However, since: 1) dirdata is tested using the encryption +
casefold features, and LUFID is primarily useful within the Lustre filesystem
and is already tested there, I would prefer to rely on testing LUFID
within Lustre FS.

That said, I am open to any suggestions.

[1] https://patchwork.ozlabs.org/project/linux-ext4/patch/20210203090745.4103054-2-drosen@google.com/

Best regards,
Artem Blagodarenko
