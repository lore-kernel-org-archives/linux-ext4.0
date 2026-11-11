Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=220.197.31.4
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794387144;
	b=B5KKR0eEyEFxMso3OfhG8lKUD91YAbFEn8GQDqYhq+BTQkjSrB2wL8P+/J0xkelvD53c
	 +kAXfmqTm1GXF1iM9v2v6D6q52nvgQv4/4mV347ixF6fU+o8bNj7I8k6q73F1dmeCZnrR
	 oV8lNANt7adQNflkKtFB5cJcxsgQlpU1GAIIcB4x/3mMS7D56oi6wXm0U515Jtr4vMpto
	 fCqcxpBTzMalnAkK8p2gcDNFq6M7KIo+Zq8C+/aZmzlHNZcUVl2oLnpxF8cU6LsMsJpca
	 XhWIvRIAkqDpdbc3bosVWvPb2W+D6k5xhz3rnLQeAghPy+xNfvODhwvSGZULgby0EXQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794387144;
	h=DMARC-Filter:DKIM-Signature:Date:From:To:Cc:Subject:X-Priority:
	 X-Mailer:X-NTES-SC:Content-Transfer-Encoding:Content-Type:
	 MIME-Version:Message-ID:X-Coremail-Locale:X-CM-TRANSID:
	 X-CM-SenderInfo:X-Coremail-Antispam;
	bh=x8AHVtJEbM2AUZdBKh4jR6I+1ge046yi64cismTClAA=;
	b=kBg/FCqhODxt3/NdNjW9Y3O0Fslb3awpBkJiTEOzExn9YRNi+w15f8gCy7YPVfGp7rU2
	 MZWRGZBB7DQyUacx0CStFhs0EiDRMOZ0yvNFiFg4WJvoq8SR0ZQh+s/YmykrQ0QzaFpRc
	 /hliJt3ck/Yar1ZNvE6F7msH+0lHqSgyNOrYfTR5KM4EqeGNgn8qEM39yGCQdtgNRMEu3
	 dmAGX7O753vPuKmQzxWx4Tgb5OiDaHyK7nFmVsbK1yW44LBVl1P1M/hZScuNQrmp6mImb
	 YeUgx2jdFCav1C0TtirsvXqcGdTRHBYCpzx86Iqg1Z6zLGAoLXgnCg84FvYqlzQeYEg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=163.com;
	spf=pass smtp.mailfrom=163.com;
	dkim=pass header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b="DT/MrEtw";
	arc=none smtp.remote-ip=220.197.31.4
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7A15606A31C;
	Wed, 11 Nov 2026 08:52:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B7A15606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=DT/MrEtw
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Date:From:To:Subject:Content-Type:MIME-Version:
	Message-ID; bh=x8AHVtJEbM2AUZdBKh4jR6I+1ge046yi64cismTClAA=; b=D
	T/MrEtwLRKdJCjpW7++nRks4tFwPe/Qpg+4ni/vU+LoAxaPXstL+S3Tc49NTiEDD
	06ePK0sufBHdUKTcp/eBJRlwnpgt60LBj5NhPS3ns3/w9gIu0wfhoqu8GwZ1gw8T
	VyPh0xZUgslC2KWBG0KKux7WY/h2XSFl2qiGcwVi04=
Date: Wed, 11 Nov 2026 16:51:53 +0800 (CST)
From: CJ <firefly0158@163.com>
To: jack@suse.com
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: KASAN: use-after-free Write in ext2_try_to_allocate on v7.3-rc2
X-Priority: 3
X-Mailer: Coremail Webmail Server Version 2023.4-cmXT build
 20260511(2e539873) Copyright (c) 2002-2026 www.mailtech.cn 163com
X-NTES-SC: AL_Qu2SBv+TuEkq5CmRYOkdmEsTju82UcS4ufQl245Xc8EEuS7f5iUqRlhADGXE8O6qGhC3lDKJfD1fz9lHWIZJRhp8D+3qmu6MruEVeLh5xQ==
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
Message-ID: <5fb9abed.76e9.1a1c9ce742a.Coremail.firefly0158@163.com>
X-Coremail-Locale: zh_CN
X-CM-TRANSID:gSgvCgD3nyqpLPRqAa5rAA--.838W
X-CM-SenderInfo: piluvw1o1qikqy6rljoofrz/xtbC+QgNvmr0LKiLLQAA3+
X-Coremail-Antispam: 1U5529EdanIXcx71UUUUU7vcSsGvfC2KfnxnUU==

CkhpLAoKCnN5emJvdCByZXBvcnRlZCAiS0FTQU46IHVzZS1hZnRlci1mcmVlIFdyaXRlIGluIGV4
dDJfdHJ5X3RvX2FsbG9jYXRlIiBvbiBMaW51eCA2LjEuIFRoZSBzYW1lIGZhaWx1cmUgaXMgc3Rp
bGwKcmVwcm9kdWNpYmxlIG9uIHY3LjMtcmMyIHdpdGggdGhlIGFkYXB0ZWQgcmVwcm9kdWNlciBk
ZXNjcmliZWQgYmVsb3cuCgoKVGhlIHJlcHJvZHVjZXIgbW91bnRzIGEgY3JhZnRlZCBleHQyL2V4
dDMgaW1hZ2UgYW5kIGNyZWF0ZXMgZGlyZWN0b3JpZXMgaW4gdGhlIG1vdW50ZWQgcm9vdC4gVGhl
IGFkYXB0ZWQgc3l6IHByb2dyYW0gYWRkcyBleHBsaWNpdCBta2RpcmF0IGNhbGxzIGltbWVkaWF0
ZWx5IGFmdGVyIHRoZSBpbWFnZSBtb3VudCwgcmVzdG9yaW5nIHRoZSBleHQyX21rZGlyIGFuZCBl
eHQyX21ha2VfZW1wdHkgYmxvY2stYWxsb2NhdGlvbiBwYXRoLiBUaGUgaW1hZ2UsIG1vdW50IG9w
dGlvbiwgYW5kIHVucmVsYXRlZCBjYWxscyBhcmUgcHJlc2VydmVkLgoKClRoZSB0YXJnZXQgY29u
c29sZSByZXBvcnRzIGEgS0FTQU4gdXNlLWFmdGVyLWZyZWUgd3JpdGUgaW4gZXh0Ml90cnlfdG9f
YWxsb2NhdGUsIHdpdGggdGhlIGFsbG9jYXRpb24gcGF0aCBwYXNzaW5nIHRocm91Z2ggZXh0Ml90
cnlfdG9fYWxsb2NhdGVfd2l0aF9yc3YsIGV4dDJfbmV3X2Jsb2NrcywgZXh0Ml9tYWtlX2VtcHR5
LCBleHQyX21rZGlyLCBhbmQgdmZzX21rZGlyLgoKClRoZSB3cml0ZSBvY2N1cnMgd2hpbGUgZXh0
MiBhbGxvY2F0ZXMgYmxvY2tzIGZvciBhIG5ldyBkaXJlY3RvcnkuIFRoZSBjb25zb2xlIGRvZXMg
bm90IGlkZW50aWZ5IHdoZXRoZXIgdGhlIHN0YWxlIG9iamVjdCBpcyBhIGdyb3VwIGRlc2NyaXB0
b3IsIGJpdG1hcCBidWZmZXIsIG9yIGFub3RoZXIgYWxsb2NhdGlvbiBzdHJ1Y3R1cmUuCgoKVGhp
cyBpcyBhIGZvbGxvdy11cCBmb3IgdGhlIGV4aXN0aW5nIHN5emJvdCByZXBvcnQgaHR0cHM6Ly9z
eXprYWxsZXIuYXBwc3BvdC5jb20vYnVnP2V4dGlkPThhNDdlMjkyZGI4NWEzYjIwYzc2LCBub3Qg
YQpiaXNlY3RlZCByb290IGNhdXNlLiBUaGUgdGFyZ2V0IHJlcG9ydCBzaGFyZXMKMTIga2V5IGZy
YW1lcyB3aXRoIHRoZSBzb3VyY2UgY3Jhc2ggcmVwb3J0LgoKClJlcHJvZHVjZXI6CsKgIHN5eiBy
ZXByb2R1Y2VyOiBodHRwczovL3Bhc3RlYmluLmNvbS9yYXcvSGpiZlRlUzEKCgpjb25zb2xlIG91
dHB1dDogaHR0cHM6Ly9wYXN0ZWJpbi5jb20vcmF3L1FaQ2FjUWNTCmtlcm5lbCBjb25maWc6IGh0
dHBzOi8vc3l6a2FsbGVyLmFwcHNwb3QuY29tL3RleHQ/dGFnPUtlcm5lbENvbmZpZyZ4PWIxYWRj
MGJmZGUyZDhhNGEKCgpLZXJuZWw6CsKgIEhFQUQgY29tbWl0OiBkZjI5MDgwOTBjZGEzNjhiMDFm
ZjQzNzA5ZjUxODkwMDc2YzU2MTU3CsKgIGdpdCB0cmVlOiBsaW51eC1zdGFibGUKwqAga2VybmVs
IHZlcnNpb246IDcuMy4wLXJjMgrCoCB0ZXN0ZWQgdGFnOiB2Ny4zLXJjMgoKCkxldCBtZSBrbm93
IGlmIHlvdSBuZWVkIG1vcmUgZGV0YWlscyBvciB0ZXN0aW5nLgoKClRoYW5rcy4KCg==
