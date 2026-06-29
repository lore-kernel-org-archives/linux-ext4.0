Received: from mail-vk1-f171.google.com (mail-vk1-f171.google.com [209.85.221.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59E04364E84
	for <linux-ext4@vger.kernel.org>; Mon, 29 Jun 2026 06:06:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.171
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782713216; cv=pass; b=Gk0NciJDTob6OJcsXUU6IWlKW/Xt1bI6wdoFA1qWO3mdVS0WqexXpyrFDoxfnt7edvVGoMKgqeQ19ZzcscGxVmTr8UA9UTrfPup4p9MmbFsip4GBUfgjrjxhgDyF7Zc1pRPTtxOuEgOrdHDlvumDwp14GBUFQpNe7v7U77X5/j0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782713216; c=relaxed/simple;
	bh=uSYFsWDft4ce2TkyTi4lT0svGSpVyfGASiwdqD98qT8=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=X5pnS42bAkdevP1nMchcJdaeaJz7wKFcPDRUtel+aVEr4vCFtBpfiuQq/F53/K5rSzyzc8/CnMlnmaR68MBqA71LKppJiy2wTIWFv9UYUfMGpJTr/pyHoycL6ETtrSDmqbnkvTpKVmu6uhXaccM8JgHhGRgQU+fPhDPeevZNfNk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MmDB7Qtz; arc=pass smtp.client-ip=209.85.221.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MmDB7Qtz"
Received: by mail-vk1-f171.google.com with SMTP id 71dfb90a1353d-5bd7309af69so1179081e0c.0
        for <linux-ext4@vger.kernel.org>; Sun, 28 Jun 2026 23:06:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782713214; cv=none;
        d=google.com; s=arc-20260327;
        b=djy3HdSmMv30oMG7mxpCDB9SZE/2fNJiWyuaJo5BU7Epsqt4rw36Dp2zN3pho2zb3v
         1PLqzR4kCrESvLWVKX/3kKzzzQ7xK6P9bSKgBgwjoXfpldkZhF1X5PTzzvwG5qG4lUv2
         KRRrxM4zF1bBrH8od21AOPku+aS4O+YmH3m2qJiN4NHmg54Fag5rdg7zuR1e/wTA4WjC
         0ObCGDEtzY081s+1eK/qcXsR4CH5OHYerXtySoL0mhe4I4TpFfDotnN40X5AVfgXoOpf
         +D1IxBqLGHwQ8iTZ+vFh2LIc02N3acj+VNZBDD91ZEBH6N2S19SVusBf4o5tKApMxYYf
         v9XA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=uSYFsWDft4ce2TkyTi4lT0svGSpVyfGASiwdqD98qT8=;
        fh=Y3i85rAca9MqroOYiSOcMZ2uavL2MnVRhqEnzAkU0SQ=;
        b=QiZuDDW8ojHwPpZfNapxvQ7paR07gIXABfE3nWbdI6VoXlhMrxGYRbWLbp7JeQ8kf4
         Kz912lYVGCeSvyYeLk4lmtJqJ5LlaFuFwIhR5RpC1AC2j7+ysNNHM5IrtZs51zSpL5Vs
         ywj1khcRSM4BG8THp0eSOz3IaUwbacrcPV7vhDh4+xXvu0DBI/PpMer2VVHNZGA+RE26
         HV/wM1/5CnQ6NOgCDvJN9kTRB0c2rrfT4+BJ/LCCfI8SrxO8Q3sXsJAn9f3Xqea3GqV3
         8HayzvZQtUPTJuX4r7rFXPeXJBYR75QdLsM7eP7i4utnid1gnd0HDTbU8dCVBrPpdHUS
         St+Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782713214; x=1783318014; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=uSYFsWDft4ce2TkyTi4lT0svGSpVyfGASiwdqD98qT8=;
        b=MmDB7Qtzjo8U2Xa5FGVNSfY+rzzO2xftpOvHxg1fgZbzQ5dduUoYzDYKkgif87QU15
         XJbXMWdzxtrJp3PYaeTXrL6gNVSPR9Ll6dsRyvY4GENoQOlFYLlLJCrPgiGf7vDD6I9S
         0yl6DIAyL04Sa7U6/kYb+uLLNwR8ivA+ti5rbv6nf0lO3CxVdfAmY1umb+WVjz/sKlbP
         6efV7yYLbZPSSKOpag+TOdWfCG06zt0hSdvVDZl2V/QAqON8Q8Kev2rSquHwMdQDBDA7
         MRLVSqEqYMaSvfdP/Gf3rsm3UxTUsbyCfmJSB8XZ8c4HEUADYciD33h454qaHr4GqfI5
         CMrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782713214; x=1783318014;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uSYFsWDft4ce2TkyTi4lT0svGSpVyfGASiwdqD98qT8=;
        b=bvevB0bkWlTNkJugbOO4Fquh8WKe7AkFAvYda1TYOdoxm7Yw6j+vG+0UNmmnf2ePir
         fRwYOJJQI1IHzYR49k46B9WMCfRkfbvSFNBFc6GtSWRfH4x8aHr/IcvQYrDoWaZuO4aj
         T4CohPB12gwa0h3TvFMaZhkr6Tmkn6cgYq4MRubgcSuxeByqk9eUn0nsCM/0ZIKq0IpM
         SSJ++SG9sZU8VP6bPUbGGM0hkB3dc0Os1o7s58jEG/jwZfCDZ9w5CF6tdRfqdPcEnZqV
         IbauceM41qszPpbi83X0ajXxJ7ce0g+5kz74Pw9vuCiHZlut8YHoY0YYUPtj2nmxS8in
         tHSw==
X-Forwarded-Encrypted: i=1; AHgh+RqF8a6rVaHEs2X3nj16Oo2aJYbRDrMSK2T10pUC2NXBHNO2ULhQjL24O56bUOo73+2tCMi6TI2C+8Px@vger.kernel.org
X-Gm-Message-State: AOJu0YwsmYGcjYFOlxgdxIzsxcZc1CZXYYbY8oYBvY/4FD7XM1KlVt8d
	5gz8wgOGF1PpQp5/5GENyT/j9xBU21kExqV+YAcTIe/wHZn6Qpsvn3/wK7bAS+WX181fkbIfKo2
	jDqqSJuYgSYkCHHXUShZFtBgjs7xwzx9h2JciHG9IS9JD
X-Gm-Gg: AfdE7ckosLOJZFVVWLbVofGHfcbUgpp+FyI/iFjmbU5iEjOKXR2k1BnkYlmu8AaeSvl
	Jq3AYZthdp/eCceaB6BoqBdqK6gAmAqR2BiY9dxCczJ450h5YF+qHI0y0BKsEVZWa3YNTQNYnax
	1HVZOEDFDRizTyoIuqJJpN28F95DcU28K37P4v8zDCBRVKFblJZFaHTZUA77ePy2VG6yGZw3b2e
	QtsEy7DW4yBu/AvAXT+YZRKoxvCxXzjyZSF0cUh7Exr9G6ylPZQnnoLZHQRUR4k41Z+/nE6/EU0
	IXQJbLj16C+nNW7+5qSpMNoTqQ==
X-Received: by 2002:a05:6102:dd3:b0:611:e0c2:1604 with SMTP id
 ada2fe7eead31-736339f22acmr4307992137.19.1782713214259; Sun, 28 Jun 2026
 23:06:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Xianying Wang <wangxianying546@gmail.com>
Date: Mon, 29 Jun 2026 14:06:43 +0800
X-Gm-Features: AVVi8CdPRpggITfdcp6loMshhxzFwsuy2-cDc0MBPIusMahmexXayVSBmluHxHQ
Message-ID: <CAOU40uCDtH22BaNLr16JgcqCVPJsct-M=ud830ES-yfpfLsjow@mail.gmail.com>
Subject: [BUG] KASAN: use-after-free Read in ext4_find_extent
To: adilger.kernel@dilger.ca
Cc: libaokun@linux.alibaba.com, jack@suse.cz, ojaswin@linux.ibm.com, 
	ritesh.list@gmail.com, yi.zhang@huawei.com, linux-ext4@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi,

I would like to report a KASAN use-after-free triggered by a syzkaller
reproducer in the ext4 filesystem writeback path.

The issue was observed on Linux 7.1-rc5 with KASAN enabled. The crash
happens in the background writeback worker while it is flushing dirty
pages from an ext4 filesystem mounted from a crafted image.

Based on the execution context, the issue appears to be related to the
interaction between corrupted ext4 inode metadata and the
writeback/extent mapping path. After the crafted image causes
ext4_reserve_inode_write() to detect a corrupt filesystem, dirty pages
still remain pending for writeback. When the background writeback
worker later tries to map blocks for these pages, ext4_find_extent()
appears to access a stale extent path, extent block, or metadata page
that has already been released.

So the suspected problem is that the ext4 error handling path after
corrupted inode metadata does not fully prevent later writeback from
walking invalid or freed extent metadata, which results in a
use-after-free in ext4_find_extent().

This can be reproduced on:

HEAD commit:

e7ae89a0c97ce2b68b0983cd01eda67cf373517d

report: https://pastebin.com/raw/VRd13DKh

console output :https://pastebin.com/raw/GU72hhyf

kernel config : https://pastebin.com/raw/fUwrL2uz

C reproducer : https://pastebin.com/raw/7cc4hyXf

Let me know if you need more details or testing.

Best regards,

Xianying
