Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9543D344DB1
	for <linux-ext4@vger.kernel.org>; Fri, 27 Mar 2026 16:09:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774627745; cv=none; b=oZwV/x0cCdeQO3hu946oHRLoN7M9nI1KW5WqnkiaZ4AUwh3ZpLIgur9GEnpnPNoc2Vm7g/264eArKoaSVNGOTPwIFWXrAtRL5c02uodT67Wp6JSIa7TytGvgredXg42R0IkGhYyxZv1G3WkIzUP7AzZAiFmv8izhZpFIpoRUWvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774627745; c=relaxed/simple;
	bh=AhACoJKUePbWhUIBfTtBJjojmEhtsQ5aOjUHthOWYiI=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rOB7E9rp0mQ7jKOyjINA522V55mes1aGR/3eRafgYrgDJvJA19R3mWYSyFdQ+SWJqYAXFWn6qyeaS2XI5GhtDuPnESpE6Zus0n+tighAp9dkxvnxkQwxTh46pH3x6qnjRJ5y4/INoi8Uk6T4ErZNt6I6e6TNcvH6OUv8TpwG+BM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JgmuUUDg; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JgmuUUDg"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-486ff201041so21203785e9.1
        for <linux-ext4@vger.kernel.org>; Fri, 27 Mar 2026 09:09:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774627741; x=1775232541; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=C6+lSlNCSf1mZSv3CVU756ouTHRZ2eG1vELpstFvvVw=;
        b=JgmuUUDgAJtQbTHoIj8T1fRkCbaTlIGIz1aK9ZWdc3mF93uqdXA2iklkY4cuwKe2ai
         mrtwSZfuKfBcjGvoW76FqIakrsIT2/XFt1xWh0qb3ERvOl6qbXFei4D1HP3yItpVNhdI
         Dhl/RfyKyWYacQ4KAjJZI4PUVRt29FK9ddBvgETO3JxeZt/EIFcyZt1ZauuuVenz58T2
         rjYmbHKlxfcphIR8FznLTdOonp7qQnpOV0a4DoV29auPVvBhrENGTXGcX2BFWtXZZNit
         WX8wZnHIBxFWc5erwHDVLfPhS2e50MR8jv7IPO83uvA+cleJP4ulnsF+8Vt4GC5ezJqI
         GOcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774627741; x=1775232541;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=C6+lSlNCSf1mZSv3CVU756ouTHRZ2eG1vELpstFvvVw=;
        b=ahMAuGRjmxqRuj3WOYqLu4PwoaFJ7j7MYZTrI8DJn8TJDgtQ6WnB6xLEbgwJPpbner
         vtLpLIoru9gh7jO91nsFi29veV+w3btBgL+QwJhSNiubnyOXaNirO76It+oPS8YrRU7y
         Y5ONVKSCoejJHPbXLAP6PfUf5bVOW17tAnR/WjXK0xWskYoQ0sshl0j+m2HwdFIUx4ZG
         ix/WRxQ170VSroWOhfU+Wn94sy5YLahDkLO+xiyTnDv8HgWVT+S3eJ8us88atWoUJhbp
         rxc4X85mvdSzd6GfF68zOomVd/fYw3ZOZsAgV1hA7iRbykg5Oq6lsJiL9oU07WMX7hH8
         D+kQ==
X-Forwarded-Encrypted: i=1; AJvYcCW9k0LID5bvZGgZbqybpNesNeuxPrBJddM45jslXFpJQu+XdEWYoVrmpZjzInISBnEnZhbPJ0srToHk@vger.kernel.org
X-Gm-Message-State: AOJu0YzgwvY4Wa7fSwCh+CsjUvDYHWGyKNbZvdPebudRLq1R6Kmc96Vw
	kuHh/0HYyKp4zU45/GS3VEAeRTmpU7IKdqYMmPBhfTeCNCCRa49CsG/F
X-Gm-Gg: ATEYQzxtbK5mSHM4LH160Q80simtF40Jkscs8OGYBn3sN3I/582aqe3DWNA8PAY3F1L
	iIEvxdO0ctSgfzK6Ljo1CRpF6AhGY3iKH5DRqQmrIQX86VVjvRcu6IzbJf0q/zycWpA9LQpKV+0
	rON9uwcmI9tjwvqvlo1guXABaQ0wRXPpvB3cyMmGW9Hav8C0mXxTSzKFe38T5LGHjQ5dBGxuzbQ
	eoYgrkudU7SBKZ57CS45L+r5DxiHr2RCEbPCgvquuYLLHKf8NVBFF+/s+ffYXBlWpfU2iIKyfJD
	wIXxAKD10L60poLOB2LvGdm8nUdAu2vq8jFEp9XsjlVKCKgtpLZ5IKb3jFkTDu03YT+VbqunsSE
	YcbVPkklJ75z/sG/tmH3ERjfF+L7dqroM2YbzD5pts9yuzKchRUog228ZMZ4XznFdxBshl0VJLw
	sKDJL5GEn7aRDEDsl7zCjvSD758bt00Uqvh+EIsU5J4Ez5nrmVmh0kGUUWSQBIGyZO
X-Received: by 2002:a05:600c:8819:b0:485:3ff1:d5c5 with SMTP id 5b1f17b1804b1-48727d55fc3mr56494385e9.7.1774627740517;
        Fri, 27 Mar 2026 09:09:00 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-487270af027sm31353835e9.3.2026.03.27.09.08.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Mar 2026 09:09:00 -0700 (PDT)
Date: Fri, 27 Mar 2026 16:08:58 +0000
From: David Laight <david.laight.linux@gmail.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Theodore Ts'o <tytso@mit.edu>, Andreas Dilger
 <adilger.kernel@dilger.ca>, linux-ext4@vger.kernel.org,
 linux-kernel@vger.kernel.org, Masami Hiramatsu <mhiramat@kernel.org>, Petr
 Mladek <pmladek@suse.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>,
 Steven Rostedt <rostedt@goodmis.org>, Sergey Senozhatsky
 <senozhatsky@chromium.org>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH next] ext4: Fix diagnostic printf formats
Message-ID: <20260327160858.233399bb@pumpkin>
In-Reply-To: <acaQVpYREnJJuJF5@ashevche-desk.local>
References: <20260326201804.3881-1-david.laight.linux@gmail.com>
	<acZgmKv38HLhky6q@ashevche-desk.local>
	<20260327125412.47944386@pumpkin>
	<acaQVpYREnJJuJF5@ashevche-desk.local>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 27 Mar 2026 16:12:38 +0200
Andy Shevchenko <andriy.shevchenko@linux.intel.com> wrote:

...
> P.S. A bit of off-topic, have you seen this?
> https://elixir.bootlin.com/linux/v7.0-rc5/source/kernel/stacktrace.c#L33
> Is it correct use of %c?
> 

Works with glibc (or, rather, with whichever libc the shell I'm using
is linked against):

$ printf '|%*c|\n' 5 x
|    x|
$

'man fprintf' tends to agree.
Left justify also works, either "%-*c" or passing -5.

The 'fun' starts if you print a zero with %c in the middle of some output.

I know some compilers have supported: int c = 'abcd';
But I can't remember whether the value could be printed with %4c.
I do remember that the value ended up byteswapped in memory on both
x86 and sparc.

	David
