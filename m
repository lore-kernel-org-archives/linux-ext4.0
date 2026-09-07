Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 323593EEAC7
	for <linux-ext4@vger.kernel.org>; Mon,  7 Sep 2026 15:50:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788796211; cv=none; b=bu6T0oqeEWQHM+SZkrEG9DMvmNcx93TDhhdxn03ohxW5pPDb0Y7wEh5DS+cMcNQGvsO57k78FHgNUe+/yGRU8qfTtpp2XU/hrPCZ+pL7KmDjmSM3Ua7xpoftH4xXplgV/mXyQD7nENv8fHYIUHZh4dVpVyLAvm+Vi2sAfZglP2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788796211; c=relaxed/simple;
	bh=KosKzGbhz/Q7I7QqTuKUBEwLTyiWpVnrz1wGI1o6akA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KY0gyW47t2cCAK3YeYiB09EabtdsRgxBWX2vbSgEVbI7/Oiy87FiftXSRLe/JHenxAwMDMxqDTAk1u49fv1Ur0yNSSsuwxaoA2jzIs11Um50m8w3Ue7K8z0s0SuExvJxqHxcEdfwrfHHg/mCuBmq5H0STbM1w4aicULry2ZuplE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=q6K2IQSh; arc=none smtp.client-ip=209.85.215.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="q6K2IQSh"
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-cc1cf287ef8so3102059a12.3
        for <linux-ext4@vger.kernel.org>; Mon, 07 Sep 2026 08:50:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788796209; x=1789401009; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KosKzGbhz/Q7I7QqTuKUBEwLTyiWpVnrz1wGI1o6akA=;
        b=q6K2IQShq3KT4s47uMiTOhogdsluGOLjSXXLoROFuMIZUgrTOlWBeTHLlzLcZ3CSqI
         srxm3braabP1NFvchbqBkWDiABeL6eDmF+kfFdXgvcXhn5aJBmVXGomhM23sFZg2RMod
         O3WQ6FiCsrWtI7La69pm5AvIkGCg0XxZqkrIF+Vf9YpwQpbfXde1FFu3qDlrojWrgT6c
         dT3Esz6ZFZyhJzmR5SDvXu2KU9iGdZkMHkJpCgFB9XrSWJltMOff8zpZBDOzfuwGfdSg
         vMtd3Oq4ZQFt6uX4PROtc/Zx8ZRqI628Z8hsFfHi8ntrLbPpTk6XWNOvfHm8AF+cVRwI
         oJKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788796209; x=1789401009;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=KosKzGbhz/Q7I7QqTuKUBEwLTyiWpVnrz1wGI1o6akA=;
        b=n1H0XEvQcYeofHruRRlm7jSDUsN5ARE9t+BSrR2U9BgX2HDviwFMhAtj6uz7zpw8ZA
         3Uyf3Icc7RtZY+UjAfI5+xdDZ2nSv1/cuNqVXedUwAByqxzFNK/ft3G59TM3znbIGgZO
         gkAk09IuytRChrvzTIgXVi8UfQZ4siub90TIkPZM2YSeim6M2LzUr5GrQx7PTt/A3RDf
         rw27rbGTdewICi7F1G+DYJYd53uHvYQ/4dXV9uVon9va6LduEHv0jafWmvqTv6fkE5uf
         eWLV7BlaHTcr7lUM+ciWjBVZssBzCcvwb15FYl/4DE01IrByOb4++C1rdQqsfou2ezR2
         qX2g==
X-Forwarded-Encrypted: i=1; AKwUvBzs091nOyyiiB5sCn1J7zOR21q6ADEGOs2zGHQVofvILqYvHrM0IBgh2DLmKmBxSYVvxlOGqJsYl6vG@vger.kernel.org
X-Gm-Message-State: AFuF++kW7LTKTa5bxchyyolGW6VZ0C1SbRYHYaXLRRpS/NnbByhkz7Mh
	iCNIgK8RkwjS1MpZUPLF8yStHROfNlX7nZ20WKGkm3tLJDgaBeHh6sPw
X-Gm-Gg: AYBFou0mcyCtc0m/jgjv6yPJIzop/vDT5ZzKgvhdPbhGmH+MhluUKImU7k3osq+30UT
	kGMYoSwTlHpy9Bm6U2+Gry1MX7G3ucRKd9RL4XdTVe9pGNfbnW55SI+Ch7K7IQSQbDwKn6H++Ai
	+B6iBirtxLjVq6zwOq64FqNzriQdhyNLu7CoFUv5L1xU5T9qmNsfJy7dZes3kfTLmyuoVNatHxl
	moyo7egMoPdqebX1jGXCCim7w19+qrHwtANz3wrDmVGswonhw8IRrpfItQ2Rz3wTujDa8XQM7Ny
	R+Twq6+wrTS0lUAXB3alW31QKBbE9VFSKT0YI9Xy29XWb+V9VV2b0B5FXPenWHeepSTJk888c5F
	bsaGXDdZX4MqQQnh+c5J12sswCGyqQUDXQYCdHwHg/MsanA3BMmhDmE/avN8LpQfY1BBtFFphUe
	zqmhteHAnmGI6Mby/H7pLYi/PdIVx9Lfn/4qZbg1Yx94/FH+Q1HUi+UB/Yj3LoUY41XnQPBEToa
	pcrMA==
X-Received: by 2002:a05:6a21:138c:b0:3d3:afd9:6040 with SMTP id adf61e73a8af0-3da3a1f77f2mr37915923637.27.1788796209323;
        Mon, 07 Sep 2026 08:50:09 -0700 (PDT)
Received: from thangnn-ASUS.. ([2405:4802:1d38:5c70:f6f8:5cb:5f1:8555])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cc455485c25sm4310615a12.26.2026.09.07.08.50.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2026 08:50:08 -0700 (PDT)
From: ThangNN99 <ngocthang2710.1999@gmail.com>
To: Jan Kara <jack@suse.cz>
Cc: tytso@mit.edu,
	adilger.kernel@dilger.ca,
	libaokun@linux.alibaba.com,
	ojaswin@linux.ibm.com,
	ritesh.list@gmail.com,
	yi.zhang@huawei.com,
	linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ext4: avoid buffer/folio lock inversion in __ext4_get_inode_loc()
Date: Mon,  7 Sep 2026 22:50:02 +0700
Message-ID: <20260907155002.75237-1-ngocthang2710.1999@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260906104841.56075-1-ngocthang2710.1999@gmail.com>
References: <20260906104841.56075-1-ngocthang2710.1999@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Jan,

Yes, your understanding is correct: with foliosize == blocksize the
itable block and the bitmap block can never share a folio, so the two
lock orders can't overlap. It's only once foliosize > blocksize that
the itable block being written back can land in the same folio as the
bitmap block being probed, opening the window for the deadlock.

Thanks for the clearer write-up of the two lock orders, I've folded it
into the v2 changelog, along with your Reviewed-by tag and the
Assisted-by: LLM tag in place of the previous Co-Authored-By line.

Agreed on the broader concern -- sb_getblk() called while holding
another buffer locked is a general hazard, not specific to this one
call site. I don't have another confirmed instance yet; happy to help
grep for more if useful, but wanted to get this one fix out first
rather than block it on a wider audit.

Sending v2 now.

Thanks,
Thang
