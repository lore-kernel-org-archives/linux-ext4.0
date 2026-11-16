Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794869797;
	b=Dl8VOfZvaHg0E/GYs4PTHVYjaGJQQ10B9fQH8eDU1a9rTh3sqnTXgQhEv0zranM4V5Ua
	 QOYCr4mToDrU9mZOLHfvtGf14+9uwZZJaiA+OhYX77nd6g9kWOyXXSTQ2PZ6R6ljKgyDm
	 wUy3drCxhaZWGIF7yCLRapR+U9Dq5ssFiYKLjzWZ1pf4JS3xmntlGhvrBNbVUMALHq6Sr
	 Yu7j4kXQJsr/YIODKfI9+UxEZTA/oGhIXKEp323uCaCOpLOe24SduOwlY2g4A4uCNMcja
	 ThY0AtahBuzaGgQ7pdWPY0PecPMs1b3Rk65p3DpXu5yslAP4hI46JDn2W3yS9zEc+Cg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794869797;
	h=Received:DKIM-Signature:Received:Content-Type:MIME-Version:
	 Content-Transfer-Encoding:Subject:From:Message-Id:Date:To;
	bh=XqPfJuv+25GBiv+9vFAmLagBac3xHS+v30pviWQc050=;
	b=UwWkg9+XNkEBL1GOHQi4lgUgjdfokp1akFnVhJUElZD2+x11rjluMPq2O+xkX/YBKpA4
	 Dm7j9UxtZaHzuWxjU98gUPPaGsE0sh5pN+FdXza0TXLgxCHRskseF7dr2TXudThlFuM2q
	 vLuwjo4i5afHKxBZFptqNMyaceJrySEf0nc08VaZwP/tG+GxEjWSXabwme/8S8jsrTGUE
	 mmONzY/vobXzTa0H9UW1RGb/zG2yWT5KDBzc/++HjeiFTgP7XJEwkQ6AEwli7YWgjxRML
	 bOFC1ejAYQ2btUXokuQDQAbfjjcNZnmoGYA301RGa73k/kEb3r8iHiJWR1haoJuxsSw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BgHqSsUd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25BB2606A32F
	for <linux-ext4@vger.kernel.org>; Mon, 16 Nov 2026 22:56:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BgHqSsUd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B648A1F000C4
	for <linux-ext4@vger.kernel.org>; Mon, 16 Nov 2026 22:56:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794869796;
	bh=XqPfJuv+25GBiv+9vFAmLagBac3xHS+v30pviWQc050=;
	h=Subject:From:Date:To;
	b=BgHqSsUd3MAmPh1aR6QvvPjGeb6JIa9gZ/Jqz12dDr29zA93Hzc4zvMmDImHaDWwv
	 tx7x8THvfHWOYAaXENbsOITMrUbUGBDWO9IzW7YrsaUq1In1HoGvJvecDW3WP2xr1v
	 HI3KGpWMYHU245VvOvXkUryNtnJhyok0nOhaxCHuWfjmfWIIF4k3CTJ2bB4EB0HPNh
	 ND2ds4DTW7OFguPvpgOq+uKv4AIX7Bc2VoQRxTe38HPt2vErjt8h0Jjof+KopBc4/C
	 svMGcxAREqse/WqKbFLNNoRg6whHJalP3aRM8G4FNmZo4KsDSEpiHsFON3SGi6euEG
	 PbgeT61R+lVtQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id AE88F391AFF1
	for <linux-ext4@vger.kernel.org>; Mon, 16 Nov 2026 22:56:36 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
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
Subject: Patchwork housekeeping for: ext4
From: patchwork-bot+linux-ext4@kernel.org
Message-Id: 
 <179486979547.220313.2683031538183201143.git-patchwork-housekeeping@kernel.org>
Date: Mon, 16 Nov 2026 22:56:35 +0000
To: linux-ext4@vger.kernel.org

Latest series: [v3] e2fsck: set the encrypt feature if the filesystem has encrypted inodes (2026-11-16T22:52:06)
  Superseding: [v2] e2fsck: set the encrypt feature if the filesystem has encrypted inodes (2026-11-16T14:28:11):
    [v2] e2fsck: set the encrypt feature if the filesystem has encrypted inodes

Checked 53 series in 0.91 seconds.
This project currently has 504 active patches.


-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html

