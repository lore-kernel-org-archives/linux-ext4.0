Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 250603D9DAF
	for <linux-ext4@vger.kernel.org>; Thu, 12 Mar 2026 23:52:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773359525; cv=none; b=lOpdQ/Yx9QTcmu6WI5NBMp6OXP9ZV/LgpIRnPGkZYw+BuQuFbPF+6JmsBqvicE3/FfzzmAtG7Sw40GbaRQufMlPTLY3FuUVuKMnULaqBfFl7MeuFwrBgk5x+O5kpIZ0OPCScN3zJouvfrtN7OQjbeYpm7lQqj/IJaEeQ3MwLQ4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773359525; c=relaxed/simple;
	bh=wOUC16WI4/reo5GvoZO5ESmt8rfD7PE3++Xf9novjKE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fFU9LeYWjK2Cz34etF+gWnvp99rmaet76VS3TNnfa4TWkyAw+eJr3xqG7lNGjqT5bbFelevHPmT/D7YZ9M2HurAft8jPKjm0zfhEcl86mr03Y67BK010/ZT7DCATr9He/INrdkmqveXe2uFU0u3mb5UXjfKVDtReRhca0k0IF/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NdLN8spx; arc=none smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NdLN8spx"
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-660a293515fso2789119a12.1
        for <linux-ext4@vger.kernel.org>; Thu, 12 Mar 2026 16:52:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1773359522; x=1773964322; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=pkgvHL0resGmXTqRBi16uC1NxLEncxIx9i+VLjGIXAo=;
        b=NdLN8spxAnXU3OtOtiPHJrtwygm0T8rtXLQoXp4tSNwDQHyWdX52NwKuAVZtYzxq0Z
         4QP5IIQva+T/9Z4TgdWvgkH0+odeZPPW5rGWwVYvuJf2mbuFhHFsEFnBBvkFCNugrvEw
         ChMECZsI9TNiDnQ+MkoUKWHMfrR+LdX2REBr8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773359522; x=1773964322;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pkgvHL0resGmXTqRBi16uC1NxLEncxIx9i+VLjGIXAo=;
        b=OubONwONrm/MNjGxp/XyLqRGHqCwzmefmaPOW9u9HWqk6RpaSH6y+c96vuPZ1fVaLZ
         Vp2NfIrki5dI1qHMihiMhqa1Uj0DMQHMHs3mdl2jeiGr5cQHSGyhFRYfRTpTNpJZTfy5
         s+GmpcSS8yE1Ot5in6OKlAwojOnFFDYGHWv1lpKcnWonRSdQzynq2UxroRqvTHg0/QyN
         dssCer5WI3HeOtZiDRpoyUPbRa6jt2RHFaVVGHvYEU06KiCWiKoEkUf+QPwDfn3Blonj
         SUbJbAlw8xD50uQYp0X96hi1mNvip/MfYi0q04gNSpjd8fD0o9EmJLQ3fZvwmIO8VV9X
         BIXw==
X-Forwarded-Encrypted: i=1; AJvYcCVFC0V3ws4DUMEbsItUkhT8QGjZtLoKe5hcmhAaudS5ntxCrDvdRDu5FOvYjQ2x9AFxUvFWH2Z+8Wni@vger.kernel.org
X-Gm-Message-State: AOJu0YzUmp2BY1cOmOeTDD5bc8vnxdwmmIgdG+aB1IzuGkEQJAfgg6LP
	7AftKRTZ8od4pFcoMR31cw3854Xri9U66+aML27AVY0S5LpZUT+Sad3Sy4YAbdlEVhcIKLaSLTE
	VcZycdSQ=
X-Gm-Gg: ATEYQzx85t/eItUGlid6BaDAeNm+3vp0jlw8JuakyqyocuEdPGSFbo3m0QrGwoRoJhj
	ipkxA9YKIoUv8wWBiKDJhP4LR2c5LiNymoeZR/gJKVA81PWHMLqBs5NdYfmBj6QjO6VUQL34Z++
	7G9+5Q10CuneEt+i8/5HsvxkNdpRI81MapsBIUzJPEFzD3mokHfjKFfM6w1v5CdiICrpoKTMly9
	6ogMTaXe01xu/CSzuclUc7xThGaRXEelewa1pkN2ZLmNoiqqAzdfUkbB9FRcZEOvm8fPf1v/qrL
	brelTeOoUcAjp9ejcCinpde9By3Z90BkZ3TX0F6uWyWzvU8tV9Sk/RU1axNb6nshNa5Gm4JNsyi
	yzEKWE82aGwaUGx3Y1ML3MZqBteVEZf7Q5SEBDMjZNS6e/kdztruBpKVg7IJiJ8fI4C32sYcup7
	0TpXjDzglRMf8swMTtmIFe41JKZ9hOycpC/kCG+GKlu+CMZN1RZ9OQoFjTM4jJ0wfaYX8uT7FD
X-Received: by 2002:a05:6402:5113:b0:65f:a9fa:cbab with SMTP id 4fb4d7f45d1cf-663bb4da4bemr689313a12.32.1773359522319;
        Thu, 12 Mar 2026 16:52:02 -0700 (PDT)
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com. [209.85.218.52])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-66350b85ca3sm846939a12.26.2026.03.12.16.52.01
        for <linux-ext4@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Mar 2026 16:52:01 -0700 (PDT)
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-b96f02b4329so272398766b.2
        for <linux-ext4@vger.kernel.org>; Thu, 12 Mar 2026 16:52:01 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUtzrdt2FH7pSEPvU9SMurqv6g7K0NpL0hFVOze7RNxR57CGyz2RuWLE75BlY7JtVZzGtA/NTB5uNq6@vger.kernel.org
X-Received: by 2002:a17:907:c5c9:b0:b96:d802:8b41 with SMTP id
 a640c23a62f3a-b9764fd8722mr66207066b.15.1773359215961; Thu, 12 Mar 2026
 16:46:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260312214330.3885211-1-neilb@ownmail.net>
In-Reply-To: <20260312214330.3885211-1-neilb@ownmail.net>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 12 Mar 2026 16:46:39 -0700
X-Gmail-Original-Message-ID: <CAHk-=wh92deXvH5iXCo9mThXCBYt-jRcVu=z4kiH-f3+wZQOHA@mail.gmail.com>
X-Gm-Features: AaiRm503fTaccEgKNbxF9h_dDHM9fUsSr52XJuxzTwCI0G9L03uDq8g5di1zchk
Message-ID: <CAHk-=wh92deXvH5iXCo9mThXCBYt-jRcVu=z4kiH-f3+wZQOHA@mail.gmail.com>
Subject: Re: [PATCH RFC 00/53] lift lookup out of exclive lock for dir ops
To: NeilBrown <neil@brown.name>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Jeff Layton <jlayton@kernel.org>, Trond Myklebust <trondmy@kernel.org>, 
	Anna Schumaker <anna@kernel.org>, Carlos Maiolino <cem@kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, 
	Amir Goldstein <amir73il@gmail.com>, Jan Harkes <jaharkes@cs.cmu.edu>, 
	Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	David Howells <dhowells@redhat.com>, Marc Dionne <marc.dionne@auristor.com>, 
	Steve French <sfrench@samba.org>, Namjae Jeon <linkinjeon@kernel.org>, 
	Sungjong Seo <sj1557.seo@samsung.com>, Yuezhang Mo <yuezhang.mo@sony.com>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Breno Leitao <leitao@debian.org>, "Theodore Ts'o" <tytso@mit.edu>, 
	Andreas Dilger <adilger.kernel@dilger.ca>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Ilya Dryomov <idryomov@gmail.com>, 
	Alex Markuze <amarkuze@redhat.com>, Viacheslav Dubeyko <slava@dubeyko.com>, Tyler Hicks <code@tyhicks.com>, 
	Andreas Gruenbacher <agruenba@redhat.com>, Richard Weinberger <richard@nod.at>, 
	Anton Ivanov <anton.ivanov@cambridgegreys.com>, Johannes Berg <johannes@sipsolutions.net>, 
	Jeremy Kerr <jk@ozlabs.org>, Ard Biesheuvel <ardb@kernel.org>, linux-fsdevel@vger.kernel.org, 
	linux-nfs@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-unionfs@vger.kernel.org, coda@cs.cmu.edu, linux-mm@kvack.org, 
	linux-afs@lists.infradead.org, linux-cifs@vger.kernel.org, 
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, ceph-devel@vger.kernel.org, 
	ecryptfs@vger.kernel.org, gfs2@lists.linux.dev, linux-um@lists.infradead.org, 
	linux-efi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Thu, 12 Mar 2026 at 14:44, NeilBrown <neilb@ownmail.net> wrote:
>
> This patch set progresses my effort to improve concurrency of
> directory operations and specifically to allow concurrent updates
> in a given directory.

I only got about half the patches, but the ones I did get didn't raise
my hackles.

HOWEVER.

This is very much a "absolutely requires ACKs from Al" series. Al?

Also, because I only got about half the patches, and there's 53 of
them total, I'd really like to see a git branch for something like
this. It makes it easier to review for me, and I suspect it makes it
easier for some of the test robots too.

But again - this needs Al to look at it. Iirc he had some fundamental
concern with the last version - hopefully now fixed, but ...

                 Linus
