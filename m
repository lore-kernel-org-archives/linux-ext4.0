Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B8B53F927D
	for <linux-ext4@vger.kernel.org>; Thu, 11 Jun 2026 12:39:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781181572; cv=none; b=Trt6NEkgb6HjA2ZQ6EVa9Zwu0KzztQI54qwyw0U2B781rpCl8l4xdkNOJo00Ro38VCh0VHsYSOTZnMCsD8egRhWFmeZfoQkNmhKgoewqrHSE5/zAG63ApH7VdbkPsjk8VahZ/CsahBdm3lzRGIrdMuWXlDKvJ0dnpUdstrCJSS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781181572; c=relaxed/simple;
	bh=URmDkykenB/um9KhiVYMPBV0OpZy2zjaOO1E8lGmUPg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ly61bNq4YgnViaI3vNMc1dOqdn0+N1+7WIT3UeLRt4a9EWlyTt34kQN8l8KPqYrHCg52nQI18l19KqvfInnA7KtfORGT307aUmBH3GsRv5kMccLRTpPss9q/AUi+htAGRGZbuhKQd2zFg44rtTVX948lSdmBlTjdABfcjTvhKaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=O39LSg7V; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="O39LSg7V"
Received: from trampoline.thunk.org (pool-173-48-113-189.bstnma.fios.verizon.net [173.48.113.189])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 65BCZT76008259
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 11 Jun 2026 08:35:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1781181338; bh=R0tiixADECE6ISYXWsswQDVR28z/cQd0kyC6RWo1Avc=;
	h=From:Subject:Date:Message-ID:MIME-Version:Content-Type;
	b=O39LSg7Vn64IZ7pKw8Sgw1gBf+6J0/aqrn2VIiHVsNcrEHJZIsQ5BszXciMjz1gZs
	 tVr1Tj+WGq72XQKc4ZYDUlIDnJ2meo8KqSLAauwLd6sWkhHZVYMNSCN91/fwxUEWtr
	 5FWJXPSvfbQVRx/MqnsPRL5XI0R0oYS4HSWBSokO7bZLRYh3DvLoU4dKxhJujdq7Mr
	 qzyKCrIqVJ+pLt6RORG4KAak49Djg898Gp/7KVbjXipw1DtUHKkvd+WbX93p9DhmEh
	 WlSao6VuXXbE5WESC61V/Y7v4j0EGsJykPoOGWuFSmrbAdxUFM6coN+Nlm7EK201xY
	 /b26bBI4RyPIQ==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 1856E2E00D4; Thu, 11 Jun 2026 08:35:29 -0400 (EDT)
From: "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>,
        adilger.kernel@dilger.ca, libaokun@linux.alibaba.com, jack@suse.cz,
        ojaswin@linux.ibm.com, ritesh.list@gmail.com, yi.zhang@huawei.com,
        dmonakhov@openvz.org, Yun Zhou <yun.zhou@windriver.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ext4: validate donor file superblock early in EXT4_IOC_MOVE_EXT
Date: Thu, 11 Jun 2026 08:35:21 -0400
Message-ID: <178118128408.522716.2733476893640078813.b4-ty@b4>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260608152521.1292656-1-yun.zhou@windriver.com>
References: <20260608152521.1292656-1-yun.zhou@windriver.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit


On Mon, 08 Jun 2026 23:25:21 +0800, Yun Zhou wrote:
> Reject the EXT4_IOC_MOVE_EXT ioctl early if the donor file does not
> belong to the same superblock as the original file.  Currently, this
> validation is performed inside ext4_move_extents() by
> mext_check_validity(), but only after lock_two_nondirectories() has
> already acquired the inode locks.  When the donor fd refers to a file
> on a different filesystem (e.g., overlayfs), this late validation
> creates a circular lock dependency:
> 
> [...]

Applied, thanks!

[1/1] ext4: validate donor file superblock early in EXT4_IOC_MOVE_EXT
      commit: c143957520c6c9b5cd72e0de8b52b814f0c576fe

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
