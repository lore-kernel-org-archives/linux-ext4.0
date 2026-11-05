Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.160.181
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793872900;
	b=jn4No2T5AtnHFNkWSzplmCxEpyK8PQXrmtMRxnTQCfUf+De2FolHBP5NT6dGenl5EMky
	 d+NrXWdJMttV8zCY73bMozJ0zmmUIiGu53TtV6pzfYIFzJPYXRLXKgGFMXosZOsy5HqPH
	 VMWSjzgNu0NXvoPYqk3RDANVwlZlI5v7OkyKVH32+SElShxH6sJEn09NKRf5whjz6nfZ6
	 jc/0fMlYRG6zO0zk+gDQPvrYcu6HuXRIioyatPBdPRtu76ripa6q24MUAV4JfUf5IYfiy
	 ORFC5qtnt+Q1I0xdDob3fu1/dOhhCcIrpXO/B/wodcvDt34K8VGgm56bVGVEq8vLIfA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793872900;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Received:
	 X-Forwarded-Encrypted:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type;
	bh=LrgDMUrSYXpYgkAhfsYKg0ebb/uLgOfOMhqzX4yL0j4=;
	b=rn9xgHa41DGv1ciQbYdNOFK4L/AB3cX62L3N0Qy6tzTNGoPe5CT9MpRRHYR688hLHQeh
	 UFj09Qm+k3Z6Y4zPc0lgIJ5lhsAkwd6zH5TsgIsrdlJDosXYRVW5tvTuYQUsVSNuKNmYn
	 a8xZG+XhaMQdtZTWyPD+4CPS9oheujw5ckPbM47h2ZYqpAU0tflUju5abEci24Z+yzAhY
	 ietuQu2eXoYuldoh4vFQdb0t1QRUnL2+xo/t21/UMdi9FgQUQ1Kn3f9xQHdjVGyZQs4LS
	 TQq9tH1w9GDSrCC8nC+V9JIsFWl8uc9djqWOjrJZvsnKS/QvtwpD4gcMgIBvz5w2Otw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=linux-m68k.org;
	spf=pass smtp.mailfrom=gmail.com;
	arc=none smtp.remote-ip=209.85.160.181
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE5C3606A31B
	for <linux-ext4@vger.kernel.org>; Thu,  5 Nov 2026 10:01:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BE5C3606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-5365d26ccbdso19500171cf.0
        for <linux-ext4@vger.kernel.org>; Thu, 05 Nov 2026 02:01:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793872899; x=1794477699;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=LrgDMUrSYXpYgkAhfsYKg0ebb/uLgOfOMhqzX4yL0j4=;
        b=qSu8vWVxwHyYh5qvscmdS4OWlB95lvuDTsfaci1nsX9K4ELdE6LPPn3SsueU/HWHMr
         x1sazHvhb3Ujz/xkW6Sbee1Qdcr6bWrE1NZGwWIg0IrVGU4d2AjGEwLwetQ8cn5pcC44
         rKO19d+BWvNWJJ+BYCtbDI4/A6orb/4AqFWCDc1PIl20mDan92gii8DZKi7r+1e9rv3V
         0q7hwLLAWtDJOTaPtfei1d/hhh74oKkNzBCipvDGbV8KsxDgcsLq5UPEG2GJrSjHvwuM
         k8sNh2QWrdjcmukuNzETbpNSS9WpTh9lMdJgO4EZdk7IrSEYDlyTbRugAgltdomcRS8N
         5sPw==
X-Forwarded-Encrypted: i=1; AKwUvBz1nGh9PQBq1ewyrxQEGVDypl7ojW/9eAimiSIACi4wRbxyPSdJQNF+2gd+x7RZC0MizQR6ywuh5Tci@vger.kernel.org
X-Gm-Message-State: APuU4Z8+1kkOkvprZeOBHVjWm61aUSN4TzGVDBDQaSols5a2B6OgBZqw
	TRZygkw6CHVF2Hl4Yi6cBT/M1lj2oluQQ//jFuXqFyoT7BaIFH59j+n5t8UHOuZmqSg=
X-Gm-Gg: AYBFou2Q3M9x+hQdSW07mY+VAZKxnVMqASO9EIJfvPCywUapIhIk50F+SiQjhcx31dY
	9WJTLlm6iDSf3iO7xum7atntCHtJ9tgoL8MkFBnGxciSthtDvs1CoScPUfX3tb3xrMHm7ChSmsp
	z89tKirfjxcIod03alN4zamxglpuTMVp9sBUrsL22A03GCFVXWhNW+SEb7Sy3eaozqpveN74pY5
	pQqTmfZWWOh9Vc6gvViS/JHv1kXiJ212Zt6naTcRu/zcqqcEv4/27kcfq8p0rjfo5pMyr60ofRn
	j3J7soSFUdFx6YUv4dSHFgU8p4p8gDQfXjxF6TzKyXgwa3laY6Oln7UvYQytRN+YTehoGvFEpYv
	66FZyGCh/n2UeEj1zD1dtf7UkaqJps6iwC7SWb7aB5xH0HxY1p4amY65CuWw71X8B2L8hKM2gpW
	+M/UVMTbP0owKljM41OsLU4+PDbkYjbQbgQScF2R8r33JeEgjv4jWcqxUkfBIO98xqucekAas5w
	OsViMmiQpfvgNCjHMDuKcOz2KgxOlqoNo5V2ed9JfHXnjAIpZW10fERjbQMNRFpXFtziFcO3QGp
	qzm+426oSSHZgqwpShWSMfXScRmwfGr4XuWAmzGejapRMuxLQxgMXP2XjI0cZNGMDBTOdg==
X-Received: by 2002:a05:620a:271c:b0:93f:25a0:6aeb with SMTP id af79cd13be357-94421712deemr3104031085a.23.1793872898509;
        Thu, 05 Nov 2026 02:01:38 -0800 (PST)
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com. [209.85.160.178])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91e939fc1d9sm22026896d6.18.2026.11.05.02.01.37
        for <linux-ext4@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Nov 2026 02:01:37 -0800 (PST)
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-5364d86f7f0so19471191cf.1
        for <linux-ext4@vger.kernel.org>; Thu, 05 Nov 2026 02:01:37 -0800 (PST)
X-Forwarded-Encrypted: i=1; AKwUvBxuWIy1k6olEZWR96dkRHtqojllKdAWhIlmVJYpuGoA2DR8E4b5w5Xsk5JIcZoBFuRYv2B5jg9so569@vger.kernel.org
X-Received: by 2002:a05:6102:5108:b0:7cc:56a:58e5 with SMTP id
 ada2fe7eead31-7d072d84a58mr8269567137.37.1793872526219; Thu, 05 Nov 2026
 01:55:26 -0800 (PST)
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261104-work-procfs-drivers-v2-0-245e54e87116@kernel.org> <20261104-work-procfs-drivers-v2-2-245e54e87116@kernel.org>
In-Reply-To: <20261104-work-procfs-drivers-v2-2-245e54e87116@kernel.org>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Thu, 5 Nov 2026 10:55:15 +0100
X-Gmail-Original-Message-ID: <CAMuHMdVHxQvKnJyKHrOZhaOg9Rn2hMeRU1JnMFFEEi31FPZaGg@mail.gmail.com>
X-Gm-Features: AclHuK_UsJ1nGicdWEWcMLQAICTi1A7pGF3yhNkxXkXRPqohle17eXAHHNBsR6k
Message-ID: <CAMuHMdVHxQvKnJyKHrOZhaOg9Rn2hMeRU1JnMFFEEi31FPZaGg@mail.gmail.com>
Subject: Re: [PATCH RESEND v2 02/26] zorro: let procfs copy out reads
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, 
	Linus Torvalds <torvalds@linux-foundation.org>, Jann Horn <jannh@google.com>, 
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
	linux-debuggers@vger.kernel.org, Chuck Lever <cel@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Wed, 4 Nov 2026 at 20:43, Christian Brauner <brauner@kernel.org> wrote:
> Implement ->proc_read_buf() so procfs copies what is read from
> /proc/bus/zorro/<slot> to userspace after it unpinned the entry.
>
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Geert Uytterhoeven <geert@linux-m68k.org>
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
