Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=117.135.210.2
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794387479;
	b=WQNpf9keK0pCLElhR90maXxbIWnSWjghhC5+mK2BBJAQi1KAB5bu6AxKsAzSnKIl34WI
	 Phn8orusM5Xr3V+XLorne5dD5JqQB563eZLA8iouW7kQduxLK57ZeZGJftNyccSAqa5Z7
	 /gAJoPwEq+LFh7UzZtswa5lYVBhek9kB5T89fQiq0UaA2I5RLWlcDw+CE2klNjhAIK5Mc
	 VeJV7+IjCwt2RutWn+7svLeDz4YTeegnyi1ye0yNCBLdktKkDHjUEdSaubLFJoV+S+k/V
	 LtV57RRBklN1fcCEKIYbDIr2psNNO1eDpWaxAexta2X2W1vWv/ROB3GQTS0tQ6teirQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794387479;
	h=DMARC-Filter:DKIM-Signature:Date:From:To:Cc:Subject:X-Priority:
	 X-Mailer:X-NTES-SC:Content-Transfer-Encoding:Content-Type:
	 MIME-Version:Message-ID:X-Coremail-Locale:X-CM-TRANSID:
	 X-CM-SenderInfo:X-Coremail-Antispam;
	bh=maFwIr4Mw4pKxUSsBkPlvX1lVcm/qiSOa2Mov6SrIOw=;
	b=Hh1y/X+MSLYaw9nXRk/UDfFFRalyc10aY2eC6ngQDfO69Nl8J3GF/95uc2nCpsAbrOM9
	 ce2ksz72lffRLMr+MsdNyfC7GIcdcetSi9xeokMgWm5nCg6N0MQMwOH7bjkgR6lv7PH15
	 gfHqA7w8uSKzQpwMZin1/CRkckqyLmqoIYUn6nnlxfnSH7h0OlHiKWjUH1+V2ElS08HHi
	 0Wngcp7oyjTuFbZKpU2JMTLNPjiSqzqkIXDJUMJAvOnITPOBm19f2R8uVdT5DPVm7PZLa
	 jZHCEYf7inmCklfVm+g/Ei4ne/KSa8AgmgDWWjRi3J34dELOJ0/DO+guaxoQsHYigIw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=163.com;
	spf=pass smtp.mailfrom=163.com;
	dkim=pass header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=ZAEmETT9;
	arc=none smtp.remote-ip=117.135.210.2
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E23C60A2606;
	Wed, 11 Nov 2026 08:57:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4E23C60A2606
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=ZAEmETT9
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Date:From:To:Subject:Content-Type:MIME-Version:
	Message-ID; bh=maFwIr4Mw4pKxUSsBkPlvX1lVcm/qiSOa2Mov6SrIOw=; b=Z
	AEmETT9AtZQIQt5E0ciupc8PA1lgfIlHtVZkh+t14bnj/PVvlrVNjgY7/0BVm/Wb
	FTLSfv424vfsUMXcWaHvzlQ595s18mp9NSi/uNbi9EnR8gjuhhdptpJc1F+j39eX
	i3hAtjjd4oWacu5YtGAHOujIJ2DjJNcjGarq7EuQTI=
Date: Wed, 11 Nov 2026 16:57:37 +0800 (CST)
From: CJ <firefly0158@163.com>
To: tytso@mit.edu, adilger.kernel@dilger.ca
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: possible deadlock in ext4_writepages on v7.2-rc3
X-Priority: 3
X-Mailer: Coremail Webmail Server Version 2023.4-cmXT build
 20260511(2e539873) Copyright (c) 2002-2026 www.mailtech.cn 163com
X-NTES-SC: AL_Qu2SBv+TuEwu4SKcYukdmEsTju82UcS4ufQl245Xc8EEuS7f5iUqRlhADGXE8O6qGhC3lDKJfD1fz9lHWIZJ3mY1eAP+8QXhaQ2Ix41B3w==
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
Message-ID: <4b513fb9.789e.1a1c9d3b4e8.Coremail.firefly0158@163.com>
X-Coremail-Locale: zh_CN
X-CM-TRANSID:gSgvCgC3vz0BLvRqgbBrAA--.581W
X-CM-SenderInfo: piluvw1o1qikqy6rljoofrz/xtbC+QFjFWr0LgGspAAA33
X-Coremail-Antispam: 1U5529EdanIXcx71UUUUU7vcSsGvfC2KfnxnUU==

CkhpLAoKCnN5emJvdCByZXBvcnRlZCAicG9zc2libGUgZGVhZGxvY2sgaW4gZXh0NF93cml0ZXBh
Z2VzIiBvbiBsaW51eC02LjYuIFRoZSBzYW1lCmZhaWx1cmUgaXMgc3RpbGwgcmVwcm9kdWNpYmxl
IG9uIHY3LjItcmMzIHdpdGggdGhlIHJlcHJvZHVjZXIgYmVsb3cuCgoKVGVzdGVkIGtlcm5lbDoK
wqAgTGludXggdjcuMi1yYzMKwqAgSEVBRCBhMTNjMTQwY2MyODljMGI3YjM3NzBiY2U1YjNhZDQy
YWIzNTA3NGFhCgoKT2JzZXJ2ZWQgZmFpbHVyZToKZmZmZjg4ODA1OGIyOTM4MCAoJmVpLT54YXR0
cl9zZW0peysrKyt9LXs0OjR9LCBhdDogX19leHQ0X21hcmtfaW5vZGVfZGlydHkrMHg1YzYvMHg4
NjAKbG9ja19hY3F1aXJlKzB4MWE0LzB4MzUwCmRvd25fd3JpdGUrMHg5MS8weDIwMApleHQ0X2Rl
c3Ryb3lfaW5saW5lX2RhdGErMHgyZC8weGUwCmV4dDRfZG9fd3JpdGVwYWdlcysweDZiZC8weDNl
NzAKZXh0NF93cml0ZXBhZ2VzKzB4MzcxLzB4NzcwCmRvX3dyaXRlcGFnZXMrMHgyNDEvMHg1YjAK
ZmlsZW1hcF93cml0ZWJhY2srMHgyMjcvMHgyZDAKZmlsZV93cml0ZV9hbmRfd2FpdF9yYW5nZSsw
eGNmLzB4MTQwCm1tYl9mc3luY19ub2ZsdXNoKzB4NzEvMHgyZDAKZXh0NF9mc3luY19ub2pvdXJu
YWwrMHhlMi8weDQyMApleHQ0X3N5bmNfZmlsZSsweDhmOS8weGI5MAp2ZnNfZnN5bmNfcmFuZ2Ur
MHg5ZS8weDE5MApleHQ0X2J1ZmZlcmVkX3dyaXRlX2l0ZXIrMHgyZDEvMHgzYjAKZXh0NF9maWxl
X3dyaXRlX2l0ZXIrMHg1YTMvMHgxYWIwCmRvX2l0ZXJfcmVhZHZfd3JpdGV2KzB4NjU1LzB4OWUw
CnZmc193cml0ZXYrMHgzMGMvMHhkMzAKZG9fcHdyaXRldisweDFhNi8weDI3MApfX3g2NF9zeXNf
cHdyaXRldjIrMHhlZi8weDE2MApkb19zeXNjYWxsXzY0KzB4YzQvMHg3YTAKZW50cnlfU1lTQ0FM
TF82NF9hZnRlcl9od2ZyYW1lKzB4NzYvMHg3ZQpjaGVja19wcmV2X2FkZCsweGU5LzB4ZTMwCgoK
CgoKClRoaXMgaXMgYSByZXBvcnQgb2YgYSBzdGlsbC1yZXByb2R1Y2libGUgZmFpbHVyZSwgbm90
IGEgYmlzZWN0ZWQgcm9vdCBjYXVzZS4KCgpSZXByb2R1Y2VyOgrCoCBTWVogcmVwcm9kdWNlcjog
aHR0cHM6Ly9wYXN0ZWJpbi5jb20vcmF3LzY5dmdBQjVjCgoKQXJ0aWZhY3RzOgrCoCBjb25zb2xl
OiBodHRwczovL3Bhc3RlYmluLmNvbS9yYXcvMkVoM2hQejgKwqAga2VybmVsIGNvbmZpZzogaHR0
cHM6Ly9zeXprYWxsZXIuYXBwc3BvdC5jb20vdGV4dD90YWc9S2VybmVsQ29uZmlnJng9OTM4MTEw
YWE2NjQyNGI5NAoKClRoYW5rcy4=
