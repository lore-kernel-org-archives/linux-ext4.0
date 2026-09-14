Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE98B40F721;
	Mon, 14 Sep 2026 09:11:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789377119; cv=none; b=ovtm6njKDEM3jEMp5FvbswovXqPMLVgIu9K0HUSH0UR8HRKSltwfZ4IZYeKqpl+pkePw+n6qcqdnLmgiLqr8KHbzfnzcmYb7H1jupcUIOqEwBfAOsiZCUeYN744arFtoRYuEgiX0SCKu99J6VgBKC7YXO0vJnsxJdhB7f0NOw84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789377119; c=relaxed/simple;
	bh=ZQ0PoAs4Pulw3ORXenybFbKJjhnMyjzeiXsGx2Mo/ig=;
	h=Date:From:To:Cc:Subject:Content-Type:MIME-Version:Message-ID; b=s1Zf5edKDttuP8kTJkzCEA+U8ujjVd5zQsnH1k4LzsDhONEoE1fqxccWWps+kn6wdhebZxvMs0HOcu8lTezL14MFYnicxw2rQga2/dAvqwwUQD6DQyPjvDtpIK1gtTUc4TqskhtH5ioM029480hWIMBxYFHyLHasmdBXlBKGs9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=JMCblaIT; arc=none smtp.client-ip=220.197.31.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="JMCblaIT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Date:From:To:Subject:Content-Type:MIME-Version:
	Message-ID; bh=ZQ0PoAs4Pulw3ORXenybFbKJjhnMyjzeiXsGx2Mo/ig=; b=J
	MCblaIToLNQIjYtrfzLni5998e5Dxku0+sqRLOVs8kwOmeMizRudNlG3m/Idrjtc
	KrfpKQgzBbhQB1QLk31SL75ckSp1XWQOCeMLMTkXUMLn0S951Foj9zrpOK4tLlp/
	na+Y4rJyrp6tQ8pCDEzoodJqiMh7YZSgA2fqC+qNX8=
Date: Mon, 14 Sep 2026 17:11:24 +0800 (CST)
From: CJ <firefly0158@163.com>
To: tytso@mit.edu, adilger.kernel@dilger.ca, libaokun@linux.alibaba.com,
	jack@suse.cz, ojaswin@linux.ibm.com
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [BUG] ext4: WARNING in lock_two_nondirectories from __ext4_ioctl
X-Priority: 3
X-Mailer: Coremail Webmail Server Version 2023.4-cmXT build
 20260511(2e539873) Copyright (c) 2002-2026 www.mailtech.cn 163com
X-NTES-SC: AL_Qu2TC/+cuEgj4iCbbOkdmEsTju82UcS4ufQl245Xc98Figbk+QAgeFpPNFDG1NiRKyuJkh+TdQFs6cJxc45/gkwpYWS6vHPI1djUM8nNAg==
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Message-ID: <72a2177d.8ac9.1a09f2f7a8f.Coremail.firefly0158@163.com>
X-Coremail-Locale: zh_CN
X-CM-TRANSID:hygvCgD3_648uqdq90MPAA--.18921W
X-CM-SenderInfo: piluvw1o1qikqy6rljoofrz/xtbC3RxC82qnujyN9gAA3A
X-Coremail-Antispam: 1U5529EdanIXcx71UUUUU7vcSsGvfC2KfnxnUU==

CkhpLAoKCkkgYW0gcmVwb3J0aW5nIGEgbG9ja2luZyBXQVJOSU5HIG9uIHRoZSBleHQ0IGJvb3Qt
bG9hZGVyIGlub2RlIHN3YXAgaW9jdGwsCnRyaWdnZXJlZCBieSBhIHN5emthbGxlciByZXByb2R1
Y2VyIHRoYXQgbW91bnRzIGEgY3JhZnRlZCBleHQ0IGltYWdlLiAgVGhlIGlzc3VlCmlzIHJlcHJv
ZHVjaWJsZSB3aXRoIEhFQUQgY29tbWl0IGNlZTkzOTVhY2Q4MDQzYmUwNjQ0YjI1YzM0YmZhODY2
MjNmMmI5MzUKKHY3LjMtcmMxLCBMaW51eCA3LjMuMC1yYzEpLgoKClRoZSByZXByb2R1Y2VyIG1v
dW50cyBhIGNyYWZ0ZWQgZXh0NCBmaWxlc3lzdGVtIGltYWdlIHdpdGhvdXQgYSBqb3VybmFsIG9u
IGEKbG9vcCBkZXZpY2UgYW5kIGlzc3VlcyB0aGUgaW9jdGwgdGhhdCBzd2FwcyB0aGUgYm9vdCBs
b2FkZXIgaW5vZGUuICBUaGUgY29uc29sZQpzaG93cyB0aGUgbW91bnQgc3VjY2VlZGluZyB3aXRo
IHF1b3RhIGFuZCBub2xvYWQgb3B0aW9ucyBhbmQgdGhlbiB0aGUgV0FSTklORy4KCgpUaGUgY29u
c29sZSBzaG93cyAiV0FSTklORzogZnMvaW5vZGUuYzoxMjUwIGF0CmxvY2tfdHdvX25vbmRpcmVj
dG9yaWVzKzB4MWFkLzB4MjAwIiB3aXRoIFJJUCBpbiBsb2NrX3R3b19ub25kaXJlY3RvcmllcywK
cmVhY2hlZCBmcm9tIF9fZXh0NF9pb2N0bC4gIE9uIHRoZSBrZXJuZWwgd2hlcmUgdGhpcyB3YXMg
Zmlyc3QgcmVwb3J0ZWQgdGhlIHNhbWUKaW9jdGwgcGF0aCBwcm9kdWNlZCBhIGRpZmZlcmVudCBs
b2NraW5nIGNvbXBsYWludDogYSBiYWQgdW5sb2NrIGJhbGFuY2UgZm9yCiZ0eXBlLT5pX211dGV4
X2Rpcl9rZXksIHJlcG9ydGVkIGF0IHRoZSByd3NlbSB1cF93cml0ZSBzaXRlLCBhZ2FpbiByZWFj
aGVkIGZyb20Kc3dhcF9pbm9kZV9ib290X2xvYWRlciBpbiBfX2V4dDRfaW9jdGwuICBCb3RoIHJl
cG9ydHMgcG9pbnQgYXQgdGhlIHNhbWUKbG9jay91bmxvY2sgaGFuZGxpbmcgaW4gdGhlIGJvb3Qt
bG9hZGVyIHN3YXAsIGJ1dCB0aGUgcmVwb3J0ZWQgbWVjaGFuaXNtIGFuZApsb2NhdGlvbiBkaWZm
ZXIgYmV0d2VlbiB0aGUgdHdvIGtlcm5lbHMsIHNvIEkgYW0gZGVzY3JpYmluZyB0aGlzIGFzIGEg
bGlrZWx5CnJlY3VycmVuY2UgcmF0aGVyIHRoYW4gYW4gaWRlbnRpY2FsIHNwbGF0LgoKCk9uZSBw
b3NzaWJsZSBjYXVzZSBpcyB0aGF0IHRoZSBib290LWxvYWRlciBzd2FwIHBhdGggZG9lcyBub3Qg
dGFrZSBhbmQgcmVsZWFzZQp0aGUgaW5vZGUgbG9ja3MgaW4gdGhlIG9yZGVyIGxvY2tfdHdvX25v
bmRpcmVjdG9yaWVzIGV4cGVjdHMsIHNvIHRoZSBpbm9kZS1sZXZlbApsb2NrIGhlbHBlciB3YXJu
cy4gIFRoaXMgbG9va3MgbGlrZSBhIGxvY2tpbmctZGlzY2lwbGluZSBwcm9ibGVtIGluIHRoZSBp
b2N0bApwYXRoIHJhdGhlciB0aGFuIGEgZmlsZXN5c3RlbS1mb3JtYXQgcHJvYmxlbS4gIEkgYW0g
cmVwb3J0aW5nIHRoZSB3YXJuaW5nIGFuZAp0aGUgcGF0aCBhcyBvYnNlcnZlZC4KCgpUaGlzIGFw
cGVhcnMgdG8gYmUgYSByZWN1cnJlbmNlIG9mIHRoZSBzeXpib3QgaXNzdWUgd2hvc2UgZXh0ZXJu
YWwgaWQgaXMKNzdhMDI0NWViNGVkOTk1MTUwYTYuICBJdCByZW1haW5zIHJlcHJvZHVjaWJsZSBv
biB2Ny4zLXJjMS4KCgpSZXByb2R1Y2VyOgoKCnN5eiByZXByb2R1Y2VyOiBodHRwczovL3Bhc3Rl
YmluLmNvbS9yYXcvNkJtM0tMUWUKCmNvbnNvbGUgb3V0cHV0OiBodHRwczovL3Bhc3RlYmluLmNv
bS9yYXcvc3JOa2V6emUKCmtlcm5lbCBjb25maWc6IGh0dHBzOi8vcGFzdGViaW4uY29tL3Jhdy9j
VFFyNWlEYQoKCktlcm5lbDoKCgpIRUFEIGNvbW1pdDogY2VlOTM5NWFjZDgwNDNiZTA2NDRiMjVj
MzRiZmE4NjYyM2YyYjkzNQpnaXQgdHJlZTogdXBzdHJlYW0gKGxpbnV4LmdpdCksIHRlc3RlZCB0
aHJvdWdoIHRoZSB2Ny4zLXJjMSBhbm5vdGF0ZWQgdGFnIG9iamVjdArCoCDCoCDCoCDCoCDCoCDC
oGU1ZTA0NzI2Y2RkMDQzZTMwOTY3NzA3MWFiMWI2NWE0YjE4ZjQyMmIKa2VybmVsIHZlcnNpb246
IDcuMy4wLXJjMSAjMSBQUkVFTVBUKGZ1bGwpCnRlc3RlZCB0YWc6IHY3LjMtcmMxIChMaW51eCA3
LjMtcmMxLCAyMDI2LTA4LTMwKQoKCkxldCBtZSBrbm93IGlmIHlvdSBuZWVkIG1vcmUgZGV0YWls
cyBvciB0ZXN0aW5nLgoKCkJlc3QgcmVnYXJkcyw=
