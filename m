Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2165429CFF
	for <linux-ext4@vger.kernel.org>; Tue, 14 Jul 2026 22:52:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.215.174
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784069568; cv=pass; b=mFPya7f8DafQWDQuwF8r8SWrBlb0hOqBwhHKYuT4wCXoxdLQrX9o4aJttr9qyvCJYSBHcAafrwwcHZMEk166iFzHCWn8czgPZaqO9AKTNoZ2+8As2UEytw+pz+rN2AI6qlpjfg9JnHKxYnaYrIbqmlHdhi5Qe5mqLRHvmKkk9Ps=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784069568; c=relaxed/simple;
	bh=nYoADaUwDh0+BQd+/OoXhra0JAA3KEwkTgxpAdiz6Fk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=N+1m47Z+yrSxEJUMUDRQoXri9dvunnVRkPM8ht5TnOcQDp3rxliekYj7tgtDLjyAlk3kfpdw6OEusM+cI61FFGPRZ5tccCXeH3MaMtzh6VZ7V/57qu/VGHzXor8q38Ts7V+nB+LRc6tEQfVmbKxunzBZkZ1KfUVMMxAL/j7+LV4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=G7RsKZt/; arc=pass smtp.client-ip=209.85.215.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="G7RsKZt/"
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-c9d1fff21edso2987143a12.1
        for <linux-ext4@vger.kernel.org>; Tue, 14 Jul 2026 15:52:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784069565; cv=none;
        d=google.com; s=arc-20260327;
        b=mri5H63LAum2D+9Z1PCEJybtjgpUNbaq0d7zxCOz16/FSbndZZMoBpzUwzzihaMzWh
         0WQSEKcNASn0bwCHoIsK4KZBaNF+aeELl3pr5IyVQLLPJjliFoWATg8Hblp5aKVtuLVU
         b2WDAzQBjwfGAH0I6i41pp35mix//YWYJQGH8Y0M2ZBib4zuNIgJF0BnbNsHhIohU4wm
         wAwwRD3Z8DK5Y/zkMWCTdG7xj5Fp9BAcJZjkX1KltQDkzcp6kBYeXveQ43Mh5eBimU1k
         1ckhvH94yqF1YSE8utHzCTOGxjqYumbAnNiQ7JmgiWa4zspEraOq5Aqt5ez29PK6d8ba
         ukpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=kgM5gfHSJ4YqkHTjYUXiFkb4Lm3TeivgtFXOYo4rTPc=;
        fh=BD7W6+wqxri1CMjzGy4F04a46/f+z+6MaVGZkI51jyQ=;
        b=ss/TC/c3eaWzMerSy1ph0SYwmfMkBHNFhSZ/QcftBkjynPaegLh1VsdejGOpSQTDEv
         cRCbVyGyPjBmSZEUDTAiRJxgodv9k9PRqnxNx/89svzluLq2IysfkFD1U4j9nPjNfMjY
         fN7V4D6LWOyGsY+ZvnE3aDS6ii3AcGLLv2YbkR8L21LjihYtC7FW70NbBJAke6E5J8G+
         e15qTx/Xn8xrxwtijGDSsB0cAnBh4Fkjhi0CGvT8SC8fldZajB1kMXlFYKvr9HwD8KH4
         tg9I3QB8weKp+ncP1mMfzQNBg+ROmXp0rj06Y9oG4k7/qOiuxAFH+0BpslpAgXUcf4eY
         UApw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784069565; x=1784674365; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kgM5gfHSJ4YqkHTjYUXiFkb4Lm3TeivgtFXOYo4rTPc=;
        b=G7RsKZt/Mq4MBNXSXBuK5nWZR5Ek4eVb/Cad+C5bN5r+80izeovHIDtrZFI5ehV7WJ
         2eGY5NF5A0AU/paKypS7i6cXW5+14WOreLjjf9flY2537hcNP9t1lbCJFAzGCxQyUwkh
         GeuRNRBn2x9GACvWs8LSqQBSs4GSnrn/JJvQTbzmZg0kFQuGQEUX3AG5MPl07hfXshaw
         VPJ/5sRpV3y6J1d0I6shK8W7zSes9ZDKypugu2uGW+KdS3ZAvmnVTzutHiunJKNOWeoi
         K1chE73FJDJvzTDF4rQQOavmKacz7eI9ceQIbdAZBryq3HS+XnMs5qwD0SNt7qb7g1Ef
         vbSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784069565; x=1784674365;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=kgM5gfHSJ4YqkHTjYUXiFkb4Lm3TeivgtFXOYo4rTPc=;
        b=AQCERQLz3CGMmHpTZE74G+p0U/Vcsl2Sz4FpTQTZuI7CFhDq7mZ2cFcjyqBEALz6R3
         U/cFAwQcrT3Wv3ERnFl90mj66dS+fdYgzW5wlSsdGW5faawfKGl88oMMIyQciogQcHKE
         Sv4+am6Ry6kLWhmgB3DLqzqHqjAeyw4f9+F5EphaVWDBe1S+030qq0oMAWnSCdAqnsit
         gUEhjQMyBW2spfYZHGp4Y+xVhxyzl6LK/V90d4YFhcXmtI5acsk66X6HcPYGD/U4OfDb
         Z4hx5J5M3Lwa5ehVCgXK+LNkArclYK/b5FvIz7geno8IF8bUvMS5Tq0GRvz0LPsOlHyw
         9zzA==
X-Forwarded-Encrypted: i=1; AHgh+RqWBqTT+EfwS5OXyLm+8aXm4yAE1YhRKLVoMiAptFPZ2ixpw9ctxQJjmA6eo1msRn5H5a5IFoh62vxQ@vger.kernel.org
X-Gm-Message-State: AOJu0YxUjuxvRJc8z+osToh731QD/ejpyJVxY2uqWkxx9owVAYmhS6xi
	RYmcN2ZLzfsGf9axnx+VtFiOo3I/Lyj0y4KB99KBRrTWQGZC9aaXhuXtBqI9pZxA0+LFrUlc7oK
	glIV0BoT/tQ1WNpX3s6BmYSVPp5dv9zr5neY83FtD
X-Gm-Gg: AfdE7cmZgmPGzaGTkIyf914OhTTEWzMF7rEeAaL9mn8uuxyxFx4WLOjQhRdY0la6m8t
	Ca44vswEVE9ZLTDJUOWyCXlKLFAR/9SxNOHdoSEQWRRNyoajDwJ5LAoSiyG1EQ8V1QVsJeo9atK
	Ib/XpD23eYOMVUpvXQxlYbzhwtxqcFvKiLNh+8/lyVANuaff+Z77atwISeze1okhrDsRVe/vMez
	UC1eb+OUtXrFY0R0Bumabyi2HcKED3uT82CotEXagaDr1Vt1oSeTnAtDrxPb4IYOZom8zQY
X-Received: by 2002:a05:6a20:6a0f:b0:3bf:99fb:db96 with SMTP id
 adf61e73a8af0-3c34d719d38mr6086909637.49.1784069564657; Tue, 14 Jul 2026
 15:52:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260712165610.366474-1-timday@thelustrecollective.com>
 <20260712165610.366474-2-timday@thelustrecollective.com> <alT2yHlfzhTZ9n4T@mit.edu>
 <20260713164417.350710-1-timday@thelustrecollective.com> <CANpmjNMfQT6Z9ke4x49sp6z8+pt_5ZLUoSh0da-99bwos5-8Lw@mail.gmail.com>
 <CANpmjNM5CmQc_YG_5=zhdLCr7gGL3QYPcd4R4=m2NzwNY03d3Q@mail.gmail.com>
 <20260714211246.1046948-1-timday@thelustrecollective.com> <CANpmjNNU_GiRW6y24hvbUsXze+jf+9ptx8_Acq1Y=mvPSr=wFg@mail.gmail.com>
In-Reply-To: <CANpmjNNU_GiRW6y24hvbUsXze+jf+9ptx8_Acq1Y=mvPSr=wFg@mail.gmail.com>
From: Marco Elver <elver@google.com>
Date: Wed, 15 Jul 2026 00:52:07 +0200
X-Gm-Features: AUfX_mzv4cLX37cRkCFKYs5gHQK6PnrtFafZdRhGytloUdSp1JvIS9VXJ-Tsfl4
Message-ID: <CANpmjNMgH3sX-RoOjo4Vo2Dqx7=3rov1Mz02u+vKt4WkNuSg3g@mail.gmail.com>
Subject: Re: [PATCH v1 1/9] ext2: fix ext2_xattr_delete_inode() context
 analysis warning
To: Timothy Day <timday@thelustrecollective.com>
Cc: Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org, Jan Kara <jack@suse.com>, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Wed, 15 Jul 2026 at 00:08, Marco Elver <elver@google.com> wrote:
>
> On Tue, 14 Jul 2026 at 23:14, Timothy Day
> <timday@thelustrecollective.com> wrote:
> >
> > On Tue, 14 Jul 2026 00:56:56 +0200, Marco Elver wrote:
> > > Relatively certain statement expressions were once again the problem -
> > > this should fix it: https://github.com/llvm/llvm-project/pull/209330
> > >
> > > I haven't had time to test the Clang fix on  fs/ext2/xattr.c with
> > > context analysis enabled  (please do so if you already build Clang
> > > yourself, otherwise I might get to it in ~week).
> >
> > The fix wasn't enough. The commit message on patch 1/9 omitted another
> > warning. On vanilla Clang 23, I see:
> >
> > linux/fs/ext2/xattr.c:829:6: error: rw_semaphore 'EXT2_I().xattr_sem' is \
> >   not held on every path through here [-Werror,-Wthread-safety-analysis]
> >   829 |         if (WARN_ON_ONCE(!down_write_trylock(&EXT2_I(inode)->xattr_sem)))
> >       |             ^
> >
> > and:
> >
> > linux/fs/ext2/xattr.c:860:2: error: releasing rw_semaphore \
> >   'EXT2_I().xattr_sem' that was not held [-Werror,-Wthread-safety-analysis]
> >   860 |         up_write(&EXT2_I(inode)->xattr_sem);
> >       |         ^
> >
> > If I apply your patch, it resolves the second warning but not the first.
> > I tried to generate a fix [1]. That branch has both your patch and my
> > fix applied. Those two changes combined fix both warnings. My fix
> > tries to add some special casing for tracking contexts acquired by
> > trylocks. It works, but I'm not very confident on the correctness.
>
> Nice, thanks. I'll have a look, but it appears right. Need to get my
> PR merged first (need approval), then please feel free to send yours
> with me as reviewer/approver.

My Clang PR was merged. Can you rebase and send your Clang fix and add
me as a reviewer? Please add a more elaborate commit description,
because it's a little more intrusive and the problem and your solution
is less obvious.

Thanks,
-- Marco
