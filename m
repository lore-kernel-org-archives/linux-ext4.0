Received: from mail-vs1-f43.google.com (mail-vs1-f43.google.com [209.85.217.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94C2839B4A3
	for <linux-ext4@vger.kernel.org>; Mon, 29 Jun 2026 06:44:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.217.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782715449; cv=pass; b=kQcsAG+Z7l+6ZJ31SaASORL0dcamLUA4heM4yTq8nCovC0Xl28nlaJbVninSOFqQeskkDoKeO7B3tjwP+exAi8PGnjCwzwt2Ewyz3de3qq6pHrnOmDf8/p+ulRT7O3GwVXneajCnAQPR+qqM8lwZgbQUQFcoQql1C3mG7Mlp6Pg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782715449; c=relaxed/simple;
	bh=diUnEjqdxWIPzg1/3l00da815doPDGDw/EqU3W4dTnk=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=I/+VM0NSUMFbiARXKN/6E7YHwUVQCRawshChOBzIUaQJMA3fk1qyUkE/paCrqsWP0efmaios28RPXwesooSjcatcJY6+3vCWVvpoeF2Xogh9BNimdTvUSTW+aT34b9qhBqszsi8GkbRWqYEzMbRaA0wiqQj5sRzBCZ/Zbsy+O1Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GlONSkR/; arc=pass smtp.client-ip=209.85.217.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GlONSkR/"
Received: by mail-vs1-f43.google.com with SMTP id ada2fe7eead31-738cdd667ceso122148137.3
        for <linux-ext4@vger.kernel.org>; Sun, 28 Jun 2026 23:44:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782715447; cv=none;
        d=google.com; s=arc-20260327;
        b=DG9cttQ0PscIuG4dIxt7a85nU+slgEHfkZASrLxFFWkq/49rBhcZnn8e9rYiNDZPT3
         qdQKoq+JOeTzqGApzluFREP4zSY1EirA4vVRU5uHeWgk7CVFiXZczBXMY4JOacIr4UTk
         Ec0JQ34VZdAjElj/Lf1V40ZxrbFj6CzB1L/l5BTTzDyYROuzaQd0QN+IsH1e82aDqZzp
         CjS9dhccXYAKh8ru0ho+TejCSJItLs1jV6YkWKsQJ7ObKUBBXQFHIalQ/xQjXXfkX0Pl
         TJ2PQTdaZZsfoo5twHMZp4gNFAUAa1aKo1/mfF91yVzcy0mt3swxwvJjs/58w00Kn5oU
         yoEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=diUnEjqdxWIPzg1/3l00da815doPDGDw/EqU3W4dTnk=;
        fh=XVP+rggXX44upFVECP5SE97VAbXQh1zqkE6OgDa7DC4=;
        b=jnePxyqH2A2/j/Hg4GLnDeVrkNpFYCyAbYz8bW8+/qXa+//H7urZ2eZNosL+hB1src
         o6Ck9u6ylZV02dVxMDahuQzKxk4+XUv/WMwX+K66S+eEgJfbXy6vfYj++/G0BJVwpNDp
         h2pPrcJnxMTCit6cescoYwY7hJLdVjHUppsTfy2CvYuIYBfoG+isKyIlwZgdINoxRvWP
         Y8eBZJ2QiE4M9w04CBaF8k/T0OggBtCL3q2f0xBPGELO+CtsAKGJabzl1F9WsFaMpBBp
         GfqV0a2GRLi7H3ESe63ZZ4MDfTrpSt13hLz5SVq9HLsTHlpopjaJFoMAEXrwO5kaOoCs
         n3+w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782715447; x=1783320247; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=diUnEjqdxWIPzg1/3l00da815doPDGDw/EqU3W4dTnk=;
        b=GlONSkR/HDJYFswyifESam6q8cAIqXbtBm87y4P/sLmOJRdxRWufHFJSUzCoFmTw7U
         Z94E+0YWxzRDLhTwUGOEl1locBS+Sz845OFWDAeve0FmgNO5bCCZzM8WXxs2/7r1Tj2R
         pA6VBRz1CZ3kuj3bZEi+OlyxRerlSDhZcTNBBcR8vzYe1+HTCNuH4axsPLd2e5TVlD/D
         pbjejm3NtJjomAQGnvfekf/Iweoi2rjBvgdJ6hBpPAVxOrdeR/ltMmz832yVl06c/km5
         aPC2x1H4dMAABj/o48j1nre7qdv4lHWZt59jK556zrPQw52iXOrsUYuMEFeKux5WGmK/
         g7+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782715447; x=1783320247;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=diUnEjqdxWIPzg1/3l00da815doPDGDw/EqU3W4dTnk=;
        b=G0cSyWbM709EHfgsMhnBs/ctwIPfYn32FY+awn0PznY78D+5rbgNOhlE4C9GJr2z/K
         z3fDBO25h2RNAEVyunPnTNgRTynHlYp3An2jxwYQ6nZ/Ksz6u2suWV/yOWbtYSjz+Qtq
         pASSHX+TgRZURBSrblxlu9FgKZB2vsRfQX1c3ygT/D0yqg2Y8I1OIl0Cb1dJDx2Jb2pH
         9dR0XYH0EKLmn1N95p44E68cCE6wyhdCFcHa7YcY05VUCFXh1Y48n8NdoyUwth5UJi2f
         CIZB2ih+GGgbjplTZTAOrtNGp90nAQqun5vn49jRdaNKYnOAEQTkJc1zjz3kz7Rt9lB2
         iPMQ==
X-Forwarded-Encrypted: i=1; AHgh+Rq8otyqRG/zanZpPflODg0AqE0hNXN6fV1sAIuI041hJlZEpvhA6i3t7eU4It/Os/GAu0eHmG9FeDfz@vger.kernel.org
X-Gm-Message-State: AOJu0YybfcsvWEKvgiQBrXqbenvm0M6vuhGTJ/UIMDEz3kka2o7FhnlV
	R6U0UyzAS07uQrqq55Pj28u5cU4u0+5MzQXIR3EQG2gtoaYIVe1u2wFcJ9E4idx7rFS7PyMUypJ
	IlTB5ll/zMeYoTdTYbCLx25oryvTQIh0=
X-Gm-Gg: AfdE7cneXUEaZ0+z/rxdn47jsQXH+/rz7p1QQwcTR52ekC9nLVCWJ2nW6lbWEMeXVsj
	URiHPM2ULBve080AM3uMHPZRYzjZOljrARIM2T1j8UTga+URiTjCGCQY/Ln5k7S0oXWa9PSSw+S
	yZ6BkucYPm8Keh5giQQ74RyLWvUmda6CID5fyt+yc2uz3x6bYfXRO/uunT2wjRo8z4I1tj9FYaT
	wt0ip9uDnQwOJ4+mxXYd+JPpnLuhQjq0SCX5+twd5KXgJjqL7rfrlV4yIP7AX2d9ti85dXF1xbC
	foXsekr79pY0a478dArdjImfIog=
X-Received: by 2002:a05:6102:2b95:b0:631:23fa:38d7 with SMTP id
 ada2fe7eead31-7343619eafdmr7063781137.14.1782715447497; Sun, 28 Jun 2026
 23:44:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Xianying Wang <wangxianying546@gmail.com>
Date: Mon, 29 Jun 2026 14:43:55 +0800
X-Gm-Features: AVVi8CcEx3czD9MCsHg8rySwnRwcuh6hXqZx-UDG_Q-mFwNWg8VBDIKE00LqPm0
Message-ID: <CAOU40uDfHk-8FxOuHO=rWcfjN0cV4psXhgdxckYhgaoaGZ51qg@mail.gmail.com>
Subject: [BUG] kernel BUG in __ext4_journal_stop
To: tytso@mit.edu
Cc: adilger.kernel@dilger.ca, libaokun@linux.alibaba.com, jack@suse.cz, 
	ojaswin@linux.ibm.com, yi.zhang@huawei.com, linux-ext4@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi,

I would like to report that this bug has been reported before, but it
can still be triggered on Linux 7.1-rc5 by a syzkaller reproducer.

The issue is a kernel BUG in the ext4 inline-data write path. Before
the crash, ext4 reports corrupted block allocation metadata:

EXT4-fs error: ext4_mb_generate_buddy: group 0, block bitmap and bg
descriptor inconsistent

The crash happens while the reproducer is writing to an ext4 file
through sendfile64(). The write path reaches the ext4 buffered write
and inline-data write-end code, and then triggers a BUG when stopping
the journal handle.

Based on the execution context, the issue appears to be related to the
interaction between corrupted ext4 block allocation metadata and the
inline-data buffered write path. After ext4 detects that the block
bitmap and block group descriptor are inconsistent, the sendfile64()
write still proceeds into ext4_write_inline_data_end(). During this
phase, ext4 needs to update inline-data/inode metadata and stop the
journal transaction. However, the journal handle or the inline-data
write state appears to be inconsistent, and __ext4_journal_stop()
eventually hits an internal BUG_ON().

So the suspected problem is that the ext4 error handling path after
detecting corrupted allocation metadata does not fully prevent the
inline-data write-end path from continuing with an invalid or
unexpected journal handle state. This results in a kernel BUG in
__ext4_journal_stop().

This can be reproduced on:

HEAD commit:

e7ae89a0c97ce2b68b0983cd01eda67cf373517d

report: https://pastebin.com/raw/1aWWc2Uj

console output : https://pastebin.com/raw/MS8YxkTn

kernel config : https://pastebin.com/raw/fUwrL2uz

C reproducer : https://pastebin.com/raw/HgPfLbKs

Let me know if you need more details or testing.

Best regards,

Xianying
