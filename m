Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A72D3D411B
	for <linux-ext4@vger.kernel.org>; Fri,  5 Jun 2026 09:51:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780653062; cv=none; b=pWBIqaUajohg8rLkMcQTh9cnIDmBJfksK3Sb5X9/Z7oCVdzEo24zly6WEMJL51ao8HwuvSLOmLzAF/lhiaYv1lmJH43V9Be8Kw+9bq4CIBT0n7XBbnwwR+5EdOoDQ1wLzSemAP02CaPTP9XayRnMhSx9cU1DXrbJtVzFc/j6j8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780653062; c=relaxed/simple;
	bh=Eu3wfuEQrxBBkGKCkeAzZasx5ExuiXoVmmjPgYkiKnE=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cKxJPXvbu9HZMnxICMkxRcoJ2e9cAsD+R3ieAkEZsHP+gVSpArLJle2ts2Mna3w1CgU9k371QckB30FEhUbdRMeWhYIFZAc3bffDugOyRpBdZZw/4eUXV3/pbRg0MnKTjuI/ye+K1Ej6l0eJMVrYYv1rWubkpJLub2JYtIeg2xk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eW47JDlk; arc=none smtp.client-ip=209.85.167.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eW47JDlk"
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-5aa2c25c632so1802113e87.1
        for <linux-ext4@vger.kernel.org>; Fri, 05 Jun 2026 02:51:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780653059; x=1781257859; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=xjcf+ZeYGf95GdPFKMkbVvi+CX0UN2Mwhbe9F7S/JCk=;
        b=eW47JDlkG9AyVc+yVGis+R03w+8ToWfDDo4Y3viCp57B3kR5wbz/FAqd47r4pYFSOm
         FkRIMiTET+hwmWxpKsFkhnrafbjsavxC2M0FzEaXg835X22wv9ZLa4QkUuqymYu4Ynaq
         8FkbMu3QVv/Fd70C0BDUvwGZRDz7ZT2lzCOFjoZlgISZM4oKJPZzqpBAS4ySo6D4fL3A
         uTv071a7XkMBuJViLY3t3Z9lGSFGUfs5ijatPPH8V36SOWbRCQaIaB/SNBIWePTCrX/V
         qbxnHIbjcApzVvHgh0B6WI7h5dc1xUH/mh/dz9blSkfPG/zCpE9t73QUCYijukbosPXu
         fQDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780653059; x=1781257859;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xjcf+ZeYGf95GdPFKMkbVvi+CX0UN2Mwhbe9F7S/JCk=;
        b=LGMzoVIaWm1BulIXAgqC+qf/9NYv0QDG8o+VARigv3DSxjxoVbaNj1YS2pp4Yn/ENc
         KzRJFbUiuLYqz1J4OkkXFIKwtDN9CZVZbM+QJ9pEJbbxgGFrBbwvfaTSfe2ZSYR1OTvQ
         r1rvqebDoWch1OtcGi6jvOg1p2d7ivLeYnBELEJEumqPA8XRT+M1v1GpwwOwlCg/iLzD
         UUWBjuXzH+jmfIqlMXT8kId0qTLz7tuJn1lMvugv1qwpjh2vidxegIo+U4NEo8p0HNlw
         lCrWNrXI617M4m19VksYhk9n/srPwe2vn3W+04FpzM1twSo9pcQOb+iX/dXs/IySeGvX
         TSLA==
X-Forwarded-Encrypted: i=1; AFNElJ9LGjytuhuK6cnjmhWMteBkOFa6SIQAXvmQnQjjSmLEwPLaRRI4VyO3jOxGkscZny4uwmHOnZbC7yQL@vger.kernel.org
X-Gm-Message-State: AOJu0YyqpbcS1xEuzFQyeAOW0ULBMr6VCoVQJLnGpvYYHPH/T/lR8zPr
	DlNWUEz8WVF5K9SES8RBufE4YlQaEyTIdVHOs0DrQufEsieumNRKcLUeYaZW206wRX4=
X-Gm-Gg: Acq92OHGUkQtQ6ObRA3Tj3LyT00eZ1fms2lvf0RkXQnCrsDSJjOVDNQqYusg9aeKzs0
	giM1mJZMa30qrhzD/HjK+DuemqnB4JrXp5YFc9AfpRs+SlKf+s4tlQQi4/Ck0xtFOHShcMbRmRs
	eH2yFhHYddo88hFgGyoUT+8RS29Xh5/eaG6HTHemtC35yNR6AG/71XrMm9H7AiFK15I7/vzMKlB
	nbubZneVJWT25sfDYhWqtlL9nTCLuLhqB/sjmPJKE3cBAlqruZiLb8HORQ/yqhfaJwMRyP/IJgA
	XPjkW9wa0ZwPGIeB17BfkMU4ToIrRJTptLyo7+UUOG9wAcPSSgUOTiTlYltYzcXvYgzSRwq/xNB
	idwwEQIYARJFr8OKbFILwseJN57TOeCzOn8wigwWPQfqoRC4KHCopdvWF0qpSKXaIh47f+FWLy0
	4iAARXoD+B1KuDeOkYXHo=
X-Received: by 2002:ac2:4e0e:0:b0:5a8:6cbc:60f3 with SMTP id 2adb3069b0e04-5aa87c03398mr899588e87.34.1780653058812;
        Fri, 05 Jun 2026 02:50:58 -0700 (PDT)
Received: from pc636 ([2001:9b1:d5a0:a500:de96:9acf:5dca:ede4])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5aa7b97a71fsm1761298e87.46.2026.06.05.02.50.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Jun 2026 02:50:58 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc636>
Date: Fri, 5 Jun 2026 11:50:56 +0200
To: David Laight <david.laight.linux@gmail.com>
Cc: Theodore Tso <tytso@mit.edu>, Mike Rapoport <rppt@kernel.org>,
	Jan Kara <jack@suse.com>, Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Trond Myklebust <trondmy@kernel.org>,
	Anna Schumaker <anna@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Jeff Layton <jlayton@kernel.org>, NeilBrown <neil@brown.name>,
	Olga Kornievskaia <okorniev@redhat.com>,
	Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Dave Kleikamp <shaggy@kernel.org>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Breno Leitao <leitao@debian.org>, Kees Cook <kees@kernel.org>,
	"Tigran A. Aivazian" <aivazian.tigran@gmail.com>,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	ocfs2-devel@lists.linux.dev, linux-nilfs@vger.kernel.org,
	linux-nfs@vger.kernel.org, jfs-discussion@lists.sourceforge.net,
	linux-ext4@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 10/17] jbd2: replace __get_free_pages() with kmalloc()
Message-ID: <aiKcAIbzz3z9vN9a@pc636>
References: <20260523-b4-fs-v1-0-275e36a83f0e@kernel.org>
 <20260523-b4-fs-v1-10-275e36a83f0e@kernel.org>
 <yfzx3jgzwesernofl7mzixa2mhjfii5v3o7yapghtmozixrpfu@6bsh7iixyiov>
 <aiEX4UTxEnBTjVKo@kernel.org>
 <ximvn6jwgtam665a4droqkp73o55kwvd5uukyidwjesmysobth@oe7rigpsjfkz>
 <20260605093332.7b067876@pumpkin>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260605093332.7b067876@pumpkin>

On Fri, Jun 05, 2026 at 09:33:32AM +0100, David Laight wrote:
> On Thu, 4 Jun 2026 10:05:52 -0400
> "Theodore Tso" <tytso@mit.edu> wrote:
> 
> ...
> > I suppose we could do it with kmalloc() with some flags which to
> > prevent forced reclaim / compaction, and if that fails, then fall back
> > to vmalloc().  Is there a better way?
> 
> There is already kvalloc().
> I'm not sure how hard that tries to get kmalloc() to succeed.
> 
I assume you mean kvmalloc()? kvalloc() is something unknown to me.

--
Uladzislau Rezki
