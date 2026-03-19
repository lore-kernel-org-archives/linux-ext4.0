Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BD2021B1BF
	for <linux-ext4@vger.kernel.org>; Thu, 19 Mar 2026 11:13:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773918840; cv=pass; b=BaWgOyULfuVfBpq6erbmo6T6Frs6EyW+8EpjyhExt++Y3xVkyJc0itEWE9IkEK1QzSOKkmer0Y2UQiQia0Ryqk6BuVhhTg9OnxKBmy/iVjOXSfmLl00t9Ugl64krH37dYZxDGxxDV/rkxbEgQa8Ao3nIv3zWj17qt3mArOZxuwU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773918840; c=relaxed/simple;
	bh=zUxBGlJ8iBNcfWPMQ3hQPJuAbRLGJJrNcunwQQ/mDLU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GPq5tA0T3godWoZY5Zg+CGXS+Ah6AdqEsrHKWrc/eD1RpITWMnWwShO2eq0/MyCnKmIrGfICdyjQ0PxnS3MIToztIEkl8xpikw8gNfeWhOvLJmr/KhVrGhD49NUTQCXcZkSMcSWcV7mEiTO7V918TzfreEf8s5tVuc4sNtCzwho=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=V3MEIyuO; arc=pass smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="V3MEIyuO"
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-667f8794e97so1599321a12.2
        for <linux-ext4@vger.kernel.org>; Thu, 19 Mar 2026 04:13:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773918837; cv=none;
        d=google.com; s=arc-20240605;
        b=iNsm/X+dzq02vbLc5e+8hyL/WhlrdxeFTa2AqgBTu0wBkP8pBBCVA8aUaFTb97ysUv
         VYJ9ZDH2zPe14AGpnGmhG4neX5AQiz0Cm+6513mPiKtiKrmgz+oCO4jMKSecaTQu3qko
         IDPihijYU2Pd4qJaCytsRZstaHSpSaaQD5/rdYFBnmtqirxvZuta2yn3GaUIaN8X6KOU
         4FSDEGO1+XvqMWpmWme09BIQij8rGGgUl/EmyTYoy4jCvWgU6M0egJweyYzjPPUA27/K
         SuMphuDDylgDhbquCcs8zmwLEkNepjQSROy8eVYgnvFLLBvnMwLu+8qKF53uUfj2Sq3Q
         q+AQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=lQCqdWJc5ct/Ln0671uNZA25+9pYlVYY6Cy461/f4q8=;
        fh=JSaq6jL8JctRAfjBOnmDMitkO9WE1ATlZDuP+KMpyUs=;
        b=hrmkXs/4b6K6r60KaQYFD4I98nJYYz1qFzLBkKs1qh7c8ZoQzU6sDCEcHy8VAGxb2e
         nrgDRtGJc4yJlTrisxuwnBuqFYxwTtez7GBa7rNmPCzLTtC/0+eES9hl0zWldt1n8g8M
         8s1sSvwSDJoPm3Ui/e/T4indEGw9f3Qq5vv5LR3cc2Ozmpdba6ZDD4/vDyoczB+vCgRD
         un51wClhSjkm5nF1pUPXE4U4WImyHmfvuTejpe8VMbi1Lr62Oh8dqaQgmceDGa4QsAqF
         Xb0/0UT5AP4M76EbWEbPcxDqgGHRYL5qfWmI4c6KUGJMVCfT5SCuPMV0OVsr6zap83a9
         NBMw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773918837; x=1774523637; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lQCqdWJc5ct/Ln0671uNZA25+9pYlVYY6Cy461/f4q8=;
        b=V3MEIyuOMYszancQ12oQLhGYdbGu3jDzTlJcU/DZX5KcgkrpImu3p9PfZV6Kb0mDlr
         v2PgdunJNZUGZiXNsKnvqpcYQ6YzeSwrnSruvRI1249vLe9neFQ5qZoMwZn0mJLR3yg2
         /UXVHmmP3yA0t/wNWOjbvsbpOkm5e01mMRPyTGOIYnOR3cjxOPgu7p236YmYTjSXiWp4
         OfWBN3Me/o7UFOs6h37w6+tjRZkzJ/zPDzisxRc68Ib43HCgy3rPERZ9cbA+quSYGUtp
         uknwfE33GonByhoXMBFd9l1gharB9G+REQGPxqxsodHK6XSt2KHh8Hia0ufo7qeAQyx4
         rJSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773918837; x=1774523637;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=lQCqdWJc5ct/Ln0671uNZA25+9pYlVYY6Cy461/f4q8=;
        b=AH+057lUxSc4WsapzRO+YCAm+krXu8AjJ+tqvFAUKE3W0AZOn+7aX+UgzjEHc6981O
         L65HHcT8oxPi73HPGpVN9nxe13rohNtNwz7KEIDyxcwudUxk7a9EAlm5gkoQaSOKdXAL
         CJapdgd7XtoDbuOY6Ib6xzyMTPGob0knkb/VCDY504HLEKW6PEJrWJPyRvlVtOo/Gm4D
         bbSVmEDkIcaq+/f1jIqozY0MeVBqx+mX+c/IU2xEG3oeiB5jt9ggfMHRwVahBNK+FJMU
         5SjVBgkEqzAiP9kEGZ854GCP1SjNJQSPkphspK7nAnkugrS36qFafYo6uQN4/b+YERd9
         fL4A==
X-Forwarded-Encrypted: i=1; AJvYcCWmWDI/cxRuMdk9D36e5WK0elHdBicuH7lLd12sZGi7pseph9u7xk0aLT6+mSoKGq9Xc7+Tt55mR644@vger.kernel.org
X-Gm-Message-State: AOJu0YwXZimEjBeiZD3fp2Kqo+xhB462RjDYxV+C2txyH2GwNRYcIvKE
	azp7DaLqX9SbHz+QAfIST+7IsyF5MCzgFfwiMUNx0G+AjPJs1cMLa7ZBbdkQDDUskgOm9oDJK9M
	J0Kq8CaEIne5lh7Fq08heIWE3q692BFg=
X-Gm-Gg: ATEYQzwQp6qiJqVcN/Q2mGxLBZz61viOrwqvcc7Vmn85fhEBN+vxZLCQAX4S5ITQEPj
	EHWHU22GU9me/tf4y/oaIJwFab7lxgkFONUB1xOvF9zHKKs4IktPFZitAglIbTLgBphK7MOuqkE
	vVL9vyWwlTWGiTv9YzOz2MsMXHC6kVwtaQD/k0Q6ze44DhnrwNHwtVEANgREKBILDg0XfA/uJ7i
	gKY8gHBQX9RVRqbRIHnkpEoqyLfjIHQ1qtaYDoon65KVodT/EUu2kJjr9upVwJpQirmB2hjz1Ef
	O7lAIUkI3XC20fbuvNcXBlPOPE/PlW5/PBdQqrkwCzhtYzYewhvyXY0=
X-Received: by 2002:a05:6402:42c1:b0:664:bc6:69d5 with SMTP id
 4fb4d7f45d1cf-667b272b67dmr5012509a12.13.1773918837212; Thu, 19 Mar 2026
 04:13:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260318075842.3341370-1-gality369@gmail.com> <20260318144509.GA82331@macsyma-wired.lan>
In-Reply-To: <20260318144509.GA82331@macsyma-wired.lan>
From: ZhengYuan Huang <gality369@gmail.com>
Date: Thu, 19 Mar 2026 19:13:45 +0800
X-Gm-Features: AaiRm53XCVRVIob3kXItKft52onwEvV0lmGxp9ZoVPXr1yypSBOl1_l65hWsu1U
Message-ID: <CAOmEq9Uq5xMvhT7cyoY2uhSBhwSEEJ1vYRY36N4sxZSPCO1S8w@mail.gmail.com>
Subject: Re: [PATCH] ext4: xattr: fix out-of-bounds access in ext4_xattr_set_entry
To: Theodore Tso <tytso@mit.edu>
Cc: adilger.kernel@dilger.ca, tahsin@google.com, linux-ext4@vger.kernel.org, 
	linux-kernel@vger.kernel.org, baijiaju1990@gmail.com, r33s3n6@gmail.com, 
	zzzccc427@gmail.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 18, 2026 at 10:46=E2=80=AFPM Theodore Tso <tytso@mit.edu> wrote=
:
> Can you send us a pointer to the reproducer?  And does the reproducer
> involve actively modifying the mounted file system image, either via
> the block device or the underlying file (if a loop device is being used)?

Thanks for your reply. I'm happy to provide a reproducer. The
following PoC reproduces the bug deterministically.

The PoC is too large to inline in email, so I uploaded it here:
https://drive.google.com/drive/folders/1OzH1XvAOAb9ulpOKfL70U1LvXhhlHAyz

Steps to reproduce:
1. Download the PoC from the provided link and extract it.
2. Build the ublk helper program from the ublk codebase, which is
used to provide the runtime corruption capability:
  g++ -std=3Dc++20 -fcoroutines -O2 -o standalone_replay \
  standalone_replay_ext4.cpp targets/ublksrv_tgt.cpp \
  -I. -Iinclude -Itargets/include \
  -L./lib/.libs -lublksrv -luring -lpthread
3. Attach the image through ublk:
  ./standalone_replay add -t loop -f /path/to/image
4. Run the reproducer:
  ./syz-execprog -executor=3D./syz-executor -repeat=3D0 -procs=3D1 -threade=
d=3D0
  -sandbox=3Dnone -method=3Ddynamic -fstype=3Dext4 ./corpus0
I can reproduce the issue reliably on Ubuntu 24.04.

For completeness: the syz-execprog and syz-executor binaries here are
based on syzkaller, with only small local changes to add the
environment setup required by this reproducer. I can also provide the
modified sources if that would be helpful.

Apologies for the complexity of the reproducer. This issue was found
by our fuzzing tool, and I am still working on minimizing it,
which might take some time. I will send an updated, minimized version
as soon as possible.

And yes, the reproducer does involve actively modifying the mounted
filesystem image. We use ublk to enable this behavior.

thanks,
ZhengYuan Huang
