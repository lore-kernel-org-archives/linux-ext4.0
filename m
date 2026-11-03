Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.224.43
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793749547;
	b=Nh2zR5ZoSLXdWBqXIn6bGoBlakmqhMw/hneIO1Zym5NhfVyFwitAgsxImDH4H2F0k27/
	 aquoCLGbdO+fQsHOMPWeVxCDeHyVyqK743pIjAR+ZgEYleNE6Y1HFjjpHB5DMrVMt6I6r
	 4W2UtLyxLg/8bu0kBidhHLe1NqntuotRoJPNpvPhejdqHBbTXtd/Y7FXmbrXXk8PAm6f/
	 fWkdOv/T4qxgtNYLV46ULCHj15H5DWLtYH192H5ixFy5eK/we5NF0T1RdKH1RihzPYyGH
	 +9uvMoguMJzNwWfMkVgWkgvCLpM2CsyYLgRFvz9IBZ9KTdepIxrjLOX7wXScQFSUFAQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793749547;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:MIME-Version:References:
	 In-Reply-To:From:Date:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type;
	bh=mWUi0jQe4jXllGQkO/zsmL9jqAxs84JxaivQ6I+Xrkw=;
	b=R8IsrBc6pxMN2y6kYCAWyRcjY5xxi9gcs37mqHbcpT6NBD0M4iIeoId0m0ykWXyjBkrq
	 R7DaSCzExTU2uF++1Fi946OdC2NKrYWLPIuRqSPXzHdMfF9RBEH5qVD+gP2a32CHmtP71
	 qTUgt1uijh+enCsG0C5daGw6vGLgFnk6syyjkTX1s9yuvYQ+zFwUOTYZKQWpqkc57E+cA
	 5Q41EEE4hIiR1o8xtz+KjiiP1ogI5NDMUmYKSly6MWCNc02N4S2JKmh+oGB+U5DAlzRoU
	 gu33H5nW3zyTY/zCtuh8wJXl7dMzgqK4tGrZIVtY8D3WeTBhzwNG7bsX4m+REx1g6Jw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="GATo6/Qr";
	arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.224.43
Received: from mail-yx1-f43.google.com (mail-yx1-f43.google.com [74.125.224.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36352606D804
	for <linux-ext4@vger.kernel.org>; Tue,  3 Nov 2026 23:45:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 36352606D804
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=GATo6/Qr
Received: by mail-yx1-f43.google.com with SMTP id 956f58d0204a3-679965fb848so233337d50.1
        for <linux-ext4@vger.kernel.org>; Tue, 03 Nov 2026 15:45:46 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793749546; cv=none;
        d=google.com; s=arc-20260327;
        b=nbhwxoqgBRxliFUHKVA7z2mkEaiNelHu10g9cHVyJ1lDucQaH3VjGpc4RH8xXUlzZ4
         2jGfCmiD0xavh0RPu0IwCFas4RqE9toPKbFLGptiUC1djEKgwrgGVww4jTr8qmrQRQ44
         pcBHkazhXBwEJDga1H/NdZx7YP4wraupNnuTTpwUpfBiZL5rMW0mxrwBedeg1rHg8YpO
         RUmGwHsqY0A1dj4TkHMPkEQe+/I3wTdUgdGMqnzbskkdouSLMzBamaGxbf8/zO0rRu7a
         vYujXu69TG6zqkRT5QU9n9z37MEqgrkiuyub2GC8wJ1WlP9EnpvsPmjYgkTJ0tM7Degu
         5dnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=mWUi0jQe4jXllGQkO/zsmL9jqAxs84JxaivQ6I+Xrkw=;
        fh=kEaSYrH61nBGKECZtUb43aWWAfMnT7KENZ6Sh7ickKQ=;
        b=hkOsgdU9WsE9gBvJmwp4Fj8ORYdtz3TGg8iTjVFmPUFjCrUfdjflV7eh/3jRrcDxgT
         QJAnI2v7G6/pXcdtZGlpVjqQQghJL+GBHzUmjEctD+4IRzsxxqErMd7ZoPYltUBwEM8N
         ZtMuXXcZ6k+cwIGx1HT3dKELtTdnUW+XkICb1VL/c6nNhS++oZrJOPnWCZD3OXQqiNsj
         eb5ehoeStnrZZ7118Xm2Ud5So+bBOx4OLjBgHK+HPxecWLSzwDCHSZuh6XtoUzjTRghv
         Q2NRs9P3XEKJXzp8Rdxzexy9IXjjTE922xNjhf7dAQlV56Ig03Wz4D8fc0GoufN3uCgt
         e06g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793749546; x=1794354346; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mWUi0jQe4jXllGQkO/zsmL9jqAxs84JxaivQ6I+Xrkw=;
        b=GATo6/QrD69w3+peFSHx2Hz/ZtgbIWkFrLLCB3vTaxOIQKFeyYjFuLcp7vQoGlJ0Fg
         A6AbMrvolKhUmMLIkBMXoS+rteayQz7B1U6SDMojG7CKLYTM6cC+1TCQEmTpXi9f49v4
         /p7PTPZXFEnnA+SQasvMvlpqJUWALcYPVZ9WGWZpMeXOLFmFNsfN1bUXBNzqkaea/6yY
         /zLkMY3jQRx5Ss1WpN/STZbb6qSAu3BVNXrnwoQ5A7kUylwJhBn0zHgzBIY5XUbA2bQP
         +pjYmo9ODScaj8KsOyd3gjDvuT0bPucOd6yf5AY90xhR5ZiG/o0wcY00H6Hpvy9INDfW
         x4RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793749546; x=1794354346;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=mWUi0jQe4jXllGQkO/zsmL9jqAxs84JxaivQ6I+Xrkw=;
        b=s22j5bPnswFiUpGjCiMtQwIsCo6P25PAdeRM73Ey4lB2TBHQLsC9f0p5JfcpIoNagg
         YTzV8Py8TBNrcujRGDUq63nQ1whQyF/Zi9Z/qNCNKyTrAh+IXEZPtKs3BSOTZnLkAKmY
         zvLeYXPRVbfxZxHFqhV1PCPrUIf8m7fSSvr/ICN4z5ECzwrTO2kTTVnRWJfGUtcodfAj
         mrxoiU7LUxo3xczSCb7tzyFsH2jlbEmTPhwgE++E3eFVB8Yve34UicqbEvSZ8+GW1S7h
         SGVJYQA6xUYnTXrr6rCA2NMdGjBhq+OgY/jQXa4JK4OJa7o9SaIgtrIXKsHUAq9zk5k9
         B8jg==
X-Gm-Message-State: APuU4Z9eR8hM4VwMt9dArktwCADyzbD2rcF029W9oTeQ31iM9aLOB2Tt
	OHBrVSVD8i6u0Nne4+PoUH4UqoXINnyONu1hJc2MY5G0hlBdhFR+xaUKuBHf5alNW4nINcg0sCb
	bzC9NW2obZMo7Xchfg+t6cnniGefnHzI=
X-Gm-Gg: AYBFou2anIlbR7gh55/ti73ZKPcpduLaa7mSMN73n0Hz5vBBjXSxWO9xBEFxKyjrKzo
	HRvQNdYjPmNSpeWDPi69Ws+JVBaxddrTJY48nnY921izZv5Qe/h0AV02J7qg14unZgbgbCIb+vR
	HRaj6d7kYWujbdAzxxVRI6xGyms6y5j9OBaQpQaAZOIvhng5/79SZQ3tiLfjVt9qNnztiKJozNq
	AlA0kjXlejxXvbSUoVtvbinE8t86UFPKEdtj6vtKUJxCPdWvgBSnTBvfksLD0pXuM7z+HKWtNPx
	jw8rJjB63akZ4A0zjhc0Me2C728oYkL2OC0RolnDGBrPfH4w9AFFWswg+FeGroN5MOGpsNqNvRs
	F1hMokWNGRqltNbvD4Kbzx5yDaMBV6GLSQ6L2H8DnLJqrncr/UQ68g8e7Y5ROlN7rlIYFRCdIaF
	Cck/rYXJXTrYW7JmyM
X-Received: by 2002:a05:690e:484f:b0:677:d43a:d252 with SMTP id
 956f58d0204a3-67ba4ef042cmr6749237d50.26.1793749545962; Tue, 03 Nov 2026
 15:45:45 -0800 (PST)
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261029122413.230409-1-ablagodarenko@thelustrecollective.com> <aunxw4vjchztwQLG@infradead.org>
In-Reply-To: <aunxw4vjchztwQLG@infradead.org>
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
Date: Tue, 3 Nov 2026 23:45:34 +0000
X-Gm-Features: AclHuK9TxWhaAgpPjh5aiRdGOHwMSPjKi_wNex-m44jH5TWhuOODi-wyqVBwAgU
Message-ID: <CA+rD4x9XAe2nFn-yP+NziRV=R76qbKbns1FP15eqDK4y2RtdKw@mail.gmail.com>
Subject: Re: [PATCH v13 00/11] Data in direntry (dirdata) feature
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, jack@suse.cz, 
	adilger.kernel@dilger.ca, ablagodarenko@thelustrecollective.com
Content-Type: text/plain; charset="UTF-8"

Hi,

Thanks for looking at it. Fair questions; I should have explained the
motivation better in the cover letter.

The on-disk format isn't new. The INCOMPAT_DIRDATA codepoint was
reserved in ext4 in 2010 (f710b4b96ba2), e2fsprogs already knows the
feature name, and Lustre servers have been writing this format for
over 15 years. The series makes upstream ext4 and e2fsck understand a
format that exists on a lot of deployed storage, instead of leaving it
to an out-of-tree patch.

What it provides is a small, self-describing area after the name in
ext4_dir_entry_2: a flag in the high bits of file_type, then
length-prefixed records. It exists because some per-name data has to
come back from readdir without reading the child inode, and has to
stay with the name across rename. An xattr on the child can't do
either without an inode lookup per entry, which is the cost we want to
avoid for very large directories.

ext4 already stores one such item after the name today: the
casefold+encryption hash. This series gives it a proper record
(CFHASH) so it can coexist with others. That work also turned up an
existing bug where the kernel and e2fsck disagree on the htree index
node limit for casefolded+encrypted directories (patch 02 in v14).
That fix, and the dx_csum bounds fix in patch 01, stand on their own
and could be taken independently.

On the consumer: Lustre is not meant to stay out of tree. The Lustre
upstreaming project is under way [1][2]. The out-of-tree code is being
split into clean kernel modules with a separate compatibility layer
for older kernels, and the plan is to post the client and server for
review, currently expected around 2027Q1 [3]. The first server
submission will only have the in-memory storage backend. Using ext4 as
the backend needs some ext4 changes, which are being prepared
separately so they can be reviewed on their own merits. dirdata is one
of them, and one of the reasons the Lustre server needs ldiskfs, a
patched ext4, today. Getting it into ext4 is what lets that patch set
shrink and an ext4-backed Lustre server run on a stock kernel.

If there is a way to make the in-tree value clearer, for example by
splitting the fixes and cleanups (01-04) out of the feature, I'm happy
to do that.

[1] https://lwn.net/Articles/1025268/
[2] https://wiki.lustre.org/Lustre_Upstreaming_to_Linux_Kernel
[3] "[RFC] Lustre Upstreaming Project Update", linux-fsdevel, 2026-02-23

Thanks,
Artem Blagodarenko

On Tue, 3 Nov 2026 at 14:37, Christoph Hellwig <hch@infradead.org> wrote:
>
> I ended up here through the xfstests patches, because this looks like
> a really weird feature.  Unix directory entries aren't really standalone
> objects.  Why do you want to add more data for them and hugely
> complicate the ext4 code?
>
> There is this snipplet:
>
> > The first user of this feature is LUFID (Locally Unique File ID), an
> > identifier that must survive rename and be accessible from directory
> > readdir without an inode lookup.
>
> Which doesn't really explain anything.  And unless things changes in
> the last year, lustre used:
>
>  a) a kernel client making use of the file systems
>  b) used a heavily patched ext4 for that anyway
>
> So why should upstream carry this stuff for something that is a
> perpetually out of tree kernel consumer with a really odd architecture?
>
