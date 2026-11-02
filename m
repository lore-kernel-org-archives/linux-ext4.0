Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793642771;
	b=e1NDMsjwtGH5q6FUYtruzkHrfe8AYrojjd8p6mYGuzDNqOuavKpuIsQwTpu5437ZOgoA
	 QLAlF2LBYmUFN/2hWwxeVrbVezdKQKioYqePSBPifcAXmz1DwJgL0PA5VAUX/IFs2LtDg
	 x4CgGYGuD6aoXZsS2aSuNylp9QVcZVs6HX4o03rneu2yg+1bEaX6TmxD+hiRa3mYRgjhd
	 Ryo8ho71DuXlGr2rt6keWaWfjFYuwhe/R24nusgWl3k/6TlK2z2lw+rUaJdKgt59hhdb3
	 e49LjwyePUKvqZrcVBvuNgH68X4DMVJmkdy/Tor6Ts/j2CYONhqFwW2aVom63orxQZA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793642771;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Received:X-Forwarded-Encrypted:X-Received:MIME-Version:References:
	 In-Reply-To:From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type;
	bh=/vXXDZI2TLqXD/tqTZGHj/cF0YcMq0fXP1TpWYkM2ME=;
	b=iQ86bE3TSuWFEAiOiE5meStzxZr1LTBE3+gvC5YfEIry7JM6P/nHuasr+R95EVCgECmq
	 dMjb+5ZZOHQroRUCGjt7A1dul/9WAkH0bea0gU12ir9HzjtNAJa5JZTopiIS26hYxpoEh
	 cq1D4mScZ20eic+JlQPHSF34rvGmox9CXTUS+W5zklyPfqfNTIdqGZbnkXQwU926FaR8K
	 U6syCTKS/J7pyHaE2b8bYS7bBrbMwrqWJHN02jrZh5/Tho67oYRMO9lLrIQiNqi1j/K8s
	 3VVqnDdX5Vo/3HVZaKvR3pcZzaXewGv/e2tnRmo6n0N0kPjB90VuiszwvSa5Fob3BgA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=linux-foundation.org;
	spf=pass smtp.mailfrom=linuxfoundation.org;
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=google header.b=Li8paXD7;
	arc=none smtp.remote-ip=209.85.208.172
Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com [209.85.208.172])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17EA8606A59A
	for <linux-ext4@vger.kernel.org>; Mon,  2 Nov 2026 18:06:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 17EA8606A59A
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=google header.b=Li8paXD7
Received: by mail-lj1-f172.google.com with SMTP id 38308e7fff4ca-3ab28f3e4dcso37260871fa.0
        for <linux-ext4@vger.kernel.org>; Mon, 02 Nov 2026 10:06:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1793642769; x=1794247569; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/vXXDZI2TLqXD/tqTZGHj/cF0YcMq0fXP1TpWYkM2ME=;
        b=Li8paXD7KPs0pWrx007VEfdTihHlgQtCGROmCeoHUCHeEtJ2EnR9w7cm7Fqdv44ZwN
         LyN+DaPrcmBo1kRVgZSroHQ+N2p1gsnNKsp0uOE60Jp8t/hPxt4KqKaHsa/7XY/NcMd7
         zE/IM/1DDXLpaY13rcibp8JXwH3/Y3jlb0YUg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793642769; x=1794247569;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=/vXXDZI2TLqXD/tqTZGHj/cF0YcMq0fXP1TpWYkM2ME=;
        b=rlBEufSCZeOqyc9NKXsDIxfBM0j8eb7KQkKaHjGeXlNkdOR4DFKrbjmJq6C6YRXZ+z
         wRlNpgqUhV5Vv8HZHlfcDwHosYq3YYbmZdST5wFKqBUH9Yv6vHUR8j+3H70sgELFgjsf
         oQ89g1RPGq7pU26vgR0C+VgyjkPWkFivD4zPMJZsWl/8VmrQraEdMJczmi2JyGrHqENU
         zMRqabeDENApgfXmmNTs5MA81L9maRXqyZSXKrrHVXgYZcZNAXgRZZiFqgMhC+Z9SW5I
         gV+pmbetXQxV8IHv7ZZ5ME+/w9PllH5phAXAutLq6iZCDgbBmO6fwtXnxBV38w8GFgGn
         gwYQ==
X-Forwarded-Encrypted: i=1; AKwUvBzLQMfI+qm5xMhcvH9Eqgn4YO+HZZPDq+s7mfwp86hoVmBIX5TFrLQD3bSYsPtk03jSeRbdoIr3hM7s@vger.kernel.org
X-Gm-Message-State: APuU4Z84YCJWsM9Rv+4NsV4CpTqxu++zHZBVM5TGxDWEjfYdDIED1icC
	9VBh4aNU09Ez/GxAHk0hS9jQWcsYg56CUHf7vl/HVEOGGTmDLItjYaeC69E92XFAXd2uVSZNyPm
	WdV/R8T9alg==
X-Gm-Gg: AYBFou2nMt21hbsINdDIHrC4THdjhnM0+LGAhNt6r+PPlB6y070EQ1iJknzuWa/9ccK
	2+zYHN/ZJADAov6laS4x7i7NaV+acFRlEhez6/QLNObde3FTbFAHlca2yO5Ag8yzbaq5O6IY6eJ
	jtwtSUOayWyAmxKGp+gKyALYKc+Xfud5i60TQp9LCUtB7rZUz48OtPHhzMB1y7Zi+4Dq4YDohgW
	Yk5iZDUWKJyuTySXcvzkV+n35G5dLZ8BrWtElVR+eOYs8nSIHSFedyL7LHlMKBFShpMGj6IApCJ
	xYDKoWS18cRQY89vlwIj4tNOJNLswl4SUQyr58smnf9P9xgPOPZN4HC+WHYP2N8hIaYxt4kruKl
	d57ZjrW0UbTqIgi75KCX9tOqM8OiFhCQXeRxwU+AnUyaeGc5tO56/cvNDyntwYvRJItWqZa4FPc
	7FbpY/ck6POoNthKHFPdLLf1ZPjUdj0r9x+SFlxeMDQsl33reIdZsBOzCi52gXY4EbrYBGuBQyn
	HM47XdAy+GJcpL6d5ClHwilewMz+UV/zVtic8HO8R1j72Tk0Vma/enRjF4hvv4ffGvUjlKSQLiU
	bQ5U+cCinMBkr+WzcpN0dSZCPVgjalL7A3pvEuA68Ulj5y/eGN8vKjOuzz3clp7yFqVq8KnI/9H
	8fheaaTI=
X-Received: by 2002:a2e:bc07:0:b0:3a9:829e:1def with SMTP id 38308e7fff4ca-3aca583985dmr31628381fa.21.1793642769250;
        Mon, 02 Nov 2026 10:06:09 -0800 (PST)
Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com. [209.85.208.171])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-3acd5c2eee8sm804121fa.15.2026.11.02.10.06.08
        for <linux-ext4@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Nov 2026 10:06:09 -0800 (PST)
Received: by mail-lj1-f171.google.com with SMTP id 38308e7fff4ca-3ac65e845a8so38026841fa.1
        for <linux-ext4@vger.kernel.org>; Mon, 02 Nov 2026 10:06:08 -0800 (PST)
X-Forwarded-Encrypted: i=1; AKwUvBxVfkcR5lk/tKsK/9BIcDeDext+H13M5ML60+8PfALcvLcisCj4VBUd6Ev2uE3GHyqbxWn5OHJbsGNB@vger.kernel.org
X-Received: by 2002:a17:907:d94:b0:c2d:c80e:8366 with SMTP id
 a640c23a62f3a-c4ca7426f6emr874452266b.0.1793642348398; Mon, 02 Nov 2026
 09:59:08 -0800 (PST)
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261102-work-procfs-bugfixes-v1-0-59422ed3e465@kernel.org> <20261102-work-procfs-bugfixes-v1-1-59422ed3e465@kernel.org>
In-Reply-To: <20261102-work-procfs-bugfixes-v1-1-59422ed3e465@kernel.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 2 Nov 2026 09:58:51 -0800
X-Gmail-Original-Message-ID: <CAHk-=wiSA7-mqmAjTQDaU7UjUyWt0TxYwXHafL8ZAPudy+B_uQ@mail.gmail.com>
X-Gm-Features: AclHuK_qZTBVsLQIdymgRHScSFenC6XsGggUDmcuOugjrSTbuVkeASUmC_hYPZo
Message-ID: <CAHk-=wiSA7-mqmAjTQDaU7UjUyWt0TxYwXHafL8ZAPudy+B_uQ@mail.gmail.com>
Subject: Re: [PATCH RFC 01/38] PCI/proc: don't truncate the position of config
 space accesses
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Jann Horn <jannh@google.com>, 
	Josef Bacik <josef@toxicpanda.com>, Chris Mason <mason@kernel.org>, 
	Jeff Layton <jlayton@kernel.org>, NeilBrown <neil@brown.name>, Eric Dumazet <edumazet@kernel.org>, 
	Thomas Gleixner <tglx@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, 
	Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@lst.de>, Greg Kroah-Hartman <gregkh@suse.de>, 
	Joel Granados <joel.granados@kernel.org>, Kees Cook <kees@kernel.org>, Jan Kara <jack@suse.cz>, 
	Jan Kara <jack@suse.com>, linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org, 
	linux-acpi@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org, 
	linux-um@lists.infradead.org, linux-wireless@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org, ntfs3@lists.linux.dev, 
	platform-driver-x86@vger.kernel.org, coreteam@netfilter.org, 
	kexec@lists.infradead.org, linux-pci@vger.kernel.org, 
	linux-sound@vger.kernel.org, netfilter-devel@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, ibm-acpi-devel@lists.sourceforge.net, 
	jfs-discussion@lists.sourceforge.net, linux-alpha@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-cifs@vger.kernel.org, 
	linux-fbdev@vger.kernel.org, linux-hwmon@vger.kernel.org, linux-mm@kvack.org, 
	linux-sh@vger.kernel.org, linux-usb@vger.kernel.org, 
	samba-technical@lists.samba.org, sparclinux@vger.kernel.org, 
	linux-m68k@lists.linux-m68k.org, linux-doc@vger.kernel.org, 
	linux-serial@vger.kernel.org, linux-atm-general@lists.sourceforge.net, 
	Takashi Iwai <tiwai@suse.de>, linux-input@vger.kernel.org, linux-raid@vger.kernel.org, 
	linux-ext4@vger.kernel.org, linux-modules@vger.kernel.org, 
	linux-debuggers@vger.kernel.org, Chuck Lever <cel@kernel.org>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Mon, 2 Nov 2026 at 06:22, Christian Brauner <brauner@kernel.org> wrote:
>
> proc_bus_pci_write() truncates the file position to an int. A pwrite()
> at an offset like 0xfffff000 turns it negative [..]

I think this would actually be better with rw_verify_area() just
checking a per-file maxbytes.

We already have that logic for lseek and friends - using that fairly
hacky combination of s_maxbytes and !unsigned_offsets().

We should combine s_maxbytes and unsigned_offsets() at file open time
into f_maxbytes and check that not just at lseek but in
rw_verify_area.

And then things like proc_bus_pci could set it's size limit in one single place.

Hmm?

                   Linus
