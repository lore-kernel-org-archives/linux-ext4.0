Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7874C3CAA41
	for <linux-ext4@vger.kernel.org>; Mon, 17 Aug 2026 11:49:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786967351; cv=none; b=iYE5YsEfLE4MzlZ0aTQrix3nAteoKtOwfC2/geIhg3kPS1GU2fBCXSVyCiGXh8z4jJrEbrT4P70IjJZyBqb4NVxexGfnyD4NIT4fi+D4THdejXeqmtm1ZtDD2YqFLRLipcekhXQxXgiEV5cNl9/Yt/PQj1z7H1WR/ahbWxXktDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786967351; c=relaxed/simple;
	bh=+oHH2oNEdYmqVCEcFHAyqbUQOs4dxsuZY2YxaGGg4zk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hiTP/7H9Xm2hX+X+W9L3DWtoIpTDXhjTF1lLVGDwVNs3Gp7aTDZYObOs7otl7dSGSbMSIc062upSIc7duXZ2Tt9ZrHcEhPESJ9F1fHGzp4H4nvSXTkEHsjjKEftlEJQBSKXTw+2BlorUsaJoH7QlvbTgi/kJKuTJSRVLmJqtqxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HxIlG2Hm; arc=none smtp.client-ip=209.85.215.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HxIlG2Hm"
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-ca766c1c9ccso1749748a12.0
        for <linux-ext4@vger.kernel.org>; Mon, 17 Aug 2026 04:49:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786967349; x=1787572149; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=F+jru68zFVDUG+9X9/jsXrRXwodS8/wdB98bVrjC8LY=;
        b=HxIlG2HmX5UbsKZ/bdgR6Qm2k2nj2N0sO10tZqfyyKbgvPkBgABzb8e91FxGLqXVQg
         iP/+qKuDG0XqjFEuu7NC54ID0rmZOczZQm8nKWdpEOadpTm6ojdwbnnElv40VBH+Zm/H
         5AGzA583c+jTyB6/qrga2J2ErbSVx2lzsGfyJ9SPSpAsWLRY2aJ+AfpI/+mEphSd5h73
         ckyLCGskkiLd6YCUqoWtQR8Yomk+Tj7ZyPaRhTrlt+/Me5OFpu5EdfSByCMS9PrnJnAk
         p8aam4RfYmzMGaRtfms2Qt1C8J8ij4x1b7UWmwZ3gjADNLUFynKjVc6+qLeWOwuCgKGj
         SfQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786967349; x=1787572149;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=F+jru68zFVDUG+9X9/jsXrRXwodS8/wdB98bVrjC8LY=;
        b=dMqDtHBviAVUxFNME4CTPaKrEnuSIpmIEaHwQdITDgzlHZor1dZnDOZRv2gxNXUMnJ
         EL/2hR03ZKd3tC8soyZfLapM8jRQBbzukZu0afM3kbZBN2xyrHhZMXZLUfWiNPkhyr90
         2vrnZBgmXFSeGIM6ZmjSjg+QTtKFtTuFlz+wDH+WY/TLssXmXZYrXoOyTgg5OPxiTIjl
         koVXg/KBxBTsDD3HwWg7/kpQPFqaj7higq3HcdoGL+xUqPIeuXBfAQdWwEliXUW63MQk
         Wq7zmTNb2qpVJhLqe7WJggO6JHEiksHa/vU/nl5h4Xl1jeO2l3616YlJaq/x76JY7WoS
         IHJg==
X-Gm-Message-State: AOJu0YyIXwBMTpNZaFfN41iEtCr0s8JCJJsJMdNtvyQ50tNWwuU6MfAx
	YkWq6gyxqgWEFAyU9ebpVEP/ElHBnbUAeuSKNQEmiRM/HrASSJeKMFGc7QmrugpC
X-Gm-Gg: AR+sD10yIRvUcsfasp5633ZStIhhEwApZJa8WdzBOZEelLF9kR2uMxWZLX5Rpw936fZ
	iOGenWXXbgRtreoeJaBQtmszFiDn0DN2RTqT/4B42A7j9+P+9xFeXDvAEnsjudwN8pdUAGh4Yug
	wnBvDVx3wLL+ePXJMzll9pzecra0fikQ5+eIm5GzSTR/cRyyA/oBRmS602Yv+J/k2YldA9XzfRb
	CmM7zhGAZ8JOw9fFKDzKPSttVvkgLufuNLzXc0G3wmqTVQIgNHuq0Jlem35cpe0AhBsY9tJl5cJ
	z1V1cjCqhtdFeU6ZxS9Qguw7dBHYCIPJZ2kEdVzQII9bw8Taw3I7/x8qOj1NCdkHCHg+aLPHpKH
	CxHB0R22qM1+wjSXpRMJabH+gfbPfiwpO8LCu30/3DcCAoFJs52hOhftmVZUEsVJiibmxzMM2VW
	wIBJikOf+NX7ZbvGAzcD3JNp/JJ1LRoZUc2E/VIo3X7mUWUbMvKmkTbz3934L8BBeaJezRCWzul
	tesauG/+oacFO68kCg7N+0fqEaRVI/fPEba7RrKqeStdOB9ezfGDhB1uiODDlisSk/R03ypjWL2
	t80V8FtqUJZ2nZAq0/CAaZ8ZUBeVGmhDqGH9Bwt7mYFgecZmpqqf
X-Received: by 2002:a05:6a00:3926:b0:84c:2e2d:57b with SMTP id d2e1a72fcca58-84fde76bf46mr22504769b3a.27.1786967349111;
        Mon, 17 Aug 2026 04:49:09 -0700 (PDT)
Received: from spider.bream-herring.ts.net ([103.252.203.158])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-851b6ff0a13sm149453b3a.59.2026.08.17.04.49.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2026 04:49:08 -0700 (PDT)
From: Matthias Goergens <matthias.goergens@gmail.com>
To: linux-ext4@vger.kernel.org
Cc: tytso@mit.edu,
	jack@suse.cz,
	sashiko-reviews@lists.linux.dev
Subject: Re: [PATCH] ext4: compensate ea_inode refs and free block on new xattr block write error
Date: Mon, 17 Aug 2026 19:49:05 +0800
Message-ID: <20260817114905.2708356-1-matthias.goergens@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817100724.923291F000E9@smtp.kernel.org>
References: <20260817100724.923291F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Sashiko's reviews on these threads have been genuinely useful — the
ea_inode refcount leak that this patch follows up on was its find.  This
one, though, is a false positive: mb_cache_entry_delete_or_get() and
mb_cache_entry_wait_unused() have been defined in fs/mbcache.c and
declared in include/linux/mbcache.h since commit 3dc96bba65f5 ("mbcache:
add functions to delete entry if unused", 2022), CONFIG_FS_MBCACHE is
selected by every EXT4 configuration, and fs/ext4/xattr.c already calls
mb_cache_entry_delete_or_get() at three sites before this patch — a tree
missing the symbols could not build ext4 at all.  The patch compiles,
and the fault-injection measurements in the commit message ran on a
built kernel.
