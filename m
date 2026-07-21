Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4943360ED8
	for <linux-ext4@vger.kernel.org>; Tue, 21 Jul 2026 14:02:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784642523; cv=none; b=SxtuSTeh3bDpO9cEiYH4zbskervli9//J6ADj6cXUmgZcSgAt68Rotgfeb4he62s/7DD/uvScJRqwf0cfV3VKlXeDx0mqg2ZNRDe+5XEFIR5hknBHf7jq0rRaE49Smqf3bEgMtS+CEXqfUBeTxMfg1tOYNx7sDn7TKRVd3bV7do=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784642523; c=relaxed/simple;
	bh=Mh4zgufTUSHxlihwEt3MfeOBSZ9TNiYiZLDtvh93aPs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZqCXew6MKkE8TtBW81WhpW8UZTzlD62/v6iR9QgmaagMdTnN3swdsCbhsrC7Jy64jqC6QextpsAh3KRTWK3/EdAw948z57vrfib9MLpBwJR4LU0oulFnx5IWudlALC/XXteub+Hwfyd1zY56Y6lL/e4EZxmgp7Lq+aUPVgUkc9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=k4KiocSu; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="k4KiocSu"
Received: from trampoline.thunk.org (pool-108-49-65-18.bstnma.fios.verizon.net [108.49.65.18])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 66LE1vnv010180
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 21 Jul 2026 10:01:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1784642519; bh=W+Lp2jKwpq7TxWch6xzsI9vElptwiCyw+THn0XhN7JI=;
	h=From:Subject:Date:Message-ID:MIME-Version;
	b=k4KiocSuSY+SNMCRPCYUaH2+ru01X7kWqjRZGGPJ+yI1HbNmHayPPM0yOhieePFaq
	 SFvlDRuzmxlfsytAqtd6O61OG6Xhiko8K62jqI4ao7ud86zm+u3QZiXgqaZoubhQs8
	 hoTcWAnsVwD4YYbC//zYlQ9+VGgNPzWFp5RHUFqToUTjROrURic3WMs7Pmh1Saz8+L
	 yWB41muBclLXuJqaNC1MbNiguuvVjDeodGoSIceYuyS7Fc2U7XERq5fclUaiRs/AFg
	 jpKn9xEOtQ/Mf0VSYQ3FggK94iwuOL5i2Rbb/gDpuW+eX/KSeLmfmL5BCJMhZMiyXo
	 M3VP/+tt9sHQA==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 9E3612E3F15; Tue, 21 Jul 2026 10:01:57 -0400 (EDT)
From: "Theodore Ts'o" <tytso@mit.edu>
To: linux-ext4@vger.kernel.org
Cc: "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH 2/2] jbd2: align h_type and h_line_no in the handle structure on byte boundaries
Date: Tue, 21 Jul 2026 10:01:36 -0400
Message-ID: <20260721140152.461286-3-tytso@mit.edu>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260721140152.461286-1-tytso@mit.edu>
References: <20260721140152.461286-1-tytso@mit.edu>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This makes starting handles a little more efficient, since it avoids
requiring bitshifts when setting or getting the h_type and h_line_no
fields in the jbd2_journal_handle structure.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 include/linux/jbd2.h | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
index 7348fdadc810..1b42fe47c26b 100644
--- a/include/linux/jbd2.h
+++ b/include/linux/jbd2.h
@@ -510,12 +510,12 @@ struct jbd2_journal_handle
 	int			h_err;
 
 	/* Flags [no locking] */
-	unsigned int	h_sync:		1;
-	unsigned int	h_reserved:	1;
-	unsigned int	h_aborted:	1;
-	unsigned int	h_invalid:	1;
-	unsigned int	h_type:		8;
-	unsigned int	h_line_no:	16;
+	unsigned char	h_sync:		1;
+	unsigned char	h_reserved:	1;
+	unsigned char	h_aborted:	1;
+	unsigned char	h_invalid:	1;
+	unsigned char	h_type;
+	unsigned short	h_line_no;
 
 	unsigned long		h_start_jiffies;
 	unsigned int		h_requested_credits;
-- 
2.53.0

