Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793699003;
	b=NOa3Om6iLy5ze914a4GvlG8GWlrf7Vkwx1inctBsZUw6NDpeIBqKfBQKQlOXqvjMRPZ0
	 TrqpDwYkF2qXb3pjtAodFUgHeBAC9nrxqinUT1LwDbPxaMGb+VT9jvRviq3TbyoheIJP2
	 Sh7y1J9LG3mYlAtE9LwrEnJGuvPWqATNyKX+ngle7TWMW1kKjN8c2zmfXs9F8T6GDtria
	 Mn05zM89NkAjm+srM0D84KN7+4E2LiDQTjDO9A2c9cSqCGZe+SRktm6lJaUJ68EK9ls9P
	 jUDStfATZnrFY4xX4o/n6SgsNRqx2wBno7HjwMbWmw+FRoxKRCWN2ZS/WHcQW/TDWdA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793699003;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:From:To:Cc:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=vue6lM7vyH/94QaL+T1sBbz9rXe4aJOLRzCadLd8ru0=;
	b=nWpaxc8+8cbntY//7NsVIW1gfjIPC1RyYV4gT/Z8sQXTDn4T6zI6J0VCa+gInqF2Pf3e
	 JxXoYOGdhe6QKWEgLE+vXpV09wKg8xEFVDZcaELFXDYpsziydJv6dj4C6MmpG94MjQ6qZ
	 yJIU9hSgPie+z3KS0PlEseHu6Ki8DTZjsGPYtP7OJFaRRd7TN3rCgNVexOKSQAuWHaO4J
	 26OcCNmRvkQ0gp5UiDI8dNd3LzSLorfd5zezPnq0hjv7EXqN5B2lR5ZUpLnqhDxFw0n8Z
	 ZiLkd3WP2LqWb4UOJCa4MSueETiBQr5jZYhNuj17hvi0ICjShSmahiXoLF+R4x9yIIQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=bytedance.com;
	spf=pass smtp.mailfrom=bytedance.com;
	dkim=pass header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=jZHVP+Jj;
	arc=none smtp.remote-ip=209.85.216.45
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A8A6606A32C
	for <linux-ext4@vger.kernel.org>; Tue,  3 Nov 2026 09:43:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0A8A6606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=jZHVP+Jj
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-3ac91ac8924so2043458a91.1
        for <linux-ext4@vger.kernel.org>; Tue, 03 Nov 2026 01:43:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1793699002; x=1794303802; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:references:cc:to
         :from:subject:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=vue6lM7vyH/94QaL+T1sBbz9rXe4aJOLRzCadLd8ru0=;
        b=jZHVP+Jj9E6bjiRvoghx/bWIFwLdFZfOv5EDzNg49IVFmYYdUfpwiXgH8FdW3nPxTC
         6V5tGgT6g7Y3QklbTBKma7kfO35O3lWLpkaF0wNZqtw25oX/o+8w4bvvQXN4zgpl9qss
         Xvwlgiu7cLwcPh7MqlttMTYd9kurwZoEAkd/YKASz64jRHgvs9cJNbgynSN3+u1TB1NL
         YdxpEL0k0tASW5+5dFnuNCPhX7IgNPJDsOr+06tvr5l/txyVKEQZ9GOFe9fgwJzItDl2
         Rw0uB4ZFzb2/ejEnMxbWotdpJDxDyR9ABBjgTL5NVPtWWtWYRgx5o9xkfqs04pmp/w8X
         ch8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793699002; x=1794303802;
        h=content-transfer-encoding:content-type:in-reply-to:references:cc:to
         :from:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vue6lM7vyH/94QaL+T1sBbz9rXe4aJOLRzCadLd8ru0=;
        b=S9c2gp43LhgVpK78PeZ3yoJXLES4PDZfwe65Zseuw69TUpcQWccjZSB9y0wKsLQIZi
         Ca/Sui8pRVtnS7rP5YF6ocOHgt+pPW69zxzkqF8ouOWoRX/oc1kLqo8TAuluG1WAam7e
         ko2tIh4qIIxb086UaWxdysSA8cMbLxpirR2PokePLG6912BCNMJb7yXRv9olV98otxtV
         ZVFK2OTmtgLZuh9UiIB4HIdKIPnHRRhDhCsi4rp2BPVZeggssJapiwZZUPiqgH63NlFG
         1Cz7Z0w5Ej7UzEVcwOtdiIAjY/CvcnV6iqxP1rQ4LShrI3xmTSPSajdy1JvD3Slwh95N
         wMhA==
X-Gm-Message-State: APuU4Z/rEe1pmXUtuacfbDonMZYxhK7nxHPrarIEcfT/LBJkInzYvWae
	HFrdF0cgRGcEbOTXLC4tj3gtF/7TDWdRA4IIfsQ2x55OCJaVSRBnyfHXZXmRVCJVVT5LPy8iKBQ
	StyMq
X-Gm-Gg: AYBFou3C+xcuIj7IMGfgSG5s68ChQ+6SlVl5LsRJUXTP+hQrSPts1CIGrgz81AkQETv
	oUn1ab7GzLzFh+t2pwyWujroMkqO7So2VZ5bkmA5fUaZEOb5Z3krudAaAOw7mcHRQdxtwkd1iSu
	NRyYp1U1NZLkg7Uo6xwhcWYaKbdlaTC+vwo4NqOn7VPyglneXLgIMtccGLre2QJ6HKDjhVDli48
	7WF2jgvPKWLWSrJE+aE9A+91GIhBA4eum8lP9ibI4U58WsQh5lD7PxtMcyX5/x7Bp6WKPMJgGJN
	ISFX6xbdiNDU/ldxRAHTeDFqy6lYSbVDuLwAJlhVDoDZanpn909tAL2evagVKUwqSRDh76QYYwv
	j1v53nST1gs/MOqX2bIxUWTfbLNpHk8VzVmUIPfw1/01ylfnmc6X+py3ONzQXoHAxHOo92tB4lO
	g6iTolWcaDXOIfmDNxQMbqQpEu677q+OgY5LmLzxTwYGSWI3y03YgKFHFtMXTkAeWcWXk8kg81v
	l2+0ltLnNRL2FfMEM3wmNvujXpTljXkOKNdvwVVOw9X4WCc2UhTQ90owCYQFvfjwWdOmiWWG3Kl
	QgGWahYkvpEgZNX5qVGK00gOVG5yFimT3jGoImyjvrJRYreOEO/iJTmCA/PrqH+fmA4GOZn7
X-Received: by 2002:a17:90b:5106:b0:3ab:e588:c295 with SMTP id 98e67ed59e1d1-3ae8983c798mr9619892a91.42.1793699002188;
        Tue, 03 Nov 2026 01:43:22 -0800 (PST)
Received: from [100.81.10.186] ([61.213.176.59])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b07c72eecasm3643820a91.17.2026.11.03.01.43.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Nov 2026 01:43:21 -0800 (PST)
Message-ID: <acad7bfc-2ea1-4da0-87ac-42f30900efc0@bytedance.com>
Date: Tue, 3 Nov 2026 17:43:17 +0800
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/6] ext4: fix buffered writeback error handling
From: Julian Sun <sunjunchao@bytedance.com>
To: linux-ext4@vger.kernel.org
Cc: tytso@mit.edu, adilger.kernel@dilger.ca, libaokun@linux.alibaba.com,
 jack@suse.cz, ojaswin@linux.ibm.com, ritesh.list@gmail.com,
 yi.zhang@huawei.com, riteshh@linux.ibm.com
References: <20261023061851.45579-1-sunjunchao@bytedance.com>
In-Reply-To: <20261023061851.45579-1-sunjunchao@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/23/26 2:18 PM, Julian Sun wrote:

Kindly ping..

> This series fixes error handling in ext4 buffered writeback. It prevents
> stale data exposure when mapping or io_end_vec allocation fails, reports
> unwritten conversion errors to fsync(), and preserves concurrent io_end
> flag updates.
> 
> The patches are arranged as follows:
> 
> 1. Move extent mapping error handling out of the loop, without changing
>    behavior, so the following fixes can share the partial-folio path.
> 2. Submit mapped buffers when allocation of the next io_end_vec fails.
>    Otherwise, their ranges remain eligible for unwritten conversion even
>    though their data was never submitted.
> 3. Submit mapped buffers when mapping a later extent in the same folio
>    fails with a fatal error, and discard buffers still needing mapping.
> 4. Drop the folio lookup reference if partial-writeback validation fails.
> 5. Prevent silent data loss by reporting unwritten extent conversion
>    failures through fsync(), instead of returning success while direct
>    reads still return zeros.
> 6. Use atomic bitops for io_end flags so failed-bio completion and
>    writeback cannot overwrite each other's updates.
> 
> Sashiko helped identify these issues.
> 
> Changes since v1:
> - Rebase onto the ext4 dev branch.
> - Call mapping_set_error() on fatal mapping errors in patch 3.
> 
> Julian Sun (6):
>   ext4: move extent mapping error handling out of the loop
>   ext4: submit mapped buffers when io_end_vec allocation fails
>   ext4: prevent stale data exposure after fatal mapping errors
>   ext4: put folio on partial writeback validation failure
>   ext4: report unwritten extent conversion errors to fsync
>   ext4: use atomic bitops for io_end flags
> 
>  fs/ext4/ext4.h    |  16 ++--
>  fs/ext4/inode.c   | 189 +++++++++++++++++++++++++++++++---------------
>  fs/ext4/page-io.c |  24 +++---
>  3 files changed, 149 insertions(+), 80 deletions(-)
> 
> base-commit: 8c4f6e3376348fc3162eed86a05b933921c8f9ed

Thanks,
-- 
Julian Sun <sunjunchao@bytedance.com>
