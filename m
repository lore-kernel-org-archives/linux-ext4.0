Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.181
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794994564;
	b=LapMf/OEAsfSegvLALxHNu0+N44JAcU8F9ivJSEGgPaKfmL3tIzfJhtv2+7XUWt4INNR
	 xK7Uw5k5Zf2PC6g1R7gLaDY8m2IZx2kadqw+Qpqeq0hIVb/ENBiNruZSBhU58eTddzvMq
	 O2hlVVsjxFhSMV6Pj2S0R0pBL6En/KRB7N8dlhDhyi2bgZjR7EnNH7zUqvU3gIRb0S/pi
	 AjVQW2+wiDUarmRkSGztWPnB07LAsn6DPh4ecRlXuj/2K5VsEzMrFKzErPzzMzQ5+57wf
	 tKQFOCFabZRkUq+sI06GX+utLrntsC8oH80wBpKSmSTwe1jzyZXsUqZKCvE4b2hC+Bw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794994564;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=duUV49H96MPxft6pLFc1UF8z64munBlO0c9zGA7dLPU=;
	b=0lbXeVk/P8kkej03OwsaDlKrVg3i2jMUFkfekXiNYK7g9OBVgbK5mP1+zhMp5S6YX8TP
	 4zhYuKsvqshgwhnn49kJtp+JykvSDkw2qwHTTthPh03u6sXs/sMkw1mtuujzwNWmjE6sC
	 8ZlEZ7Ludb3cpYTLLv62FMSlP3/hHdq+PbWoLJDjrmyub7uGVHLD/Ifxt9YkiZcpdHK54
	 GKUl2cb26MhYv0lJmrenvRInL8iYZrObg4UGdNvzK45SvlgKSSgyp6/OhjPHt6dJbQvce
	 eU4veNIKo4lyn65CWdUfthSMatgTE64/4yq28vkf2p1nr/6V4B3LZpCFkpU9pfnERfQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=mGOQR19o;
	arc=none smtp.remote-ip=209.85.215.181
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94C71606A8A4
	for <linux-ext4@vger.kernel.org>; Wed, 18 Nov 2026 09:36:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 94C71606A8A4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=mGOQR19o
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-cdb75699c7cso392181a12.2
        for <linux-ext4@vger.kernel.org>; Wed, 18 Nov 2026 01:36:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794994564; x=1795599364; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :references:in-reply-to:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=duUV49H96MPxft6pLFc1UF8z64munBlO0c9zGA7dLPU=;
        b=mGOQR19ot4NvHLd3vZv0p8aKvwi0KLW/z0VSlaX8lnmOlrHdBFD47svrCSzVjodLNN
         v9HvALjM7udwt4WlswzzkZEGKwD0zowPNR3LxZLt6bM29nQLMkBr+YXwS+YNks/nQrkU
         6CY9dcEKoXEmTS/lR99f43Zfz1qDPF/JhEPlnkhaR9hNLCwt1EBRBnrvrhlirkFn1dWA
         YXFxwx553vpm3UfEMLBkNMY//YG2Co4UNObZLKFeHy5SrmHqmWMWlpoqHH1AMzFGY2kv
         RKQfZHUgzn3q/LqsLHFhENdMsaGTgsXs4tFpYIj21HsVfCnWo5B3dfcOEsuXMvSGxXo8
         cZrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794994564; x=1795599364;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :references:in-reply-to:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=duUV49H96MPxft6pLFc1UF8z64munBlO0c9zGA7dLPU=;
        b=MvJX5JyoWsRIS46upynGQCmIbJWJT5+XHecviVLhppsiT3PMzYVtUr9NiGhSf+G3dp
         GPPYUHc9kMykbmEe/uD1xxYSs0dYVPksAVcCexfF01xWGNUr5TlNKcu7WKx4UdKoSdn3
         KGgyu1dnl0qurNHnQCukdVhRQh/7/aYbImlJJ8uqFzDvoDWdZsfKso7QZL8Xv1SX+DBH
         p8bb64mQCrdH2pac0XePNtM+g/vsfjxQ40iQfoBie6n/D8DbEkHrTLmlHe4zKNkqz5c8
         0FZhSQRY+zYqvID4T1fl7Iw3R3fXrlq/Z+bLwDuOwcJQDohkxNVFPrDDgqb7jFORlqNI
         H+9Q==
X-Forwarded-Encrypted: i=1; AL+hErEceWmTvFpbcSyiZzd0zCGzvtjom7YKV+EYGJM3ejFOJxynTGU2jiXN+5KyAHAe12g0wJdn+neb32Y+@vger.kernel.org
X-Gm-Message-State: APuU4Z8PNeQsWqBfJo82XOdYuzn2KMt/4JoqjDLhNyJjsfj18bmvYPak
	cnFjTUFs11IaEK1xzitrqw1H+Ia7utZmZUXnxJOaQrLYxbtbuWeQYJFoA7BxqQ==
X-Gm-Gg: AZFdTZfAbH22mTzrpoa+oOqcdCe2ojoGjChhloVyvN6EVGNUcFX483u0fttC+Fb1C7g
	qW9EiVPrEB9vXlR6zTEV9n5b6oENuJTehQqUCRnXWHOrAihhquIebuhbZUhUwm4D4Ep9M7v009Y
	wiBwPsBK4Vi8LMRs7D7poTROP8frjS0u67wlSB7s9Ax8AwaILQ2rIFWD026iq4QNBS/u5QYvrkW
	ECcy+M9Bfir9ZST8R3LmPvxtOJW6pg0aXciP/igpa5/HwtQVztv472UN8XmWX8hISCCvczhOZXl
	UIDAtoyTu16bUj7AJcznA9qvn3kwx5QaBqEwnumdEE7rZHYcooqaN0Q2eJqYe68Bwae+k43KyY7
	0AiDcGI6yAy0VYFftW6puZyrT+hb/c0wD2KXU84RuWZ2YCliGvNE4OFry0D+5l8Tg9QsQxuy2OC
	aVfP/Z6Np9fANCpJpTouciX8HvFIR06BtDdpRSQwDskbQmg5oeVmcpxZFKNnyuUejYMNExCLBCF
	sSomSByi81/JCR12ncimUfljsKS7L9VrRnc3d1MBGF1ynd0686tXUwOhPTanqBGcwWpewHrxfvW
	74u+/aeFAJikZylcdKxEoYEMk0qNnUdcOmx5gkdUHeL1S4IgnwxG6q5C2BO0fp7grnaRSHFCVzL
	gf3q9kZy05kkJ0xL7kKr1vxh/9C088yzy
X-Received: by 2002:a17:90b:5343:b0:3ac:9176:e82b with SMTP id 98e67ed59e1d1-3b3d07c9cb1mr1972912a91.54.1794994563902;
        Wed, 18 Nov 2026 01:36:03 -0800 (PST)
Received: from reply-prefix.eml ([117.28.251.181])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b3d143b9a6sm3505843a91.2.2026.11.18.01.36.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2026 01:36:03 -0800 (PST)
From: Chengfeng Lin <lin2530632123@gmail.com>
To: Jia Zhu <zhujia.zj@bytedance.com>
Cc: Theodore Ts'o <tytso@mit.edu>,
    Andreas Dilger <adilger.kernel@dilger.ca>,
    Matthew Wilcox <willy@infradead.org>,
    Jan Kara <jack@suse.cz>,
    linux-ext4@vger.kernel.org,
    linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v3 0/2] ext4: avoid tail walks for cached large-folio writes
In-Reply-To: <20260609035202.90669-1-zhujia.zj@bytedance.com>
References: <20260609035202.90669-1-zhujia.zj@bytedance.com>
Date: Wed, 18 Nov 2026 17:12:32 +0800
Message-ID: <20261118091232.ext4-write-t1k-prefix.3a08a@gmail.com>
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Hi Jia and all,

In libMicro write_t1k, one worker overwrites a prepared ext4 file in
1 KiB buffered writes. In our v6.15.11 / v7.3 / v6.15.11 comparison,
with nine runs per endpoint, libMicro's reported time per write rose
from about 0.233 to 0.502 us (about 115%). As discussed in this series,
large folios amplify the existing buffer_head walks. The measurements
below concern the remaining prefix cost after d09811183db2 and
f10b9cc1eb20, both included in the tested v7.3 kernel.

Before each run, I created a fresh 10 MiB file on ext4 with ten buffered
1 MiB writes of zeros. Each batch seeks back to offset zero and performs
10,000 sequential overwrites; each invocation runs for 30 seconds.
The machine is an i7-12700KF, with THP=madvise. The worker was allowed on
all 20 logical CPUs, without another benchmark running.

I compared v7.3, the same kernel with ext4's maximum folio order capped
at its minimum order, and v7.3 again. Each endpoint has nine clean runs:

                                v7.3 A   min-order   v7.3 B
  Buffered write, us/1 KiB call  0.500237  0.245877    0.496312
  Observed folio size            1 MiB     4 KiB       1 MiB
  Buffers visited per walk       128.5      1          128.5
  Of those, before write range   127.5      0          127.5

The timing row averages libMicro's nine per-run medians at each
endpoint. It covers the 1 KiB buffered overwrite loop, excluding file
preparation. Maximum run-to-run CV was 0.59%; baseline drift was -0.78%.

For the traversal counts, I instrumented one separate run of the same
workload at each endpoint. I counted buffer visits in the begin and
commit walks separately for the first 1,024 writes from offset zero.
At 1 KiB per write, that covers one full 1 MiB folio on the unmodified
kernel.

The min-order control reduced the reported time per 1 KiB buffered write
by about 50.5%, or 0.25 us/call. This supports a remaining prefix-related
cost, although changing folio size also changes allocation/cache
granularity; the control is diagnostic, not a proposal to disable large
folios generally.

These counts quantify the prefix traversal that remains after the tail
fixes and may be useful for future work on this path.

The libMicro source is gormanm/libMicro at
976d502afaa2d9b919564d7fa8a08fec286dfc89. The command was:

  ./write -E -C 0 -D 30000 -B 10000 -L -S -W \
      -N write_t1k -s 1k -f /path/on/ext4/data

Thanks.
