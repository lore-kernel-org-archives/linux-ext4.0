Received: from 15.mo583.mail-out.ovh.net (15.mo583.mail-out.ovh.net [178.33.107.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E59855D86C
	for <linux-ext4@vger.kernel.org>; Wed, 14 Oct 2026 16:30:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.33.107.29
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791995441; cv=none; b=iBeIa3ZclEWCtKu4hAyQOJkWUq8HzXyPajWjNdu9EwEfryN6Kki0FLM5VDVVhDHphO7PFTscVaAj1BW0F1KHrH5BDV6ECOdVSAzTEbPIqXM2dc8TGKAfhb9llkkxdULnLA578OIitBW0HNdZle8SFrm6Ga9ajYBx74g+LQ0B8SE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791995441; c=relaxed/simple;
	bh=TYtYdXUsdW2Bgbj0of1rrpHBCaxBL/WJU5cUe8oRie0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=eF3nHQWY3M3PPP7SRKccXabFSYOiksQMZETYILyVUD1lphHmumPQBSlYOM+9ZOYbMp7QSrCn8CluIcTXd+MZJVxGfICDzIY72ip/iJqbPcmSSsgoppounWgjAM47Z9MqXq1bcFCu6E7m5G2vM33QJoJvDYiVvV6fQW0CNOzWKzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sk2.org; spf=pass smtp.mailfrom=sk2.org; dkim=pass (2048-bit key) header.d=sk2.org header.i=@sk2.org header.b=JZGYR0wT; arc=none smtp.client-ip=178.33.107.29
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sk2.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sk2.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sk2.org header.i=@sk2.org header.b="JZGYR0wT"
Received: from director7.ghost.mail-out.ovh.net (unknown [10.109.254.207])
	by mo583.mail-out.ovh.net (Postfix) with ESMTP id 4j4cBc0VSrz60YK
	for <linux-ext4@vger.kernel.org>; Wed, 14 Oct 2026 16:30:32 +0000 (UTC)
Received: from ghost-submission-5474cd94dc-54jct (unknown [10.108.54.179])
	by director7.ghost.mail-out.ovh.net (Postfix) with ESMTPS id 7331AC00EC;
	Wed, 14 Oct 2026 16:30:31 +0000 (UTC)
Received: from sk2.org ([37.59.142.96])
	by ghost-submission-5474cd94dc-54jct with ESMTPSA
	id 4JDAECeuz2o+bwAArWaaig
	(envelope-from <steve@sk2.org>); Wed, 14 Oct 2026 16:30:31 +0000
Authentication-Results:garm.ovh; auth=pass (GARM-96R0019bfdabee-4663-4810-a2e9-75780c991234,
                    58F39AC3C6885B12E77626CC8F19CB2AA97F92B4) smtp.auth=steve@sk2.org
X-OVh-ClientIp:82.65.25.201
From: Stephen Kitt <steve@sk2.org>
To: "Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>
Cc: Stephen Kitt <steve@sk2.org>,
	Jonathan Corbet <corbet@lwn.net>,
	linux-ext4@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] docs: ext4 filesystems can be converted to 64-bit
Date: Wed, 14 Oct 2026 18:29:20 +0200
Message-ID: <20261014162921.450235-1-steve@sk2.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
x-ovh-tracer-id: 12549280362310800188
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: dmFkZTEsbPbKHZOPgPI/mX6A7CnYR0LAqhjLaJ8Hsv+j2KcA97N26MkQmccjLi+Q+N8FeT3jmxY3i/wb77hVwtDV9GLwBgh4NDmlg+Hu13U3TTDHBYUNuwyth5NtCg+0V+Gp2K2t5Q8ehEWP+H1p3nmCimE4Sv/MWnOarWHliLmaXR4KKhekqih5N519b2fT95vQrEMqJlC40UFX+KnQsYN5Cg1KztDkOP9yeCWBxjI0cEoLp8smDOtTu87EYT3L5/r2I8Din06AJiWV050rWiJX/dW1rfuXYB4/uEcdkK2aJyX7vEGQhBF84Y4MQzPeaAp9IqUDJ0Y0jCWc2z5XVZS2LSlRZusWjuaAQ3EuGIVe2QyeSbp7RKtLz527PgWVUZx0ZUkuYzTOcyUTdzTHYRTT//VdpKkgke+GQcG0xOdAg/NIdvSwqir4ZZhzzpwQ191X3meFv9QhpE7hJsD1x8c8zb4DcsmUi88svHjsTSjOxY/7VuGIonX9OYGB87rC34efz6670bDdN+MB5dZleKxXhVi2cmkizpFOBf6sCCoTd0C0+PDYXMfp31n81EOdi9U5o26FANGjGZwSL9ZC2DDqR3up6fQp8rMzrMDJ7F7tanO7+XB7ti06UGi/U2ekL33vjASh23zrgY9Wciftf+xFOnjdbj9dJiCuKuJJummELSBZUA
DKIM-Signature: a=rsa-sha256; bh=bMGDprWDfvd4xUWzv9mBDwkTiIxwCEOXyHkVqN5mtQE=;
 c=relaxed/relaxed; d=sk2.org; h=From; s=ovhmo304764-selector1;
 t=1791995432; v=1;
 b=JZGYR0wTGI0ehWgWaMs9Cmhu/DWAOk+xrOa8tejBOPFjE00Ff4/wFo3z3+PMJfEx1eSbVvy4
 gD7Uzm+aRkRWIrpjRrvAxJQkJ6+o4YaZnvI0B0EfzZ0geSf7faQih69MyDyJqIqm3s6sGpgJQ7V
 IKfVID+lgg92rNKDxB+immNrFWZ0lRhBZWZvSYzLGgj98I1BJXWHht9AKzP7bok3NxHVqX5yKQo
 rYxSmFkUGtMO3Q/f7EiT6/zLcOJZJ3SjdP98WEpskvb/Z3liAey0tauMpioHp4WNKop/zAgIvEi
 T9ikpDwyGdOPrh+y+XbwXsSru8Qg+e6FwYGKRG58LcHBQ==

Since commit fe12931 ("resize2fs: convert fs to and from 64bit mode")
in e2fsprogs, which shipped in version 1.43, resize2fs can convert
filesystems from 32-bit to 64-bit and back, so the mention in the
checksum documentation that this is impossible is obsolete. This fixes
that.

Signed-off-by: Stephen Kitt <steve@sk2.org>
---
 Documentation/filesystems/ext4/checksums.rst | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/filesystems/ext4/checksums.rst b/Documentation/filesystems/ext4/checksums.rst
index e232749daf5f..51a2150a1bf8 100644
--- a/Documentation/filesystems/ext4/checksums.rst
+++ b/Documentation/filesystems/ext4/checksums.rst
@@ -10,9 +10,9 @@ of October 2012 the only supported algorithm is crc32c. Some data
 structures did not have space to fit a full 32-bit checksum, so only the
 lower 16 bits are stored. Enabling the 64bit feature increases the data
 structure size so that full 32-bit checksums can be stored for many data
-structures. However, existing 32-bit filesystems cannot be extended to
-enable 64bit mode, at least not without the experimental resize2fs
-patches to do so.
+structures. ``resize2fs`` in ``e2fsprogs`` 1.43 or later can be used to
+convert filesystems from 32-bit to 64-bit and back (using the ``-b``
+and ``-s`` options).
 
 Existing filesystems can have checksumming added by running
 ``tune2fs -O metadata_csum`` against the underlying device. If tune2fs
-- 
2.56.0

