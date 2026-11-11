Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=117.135.210.2
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794387761;
	b=wPqaD8fZL7tt7ShCfQFXg7enpK149TEHDgooowxBoN277N5zbD5O7B002sZRWjEhGIcF
	 1ZnMZAgQpOEaQ7hDqK5jn+D7xSX3NxjwlASXdQDFGDdI+2aLXcHuKnBLWhkkUpNQ6DkkI
	 tQec98GLEPvcvUBaNV0RnKnmIRS9T/Z0QFep9rvlXUdlg88IBRMXvlMjn+3teHkuX7xq4
	 vwXFVIvZYzWUi2/6dcbMIPA3AHr95sVGRLhhI14O0NaOfqXdh3BM7oO0jXm9TkcWmrkvV
	 FkhFcgZdJRzPwUcFsRuSDIyQfINdiO9zWPq3KOvTtEAOjDaAtasy0nr6vdL0Z8/6IwA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794387761;
	h=DMARC-Filter:DKIM-Signature:Date:From:To:Cc:Subject:X-Priority:
	 X-Mailer:X-NTES-SC:Content-Transfer-Encoding:Content-Type:
	 MIME-Version:Message-ID:X-Coremail-Locale:X-CM-TRANSID:
	 X-CM-SenderInfo:X-Coremail-Antispam;
	bh=f9tAq97k01UHjM7LgnvC9nISl0QQlNERB6H9K/ku5gA=;
	b=Hgk8KX6I4QWXBVFMBDnILf8s4xMCXTyT/LYKcxdbyxyusTeZWEmxVy5dP7OdwEnheuY+
	 lM5ozq2gO+SzZp9bkDA3/HqSnN93y9hiJVqXe8oINvRZvSb7xFdrMAO9Vf6xJPpWrVQdX
	 C1p+muhMO+RPQkCZb53TRuLFc4Tzx0TfHbdxd/Sp7KJSmO0HAWQXJX85jazxgqEylXoXi
	 mW97uWzl9w7dPa0Oy43j6Us0IBHPb2L5+oHGVAh6oQ8vRQJHFHhocZ2fbI3GJQ8c8LyGf
	 6tjJhD4Wv7GKgvTl0X6JCPpVweS4EuzG32GmDyVAtOxRIV6yHNFSPnIBgJVW9jZDbHQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=163.com;
	spf=pass smtp.mailfrom=163.com;
	dkim=pass header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=DKsR09Ix;
	arc=none smtp.remote-ip=117.135.210.2
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA900606A324;
	Wed, 11 Nov 2026 09:02:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AA900606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=DKsR09Ix
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Date:From:To:Subject:Content-Type:MIME-Version:
	Message-ID; bh=f9tAq97k01UHjM7LgnvC9nISl0QQlNERB6H9K/ku5gA=; b=D
	KsR09IxlIvaLxBRGkZ+4udBE79vxBMCF5J6zElhndABK1NfxhcRoU4j1BipQJhIP
	rgxEAwKifTCOa5gZLbovBrjtS/qkOV6ZeJYA3SNlbK4gJMQadSKboo8xDu26mK92
	71+3HZpCuLrhX5aY4zCK7z3UvUYyaH9YDgDGe//8pM=
Date: Wed, 11 Nov 2026 17:02:24 +0800 (CST)
From: CJ <firefly0158@163.com>
To: tytso@mit.edu, jack@suse.com
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: INFO: task hung in do_get_write_access on v7.3-rc2
X-Priority: 3
X-Mailer: Coremail Webmail Server Version 2023.4-cmXT build
 20260511(2e539873) Copyright (c) 2002-2026 www.mailtech.cn 163com
X-NTES-SC: AL_Qu2SBv+TuE8v4iCQY+kdmEsTju82UcS4ufQl245Xc8EEuS7f5iUqRlhADGXE8O6qGhC3lDKJfD1fz9lHWIZJlgPavV66nb9/otzrTziG+g==
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Message-ID: <5513ea81.79f0.1a1c9d81560.Coremail.firefly0158@163.com>
X-Coremail-Locale: zh_CN
X-CM-TRANSID:gSgvCgDH_zwgL_RqYrJrAA--.589W
X-CM-SenderInfo: piluvw1o1qikqy6rljoofrz/xtbC+QCrXWr0LyDPMwAA3i
X-Coremail-Antispam: 1U5529EdanIXcx71UUUUU7vcSsGvfC2KfnxnUU==

CkhpLAoKCnN5emJvdCByZXBvcnRlZCAiSU5GTzogdGFzayBodW5nIGluIGRvX2dldF93cml0ZV9h
Y2Nlc3MiIG9uIExpbnV4IDYuMS4gVGhlIHNhbWUgZmFpbHVyZSBpcyBzdGlsbApyZXByb2R1Y2li
bGUgb24gdjcuMy1yYzIgd2l0aCB0aGUgYWRhcHRlZCByZXByb2R1Y2VyIGRlc2NyaWJlZCBiZWxv
dy4KCgpUaGUgcmVwcm9kdWNlciB3cml0ZXMgdGhlIFBDSSBjb21tYW5kIHJlZ2lzdGVyIG9mIHRo
ZSBibG9jayBjb250cm9sbGVyIHRoYXQgYmFja3MgdGhlIHJvb3QgZXh0NCBmaWxlc3lzdGVtLCBk
aXNhYmxpbmcgbm9ybWFsIEkvTywgYW5kIHRoZW4ga2VlcHMgYnVmZmVyZWQgd3JpdGVzIGFuZCBk
ZWxhbGxvYyBhY3Rpdml0eSBydW5uaW5nLiBUaGUgYWRhcHRlZCBDIHByb2dyYW0gZGlzY292ZXJz
IHRoZSBiYWNraW5nIFBDSSBmdW5jdGlvbiBkeW5hbWljYWxseSBpbnN0ZWFkIG9mIHJlbHlpbmcg
b24gYSBmaXhlZCBndWVzdCBCREYuIEl0IGFsc28gbG93ZXJzIGh1bmdfdGFza190aW1lb3V0X3Nl
Y3MgdG8gMjAgc28gdGhlIHN0YWxsIGlzIGNhcHR1cmVkIGluc2lkZSB0aGUgcmVwbGF5IHdpbmRv
dzsgbm8gZmF1bHQgaW5qZWN0aW9uIGlzIHVzZWQuCgoKVGhlIHRhcmdldCBjb25zb2xlIHJlcG9y
dHMgdGFza3MgYmxvY2tlZCBpbiBJL08gd2FpdCBpbiBkb19nZXRfd3JpdGVfYWNjZXNzLCByZWFj
aGVkIHRocm91Z2ggamJkMl9qb3VybmFsX2dldF93cml0ZV9hY2Nlc3MgYW5kIHRoZSBleHQ0IGlu
b2RlLWRpcnR5IHBhdGguCgoKQW4gaW4tZmxpZ2h0IGpvdXJuYWwgdHJhbnNhY3Rpb24gd2FpdHMg
Zm9yIG1ldGFkYXRhIEkvTyB0aGF0IG5vIGxvbmdlciBjb21wbGV0ZXMuIFRoZSByZXBvcnQgZXN0
YWJsaXNoZXMgdGhlIGJsb2NrZWQgcGF0aCwgbm90IHRoZSBmaW5hbCBkZXZpY2Utc3RhdGUgcm9v
dCBjYXVzZS4KCgpUaGUgY2FuZGlkYXRlIGNoYW5nZXMgL3Byb2Mvc3lzL2tlcm5lbC9odW5nX3Rh
c2tfdGltZW91dF9zZWNzIHRvIDIwLiBUaGlzIGlzIGEgZGV0ZWN0aW9uLXdpbmRvdyBzZXR0aW5n
LCBub3QgZmF1bHQgaW5qZWN0aW9uLCBidXQgaXQgaXMgYW4gZW52aXJvbm1lbnQgY2hhbmdlLiBB
dHRlbXB0cyAxIGFuZCAyIHdlcmUgbWFjaGluZSBmYWlsdXJlL3RpbWVvdXQ7IGF0dGVtcHQgMyBw
cm9kdWNlZCB0aGUgZXZpZGVuY2UuCgoKVGhpcyBpcyBhIGZvbGxvdy11cCBmb3IgdGhlIGV4aXN0
aW5nIHN5emJvdCByZXBvcnQgaHR0cHM6Ly9zeXprYWxsZXIuYXBwc3BvdC5jb20vYnVnP2V4dGlk
PTllM2Q4NTc4OWQzOTk2Y2M4MjljLCBub3QgYQpiaXNlY3RlZCByb290IGNhdXNlLiBUaGUgdGFy
Z2V0IHJlcG9ydCBzaGFyZXMKMTgga2V5IGZyYW1lcyB3aXRoIHRoZSBzb3VyY2UgY3Jhc2ggcmVw
b3J0LgoKClJlcHJvZHVjZXI6CsKgIEMgcmVwcm9kdWNlcjogaHR0cHM6Ly9wYXN0ZWJpbi5jb20v
cmF3L0FCdnplWE1TCgoKY29uc29sZSBvdXRwdXQ6IGh0dHBzOi8vcGFzdGViaW4uY29tL3Jhdy9I
VXM4eW1kegprZXJuZWwgY29uZmlnOiBodHRwczovL3N5emthbGxlci5hcHBzcG90LmNvbS90ZXh0
P3RhZz1LZXJuZWxDb25maWcmeD0zMWRmZWZjNGExNGVmZWEzCgoKS2VybmVsOgrCoCBIRUFEIGNv
bW1pdDogZGYyOTA4MDkwY2RhMzY4YjAxZmY0MzcwOWY1MTg5MDA3NmM1NjE1NwrCoCBnaXQgdHJl
ZTogbGludXgtc3RhYmxlCsKgIGtlcm5lbCB2ZXJzaW9uOiA3LjMuMC1yYzIKwqAgdGVzdGVkIHRh
ZzogdjcuMy1yYzIKCgpMZXQgbWUga25vdyBpZiB5b3UgbmVlZCBtb3JlIGRldGFpbHMgb3IgdGVz
dGluZy4KCgpUaGFua3MuCgo=
