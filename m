Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24C9C4BD119
	for <linux-ext4@vger.kernel.org>; Thu, 24 Sep 2026 21:04:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790283873; cv=none; b=nFDMeMMcHQWEzG6Kn5JgOWr+caRWbL/wW95pCUMh57Z5kA+zBHVQ65sGiSB+FR818vmaxaaafNZlLoF6jopuwubmOtkF2Myx360xbr4o7QAJjqlqJhEU8KZKW/PslUKTIbUwbSucEVSZ3J2USAME4Rfqh8nyb1hyCDad0UzUiNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790283873; c=relaxed/simple;
	bh=kqwIjf9KDJziG86ZcsZCg6ozRTfrhg0rt2D1e8BaoVw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=YVTz7dU9LY/ZvLs5q2amomjfgIxNrMlrPAqfxbdw54e0Y+OI7ojQt0TdFyI4rMqIAqBFinxOY+QZXnLKeqiDPxDA88/IQwyMjQwesUgNM68IcXzjUcOtySqhERnYVYtVX5QiCaUjolGm8a/qh0OgKxaDy4YXGBMp0A30XR5+784=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=O+4NUHdv; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=llRHnAeB; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="O+4NUHdv";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="llRHnAeB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790283867;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=kqwIjf9KDJziG86ZcsZCg6ozRTfrhg0rt2D1e8BaoVw=;
	b=O+4NUHdv3t6uwdvMKPLgcdUT65/1bv6rMqK+tEzl5A80qQFr1bC2U4XFwUwha1jkzxLUeQ
	Trlv6l3YZOlF7Dc43Gh5ddxIrWsxvJ1J/Y/ko0Gx3XzaLrvLvM1JFkNME9Ivs0dB6s+4NA
	xjM8/ReFswO9OITfHWcFLdNRmeutMc0=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-244-Dxrhho24MBiO16F_KQZEig-1; Thu, 24 Sep 2026 17:04:25 -0400
X-MC-Unique: Dxrhho24MBiO16F_KQZEig-1
X-Mimecast-MFC-AGG-ID: Dxrhho24MBiO16F_KQZEig_1790283865
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-530f968ccb3so4462321cf.2
        for <linux-ext4@vger.kernel.org>; Thu, 24 Sep 2026 14:04:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1790283865; x=1790888665; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=kqwIjf9KDJziG86ZcsZCg6ozRTfrhg0rt2D1e8BaoVw=;
        b=llRHnAeBA83pnOTsMXlFdsT1UpupPsqlkfaQyyQ4iI88RvFGQFaSgXSYubjVERITaK
         TZr1zoz66b8+HUgNbNbPtXo4OKBpHFvMrk7lIDtOrD0LQngNABLWA5jlKMKH2zQRbAY9
         7L2/mtXQFJoKvT40W9xddqHwHz8GNwU179+l7b8xXOiBz+UPqAr23lZk2T0neElo9Dv/
         LdCu75pm80q6BhxH7aQ9cyOBZbWTHF5lxP3N747sx/fEHsXA9MCpmwnySk/3OiUAk8FE
         GlXc5EDOLqtljgC9w+W77EtMDiTM+hZg66ULgnc4DxAaYShNze+vQ9o22f0evVE6YcmC
         QxhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790283865; x=1790888665;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=kqwIjf9KDJziG86ZcsZCg6ozRTfrhg0rt2D1e8BaoVw=;
        b=ZiUomgPhTJ55xxlATU5Fs5klhJ/mmi+hrMPVzB+i0U/sXzvR77ZlrFc0SAzEoYFSRb
         Th7rnv8EdrFDxTfcLYmGH9kmKJn0F74RShlEXegWPU8ZWeAdPUZfQsMdTflE/exPddmv
         8+X+68zBKB7vZmueqV0XrGTvlfbtQw3KSbDlEI3UDwj1pEs2RL4z0i5CMtO4SWNDMPdO
         gnh64+HV2iAWLGGNGS0I6608zBN4lw0FGHPG71E9z+Kd//F4VLJI2LkJ3C3PwU2RXthJ
         FrluYuVW/qY/ARMkq2phPQ83t7Ek5lQGIGwbtaQqDl3m9vxqy1HAO+TXKhyD14lzZJ9H
         Zc9w==
X-Gm-Message-State: AFuF++m4ZLw0Idzcj/Hlmu23eFlp1L4cMn3O/8MI7Q3+GI4Ua6Z4dumx
	R4mxcpu9DwCPdW4YluL1LMVf9yVbl61TW82vIKs59sGKBSY0wESeq1I8+EKvmInEorUImq8gElT
	1omfGlYdMGcG6phT/BgXP+GaO4S4YzpHl0Pzd5pBqWuh3l/afRlP5vJ//HzR8LUFWA9N/oGmQkY
	9Gs39oXilhGJujHOMbVjoENqYNdptUlZ56Eia8gStZnujVb0MF
X-Gm-Gg: AYBFou0d7MLJvAS2FCq+DQdYZC5Yn7tikVHrSYcgAJXRsuKrR/xXHUsbXDCaSEtJ6AA
	lOf+zFWOyDPE9uIqY6meQP24JI47bcOraQErpDlL85pZcYz6/GB7XrCZAhlDbP+TaMv+AD0EajS
	K7qChRVu02lwPpG4NFtuhxALbMdDDcW6D3WNhpUiJ/519yzP1wKCylfTce/Os4bibBT0KpNFdq8
	sanyotctnqUv6GHxYkkfDhrzEa7kA5fx96rnUW2pex17XQgYp+sj39C7uvHzN0I6MNgeJ3lhTOa
	lbw+C5JSsCyVKXdFzmqKNlZM2k41QLd5JXtbwPXOH4r/khzYrfkESpS4cCeqa4Enh9XzTv+Qjb+
	ViXRq5+yimvMofSp8VBB/89evIoVjoifSYqOzuw==
X-Received: by 2002:ac8:610d:0:b0:532:9e91:7db1 with SMTP id d75a77b69052e-5330b6b94a1mr10075431cf.45.1790283865004;
        Thu, 24 Sep 2026 14:04:25 -0700 (PDT)
X-Received: by 2002:ac8:610d:0:b0:532:9e91:7db1 with SMTP id d75a77b69052e-5330b6b94a1mr10074831cf.45.1790283864413;
        Thu, 24 Sep 2026 14:04:24 -0700 (PDT)
Received: from big24.sandeen.net (97-116-156-223.mpls.qwest.net. [97.116.156.223])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5330c06e5ddsm2112091cf.22.2026.09.24.14.04.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Sep 2026 14:04:23 -0700 (PDT)
From: Eric Sandeen <sandeen@redhat.com>
To: linux-ext4@vger.kernel.org
Cc: tytso@mit.edu
Subject: [PATCH 0/4] e2fsprogs: blkid: misc fixes
Date: Thu, 24 Sep 2026 16:02:44 -0500
Message-ID: <20260924210421.3631790-1-sandeen@redhat.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is a series of LLM-scan-inspired fixes to the built-in blkid in
e2fsprogs. This has been lightly tested against trivial ntfs and exfat
images with labels, to ensure they are still properly read.

