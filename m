Received: from mail-yx2-f12.google.com (mail-yx2-f12.google.com [74.125.224.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D3F3496D29
	for <linux-ext4@vger.kernel.org>; Fri, 11 Sep 2026 17:02:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789146147; cv=none; b=iJ09njlus+CHXOFJHf6AehJ0fqZseG04PeK0MREOLGgT8wahkvpDYA7Q+UPwhe/Ge7ckvjc+qW/wndsCxZu1wZJHJq4GwDmtYxd147OORwWGy0yQXokSx3/rHeRuEkgrMcLRluo40zzsUkNnFc+vKbRxz2+epYiG58PNcdJiAkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789146147; c=relaxed/simple;
	bh=NRD+E16Ntqi48SkKeqUEb2XLh/7GQUHq/VvV71uQbds=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qAR5T5qzWZlENWmebS4Q3IexnCFXg+bZJUnDZoZJCcb93eaI5gBoEcOhV0bIiTK2Qqt4lSc9le8exNnxR3X/+CNtstFgqhc1dg1SnDZZePEwpzb4EudLEvppybHYmbyEvMV+mHKd6cP4dcE0cX4ZDhbf7weFZrPHy+SF74WpPf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=akAKooVA; arc=none smtp.client-ip=74.125.224.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="akAKooVA"
Received: by mail-yx2-f12.google.com with SMTP id 00721157ae682-85d4ddd17a0so2161387b3.0
        for <linux-ext4@vger.kernel.org>; Fri, 11 Sep 2026 10:02:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789146144; x=1789750944; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NRD+E16Ntqi48SkKeqUEb2XLh/7GQUHq/VvV71uQbds=;
        b=akAKooVAa3kqR2kW2UhQmz5kGjh7vuPgUOGtKAuR188p62NuSw4yci0yeTDSSuZtjA
         Ez8UJWG4hSe/VA8H5RyvVrtJiDPmJkJOjNolmOns2Bg43OiQ25GX+y29k/xl8WCy5C7I
         D9eMGZZU04VBTD1vjno3MAGDKqBDEKze8jM2jowpCQH4V/lIsdwT8QjoFW99Ahp+Nu9R
         0SVX6Y6MI2Fizf9GIilGRMpXBKHJNBEEV/JJ9Y4p3US9qIptrtxoChHXoryXnGP9Qmk7
         bw4Z9N7yI/ulh1vxlgV/IIbBbBR1R2Hof5H/NejgVaeGCy4uukGiurIRt6DuMZRk3Hpx
         QrFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789146144; x=1789750944;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=NRD+E16Ntqi48SkKeqUEb2XLh/7GQUHq/VvV71uQbds=;
        b=YCHtREe23J6AgWbRo2Sll16ZJwe9WxuvaHKVqvAuMdWli62f+T1VHeyFaO8ahYQmCg
         g2ontXQMPH8lqYXWPSzrFUJEivOlkD7CWAy1tKrt/AQlvrsb+kHidyz0fDT5gcI8tyzs
         0wY1iK1qIqZv8HQuDZkVbilgZImtFJkP/Q7oh7i0REB+ady/yYQL1t7RLoZYwb6FdTll
         NLl6LNI7CQFfZ7nOoHIjQWsKXXByL5+Ib1ZqjbZQA/SrX8G7kb9g5ncog1D8TK8dHjo4
         ArXyXdKFAS3BNJuTR7t5v96KBSTo56+8l9m6MGU8Z7867i27nRYH/y+j8AnmTFef/6xK
         KkfA==
X-Forwarded-Encrypted: i=1; AKwUvBxRN03yjGr40l1z1txBj2hkmDLcEFWLPBRhZK03WjiPOTuyJu+RJfsLIe/kWIuKrVRB9SCaL64ODkZS@vger.kernel.org
X-Gm-Message-State: AFuF++nGm7nfUw/poS1eoNS6rQL+1uFRq4rGCQkjrtK9P5iN7Jzw+37y
	4O+6g1zG3yRIfroZ2H077jWtuVQSjpjczU9LQpAPmvPKw281F6mmy2nU
X-Gm-Gg: AYBFou0sy+n/0xz8zeyWZ6TCRfJ/PorXGVN92AQuLfJN5zC0HfYltExLlwqjo7Id+na
	g4Xr72OLV2qTq0aM4xoR191bkz1YWs1oHqf8lq9qBqfhfn7t79HjQleVVorOLspaj8g5TT6ftvB
	tVbve/HqDjEG66ci8ykjshnjiMi0Z8aWxNkDfhKcrEBW1EYVhuu7HcngIaAuGJ/Dh/yUE78xtC6
	TnuvMDByxhQBJ6DrbAtpjOap0Lw/56qDfqyueibkGgajdFw54aphr2GCq8FSmzCtSNfmMfkO+aQ
	MKZ3aKTKNPffOQM+bf7PQrOe0mbHrI74A/3D+DCZDuUqawrDGuXsayezdWXLdRPMpcQyAI559hX
	V6213Xr+Oihll9Ufc/2edeiYC9fddVhPvpPIoUi4W4J5IeUCo3khu6KXL6ExMrCdbxLLJtaSRCI
	nsnzz3ln0xRXOtTuhyegxi3hYQaEbZ4R9UbW3IindS4zGR89ZxkgRpD0zfwpk5HPi68vc1Q9y7F
	zcZY0AJDXXUNR0aZw==
X-Received: by 2002:a05:690c:97:b0:81f:e85b:f9da with SMTP id 00721157ae682-884b4b01ddamr20863627b3.33.1789146144099;
        Fri, 11 Sep 2026 10:02:24 -0700 (PDT)
Received: from thangnn-ASUS.. ([2405:4802:1d38:5c70:b928:dcab:35a4:adf0])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-884899d85fasm13403587b3.48.2026.09.11.10.02.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Sep 2026 10:02:23 -0700 (PDT)
From: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>
To: tytso@mit.edu
Cc: Jan Kara <jack@suse.cz>,
	adilger.kernel@dilger.ca,
	libaokun@linux.alibaba.com,
	ojaswin@linux.ibm.com,
	ritesh.list@gmail.com,
	yi.zhang@huawei.com,
	linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] ext4: avoid buffer/folio lock inversion in __ext4_get_inode_loc()
Date: Sat, 12 Sep 2026 00:02:15 +0700
Message-ID: <20260911170215.35183-1-ngocthang2710.1999@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260907155017.75543-1-ngocthang2710.1999@gmail.com>
References: <20260907155017.75543-1-ngocthang2710.1999@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Ted,

Gentle ping on this one -- v2 addressed Jan's comments and carries his
Reviewed-by. Let me know if anything else is needed.

Thanks,
Thang
