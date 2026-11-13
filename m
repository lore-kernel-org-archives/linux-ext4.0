Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.45
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794607916;
	b=oV1aq5NkHyh8uIMflKRMn9LTu6pGSjQjQtjSy8TNy5LRXM0dsQ6fHBmPL3SeqXSOdYxq
	 0ibzZeiQgGX++owXbpGHi0xljv2WzAxkcas/9vL/Cmp3/LfmOGajYoFqK2vDStnY+S4ws
	 e6B1zwkbYyo8du9Trnskvn38ctwVMeJtkgpbMkd1eJUaxhIEWyg6a03h+7wd//NKDnaPA
	 9uSSttyLQbAzvHafMu/JnQE8HU66pf8oSRIT8J0IrI9NxFo81fwy8CZ2BDPcCPpx59q4M
	 1UNwBQr3DrYfTXqsqNf0E0oXTatiEOtzPiEN4CnJGFcxP0ygkmZFWw6wkCKlhbxxixw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794607916;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type;
	bh=ybt8M67biDsHhGooRRbdUNrCGrHYGM9IN8vEnin7R9I=;
	b=K90/rxkpYtcOHurWWmUVZ+rR8PYY4Qkjibyq1PJz+EkxL6KbYUkgYYZJqcsfpB5G9yme
	 X6rRap1jCy9Z8dnO45zeafyej2dPYmfMxPHLW4ru2V76lH9a5a8ImrGu3iqKSoncAWtr7
	 MWlWTou1/evT2/YBRLMeCCAwMsbIUr+gjde5lr3SHddHK+AeNalgnKlXVtaB9Own6EZ+8
	 plz4dhiW6O2J77Kz3DGkuRKIwZVWzMexv5AAD9bbwl9aTB2n+T4bYRCAXup4ZS1htyi4B
	 dz9jKmOaMXdG7iIreiGhyZn7ZcZcaql6JjdLBJfOLZ4BpYDAc0DLSPwVzWHKa9Vjztw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=fkKGGul6;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.45
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83018606A883
	for <linux-ext4@vger.kernel.org>; Fri, 13 Nov 2026 22:11:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 83018606A883
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=fkKGGul6
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-c40e30c26a4so342400966b.0
        for <linux-ext4@vger.kernel.org>; Fri, 13 Nov 2026 14:11:56 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794607915; cv=none;
        d=google.com; s=arc-20260327;
        b=Rov95/cdRtfwRW/JKB8luQixGszKPxjMp0Yu3GBgYrKIAlp7O1TdMCjZ0s2Zy4r25f
         ItBHo/OBoBaj6oNz2qpN4dQetz+6wOSf9Qv1med+813xOT3qPhON9lAJbFQgCLHk4Nli
         1pni92gxmxXyeZZwcpHT+ia8s59vYdm7SUSX6fdbEOJUf2gfwsCOGsmxaZhQwH2IUgZk
         +/v68tdzWo72kkEbIWqAAGmhVZMHddPmpBD448f+HboST5qwtQZ3b+A9lN2PVyN/peyD
         hJSptvvrTWXhJJGGiy9krclc2UOIImsjYJyQjU2QzA4FGESROavwzj8APFr4cjYkD8mh
         rq0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=ybt8M67biDsHhGooRRbdUNrCGrHYGM9IN8vEnin7R9I=;
        fh=xML0hpWv3mVKOvhGDHSzbVuWfi1RFhUzNwi1AnNyh58=;
        b=a9X4EbWWH8N2WXISaAVOwBBCcd+0tp4cowNB3VKJWnon1VtIdGrITMClu4Ju8wph42
         /Hf4WfC4Ay7msVoz9mk7nE/5BavvK4H7G9uBoZDnVSlOuBjTx5gklqnubQHGQagu9BIz
         xlVELorR1gk9kzRSITeAcKCTdC8Olj6yrsQbFowieoHaa6bB6qxoiTnsX6NQZMfWJ0Gm
         D91f4Vb148izlPxRa4mbFdl6ChB62WGwC7/c5aljIyF+cETL8pc4qoGojgqGmnzxI9vA
         5BExrLKnsYUUT46oHnEGBQ7cwjpeYv7AtWpi7eddW7ARJnxCz6IjzjGNQp6JTcoa7jiq
         QmTA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794607915; x=1795212715; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ybt8M67biDsHhGooRRbdUNrCGrHYGM9IN8vEnin7R9I=;
        b=fkKGGul6k5DfHm/ywwJyW7SQPx73tf0+mO8q7ouVZBy4v2lrAFxYP4r91QXtNUL1mU
         irdELIE0V2E5fWF1wUnwTWRviflVxu1d0ac1q+8gI6A1K/9zdHoBEMmjLPi6Jiiqqx6i
         NmtRAgzjGp978IRelMN3Wyj0kHipRDzJAhpAvG2r8jOpTUOyfxGLBls4G0k/XsAXLw2F
         U+qfBJCSwcOo/+4LecrpNDbXQFRrVT0Q5GxyNq/UYeU+4nnfe5kaapWHC145/30E+EC/
         TYHjPXslM+ZoS5zYRloqlvyQg/hPfqS2ZyhiJmMZCB7j9md1jhBttd/Ctb0bS1TBgEBj
         fphA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794607915; x=1795212715;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=ybt8M67biDsHhGooRRbdUNrCGrHYGM9IN8vEnin7R9I=;
        b=L5JpetcI9qcApRPFwQfJ6SSPDRfws00b18AOihM5y0DSZbyETKzuCDQKIil4Ef881n
         sct0lbaBdj3cKXKpsoKhsFkRkJp7AASpZmBFAHJNTQR+WL0F6FnnGmRgPc8t6laZZUIA
         +iepMwzkH/IDUpDZ2GLKKhzg+e7YOlk3llBsTa0boNI/n9j3FNMOYbPjtYDOU9qXz4iZ
         p3a7JfdXC0k+yubIEjDx1HT5eA1bRciDqXSeBzmDQwrEc4fqlY6tHu37lkvksC7YhoPa
         LKyj6Nn9k3TYZuVeJeEerakFxcoOPOk7/tDLT2UKZuTHXc/Vlza4mpBjCv8zFKlajORT
         +vvw==
X-Forwarded-Encrypted: i=1; AL+hErE7hiWuR7NqvTHLs3QQwghullnjejkkYFf1B7TzQg/7b/N5jMu9psggyeifLKgLBtQ4iSteB07Aur4E@vger.kernel.org
X-Gm-Message-State: APuU4Z/GmsE6jMRGGi11W+XiPAI5ObcRcCpAuJCsJa3j7e16BzOR2l6E
	0g2XOSDdXf6wOI0p0D/OnS0D33ERO8jhS2Bw6mhpPbXi4eTu5DBckCOwCQkewgQFzNi++DGJxrq
	Toz2COwdT5tAzYHZcY12EKXXHxhjvItN063EMJlbn
X-Gm-Gg: AYBFou0yrGv03+D+0oAyndMsfzfVAhahSiuBeaSdIzmLhSSHneyU1CkdSXoUr5W85Y2
	PzlURBqtiFl5qzkxVOGpi1AyLQN+NqTgtjqHI+3Mjxt6cMzFTSyu82/CJqAVGYhWhf+ndk5FlSB
	wk/MxS7veET53XBZpFJIPHDGrlrCR0+XEqS99z/gaiP9OC+o+6yzXANKb3zt3pQsMLXzcCL0WAT
	/VhgtWCbpKOEdlCQp/6/5UfIOXKnGfj/4diDJyyBFADULdXo9KvEfsQ4jkkl1WMOMu4aPdDT1Bl
	5NZVN+Zn84qypJiVhTRTY3MsQqwlZMqPib8bvB2UoHIsRcbhIh3utQqeQvPvj9S6m4TszQmFmD6
	aUpx9PMbglwvuYEqvfv5cQH/VSzm1g9MTp0K4z+WRVC5UneesfAWMyHKOKaRBvBr+GQwH
X-Received: by 2002:a17:907:9285:b0:c49:8bf8:a7a7 with SMTP id
 a640c23a62f3a-c50963173bamr342209766b.7.1794607914514; Fri, 13 Nov 2026
 14:11:54 -0800 (PST)
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20260918025416.604297-1-dhavale@google.com> <2ednz67kpd2ikrnerrmnvol2mdfntgqhakuoiu7x4cnrlpiugm@ojqolvlfmpnj>
 <CAB=BE-Svy3yoG+nJ7Z6Us5GG2Rj-7dyCY+EMpR9Y+PtyXUKnCQ@mail.gmail.com>
In-Reply-To: <CAB=BE-Svy3yoG+nJ7Z6Us5GG2Rj-7dyCY+EMpR9Y+PtyXUKnCQ@mail.gmail.com>
From: Sandeep Dhavale <dhavale@google.com>
Date: Fri, 13 Nov 2026 14:11:43 -0800
X-Gm-Features: AclHuK-6Nfu6yXgfsqoXIuZdafpVDjnEAv-_a_h3e0B--jKTepPtMeiRqE-zaPU
Message-ID: <CAB=BE-QiSn5N=R4aAXSzqvvac7rUb95grTidv6DVfKnjha=drw@mail.gmail.com>
Subject: Re: [PATCH] ext4: fix race between inline dir conversion and folio read
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: kernel-team@android.com, stable@vger.kernel.org, 
	Andreas Dilger <adilger.kernel@dilger.ca>, Baokun Li <libaokun@linux.alibaba.com>, 
	Jan Kara <jack@suse.cz>, Ojaswin Mujoo <ojaswin@linux.ibm.com>, 
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, Zhang Yi <yi.zhang@huawei.com>, linux-ext4@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Ted,
Can you please provide feedback? Looks like this was not picked up,
makes me think this slipped through the cracks.

Thanks,
Sandeep.
