Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3D513E95AC
	for <linux-ext4@vger.kernel.org>; Thu, 12 Mar 2026 15:47:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773330459; cv=none; b=lBw1S0/GXnIVbjIyRDMDtfgWrazEdAh/QULAvojg7tV0FuDjbPeiDruBnce4XQsPDVY16CVhqXv7N1bMTG24jrNrSf9KMJkc6/NIH99SnVJXG3jxUCQUtQpMQyqxHmpjrTn2oHUKOcekxwIG6Tqu3uWbH86oDh2BycMC0kOySTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773330459; c=relaxed/simple;
	bh=Z86+A8JRng7UI2sF2Tua+R88v0ug0pwspifJ/PNCf28=;
	h=From:To:Cc:Subject:In-Reply-To:Date:Message-ID:References; b=lvh1Zm3N/kVTK1ZRzd3yXTHmVrp2IMgTWW35Ll0P/u2zH4HkAMYZpm8YS0HGoH0rJoe3I744rqQ9Ojmr+ufYVk1meIVWxB51s8WVPhgvNIwPPeBFOZBvKZZeGkse+ShjkzaY9gTJrdXlZdhA0vfdNpPOd/cturIDk4PDZBUA31c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LqPu6mhn; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LqPu6mhn"
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-82a124f3a5bso335247b3a.0
        for <linux-ext4@vger.kernel.org>; Thu, 12 Mar 2026 08:47:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773330453; x=1773935253; darn=vger.kernel.org;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=D885OaMthHKzMazfSmWLjhSizdtYPijabBVqN1Os/BE=;
        b=LqPu6mhnKK1TDBKEOSkdpxYoNOUohdhgI2YvQcmdU8a7tLxho0GkvhfDGDITWR6iaN
         3/5jtCVR/tmFlDr+CoiG5Nef1S+poILn5dgLmBXbNTvjj2lEO5PqqJfK/Ql8Laol7ACJ
         kyFAIgm1ZVGc0WNrY01cnwhGNj/oi2Wjj7I79CXc5VB+LbBEpmpgPtr1uGb3xDMJkDGu
         fSdS+Ci7vJ7cQaQknG7vyso+9kWdQ1xkGU4PdKndDWswsqk6GC9eHyzwcWaDrdB31mnA
         wr3wbB+fg7FpR27vSF0CE4lWtch7k0svxOqNhmRjgSePEOQbu78/LqPIqDpshsRDSbGg
         SPMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773330453; x=1773935253;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=D885OaMthHKzMazfSmWLjhSizdtYPijabBVqN1Os/BE=;
        b=D9YKMxcAiCx6l5tKVcxpggO1Ka3PKP9lbuHhfMigY3mkLO49HQSGGKPB9ELAHv89RG
         x8nPGPF6jYlDIJSaen6v0O9R+d05CIjRaL0HITJl/H9QMgvJVRTiLFgophbZ/9XPxd6r
         DzAerV8oa59zYL4NCYVjRyNESBYIO3VxRsnb1NmsSwl9HR89GUE9gtH3M1aNNE7GLvLy
         gPbM5FXy/pJwAhi54fmWCirVNo+zxmw9nwjG2aRdj+4ilfBcfThEZEj+NRIW9M6DTrUZ
         Fwn4np5DOaS6Br/G5B6UmBK4S2iZwnn3BTGOxUOdn4/DxGz3gS5yqx4/LBgLDjQ1LUzC
         Zv/Q==
X-Forwarded-Encrypted: i=1; AJvYcCUyItg8sbsLaWt1r0T8nJuXNGGHPF/fFtjVaKWYwvnNXtGpO/psUNIAl4d/57JmnrrGr9AYuWMAyST5@vger.kernel.org
X-Gm-Message-State: AOJu0YyvYjc30x/aGhPNQ9RDz3PGX3k9LmPhrIetNYvefnsASsmmQw+E
	h6ytoJzbKZtQhY9JY1DxNctYI2z445bjfmxArEVS0mocoqt/3Jf7ia52onEywB4t
X-Gm-Gg: ATEYQzyiHP4fbJ54H5pd0pK3qcGpJzXj9WF7lupxIRjhhuOxGW1cK1BKupBGPhzkwgc
	Qgr+tZzIQkPoQghn0LutEm/oHK4S71NIR4QYhBwiRKt2/HBU+ZyfQJHNHGLHIuOCaOkdZWstOdj
	ogscY/9+1GMPqAQt5/p+qMfQGkyaxcBdDUTKFIIFhljYyypVHrI0l21PtZOAT0dd72H0PiWO3/Z
	b6kZEGGRsMsPMoq5dVFFJlpAr1vFaIzHFF15JZsBGPLBUHqR582PoFwgQhLKWx2PW/oehV7aZh1
	yegN9ziOobYS9UgjGh1pM8xMO5L0+mBL5nBmKYh37kZWZF3pE7t1rsH2djsD7IAsvJpmmbJ6L0z
	3qb1eRpVs+ZE1X/NvLq+f/SRLEM95dLWV0V1JguIIIVKAAhUGSjJo6lvNfpCU0HqIwlv8qy+4/s
	4Yk4Pkp3yOsAjuvJzmVcZn+Q==
X-Received: by 2002:a05:6a21:6e0c:b0:398:a71b:a0f8 with SMTP id adf61e73a8af0-398c5ee81femr6563496637.14.1773330452717;
        Thu, 12 Mar 2026 08:47:32 -0700 (PDT)
Received: from pve-server ([49.205.216.49])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c73cdf0e5afsm5678092a12.2.2026.03.12.08.47.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Mar 2026 08:47:32 -0700 (PDT)
From: Ritesh Harjani <ritesh.list@gmail.com>
To: Mark Brown <broonie@kernel.org>, Peter Zijlstra <peterz@infradead.org>
Cc: Ojaswin Mujoo <ojaswin@linux.ibm.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux Next Mailing List <linux-next@vger.kernel.org>, willy@infradead.org, yi.zhang@huawei.com, jack@suse.cz, tytso@mit.edu, linux-ext4@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the tip tree
In-Reply-To: <0d21783c-5299-4488-9708-def0b1a4dcbe@sirena.org.uk>
Date: Thu, 12 Mar 2026 21:13:47 +0530
Message-ID: <wlzht5n0.ritesh.list@gmail.com>
References: <abBizpKaBlTZSYh6@sirena.org.uk> <1e549c32-ea40-40a1-a0bd-0ee87652ad21@sirena.org.uk> <20260311103743.GK606826@noisy.programming.kicks-ass.net> <abF9Ti4pTYnnsMdq@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com> <20260311160904.GP606826@noisy.programming.kicks-ass.net> <0d21783c-5299-4488-9708-def0b1a4dcbe@sirena.org.uk>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

Mark Brown <broonie@kernel.org> writes:

> On Wed, Mar 11, 2026 at 05:09:04PM +0100, Peter Zijlstra wrote:
>> On Wed, Mar 11, 2026 at 08:03:50PM +0530, Ojaswin Mujoo wrote:
>> > On Wed, Mar 11, 2026 at 11:37:43AM +0100, Peter Zijlstra wrote:
>
>> > I believe this issue is resolved with [1]. However, I think this might
>> > not be the same as the issue reported originally as we the original
>> > issue seems to be in mballoc-tests rather than extent-tests. I'll try to
>> > look into it a bit more.
>
>> > [1] https://lore.kernel.org/linux-ext4/5bb9041471dab8ce870c191c19cbe4df57473be8.1772381213.git.ritesh.list@gmail.com/
>
>> I can confirm that solves the KASAN splat; it also cures the defconfig
>> hang that was initially mis-attributed to the mutex patch, but turned
>> out to be memory corruption due to that issue KASAN found.
>
>> FWIW:
>
>> Tested-by: Peter Zijlstra (Intel) <peterz@infradead.org> 
>
> Yes, that seems to work for me too - looks like tip just triggers it
> more aggressively for some reason:
>
> Tested-by: Mark Brown <broonie@kernel.org>

Thanks Mark, Peter & Ojaswin for testing.

++linux-ext4 so that if someone observes the same issue in ext4 kunit
tests, they could find this discussion on linux-ext4.

-ritesh
