Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.53
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793713823;
	b=DtHjHfF3Nb9sUdxTY5eP5Vj4b/gkvW8wF7jLcVzkF0dCyxbUxRMOXaixySo1DrrgThH4
	 YXWVP97XuHopHiv95piphKye6UNEOLUKyzvIK46UYpjOhnM2xOyTfBUHNqhCOfu5/LUB/
	 7GJhy+uBlcdhDQ3pxK2UwEyoDrGwsfCP7rHVW+jBHXl1gXMOlhiiwhyLJ5sO8MVPt9kE0
	 B7zy/QKpMESLjq23vXaHVdn3IKfuCJcPuXzKLBSxRR2MafpL/EAc4cEJTBRlx4WMda0Xv
	 Mcve4e8DsPVqZqfY4YGsebx8F4zKbvTk8XNkOsNpjojWHp2PnPXn/EIbFsjSb6CZeTg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793713823;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:
	 X-Google-Original-From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=awDACKIeVrogbGbYFqhsYXsdAMvnrSWHYCkAVzPosm8=;
	b=G2/TIH2vNLwVuZ1tEp5/cLfbUCylOxFeX1DTLU85AW2ohQHPYySOVXgF50J6dKj8NCo5
	 mreATqrN02kbqvZuX2+0nD2Zt8JeeqC5fAx6ryV2nrY6D2gjCKdLfXIzg4g81qSpq6e9K
	 WrGfzjCRt6apzHtx75nOqP12D8O0fwwq3CMqLXifDViM3mlLLphyja/wpfoAqVPRt0U5a
	 O0vvs/rYugndMI9j8tyl1CzOoDY9MMMxoFUIk1IWdcNLMVEyBXcYldeMfPThaR5KChQNB
	 Ejuk6/7223NmOebnSFuj7q8azJ1BXheWvPkmY1WZQ1scf7p2aUmH4bENL/GQU9aQOvQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Y3eofdnh;
	arc=none smtp.remote-ip=209.85.128.53
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1687606A329
	for <linux-ext4@vger.kernel.org>; Tue,  3 Nov 2026 13:50:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B1687606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Y3eofdnh
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4a2167bd087so35634135e9.3
        for <linux-ext4@vger.kernel.org>; Tue, 03 Nov 2026 05:50:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793713821; x=1794318621; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=awDACKIeVrogbGbYFqhsYXsdAMvnrSWHYCkAVzPosm8=;
        b=Y3eofdnho56Y0XxW7AbNKf0dLIE1SvXWyJXACXnShZHMAox1ml23E/0zX/rTMnttqa
         wzK8cppgwCKiwNN/7avq5/IsrV7coFnJxrdU2ksHetrpS20d/kFjcgpQfZJwRBmS4mCO
         ebyhaCa36YNNSWnaF8GPlSLF5RS9LaeMMa68q5Oa9qAo5W9larf1ZOq+ME1ScmmAVF4H
         PRGbABAGdVhc5loxEIPNVdDGPjiggA7s91msqRwcAbmfmSsUjDfuRLkDuCQMYLHyV23e
         e8Bg3bax/6KMdN0t+8f9sKJUvbcTpwp9g1CkC6yVBpteQoN9knENNHcGCNZArGlGLGrA
         16kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793713821; x=1794318621;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=awDACKIeVrogbGbYFqhsYXsdAMvnrSWHYCkAVzPosm8=;
        b=IvRuAEK1CcDF8If6BDyO5iQ9D2evJ2pkLXKB1QkFlY1bCyh5HFVuInBnPKUXYgekLP
         672gy6qjoj6H3SDaCwEp2TON6nAtFJpQwmBGuikysnlk2eHIQbnH8xUwMe5c3d6I8Wu4
         Dkqw5oLrVumrVJqS03KXrI7LqKpCX2gDdSGnw9sFbW7XRL3V3unCG4+TDgUsWy5Umyk9
         iI1PYQhwS7JQz5nDWzqERuTWacJT+Q98gr00vHHvfPpCHcVt+xtcQP3rGYItydostzZ7
         iladnw8MM0/Gcm1bYnIoagekFvdbONngm5fasgdZyE0qeWD+ogMqexGGQg3B4iJDRQbR
         kueg==
X-Gm-Message-State: APuU4Z9mnVq736k1FCTxE8ep1aVN+3IUsZLHQbns17Y5vv1edJAACmCO
	QkZYqt846DkB9F3pp6zk2dTxr5Gks7OFR912BHWGi56yM9GmTruJA5jCS8/O4kfthDw=
X-Gm-Gg: AYBFou3Ajb8ODZQboqPfdPrPR6nuFrTfDKoB7uGwQatgDMz86NdoV6T+ymMn9QVy+AJ
	CSQU3UbPluG146R9CadLsfvtHmb12YMntShKCSKrlfJd8BXIknPHB148LXkWU9tmCAUrMUQlTiF
	BMV7mL3SnKeQvlCQzXeFZDE+dhigS9/XPLlgN3m4u01CV7bFnzQzXEgdZ3kQafaIt2ExCB6pCp1
	2bALwHUSI+C8fH1qHBCo63ZiDFWMSIibtVmN8f/cC4djAqBRNSznwYbf0NQlctkUUGmpL+kzdJ/
	4bLuuRLN/sFygdapfNcB66auFcbM/jjWlyX41Pw0W1FjHXzPBYo2r0wzeMF5TvsVa/lwmQ8WbKU
	uOzRTKvganHw7XVq9NoGRgWdgISu3fvi+DMvyuUB87nCz6AnfCXB54xPeInMwLT3evfJSBEixey
	xJsiG1wWO7KqrdkUFdzO19kbpQxJ6wo+RPRS0Ezkrr5USx36J3tAlY4F8wCsI57xC6/EU4FmQcN
	QINsKJfoJ8NKeugubkFjoHak7Qwt2k6LeJocoeYc5hsOAUfAKUCl9L10yecEuUqhLO6F9KabYOG
	SwMQpeeZf0sU80ezWk5EJY8qLYec0HfaxUlfG07mqNbMCYloQYzRocfJk9PY
X-Received: by 2002:a05:600c:1381:b0:4a4:fc8c:cfd9 with SMTP id 5b1f17b1804b1-4ac180f27cfmr317386545e9.25.1793713820898;
        Tue, 03 Nov 2026 05:50:20 -0800 (PST)
Received: from Cluster2.powerhub ([2a0a:ef40:18b5:9e01:225:90ff:fefc:9ffe])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4abeb77af8csm457146785e9.1.2026.11.03.05.50.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 05:50:20 -0800 (PST)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: tytso@mit.edu,
	jack@suse.cz,
	adilger.kernel@dilger.ca,
	ablagodarenko@thelustrecollective.com,
	xiaowu.417@qq.com,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>
Subject: [PATCH v14 01/12] ext4: validate count against limit in ext4_dx_csum_verify/_set
Date: Tue,  3 Nov 2026 13:49:08 +0000
Message-ID: <20261103134921.610047-2-ablagodarenko@thelustrecollective.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20261103134921.610047-1-ablagodarenko@thelustrecollective.com>
References: <20261103134921.610047-1-ablagodarenko@thelustrecollective.com>
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

dx_countlimit's count field was read from disk and used directly to
compute the checksummed range (count_offset + count * sizeof(dx_entry))
without ever being checked against limit -- only limit itself was
bounds-checked against the block size. A corrupted or maliciously
crafted filesystem image that sets count to a large value (e.g. 65535)
makes ext4_chksum() read far past the end of the directory block
buffer, hitting adjacent slab objects.

Reported-by: xiaowu.417@qq.com
Signed-off-by: Artem Blagodarenko <artem.blagodarenko@gmail.com>
---
 fs/ext4/namei.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 231a274b814e..76b9aa3fb03c 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -477,6 +477,10 @@ static int ext4_dx_csum_verify(struct inode *inode,
 		warn_no_space_for_csum(inode);
 		return 0;
 	}
+	if (count > limit) {
+		EXT4_ERROR_INODE(inode, "dir seems corrupt?  Run e2fsck -D.");
+		return 0;
+	}
 	t = (struct dx_tail *)(((struct dx_entry *)c) + limit);
 
 	if (t->dt_checksum != ext4_dx_csum(inode, dirent, count_offset,
@@ -506,6 +510,10 @@ static void ext4_dx_csum_set(struct inode *inode, struct ext4_dir_entry *dirent)
 		warn_no_space_for_csum(inode);
 		return;
 	}
+	if (count > limit) {
+		EXT4_ERROR_INODE(inode, "dir seems corrupt?  Run e2fsck -D.");
+		return;
+	}
 	t = (struct dx_tail *)(((struct dx_entry *)c) + limit);
 
 	t->dt_checksum = ext4_dx_csum(inode, dirent, count_offset, count, t);
-- 
2.52.0

