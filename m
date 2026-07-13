Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68CA82ED870
	for <linux-ext4@vger.kernel.org>; Mon, 13 Jul 2026 22:27:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.216.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783981677; cv=pass; b=g8uZKcz6Mn/6zEUYOXPycpkGI6vYK75rAYy5IvNl/2F/ID5IjugJqRFxFasLyHknK82hNsV8/bVPMBpNjusikZc1q70WEEfI8jt9gNlRkaIi9dpeJW7lbI+vVTOaEm1YxYxo4O4HO9iSVQn3SgwF6JGZEUXe19B+T37F1Bu1mk0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783981677; c=relaxed/simple;
	bh=fbjane7tfgJKd+yHPImlcewhWxOYomgF7EIsJ/qW25k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sUqre+w1OWwAebjj/8q/8YSKekSFCN9vtUAuOJlqUsbQthfDYNdwsEK9d/qpWDq3U6joquG/m04zbg7giF+2vznGOO/C0gYYpDHn8NaFBXkvmt6LBCaVU3LUNjyVS3nW0jWIRCJjHGpYJQSm/7OHpYxTZroOHCkF7lzfP7IylK8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=q+G678hL; arc=pass smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="q+G678hL"
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-38125cebfdaso441172a91.1
        for <linux-ext4@vger.kernel.org>; Mon, 13 Jul 2026 15:27:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783981676; cv=none;
        d=google.com; s=arc-20260327;
        b=YvlO/9LobRgsVj4ngLQOa1fuYuJNS/HxT5vwMH3K19/ZGS2bGJlnGfoZ6ssPUDgtRM
         3EGEC7yTLkjoX1OlN6kEdo3roDfGinU4N8y1t+p9VVPv0fqVptEZcWU1XUCJmm/0AuN2
         an4GDLlBzi2ncvTzf6mNrcb8MhQMox4EVgr5Zx/n8LbwOpmqYt+8XQEnfSMS9q91BYbX
         D4/mpHjh/DvIWfVHQex6XjCs+qwe6uVa3qfGkio7bdDYUaWbqNbfix9/g+y3AgY5FjJW
         IJ5ICNXFcNihrW/81n3P/h+SfDZbTMfSoZdEMr5HdNC4VoYSx2PVyRSgvqCgcE8vFj4d
         LA6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=YOd9mExyjtslY9x3KYTXq5oCKN8VGg/406f26GPZg2w=;
        fh=29a7yMjhG77v46Ll53BR1miycyryAsAkIRpBmGh8kic=;
        b=OxAAD5wpgNAO3uTUorhJ+Xri4KzLSfUUBpdT8D5FQ8stjDPpQXcvWjdBy/XMgUpw2F
         hjrcGdsVPnDWZZLeytU7FZxh1sN41alxFZYAAhUoaYTXwhBCdWmWF7hVhk6naRPI6MpX
         MA9GTPdUxyFsK7Hx2VpsAonuvUWqQwXa1Jn0AdczkQMrxLOEAbJ2ak1/Ljbfwz5BB2lS
         tTIf7WV7fb2A2iEn+4ov/cCx8WNfwW4nn5xcwfLvx+gb+tfJNwmplg17sDgPGZp3h3Sa
         3T8wICgYxt+yxuMY6Zgd358HljEw9UwXNBtcRuv3A+D0EaOeWgn4OE2nu/05z/c0kCP7
         +p+Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783981676; x=1784586476; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=YOd9mExyjtslY9x3KYTXq5oCKN8VGg/406f26GPZg2w=;
        b=q+G678hL15ZjVXp9f6HBc/pHNH/IJOaFEfaBdauvl1HVJTezUCEtOfX+cVeEEE6don
         qbl0OYt26VQclHrRzR1gzFskvR5o9aRghK09Yr/FYEhMItvHir4scL6+MuywomN+uZd4
         4gx4a4sIjc0Bh/vMbhyAe+MNrDlR4Px+IBgEfkVDUJa3F8mQNcA3WA3uy82shu1HM+Wy
         HnRySY4xhJSawlHKKAoEa6aGwiSoV+TYTIkPb7Is57R74q3bLzr7NWa1dBAv3TnERUQu
         rU5mGmWaZlpJMLa0Ttr8+Q3qL/t8YpyCTc4cytFGjKtpMbKTjhZc/4XmCR1GiJthlJsp
         34fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783981676; x=1784586476;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=YOd9mExyjtslY9x3KYTXq5oCKN8VGg/406f26GPZg2w=;
        b=D7yTaI2ODyUrsXMktESrBG7+dyst1s38qTI9vUXT8b+hA0kXI+tE1PKrjOKufZdDPl
         QT/yBC8iUKnzE40dubuW+YkyH5eUqf8GJfjDsluUInw63O9xMlNZJqk5j1oEI2vp6Vkp
         urs4cMJhEcJZapkN74HPfX+EpbwTTuW5pZJs5GE4MBMU56DoAkerkKogTT4639ZVBsz7
         aCF/YsfYIfbbsrSYCUEii0+vy/ccVzv180Kg/1urooGd3DWg86S5ti2p4yBkHJ01uhIb
         ix2aih56ni4AkUbKXpBdHfjWjrsvTg2cswnblYqDEElrE29CF58HO/r5wCPY+94WSCXw
         rvVg==
X-Forwarded-Encrypted: i=1; AHgh+Rr9EpwC0sVGm4yGmNGiHDR/hWYNeswFVAZ+iHvuHSwalL8F+LnJ1tHR7MpFvpNETrG0GKLswVmdNcs9@vger.kernel.org
X-Gm-Message-State: AOJu0Yzf6DnV0LalF6O4nQ4FBQcK2zlX2AYE0U2F0PF0+1HX2pehZOs2
	Dgbai9Z6fbTOqSk8lI3ZqcLs0HkGMVjYT4JS5aYMh5bAtQdVNigtkUyfGGVApMH47keRAs1kbr8
	Xd9E0cxEL0BupnJWvdSLattkDYEfONYQgQUmocYu8xA7FryLuNrkjmYTk
X-Gm-Gg: AfdE7cmD/bAoawGMJDtW92TtbsFvN2ioiHYB5s9C7qF8s58j9y2w/7asDxr1rI3KFXT
	EYw9I0RKxnZchz4RIy43bFQmfG4LhAX0Fl4QWXtSY3bY+99JoIlNV6oVFaWK9QiuHRdTlAd7BHl
	mb6UEro7SiHDQMJOusb08bVEvWyDCW/Nd7JoKBCTFP6pDt1ZwKeSxy+hgF7//U33C2FI3GLafvY
	NjVBLVMsiOgaTOFZi/l3QM3NVy8Yuy92bRwsKIR6bA/WUkZge9BF3cTcOzWhBLrikZgIknI613s
	NPm5c8g+RJPdoWhrxwI=
X-Received: by 2002:a05:6a20:734a:b0:3bf:b9de:8570 with SMTP id
 adf61e73a8af0-3c110160a19mr10849033637.19.1783981675450; Mon, 13 Jul 2026
 15:27:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260712165610.366474-1-timday@thelustrecollective.com>
 <20260712165610.366474-2-timday@thelustrecollective.com> <alT2yHlfzhTZ9n4T@mit.edu>
 <20260713164417.350710-1-timday@thelustrecollective.com>
In-Reply-To: <20260713164417.350710-1-timday@thelustrecollective.com>
From: Marco Elver <elver@google.com>
Date: Tue, 14 Jul 2026 00:27:18 +0200
X-Gm-Features: AVVi8CelYR5CFRDO3rcKViR68rwlP0BhhN5oDZiKHJ8mDbFXztNS8i5n-0eRql0
Message-ID: <CANpmjNMfQT6Z9ke4x49sp6z8+pt_5ZLUoSh0da-99bwos5-8Lw@mail.gmail.com>
Subject: Re: [PATCH v1 1/9] ext2: fix ext2_xattr_delete_inode() context
 analysis warning
To: Timothy Day <timday@thelustrecollective.com>
Cc: Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org, Jan Kara <jack@suse.com>, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Mon, 13 Jul 2026 at 18:44, Timothy Day
<timday@thelustrecollective.com> wrote:
>
> On Mon, 13 Jul 2026 10:32:56 -0400, Theodore Tso wrote:
> > On Sun, Jul 12, 2026 at 12:56:02PM -0500, Timothy Day wrote:
> > > Clang reports the following warning when context analysis is enabled:
> > >
> > > fs/ext2/xattr.c:829:6: error: rw_semaphore 'EXT2_I().xattr_sem' is not \
> > >   held on every path through here [-Werror,-Wthread-safety-analysis]
> > >   829 |         if (WARN_ON_ONCE(!down_write_trylock(&EXT2_I(inode)->xattr_sem)))
> > >       |             ^
> > >
> > > When WARN_ON_ONCE() wraps down_write_trylock(), it adds an unlikely()
> > > annotation which hides the conditional acquire annotation from Clang's
> > > context analysis. This triggers a false positive. Pull the trylock out
> > > of the macro to silence this warning.
> >
> > Does this mean that using Clang's context analysis means that we can't
> > use unlikely()?  That seems.... unfortunate.  Is there any other way
> > we can fix the false positive?
>
> We can't wrap a function that acquires a context inside unlikely(). We
> can use unlikely everywhere else. AFAICS, I think the trylock functions
> are only problem right now. Grepping for ".*WARN.*trylock.*" and
> ".*unlikely.*trylock.*" shows a few other examples of code like this.
> Not a huge amount, but not zero. I looked at a few other
> series [1][2][3][4], but I haven't seen anyone do a similar conversion.
>
> [1] (block) https://lore.kernel.org/all/91cb8c790fc8b26b8aa742569fbf8c2c1d099dac.1780682325.git.bvanassche@acm.org/
> [2] (drdb) https://lore.kernel.org/all/77d0fd75811d7f604fa80b5c93172b5653b52880.1781042470.git.bvanassche@acm.org/
> [3] (raid) https://lore.kernel.org/all/20260708090614.1431014-2-hch@lst.de/
> [4] (nvme) https://lore.kernel.org/all/20260713115444.465704-19-nilay@linux.ibm.com/
>
> > Even disabling unlikely() if and only
> > if Clang context analysis is enabled might be a better choice, since
> > we don't necessarily need to build with context analysis enabled when
> > building a production kernel.
>
> I don't think we'd want to disable unlikely() globally when context
> analysis is enabled. Only for cases where it'd conflict with the
> context analysis annotation. Long term, I think we'd want context
> analysis enabled by default for Clang builds.
>
> I think we have a couple options:
>
> a) Current fix - it's okay, but a bit ugly
> b) Teach LLVM/Clang to handle this better - no idea how practical this is

I'm not quite sure what's going on here yet, but
__builtin_expect-wrapped trylock function calls are supported by
Context Analysis (Clang's Thread Safety Analysis). Some of the
additional layers that WARN_ON_ONCE adds is likely throwing it off.
I'll take a look, but might be a week or so. We are already bumping
min Clang version for Context Analysis to Clang 23, so I'm hoping this
can be fixed in Clang 23 (which is not yet released).
