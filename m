Received: from out162-62-57-252.mail.qq.com (out162-62-57-252.mail.qq.com [162.62.57.252])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ECD9846A
	for <linux-ext4@vger.kernel.org>; Mon,  3 Aug 2026 11:10:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.62.57.252
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785755414; cv=none; b=W/OIUQzkmOKoLba+Zin5gpnfDHqsiee96uTqiyY1BEziXF230aLLP1f+iD+TXqH29mBCVRMWv4fMqhY5VlrSsTuFizdykQGwcymvUAjQpVXveObdQ3OTfpXJAl5fdaG5SeKd4krGRveNqzjRF8mxvTp7ZXwbPtwr23HtTgXxFU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785755414; c=relaxed/simple;
	bh=f584setxpECfnm7BPaDDv+uJUDD8kynlWOGfVBnHxps=;
	h=Message-ID:Date:From:To:Subject:MIME-Version:Content-Type:
	 Content-Disposition; b=Vd4qeSQTVQpM5FWTVUpXtL1/Q5yZsd/kA4WiPRxSTPoIgB6Olx0OTBJtTFEffvn0Qxn2kCd8DW+Ue4nko15I6FPyIKPXH9czraG5zuEr9m7Fe6XuwUHoiJ5fe1cH/hjayj2V/JQiioFAZgnOViD3W+HB5a2BBxM92roR2eokfYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=OjudgUVG; arc=none smtp.client-ip=162.62.57.252
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="OjudgUVG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1785755406; bh=LxZWIoQtgsbZZGLSKs+vVZvEI3iXtgx5akvMC98+KCI=;
	h=Date:From:To:Subject;
	b=OjudgUVGYSfRY5EKKZwL0gtxoTFSxtzyzL6pZIyL89Osm2fB9BEyqoTB9TqH1HLSa
	 4spSgWKQ9Os3b2BB9l+w2P/uz4j6CNBqpjsXU6Sy/9pgkwQrGrtGssv4T6kdcm3Nca
	 Zja8aCoajOvJ+vyhzwp7b9qf4mPHBe47nx+2FDpk=
Received: from DESKTOP-AT5F202.localdomain ([183.242.244.64])
	by newxmesmtplogicsvrsza73-0.qq.com (NewEsmtp) with SMTP
	id 283BAE3E; Mon, 03 Aug 2026 19:10:03 +0800
X-QQ-mid: xmsmtpt1785755403t2esljuac
Message-ID: <tencent_815048083723E7EA4309DA0B7DA35B78D106@qq.com>
X-QQ-XMAILINFO: OATpkVjS499uOj/285n37e+rSgp7RL14oOv6VrmhHqaD0U8F+ol3+2TtiEPoEl
	 8NUy3NL5guiWi+LbUI8FPJg1yPHW0mkLOVRWqi5d+OQ0z9EyygTw0/6JaMIZns6Yz9O74uMTwZUi
	 QljTvOsa02ZZY9BitLef5MiRsoqdxd0e021JL22yzULWEX8Y1Wa3z+lZ9oZMnubTM7f2uVeJgeH1
	 BB1OyhovHIo6iddfIJ5+arXinwItwkVaBMj/AYoa+sjXKpJgj8U2y/TpxdxgAYEIk3spmieYWJdx
	 9MAKdlqud+CuR+d2/NLZmUJ4SK1QYJ2xgyp5EAMKQSSybRfrHJ0kwjzwnkr3MZe1HRdohc+alCd+
	 08s/Ekv8FuXNxCIatAiBEYIulnIMKMb6LHBi0j/1O19JudnIY59EbllrZc7QRCScjB5O5y+uxLNh
	 q0eZNYnSzJl7anFFn2fE51CrBk9iYbdCBr8IIxpre43kbcZqjf3TS94okZ/YcvmmEIkoiOAkqtqz
	 U9Dc/yN04v8mLHlW66lfwD6icNF+P3hkuy+DB1GzsXEe2impG4gxwCkdv3oXPfWe7Lxh5ds6DFS9
	 S4+eNaXHrGfIxYU5Xma9muAiaK1y/jKBcggRQRyFyyJLl8QWorvAdUOKEgnVu/FC5ywv6w6YUzg2
	 YmrSGYJa1sWGNymT3G0toqJfGn1ynwntZ0Ezc9GgZG2Yfnb2sFCppnJh2+P/EwxDKftEl83w1lps
	 u2CriVwxBsN3K+a/xFGVc2YESURlKjgqZaXMgZEEWJc2VYYDtuLbWPSl3ioQBs/y4lZP0NHyT0rk
	 IizPZ2Wa0JQb0gknO1nPlSnrgZoGQKlo9RC2Blj8pebU3YJYtP0bY3zgZFodoeC0XQ7PISCagGrP
	 YMCNw0TZI0+i2YMlgDOWNXydxghM6S8hQsx+tlbwK9gM28j6nCJfnoeqATXqiF/onaqKPVjvgnnr
	 DXhvZr3jwtg8JJa22A61H15KPrDzk0OgyQe4xvHCQaqO2dtoc91WJnKO6LqkQQc35dOnWFr4r1J0
	 +o3xmQJty+1HA/MM34Wp3tlK2Omo9BwfEmpFaOhlG3lh2v/2ZLzYLiyxLm0xk2/gLndk2/SCuuaL
	 YE4m9U
X-QQ-XMRINFO: M/715EihBoGS47X28/vv4NpnfpeBLnr4Qg==
Date: Mon, 3 Aug 2026 19:10:03 +0800
From: shuo chen <1289151713@qq.com>
To: linux-ext4@vger.kernel.org
Subject: [PATCH] jbd2:remove unnecessary finish_wait call in
 jbd2_journal_wait_updates
X-OQ-MSGID: <anB3C3_3_caqvKyW@DESKTOP-AT5F202.localdomain>
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

