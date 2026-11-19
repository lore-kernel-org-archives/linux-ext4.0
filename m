Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=18.9.28.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795099669;
	b=rEoo/TkTEvEur4FQ/gI4OOI8ezd0VT0vGkxPqidEx1XM56OsYLAh//0TPdC8unOuf7aq
	 dcZ3EV1KQnxhJCiG7Schyt8d13DSj6yxjMpD4XW2jzlr5Uq7JNqrE2Qd5k+s7B2wMH5TG
	 BrMLymZBayLS6ru659i/jjJvHkjKS170fPfASAVeOWhRHRgCAc2Vg0rzyW1D35QRbxk5d
	 WX5Cz5A1M2bP/2HPgfrOj3xDvvQJMbBaN3pDVcOedUnFdgGQVlszkmWop9zHeSR3TW9kq
	 SFvOoxyB/ryN5BgXHjNQ29eYKkhOaXfbL7LywccsKJj+i0BzM38qyPD/L1E6MK0C48A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795099669;
	h=DMARC-Filter:Received:DKIM-Signature:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Transfer-Encoding;
	bh=in5nQCoUrQujBZoVynDTrPnVxRm7bzTP2QSdV3z7N8I=;
	b=ct05Ov8W1suX0DyTzl+gM/n4shaPmLFPX8h2NmIpz0EbjyIrxxIUw+cXUO7YGIKNQREQ
	 mT2Yo5qXRj9VKyWwMV2Et91YmkkEtmL645YfZEq1JA/7Nlnvz1R9vkwRZt3fhep6gxor+
	 JPm5T53+LkwC5HU57r+KUaVPn1MeaQg0uy/W4ff0aNtdmE43gvwy8YRHrjX7tUlbk4+lf
	 WKd3bpFxw0ZZOjWIToWRy414emom3XP+dIg9y+8F8iniCDA+llTx/QG+TsexjXhxcMqZ4
	 RN+QYGtZ0cYzxf1LPG0eaeCX+OvHJlWuDgR1C7lJv39RfkxineTlBdQ0Rt1d8CeC08A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mit.edu;
	spf=pass smtp.mailfrom=mit.edu;
	dkim=pass header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b="Iy/JV+x3";
	arc=none smtp.remote-ip=18.9.28.11
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3A5760A2620
	for <linux-ext4@vger.kernel.org>; Thu, 19 Nov 2026 14:47:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E3A5760A2620
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=Iy/JV+x3
Received: from trampoline.thunk.org (pool-173-48-114-214.bstnma.fios.verizon.net [173.48.114.214])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 6AJElf7v018189
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 19 Nov 2026 09:47:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1795099663; bh=in5nQCoUrQujBZoVynDTrPnVxRm7bzTP2QSdV3z7N8I=;
	h=From:Subject:Date:Message-ID:MIME-Version:Content-Type;
	b=Iy/JV+x381U9clIcsV8XrLP4T4/74yutFZlHmQYKvK9RIqbAp0TNEQC9IBn2M3iPv
	 i7aLwoME5qYNWIRgR2enY7/JjAFMmmHM4tUNhnuW8FuFo+T6e7kUxfgUpjLaO0N6Za
	 ns3ZRDuvFsgW5/X2VRNb9Q1sWIk6FT4ca4c8WLLJteWHOnflWJAxKRu06n+TpDtkBO
	 6Jc9JHBMyovDStvio29KcodeFemdrlQO1lUhGfELEv8fmnXv07zkCaLV5dyRtzlTta
	 XPlg/QaSn3MJVZmxBXTm4wYpwNLUpSPCqqBUJ2YL80oMSh6a8DV78AiSSsoIjlv6Xr
	 I80KQJAyQ8F6w==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 5813C2E0193; Thu, 19 Nov 2026 09:47:33 -0500 (EST)
From: "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>,
        Jan Kara <jack@suse.com>, Qiliang Yuan <odys.yuan@gmail.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v5] jbd2: fix shrinker scan budget accounting in jbd2_journal_shrink_scan()
Date: Thu, 19 Nov 2026 09:47:16 -0500
Message-ID: <179509948690.1938961.2752357000354922584.b4-ty@b4>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261001-fix-jbd2-shrink-scan-nr-scanned-v5-1-5348b51efce2@gmail.com>
References: <20261001-fix-jbd2-shrink-scan-nr-scanned-v5-1-5348b51efce2@gmail.com>
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit


On Thu, 01 Oct 2026 15:43:43 +0800, Qiliang Yuan wrote:
> do_shrink_slab() reads count_objects() once per invocation to derive
> a one-shot scan budget, then calls scan_objects() repeatedly until
> that budget is exhausted or scan_objects() returns SHRINK_STOP.
> include/linux/shrinker.h documents that scan_objects() "should track
> its actual progress" in sc->nr_scanned, so do_shrink_slab() can tell
> when there is nothing left to examine and stop early.
> 
> [...]

Applied, thanks!

[1/1] jbd2: fix shrinker scan budget accounting in jbd2_journal_shrink_scan()
      commit: 9e6f36987aafbbf10b87c153fad0337dd2e611e1

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
