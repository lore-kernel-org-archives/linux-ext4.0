Received: from out203-205-221-239.mail.qq.com (out203-205-221-239.mail.qq.com [203.205.221.239])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B857403AF5
	for <linux-ext4@vger.kernel.org>; Mon,  3 Aug 2026 12:35:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.205.221.239
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785760556; cv=none; b=N+jKK/P//8faFDhovmYCI/hLIQgswC0d5nr0RJMonud35Wi3VdoPabEi8K77umIR9wTZKbQSxI5BVlL3RdEDWVyZjGLnv7/9UnRKB6atIkkYSSjE2IPoX7+cs+3gJzrLw/Emc9rNDLimloZ+h2jUfUwhA1qMoBQUY4i+k4kiGPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785760556; c=relaxed/simple;
	bh=f584setxpECfnm7BPaDDv+uJUDD8kynlWOGfVBnHxps=;
	h=Message-ID:Date:From:To:Cc:Subject:MIME-Version:Content-Type:
	 Content-Disposition; b=hluGJwIJXztgnRp6ww2lC1WEwhnwJgBVR28U25PVTwTnyVxX2IPMIJ1RLLn9gY0IfC4RfwnBrWhcNPEMsWuRixwjerxhIliIfOLFt6GIo441dZDKUQR8j3Hcrr7VDzV2hoPlyd6MEWA7JM1Mzq6xKR/B8auL9H9QEDucHQ3Xdv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=syHy+By9; arc=none smtp.client-ip=203.205.221.239
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="syHy+By9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1785760544; bh=LxZWIoQtgsbZZGLSKs+vVZvEI3iXtgx5akvMC98+KCI=;
	h=Date:From:To:Cc:Subject;
	b=syHy+By9Ek5v6Elo1LL1ooTebzMC/llOZ0jvAIBLyKPgUxynTvJcsOL7us8p39/dk
	 m/bVeDLt1iWzAPsZBJvoHk0h/gLVn82hCNNvuRH9Qm6zj/iwg31fW9V4n/3e7K1zSe
	 qmj/jh5FJiaMBQwkK0WOXOCHsRvypwlV1DsNiMs8=
Received: from DESKTOP-AT5F202.localdomain ([183.242.244.64])
	by newxmesmtplogicsvrszc56-0.qq.com (NewEsmtp) with SMTP
	id 8E8B7628; Mon, 03 Aug 2026 20:35:40 +0800
X-QQ-mid: xmsmtpt1785760540tjpm3i145
Message-ID: <tencent_AA7E2FDA8D68E1E3430F219A8C3DAB442508@qq.com>
X-QQ-XMAILINFO: NPa98HB0c72No9BvqbN27YUNQiLtTYejGpEOrX+eRYIaJsMAcOFblbXgPvw5in
	 ngWfWpnqrdIyaCNcjMPBuihvpp1KBhQmqHTSLdqjRmaD6uDblKLW9h+PjKtMY7wav2wbClSu1FuL
	 SoiRYzk0uaVAxV/8TVYONW6EB7QeBT+qYS4JDrBoiUu+0C+X8gXYcNEPHC+pTs2VZSoqsj8vFqzO
	 JU+mXJwZ0ICpffMYuyAhjPUstUtcH1vBm9PNvoYmqvRvbiK5aMrppdNKM+KUl/G4pDygAQubYUVs
	 PRseucb+SEv52C0BEJGk3ZR0GXCGU80aYjZOACd7SMxX/c2LFfYN1Tl8Xkrk2RxT1c074J/e+Cri
	 jfTcn3UNNeVS6G1zjJ78T0ZU3YNx42loLU7bvj8kTTjSuxifcAmwRHpw9oCcYSPjyTHjA3VJDWSh
	 cG0+2UyXy2mTzrYMbeg63H1H2cyqvUQqfm4/E7bOD3eA5GpW+iyu141EvvbRZ5GRw9bxnL/njJ22
	 5opTsTvfIgSstJctpxFsFCLAQs9kWfWEZ8fkp9zIDI+AYvqHGNog9Px+EHLrnkE/PircVdM9TvBS
	 INPFYeXzgZouCPmmStf0uxZKWL/DFqqwv/KgLti0IISYrJ9ZzT5x2pFrvS4RqA+VFcTshRO9vflS
	 63bcCDGeYfF29yqNNuaxfo/KRojtTrtdkz/sngaa+cyuHy1R/7Cih8Ism8cFMHf2xbdx3pQ/uilp
	 leBrmgLE5fCmrDTu1C8CPK8obnHQemZaDCWfeX6OS5iTICbwUWBhY9EPQjhIAvyLCx9V2ExnHa60
	 sBKZoTasz3M69kAPeMGn2Qaut3nIS3ew6hTCKBBuG9Gx6kQfFRHEJvstYC4klIPKQ2I38T7DC6t9
	 26yAsI12WTLoCa28B9YR3nMxouMi+OZsOG60g1cfAO4io8uZFs+cD1m8UO5uprdzS2k8DZpXiJgA
	 OJtM3jupAOP+MXkiTNEcYruhqyA59MrpYlUQD0T3nyHILiU5tXzbFb1pwRXyMbZaTWBFk/nG+Pwq
	 7ftUMdIiyR3/EgHedux5hTPusDjMC2Cgi9SJo9l9fnhnKXcEEiYiNmIYinFsy4mbHot00mww==
X-QQ-XMRINFO: Mp0Kj//9VHAxzExpfF+O8yhSrljjwrznVg==
Date: Mon, 3 Aug 2026 20:35:39 +0800
From: shuo chen <1289151713@qq.com>
To: tytso@mit.edu, jack@suse.com
Cc: linux-ext4@vger.kernel.org
Subject: [RESEND PATCH] jbd2:remove unnecessary finish_wait call in
 jbd2_journal_wait_updates
X-OQ-MSGID: <anCLG_j02EFYoV3U@DESKTOP-AT5F202.localdomain>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

merge transaction and atomic_read(&transaction->t_updates) check.
remove redundant finish_wait call.

Signed-off-by: shuo chen <1289151713@qq.com>
---
 fs/jbd2/transaction.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
index 5cc7d097b2ac..0f193d02a054 100644
--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -831,15 +831,12 @@ void jbd2_journal_wait_updates(journal_t *journal)
 		 */
 		transaction_t *transaction = journal->j_running_transaction;
 
-		if (!transaction)
+		if (!transaction || !atomic_read(&transaction->t_updates))
 			break;
 
 		prepare_to_wait(&journal->j_wait_updates, &wait,
 				TASK_UNINTERRUPTIBLE);
-		if (!atomic_read(&transaction->t_updates)) {
-			finish_wait(&journal->j_wait_updates, &wait);
-			break;
-		}
+
 		write_unlock(&journal->j_state_lock);
 		schedule();
 		finish_wait(&journal->j_wait_updates, &wait);
-- 
2.47.3

