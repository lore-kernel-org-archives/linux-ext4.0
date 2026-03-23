Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ABC737FF7A
	for <linux-ext4@vger.kernel.org>; Mon, 23 Mar 2026 21:50:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774302630; cv=pass; b=TedTHxkWfVVWxhRrqjwOvlKRfwZPGl7YgLmwF+3C8N6jH3grL7pzeGYTw0aDaLQyYyQkB9KGwjvSRIt3nVVFkKpIksbOzGJFmgPW8QMveKuE0ik77uioP7r6w/9ROPVJC0H2/Tn2BCwlvmD151nzz/L11Lvcl7UNlHOOlOorXws=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774302630; c=relaxed/simple;
	bh=9VugXVEXTcC95cpN/qE+5KnMP/gH3SvyOEvds2IGqYs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=p4t051cEPsoyt+0BFa2CIFcr1CbIek6oO/HbOWkbvN0InV8YLuSj/vVQ7AnFzUXNrpsbXVj22TNIzoJsR0QazuvesVhTw0ObEiOqhEaza4ONu9UynRbn6xRpgy8K8CGg5RRdwVoFAJd6DPMURg/Ka1lG6uv7suIVl4V4tnjN6n8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GZYT03EB; arc=pass smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GZYT03EB"
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-b9841aecf72so368786266b.2
        for <linux-ext4@vger.kernel.org>; Mon, 23 Mar 2026 14:50:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774302627; cv=none;
        d=google.com; s=arc-20240605;
        b=eeYkE7QPxiKQU48pLerfY3kFmaBrXtNqYWLXa0/HlgCDJYnvktBGMezd8rIK1DhDWF
         F5PkuwVYDncBCcpBK5Fp2HcixGea+yQua2n4nJmnuHnUssljqs4CPO3MtYJupt9ULWE0
         HPrEknVu18bnYDoRKiw1dL51t1Mbkl74tMmF9KcC00CjqWhI7ctm2aNXDTfvS91GJNe+
         t2YHNJmYCyRE26Rz24i/sKOYfuc1wf2cXz+nfZwF+37ew1AxCH96rV8veYA5eloocaGd
         JGosfvisrtnfkSoJu1NEfioH6PRZlSgQG/u40xh74MKsmYK7AWoXUUgxk8jvrmOBjtLn
         qFMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Wh8YPl7clnjG+dbCdALg7vSRjUgZbbAK0/IW8N9piAM=;
        fh=PHdSwlqz0vqkOGdgKqLoV1lFFspZgEPZ3YI+ejkZOvg=;
        b=Mm7OM9MeDK7qWXOTnJomU971vsdWrumYRfSjMU3HPwFxrz5yL6THqNptF1IMHyJvW2
         nPhTBrHr6g5YRYAFj3Jd3pdK+f3EF5stYbEsdkMEykf9P4SpxSqAY9adxH2Ixy8NbpsD
         7CTAYLgjKtMymQAIqC9OlUj8YXMBYCF4Ehuves8B4IQR5/aZcZyNz9nEQ/iEQwoZFKVn
         MUgO/7lmZe0Y+lIbz5wGxCeeHj8YZ+5WLi4DxJzggeq4W648zQOB7d9x2v5hCoQc5mlN
         1xpZvUQHfX4sJoMHvGqFKEvoFU72In1NdvklMv7JtXi3CMCNi48yZuHKA7BbvbQXp6/9
         nPwg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774302627; x=1774907427; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Wh8YPl7clnjG+dbCdALg7vSRjUgZbbAK0/IW8N9piAM=;
        b=GZYT03EBirDPc4gx5UQbAj5VIUbfiG8wMS6WQr6tNam+5a1XyYNX1W+R2oxjkTUM9a
         oUIRRQzp2IevMZ8hFq0A9kVzN7epTroAWeZqsXsfAkzAXpTbvrgQutnxN3Zo9nFDFyqH
         izn91DW5En3A22dXjzziregIsc09KYpKpYxNtMIwFpeSqi9zS33EtEyealgBRihLg+ei
         fQEFJmafzU2bnpI1+taFF7nEtoDHaspRHLdwykZzKUwLijb3DEuRagzdR2NiM0Tz+l0g
         Pkc9C6JeKCRfCBgkRg/Wh5ADgF3zkJlkYn6GrSTYli/MljoxhE9Qf2C4AxUmtFUZCQbq
         lpqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774302627; x=1774907427;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Wh8YPl7clnjG+dbCdALg7vSRjUgZbbAK0/IW8N9piAM=;
        b=OhuXnkgZpVTUOfrTBFM8qyXok/gHRKZjvEm8okHaBAtZhPbrxqsCVmQbYZRnNnDYfe
         h/vjyqC0uSwgh6DcIH6dTbGy/iw45h0f0wgH1jFFkuvQLSZPVzJBIBwicMcs312y6Mx6
         c+nezuy5HmjPZfR6xyXJmcJm9OPhjCipFBlLKSmYbRAbczi13IBHAwcL9Llfrqwohh7N
         JY66wbqH7/8SxmQEtC6hoRYYskb+p5dPzUbcVu1fxMUAdBAQmzL2KJe0Zea0WPzRRloT
         QEt32VyKmnwZbPDBN6qzgnw5Xfm4ZNMjhdnorwYi1pzvtUjF+V4RtIHGROgUrFZtI3qW
         eEUQ==
X-Forwarded-Encrypted: i=1; AJvYcCWs6mEYU9nPJISqN5ddOWSIIdDfAAPXvzDSTVtsNpvOBP4zc9ehqUWIs7LRfyFk8PqLDgqdLSGUOXWL@vger.kernel.org
X-Gm-Message-State: AOJu0YzhLdp4RCLr4PxX8+RV6HJP9pboQd98cqRDfoGQrAU4QbpPqkLd
	e2ItY4Eze0RfNfbR5nvFKNivxsT1jYP8SdrWbCcrBmapO6pcUnc7pRwYa3E2qLEDVzoLZYJc0XZ
	ubrsMoSs5nF8qWOGruzml/rlOfUrjHCM=
X-Gm-Gg: ATEYQzx1vgxfaH60mBq8O9L7B+lGFQI8b4+r0M1/Zd2nzNf+r87FhB0CrUwvfCx7YXC
	djp6PQUqE2owlDtVTPPMrxRtfuiPxNSlDUjPzeGlTl3Z36ZJoM8fC5TS4W/F0Gt3hcZzugfBUjB
	KJXK3Q6/mOFdxh0zz/XFUaaKPPUEnbeye1yBxzMO3tNpskAhnZzjbS/CQOA8aA/IUzpbyjAPaBC
	rsgjv4ZmGqqt117sI1B+ReZaGQP92PVe5pTKSWVqMBtgEml7dGSS6jn46OhdLyWkWp3TPvjbG5H
	zq9fFexOgJTd5TUaAmQNfJduI/TQGUqmLnE4GqgcUNdTGCJbjTNKWKdmrnLcI3sKDQq0sVRYnT7
	OnTybkVVzdVXg4H0NOFWSAA5Kr4x/bkXyt2aNHCafKrn6L/Yk
X-Received: by 2002:a17:906:3b86:b0:b98:cb6:e890 with SMTP id
 a640c23a62f3a-b982f502d2emr717818666b.54.1774302627226; Mon, 23 Mar 2026
 14:50:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260304172016.23525-1-nikic.milos@gmail.com> <20260304172016.23525-2-nikic.milos@gmail.com>
In-Reply-To: <20260304172016.23525-2-nikic.milos@gmail.com>
From: Milos Nikic <nikic.milos@gmail.com>
Date: Mon, 23 Mar 2026 14:50:00 -0700
X-Gm-Features: AaiRm51-Giyn5HtZZ3JSJV2iLMyrXLwTLyF-imGDU5EJ71cZTi6xeKrKEpq6O60
Message-ID: <CAOeJtk8hrcM6NR73Xo5++aU_ZXyM8GvN7U44iA-rJdp0evhrpQ@mail.gmail.com>
Subject: Re: [PATCH v5 1/2] jbd2: gracefully abort instead of panicking on
 unlocked buffer
To: jack@suse.cz
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Zhang Yi <yi.zhang@huawei.com>, Andreas Dilger <adilger@dilger.ca>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello,

Just sending a gentle ping on this v5 series from March 4th.
It looks like both patches have collected Reviewed-by tags from Jan,
Andreas and Zhang.

Please let me know if there is anything else you need from my side, or
if this is good to be queued up in the ext4 tree for the next merge
window.

Thanks, Milos

On Wed, Mar 4, 2026 at 9:20=E2=80=AFAM Milos Nikic <nikic.milos@gmail.com> =
wrote:
>
> In jbd2_journal_get_create_access(), if the caller passes an unlocked
> buffer, the code currently triggers a fatal J_ASSERT.
>
> While an unlocked buffer here is a clear API violation and a bug in the
> caller, crashing the entire system is an overly severe response. It bring=
s
> down the whole machine for a localized filesystem inconsistency.
>
> Replace the J_ASSERT with a WARN_ON_ONCE to capture the offending caller'=
s
> stack trace, and return an error (-EINVAL). This allows the journal to
> gracefully abort the transaction, protecting data integrity without
> causing a kernel panic.
>
> Signed-off-by: Milos Nikic <nikic.milos@gmail.com>
> Reviewed-by: Zhang Yi <yi.zhang@huawei.com>
> Reviewed-by: Jan Kara <jack@suse.cz>
> Reviewed-by: Andreas Dilger <adilger@dilger.ca>
> ---
>  fs/jbd2/transaction.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
>
> diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
> index dca4b5d8aaaa..04d17a5f2a82 100644
> --- a/fs/jbd2/transaction.c
> +++ b/fs/jbd2/transaction.c
> @@ -1302,7 +1302,12 @@ int jbd2_journal_get_create_access(handle_t *handl=
e, struct buffer_head *bh)
>                 goto out;
>         }
>
> -       J_ASSERT_JH(jh, buffer_locked(jh2bh(jh)));
> +       if (WARN_ON_ONCE(!buffer_locked(jh2bh(jh)))) {
> +               err =3D -EINVAL;
> +               spin_unlock(&jh->b_state_lock);
> +               jbd2_journal_abort(journal, err);
> +               goto out;
> +       }
>
>         if (jh->b_transaction =3D=3D NULL) {
>                 /*
> --
> 2.53.0
>
