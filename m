Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com [209.85.208.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C78A52116F6
	for <linux-ext4@vger.kernel.org>; Thu, 26 Mar 2026 02:29:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.179
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774492182; cv=pass; b=FWG1ack5fzYFY8zMwsob54CEF+7l7eRAwbtLdOqCi/R5G48GnMb5yIOMTIvggoIemHEjFv1R/5AB0tUxIpG1/O4rYnX7hUTxxyYaYx7cnVY1HsoYkf3IfHuWdEMEdyp0JLuebQpGuJPDNrVEsp7j8g9igDD26l4MtTY+AWTWgB0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774492182; c=relaxed/simple;
	bh=z4Rn3gNatuHl/9qSVwptNOj7bYliPOcWtNmCwZiRk8o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kYyWzadAF34hz7BIkeTTqGJbca932jPMx4rdIUMStlCrUWM0vEWjr7xXjmb0+4QxkhYHb/oZ8CHAr7wCMqFgegQWtrjL9NgZvBbdyx8tb1kxAavp7VbEwcXKfWV5oLsHCF/jCr8gojN+pkhur4DyyqsTB/K5CyyqKWUIF3up2gM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Enx7LrGJ; arc=pass smtp.client-ip=209.85.208.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Enx7LrGJ"
Received: by mail-lj1-f179.google.com with SMTP id 38308e7fff4ca-38ad12fb595so15206071fa.0
        for <linux-ext4@vger.kernel.org>; Wed, 25 Mar 2026 19:29:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774492179; cv=none;
        d=google.com; s=arc-20240605;
        b=OZHhOEp4Ue/0w3r0uXu5E93EhyWlVVILuWEecguH9SHn9rAYxcdkNYxd5pcglTfAYR
         oiPnv1iBIriKI0yQC5bQPbQxFu7vWSNgqihEyIDeP0vrYIeT26F4NLPbMZYKJTJ6Nlq8
         kREvm/ALyxDeMTpVtBd5a6Y5Jm8pkHQVPmR37ACgTCmK3xMOrhbFtM/Le2FkWhJJFyXg
         IyZskB1hVWizhTL8NtktzI9j99bZbaIKB5jwqYK/t9DC4L5gPemu+1f0h8Glmie49N82
         yHVzYyoBLeULqfwaHzWQHhBSv82ZViXhBF41xS4Eq3+rnr9IpsrAcjAmhaScwuSCJP7n
         xJjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=z4Rn3gNatuHl/9qSVwptNOj7bYliPOcWtNmCwZiRk8o=;
        fh=xlYWRdzNNPBSUzK3n2O82fZAMzRSCVpiBtPdaEjMWwo=;
        b=IjRWxLXyiMz2p7j1zDGrJ/hUB7d3dD7qg8zBGkIt3pSyUQ1G8mgCGnsoU+3brrndsT
         JDX1L+H3blNTtvoivgAF6eNZy4ygs2CoPebU5cBSR8xsxOBDHaYoyTQdF5i01j5RR4yb
         9nmgjq4vS3RiKIKlrX/fBZpejNdy4hLRVK5cP8Z2h9GaNroxsTHRtr9mlWjhrzstISVZ
         Lya3kuKkd0DOQRm8jUTh6Cf4rLAdGaxtGu+UGpXQSqOPXfZCkIkyYVPtj4qMc1817do6
         LSnwAkJLlndBFGdX+Fb58D6yTc6riuQhb3+gt0usO6gNv5sF/gKdEjSPJIZPHs+FVTwG
         SzsQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774492179; x=1775096979; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=z4Rn3gNatuHl/9qSVwptNOj7bYliPOcWtNmCwZiRk8o=;
        b=Enx7LrGJupQYN5lCl8cfH0Hde9x1dovzlhUv/PrmUfXCbrLOF+zHRjQvV9vXomVqXQ
         sWqasSFnoScj1kY/7j0Kf7HfoH2zxWr9Y9Jf8aNi4a/9WtgYSHKL4TooDxq40YpxHHIm
         zsNO7BY1smqKGKiPwqVOU6cjyqrUsLsVpLoIf9pQiifxlZqVGBxIFbO4crd7eBjAStwj
         afCjsA9ez7t1RO3jDZ5J6dWUOCGsJXlfIPlBRzwXhKV1asi0GUVxg9Kxl9leD6WB+7cz
         lfj4ibmgR1/QvhU4Ia7wTFY73b7lW6keMe4y9CgOY3YlZlwdKPoFL3vnas+w+r7cnrd6
         dH3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774492179; x=1775096979;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=z4Rn3gNatuHl/9qSVwptNOj7bYliPOcWtNmCwZiRk8o=;
        b=kYVjDada3jLnv9YcF/uLtgrZ5g88qjNS39Ojiq9VpsVsZ2gKKYTVeag00J5gSW+3/V
         KnFSRX07xtDtjmtMRoRnPDmAMooEkcnvagd0UdFMMietUDZsa9kj5Ug8TxQFhHEd4sur
         mrYWJ41jw4zc9cmeDhKRW1iF1G3R7FRX6tkKn79EV2/Wt2wzXDIlTG2y6+ymnapQ8CNN
         QxI9SqzLy6Ta6VxG1S4VMiHYlmqcHjGL/lkZvEF3xhN3KeEz67flkYKLSzgKZZzfp5db
         WRqv98LP72KSxP06WG401Qu5WzNPoC6YaLyeN5inVoxAwHaBop/eqswuv9zwZNTxGWUC
         qFxg==
X-Forwarded-Encrypted: i=1; AJvYcCVk9JrRbzhdW5RhNtKUccRS49/vivuuQxcsNmpMGo04kLbtcsKtIOlqbGnwXD2SPABGdI7QzVMMc8Ca@vger.kernel.org
X-Gm-Message-State: AOJu0YwSv/8oJZQ37rg9+3Q/YmbAcdaHYo3l+tLx9KV5Sia8KOVD/4f3
	hpqjmgR1Q7N3vF137kq4ktSO5MZNiaM6GTvWKcw3/9s1n8Tyw6Tngi6hA4kWIhsU7e1FIYjz30I
	mTbeC5hdMdOmc47aaHU/qj/PIr9jHST0SdEscseg=
X-Gm-Gg: ATEYQzxRGcE++eflr6oeH8U2ZjPSQITV9/u5bW6w3AjWr/fWBJMv5ezd3CctReNEN9i
	+0O8z5HRM03TckGayxUxVPsIW1js6HNAT09JNlDjRY6i8W+9O5IPJbmp8o1GpFgydoYwvS+4Md0
	puhLbcnnEESKMT0DVkeW1bWOZunFGaJ2Chlam8b4JtTumyND1ogzX9LnZF8X2h8ghdsbKxoWxPs
	SoIVrcHeqZ/hxwZ/JTTMBD5H3Xhjqb2DOKZQWgJGkkvxX36J2SWbHL9ZjgoBROJkDjf2/dmvpuE
	8yfB
X-Received: by 2002:a05:6512:1286:b0:5a1:44d7:1fae with SMTP id
 2adb3069b0e04-5a29b4f8fd2mr2449829e87.7.1774492178666; Wed, 25 Mar 2026
 19:29:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAOx6djP4hb-Cd1Zk07SNfFfLc8irjNmbVqq+58h1Whz+h1wSFA@mail.gmail.com>
 <befb1cd7-f709-4e46-b08f-9c2579b10fd6@hogyros.de>
In-Reply-To: <befb1cd7-f709-4e46-b08f-9c2579b10fd6@hogyros.de>
From: Sean Smith <defendthedisabled@gmail.com>
Date: Wed, 25 Mar 2026 21:29:27 -0500
X-Gm-Features: AQROBzAQWuoiwj5NVrb0IEs5rZjhQDz2eA9mdIKzDHDnBj0mRJSEFKwDanpDi9I
Message-ID: <CAOx6djOJGstn-GHX_wgqOVQ6FKn7O=X-ARSi5=711JwXoQRZXA@mail.gmail.com>
Subject: =?UTF-8?Q?Re=3A_=5BRFC=5D_Proposal=3A_provenance=5Ftime_=28ptime=29_=E2=80=94_a_se?=
	=?UTF-8?Q?ttable_timestamp_for_cross=2Dfilesystem_migration?=
To: Simon Richter <Simon.Richter@hogyros.de>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, tytso@mit.edu, 
	dsterba@suse.com, david@fromorbit.com, brauner@kernel.org, 
	osandov@osandov.com
Content-Type: text/plain; charset="UTF-8"

Setting an xattr user.provenance_time was a solution my AI agents
and I arrived at for meeting my immediate Windows to Linux
migration needs. The idea to submit this ptime proposal was to
help the Linux kernel maintainers better understand the types of
problems that users like me encounter when switching to Linux.

Users like me are working with AI to solve previously neglected,
and untenable problems. I believe I am amongst the first of a wave of
disruptive projects that is going to hit many industries quite hard.

Users like me are unprecedented and working on unprecedented projects.
I think of my proposal being a bit of a heads-up to the Linux maintainers.
To help you plan for what's coming by understanding the vanguard of users
that are now arriving.

My intent with the proposal was to highlight:

1. The friction I encountered in Windows made the switch to Linux
*necessary*.

2. The friction in migrating to Linux can be reduced with simple,
long-overdue changes.

3. While ptime might not be effective proof of a files provenance in terms
of forensic computing, it is metadata that is critical to effective human
and agentic workflows.

Additionally, a sworn affidavit of authenticity is one way to assert the
date created is accurate file provenance. If the system administrator
knows the integrity of the metadata is sound, then they can attest
to that under oath. But if that metadata is destroyed, there is
nothing to attest to. The date created metadata can also be corroborated
by third parties. A plan beneficiary who records a phone call with
their insurer, and the insurer representative enters call notes into
a database. It's an event that 'happened'. With enough third-party data points
verifying a private dataset, the metadata becomes something a reasonable
person should believe to be accurate.

My point isn't to argue rules of evidence or debate how AI deep fakes
will require courts to exercise enhanced scrutiny. It's to illustrate
that the date created metadata has substantive value to legal work.
Additionally, that legal work is going to become an increasingly agentic
and pro se process that can supply substantive value to society by
enabling the under-served to access justice through an open-source
stack.

My proposal for provenance_time is more about reducing friction in migrating
to Linux and optimizing real-world workflows for humans and agents.

I concede that using xattr to add ptime will be effective, but it does
introduce operational inefficiencies and overhead. Overhead that I think
it worthwhile to be mindful of. Having every users AI agents coding up
an xattr fix for an obvious problem is a lot of wasted tokens and
human attention.

Sincerely,
Sean Smith
DefendTheDisabled.org
