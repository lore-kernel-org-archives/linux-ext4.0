Received: from mail-pz2-f43.google.com (mail-pz2-f43.google.com [74.125.228.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88D773D1AB9
	for <linux-ext4@vger.kernel.org>; Thu, 24 Sep 2026 08:30:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790238647; cv=none; b=gWPAjIvwKzvpvyBn6GqqqXeXsdiTZ1Q9MnpKGSmGMfasEJjkw85CcgcFMmxQtZewbcGusM8Y3apn98s9rkaE5BLt76xGyXjnlXXunvrYt6cBT4WshlQVf3PW72/s7GnyH9/KFIyFWmC9cHyk+K9yqmwHVZOBaasqWgbjz1rqJ74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790238647; c=relaxed/simple;
	bh=qxMRa6wv7QbTUusk+oyaNLAJ4H6fr9e0rNV85IN4SmQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Db2c1mgGnPbKB7g9ai508pHeiKS3sdhlsFn0RHivRHm+RPCgx4TdBpgCJi063bm1VHDYMcJR8hLl7T9Ud3feBjVDZUzr9PHwQsHeZjzcxEgmqD9dcNz9GxOhwWHo/zT1qMDSdPeVAeOMOrCB2mXt3ZKth1CMabfIdDfptYgY2yo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=d6zw2C/o; arc=none smtp.client-ip=74.125.228.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="d6zw2C/o"
Received: by mail-pz2-f43.google.com with SMTP id 41be03b00d2f7-cc4aa0f1a94so796533a12.2
        for <linux-ext4@vger.kernel.org>; Thu, 24 Sep 2026 01:30:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790238644; x=1790843444; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=V3xohSHDe0tgmUB70SuwVVW9cXNJnwebFomuNmYEMJE=;
        b=d6zw2C/ooxG5HKAblE0JoL+C9LfdwGd9gIuBJs5RHQSsY53jydGaldBYCaGwWL6iJf
         S2FqR7n06PpFr7Lb4bAYfcMrZSsu7vt490BQC9sR5hI3xLrYpugDoUlDFGm+wwPsIFMY
         x/Wd2OVdGHaXw2vv20LnbyY458HGKINWteCLhL6t4jg0YKyUEhf0h3pTTc4KljpD4w34
         VEm1lAliOHeJJbRBsXRJiFks/86fOne0qu5uakr5wJW/tQsZuu/iMhe1B5NF+cnK3zFb
         YQLZjO+AzGwLSNcrVDPA+aWpLjbF22CyYttZY6dXKvQmJkfBDpxRl2qwpOrF8C++ypKe
         MLHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790238644; x=1790843444;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=V3xohSHDe0tgmUB70SuwVVW9cXNJnwebFomuNmYEMJE=;
        b=nvtB14RF0VwJ9NSQOTDeTJRxJcGsT7WF98S2tJ2Z+JMAUEnjKePILBfRJharC8/wXx
         NGs/HnX0EjJ5Bhx913vCaIFrpjuujTNpXDNRNnBo68KQc2KgTBM4ejscC5kYDmGwUV7S
         9R1gJAeCSRvvhDbGIQvl6ThEDHypNuH0CG4IRcQbhOVQbqfQCJE2wO6JJiImN9xyBXde
         a2foMcYTA+ueGrhtBgelSm2fpMtplbxGWfHCJvQfqNTmejJ7mtzANnIF2KplJOpQ/EEm
         A9FjwmTKTGoP3IkWEsnSm8uk5H739M16/bKYZ/eTlJbGBG1W2ZFFZMQ6Jy1iI/vlWKBp
         POcQ==
X-Forwarded-Encrypted: i=1; AKwUvBy014ojRn9eWf9ozE5BIpS0w1esUxv4yySz/lEDdve80D7vsDX62e4uw1jdKFFrvHXL+N8Ol3EvNE6x@vger.kernel.org
X-Gm-Message-State: AFuF++mRQEE4jiHooLu1p2m5KsKBIkWD7gbtA829fmMN9fAMenouborT
	zgWehKv+q9DbS+zNKbYCzASEbBAeTdz/ISrX6ASlwoxsiOfmI718ZzEjRRnh9jyR
X-Gm-Gg: AYBFou3E4g91YAU2LeU376OnC5X5DjI7kRjaw+7dvwYTbifNnlU79QfozL28JiUfH41
	BSmVu8lQwFK0ZSWXxvWFveqY39XUa8UWuveZUgLIlu/VY83UxLT8g+hR6feBxybXrsxDipTC15J
	xZKJSNkw2EJtxyBIAgCDQxmRnZpWRquPsesZzWOXbbPQn5Ea/PH11IWZ50ICFlN2YtKP80tqFjz
	onK5DvEkwe3onnwc+UL3Fl6esKAdZpD7ZqSn2cool8ugN75K8QkYSSWbOTZGTICyvS9LnQGT/F9
	l4RCv59UEeAdUfcbRyHJHTRAIGkg3WsSsc9TU/AEpxlMtMK/PAhjgEoGeMjS1WHFjavI0ZK3DNk
	3wZMEmrp1w5TVeLSHjJ0xZujefPNLPbe8PB4iDngFvB76Eyw+dpfTnvlPMPf57rXLJ4GMVPTdJX
	qa8WO4B7zpub/1QiH5AY9p1uEowklrPOEsfbxqrCggVLs7nT6qsnSL0H/60qXl7AF2RjDMKFypW
	RfWhuUvOPX2XH8fV2VQTK1W1baE9fkvxWC/j8YF4ze4WRzSPMeq64STNyJ2yagIg/MITLluqUt0
	4Yl3vIjxpvk5WteMTeUXOyzjgHOQuWjZTs/2C9v92vA9MMQu0MQFIk8SsTmC
X-Received: by 2002:a17:90b:55c3:b0:39e:3559:12df with SMTP id 98e67ed59e1d1-3a098b98d43mr1515081a91.1.1790238643849;
        Thu, 24 Sep 2026 01:30:43 -0700 (PDT)
Received: from spider.bream-herring.ts.net ([103.6.151.236])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a0972b15f1sm3467314a91.2.2026.09.24.01.30.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Sep 2026 01:30:43 -0700 (PDT)
From: Matthias Goergens <matthias.goergens@gmail.com>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Theodore Ts'o <tytso@mit.edu>,
	Jan Kara <jack@suse.cz>,
	linux-ext4@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: name the ext4 dev branch
Date: Thu, 24 Sep 2026 16:30:40 +0800
Message-ID: <20260924083040.1744688-1-matthias.goergens@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260924040030.GB5048@sol>
References: <20260923101749.3505886-1-matthias.goergens@gmail.com> <arSMwd1bGO1vrif-@mit.edu> <20260924033200.3615554-1-matthias.goergens@gmail.com> <20260924040030.GB5048@sol>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Wed, Sep 23, 2026 at 09:00:30PM -0700, Eric Biggers wrote:
> Explicitly documenting branches in MAINTAINERS sounds good, but in
> addition to that, HEAD should also be made to point to the correct
> branch (at least in repositories where there is only one main
> development branch).  This can be done using gitolite's symbolic-ref
> command

Thanks, that's a better fix where it applies.  I'll mention it in the
per-tree patches, so each maintainer can choose between the two.

Matthias
