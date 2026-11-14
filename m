Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794648350;
	b=UOUuAp/2Hcxu02v5mLDKg+Vz9xbCWFNut2FN+rufn7e+3BlF1DI7ryNdfkxcj/nPuLoX
	 GBOmu3MN8RSoUTIBu8W8AzoYjU9BH7ZM9sSUVJC5Ry+DtMBwiTcGU2092RqsvnIQChuEK
	 7hKsXYgsZnkLEgZAN7gHsE7voSfj6gesQo5feZ7LKZUQvQYauuWjXEtxfmrxDtFOT0Aze
	 efZpngK8Qd0jNZ1wPeOeysjMgXbL48AEJ7dP418SzdPoDpd5YBBsryZ6IDu3BaMOV8+Ob
	 QjyrYis56v7MDHbzLwqbHPhvQYSewtlxB53piH7e2mpEpmpR+daEE+GvO4xcxyquY2w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794648350;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=/mZCd16s0rOJD8RvwqMAPGTGJNlQHWt1x/I87qRDNSM=;
	b=KPafoNsVVUqh3qLhk2F9uyB3IwvqPxmL9YRSAWXrc5KCZVANM6Z4X1F7cvAiyw3AOfut
	 7a6HorpyP+fswlZBhsL98lN98NhklaKcrw2kXBukoh1grt/khQ8V13jE0k2JEI/kg3B+y
	 HoC5X1WI0vLquL4c9MKKXFTL5PgXibWwksPdPLh2ejeKCP3K3bk9a+Y37kQ7EslODm5mX
	 XS+epb+Jad6+zD6qyZXT72hlmD6omtlk2EZ+sYXTnbeg/jualhjK51+qzp/vCk/felOPk
	 kFjXlJH0lDHTeM48zOy5Kc2g9l+sRoWctZ1m282U0AwzIhYMTfOTR5iZNDuG+miNW+A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=nWvKCEOv;
	arc=none smtp.remote-ip=209.85.128.42
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53918606A327
	for <linux-ext4@vger.kernel.org>; Sat, 14 Nov 2026 09:25:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 53918606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=nWvKCEOv
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4a4d7ae1ae9so13779935e9.1
        for <linux-ext4@vger.kernel.org>; Sat, 14 Nov 2026 01:25:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794648349; x=1795253149; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=/mZCd16s0rOJD8RvwqMAPGTGJNlQHWt1x/I87qRDNSM=;
        b=nWvKCEOvJ1zord+TkQ/lmJEI9fAIXaf6FyXXOq2gD2fiKMwkgCC/m+VnkIPljYmnxH
         D3s+igShRxFDEVr20c9uYMRzQ1phcOnXn4iZn9+MswCnq2JRYIqmdtKYnOsty9/LWTbr
         CF+nqwd4zoEkCR1AmGpKY7oyl+MIVgOdv3KNePMNajkVnUFSSkgVlM5ANb57AjoqQt8W
         LVq+Ba/wtdajYbFXvOd+fhBFYCdm0tdZ6rUDfUt+QrWECoTTMzqxdRkQjtHuJID91Ywy
         4OWK5T9jfAbJCmt7I99QdsArPgNalPd8v72/bCzRzO/LZZfdRmWL+kAAxZIm9FvMYp+0
         Lo6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794648349; x=1795253149;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/mZCd16s0rOJD8RvwqMAPGTGJNlQHWt1x/I87qRDNSM=;
        b=fid/fcoyndY0XFavcLI0wbAm3hdbw3aIhAExJYiAQpOA5MkOIsS5V6suFOs3JgMcxq
         2nvgV2+tRY57ygsKnTN10MOy6lfloXWsmUNu52SlZiEl8jPRj5rAoHOnbbAXhWdTwuQ6
         SN1uXd6FPDLD3cfv+cZ8kT6cXEToQ/gSFpp/f8YMVUwjnX88hVcPhTjhElXczLvhMY3Z
         Ml/nFl6Hl6dOuNPiNDwnd8MBHT3aYyJPDfPUS8jDzzG6gxmWayqXxP7wUBna+uXGvBRy
         DDX8+FTxDRoFFs1dq5g7uboTf+ympUVibcizOe5/tPv2EDhQCxTlMVreaDC5TF9KpDyt
         KvSA==
X-Forwarded-Encrypted: i=1; AL+hErE9UJTNneggwYRo+SNe+DyLF6YtDKm82B71ZVMqVZ9fjOrDaq8KOl4ZKR1s68Er1YJHOV6WjbdXHCnn@vger.kernel.org
X-Gm-Message-State: APuU4Z9UWzfyiGrH1YkV+zTo8S9P8qxDLS70dxue5kO4IOQOEq/vRl6T
	Aimsh86ywIV9f03JGrmOHQGYoSrKQPZPbHmLoPhNnUJBTaADrbWQ5lai
X-Gm-Gg: AYBFou3eSWqJjy7AL1ab25509r+yYaLDhZzXNgsCofV7HgkLPb7O2WnnJfz+znRldrD
	6YypTx0R7zwqWjv72KkrOrspFv9sR7elug+V0sOy2PV6q9FFAEBDXkyIWeVWogJWJE/PXmVlwJs
	zbUhnsI24O3hDVvax1c/aOlh/kPOtPlL8jtv8ShTJagIu6vK4v+ERxCxsUyJg2NHExELMCFg8f5
	SJaBz7LiQh9joLbWkEfFzpQlSvOjcSxX+5ZeL7zMXQWgmY/1iBs83QmHhb41RpiEGTbeOHRtbcx
	9iHcobDZNsV+hY9ZkkywwP0asCf6FPzK/HQk25BpV9sJTAhviSeU3U/O71/z2WsVovAnjt+ZQpO
	JZdSvP9X4n5rgKbKVRQ42RyYlX2mY3oqIzXKesYotbhW8j6eSMJz3jz99OlM5F971DVQZpPduXh
	tU736bGq40uAX7oLviZU0hFufR4ZGPknen+Tu4ZKHNJhPSRzIRdIs5Uuizbp+KOBb0anJgOJCBx
	m2x7oMQeG2xlpWrTwMBz7IGsZUgFFs0PqGGoKdPVbcqKsHmd4wYjX3YjinFaHc/jtKPAtxXnjN1
	eAjEK1kGuOq/8FkUrf9gysqa1htmwR4XCyrO3T9+hR5FLP312tEKez32Pw4JQMNeFkEI26dMt8V
	q6ecQwX26ltsSi0dN4BH7CvUNg9w8Mu43LIoyw86r5pekt1koFrqj3qvi9VeixOi8D+9jTNACpb
	MbfOW+AfhH4gahaWEYOL+goA8wgViVCPmC/Q==
X-Received: by 2002:a05:600c:37ca:b0:4a1:e0db:8cf8 with SMTP id 5b1f17b1804b1-4bb559f2787mr104257555e9.3.1794648348343;
        Sat, 14 Nov 2026 01:25:48 -0800 (PST)
Received: from unknown748F3CBA5068 (dynamic-2a02-3100-b358-dd01-fd08-0f0c-fef7-8409.310.pool.telefonica.de. [2a02:3100:b358:dd01:fd08:f0c:fef7:8409])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49c604ee47dsm9295782f8f.38.2026.11.14.01.25.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Nov 2026 01:25:47 -0800 (PST)
Date: Sat, 14 Nov 2026 10:25:44 +0100
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Theodore Ts'o <tytso@mit.edu>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.cz>, 
	Baokun Li <libaokun@linux.alibaba.com>, Ojaswin Mujoo <ojaswin@linux.ibm.com>, 
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, Zhang Yi <yi.zhang@huawei.com>, linux-ext4@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] ext4: return an error when a journal block is not
 mapped
Message-ID: <avgo364sThHcltzC@gmail.com>
References: <20261016103726.98553-1-kmehltretter@gmail.com>
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
Content-Disposition: inline
In-Reply-To: <20261016103726.98553-1-kmehltretter@gmail.com>

On Fri, Oct 16, 2026 at 12:37:26PM +0100, Karl Mehltretter wrote:
> If the internal journal inode contains a hole, ext4_map_blocks() returns
> 0. ext4_journal_bmap() logs "journal bmap failed" and aborts the
> journal, but also returns 0 and leaves *block unchanged.
> 
> jbd2_journal_bmap() takes that as success and uses the unchanged logical
> journal block number as a physical filesystem block number. Journal I/O
> can then overwrite filesystem blocks outside the journal despite the
> abort.
> 
> Return -EFSCORRUPTED for a hole, matching the error passed to
> jbd2_journal_abort(). Keep propagating negative mapping errors.
> 
> Fixes: 62913ae96de7 ("ext4, jbd2: add an optimized bmap for the journal inode")

A friendly ping on this ext4_journal_bmap() fix, which carries
Reviewed-by tags from Jan Kara and Zhang Yi. Is anything else needed
from my side?

Karl
