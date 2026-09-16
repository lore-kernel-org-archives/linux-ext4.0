Received: from mout-p-201.mailbox.org (mout-p-201.mailbox.org [80.241.56.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54A5B4FECE5;
	Wed, 16 Sep 2026 10:44:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.241.56.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789555527; cv=none; b=mHcsn0oY6H4BMqvDGLRkvJV3kCzQkgl1QtPcQR4Ilp2lppTuymni9gSpkX7QuLIAAuqTrYSMik8jAkSTKtOxVXQE95tv2Ee8X5s9DBOs16d74mr+9qKoVF+DDkmdqWvpaIqkf8RpcmXLWKSe2cEYDce8dSk5nbVjb6zb4luY7P8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789555527; c=relaxed/simple;
	bh=7e8L4zD0Xm8HDCepCxOzn187CvpONJz72dR1IkEbxjQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=iNnbJCoFkNYYUHS4YwDHrPSjQC+VNzsIvxcWeI5bySAWViId6/Ebo8vBTS8f8BN/9+XFqRL2vLnxLi+E+PlVBF0syFIfDUlLwxK9qzJ8BC0n1sYkhhq+TaRh7j29/TWjjs5puWvK6MgxHYKd8gkrZEPvJDXtVA3SD2Lsug2Heyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mailbox.org; spf=pass smtp.mailfrom=mailbox.org; dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.b=u/8ywcwc; dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.b=X/TyP2wJ; arc=none smtp.client-ip=80.241.56.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mailbox.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mailbox.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.b="u/8ywcwc";
	dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.b="X/TyP2wJ"
Received: from smtp2.mailbox.org (smtp2.mailbox.org [10.196.197.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-201.mailbox.org (Postfix) with ESMTPS id 4hlFrD2rHszMlCf;
	Wed, 16 Sep 2026 12:44:28 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
	t=1789555468;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Uh5ymucdRi2MylCiaaFqi90by3OPOvkWAM/nLZR9o+I=;
	b=u/8ywcwcRxzqJcryZItTzVmVzYAosjXyO7I67IAisNrKuWCwfNsJWRy2KBzA4jzUKP3m0I
	D0XUjv850O4z29QaDFnaysvjZe6vXJ+jg4rDNbXqn/ZFyy0va7L40tveuKcDQmlUGjs8Dr
	KwSeIMX2RDNUTuHIxTyloYMLJI1DvtEMfhROJU5gz7prnCwiN82ycK4S3LPuuR6mLAAJlF
	fJaZjOzeBxMIobg7PYV/zfsmFbigcroeFdiIxsJ9pNTo/DVq4Zy8J0dXuXdE+Xbz7JAE6y
	ohpoPy4chlGYIy5HZNXPPMQD1whmDwLTw3RBPLXlQPAuOKW8kPOutetANX/USw==
From: Manuel Ebner <manuelebnerli@mailbox.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
	t=1789555466;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Uh5ymucdRi2MylCiaaFqi90by3OPOvkWAM/nLZR9o+I=;
	b=X/TyP2wJt+FRIQNxzw0qideQ/CP7dqSOTiOHDDpQ4jajzh87y782omnQokTBzgVTrCo8EA
	QQMR/+/ef7UEtaELnlxzOn5he59XJop4WivWoW5IKkocBe6OI19fdIbuuOPUbcQxY3M32Z
	4LxwtUGQGgSyXY4ltDnjgyV7HThpkek3P9fBennj0dpif5ss/E08U/CzT/f6r4bNzp7p0C
	RIxj22y4fDOwoFlwGdxS0IglHDeBa26YTX9yQ6v/rk2Nqmo0LgFa3HecaF8AcXpElatuaj
	dOcWNf9RRjQda2T5VfXng6us2z8po8K5Flyf8NFOYj35jWnOfjhbiNoBiboT3A==
To: "Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Jan Kara <jack@suse.cz>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>
Cc: Manuel Ebner <manuelebnerli@mailbox.org>,
	linux-ext4@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] ext4, doc: remove unnecessary bracket
Date: Wed, 16 Sep 2026 12:42:52 +0200
Message-ID: <20260916104251.296148-3-manuelebnerli@mailbox.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-MBO-RS-META: 7dd6d9kycmqcedz6cb59uctu6ipkj1ew
X-MBO-RS-ID: 15f51d3f17e7961cc77

Fix sentence structure to improve readability

Signed-off-by: Manuel Ebner <manuelebnerli@mailbox.org>
Reviewed-by: Jan Kara <jack@suse.cz>
CC: Randy Dunlap <rdunlap@infradead.org>
---
@Jan Kara, is the reviewed-tag ok even though I changed the patch?

[v2]
 Incorporate Randys suggestion.

[v1]
 https://lore.kernel.org/all/20260902143254.702971-2-manuelebnerli@mailbox.org/
---
 Documentation/filesystems/ext4/directory.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/filesystems/ext4/directory.rst b/Documentation/filesystems/ext4/directory.rst
index 9b003a4d4..6d8021309 100644
--- a/Documentation/filesystems/ext4/directory.rst
+++ b/Documentation/filesystems/ext4/directory.rst
@@ -429,7 +429,7 @@ block (precisely the length of one dx_entry) are used to store a
 ``count`` entries in the dx_root/dx_node structures are adjusted as
 necessary to fit the dx_tail into the block. If there is no space for
 the dx_tail, the user is notified to run e2fsck -D to rebuild the
-directory index (which will ensure that there's space for the checksum.
+directory index, which will ensure that there's space for the checksum.
 The dx_tail structure is 8 bytes long and looks like this:
 
 .. list-table::
-- 
2.55.0

