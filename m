Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2DAD1B78F3
	for <linux-ext4@vger.kernel.org>; Tue, 26 May 2026 15:19:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779808775; cv=none; b=TTnjV7iorupX8dOfyfA8trVXBcOKNaf1KJmYXMKWihNRyBLHJCawpGeDtoV1osGetYjn9+RxA4Cm/CeYN6YQ7XrsgOUsxHdSojwv+mU+VG+HFj3q+L125GVKOWd56qu6s4/GA1mc/PqxIDsBueXQUAqwZdWSS+lkERhfTj1u8g8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779808775; c=relaxed/simple;
	bh=0ZnjPi7BwnAOrVB91/FYkrKd3xmpByfSExU4BuXXulY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RoVErC6j8D/SO7Lac2Lm7ruuaIM2YHp7rLQ0lCuUwKWCjjYe4tNUrJ2dSTibu2G2E/o+890zozUxd2SeKzfHvrKVzQHp3Bp3CqkFpOTIWsaR5zrui7yn7uVjwJwZpfc8oF2M7O4kl7sMZXnLPBb6sHi+13a0H9BH4/MWjc9YIsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dCcHEc51; arc=none smtp.client-ip=209.85.215.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dCcHEc51"
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-c8173b2af32so8337360a12.0
        for <linux-ext4@vger.kernel.org>; Tue, 26 May 2026 08:19:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779808774; x=1780413574; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=81JJQRQ2yMbKHbejnSmsG4QSx00hSzBR2QqgEz/z/s4=;
        b=dCcHEc51DzUejXFJU3CnUz4cmcO4A9DHsnuI2CKbf9ITFWqspVdZziai3B7o9xl5W/
         wtkpACv10/WcrV1U5wsAcjg1qYa5cIg8JIHId3hxsDTTtOIWFjlKXajYMY2Jfo2A4qeu
         2eZg6r97gA8prwOlR7gY5dsNdL95tdIwk5MjZdc8ePyN/aHTOk1gnsAKgaHNy2g3aHni
         w5oS4glZ9wgeDKbOpWhBO6sANzc65qoCEG/61ZT6FEXW2qa+uuV4ftz/r5rawMpicFyB
         5WGrmaU5KQTPmOgJ5o1uLpEk+j2hTAXIP2a7B8PH0gv1SEDbKpM093lKjKHNKq+fI9ca
         uu9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779808774; x=1780413574;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=81JJQRQ2yMbKHbejnSmsG4QSx00hSzBR2QqgEz/z/s4=;
        b=YmQFZKB/dUZZzvFR2Vb8l0Wc2dJra2jNosRnz+sx1wJoVBGuCSUMgrDu4WUDES4eYj
         ttXZrtXO+2lWaucPPQUttryxAmFVY0DyEsP0uNesaC20ygGuMbTeG9AIMKts1UCaD4hs
         1yJ/Lk568yCXQ9EO2dzkQDteW1AjeaNA2SM3cwl/wtPWciCkpseiOabhHvoo/3B7D1wp
         hDOGOk3m2Gs8w7WW72pXpt7nCT/Y/2t9jIdjD0gt+N2kB0I3ykYHw4q5Dhha8D5wxOLi
         bFpB+6FADPHStD9mh/1u2WpjcqE+qkI4os4fCyVZCCulGxqsKQ0j/DdC/9O7bGd0a+Gv
         jiMw==
X-Forwarded-Encrypted: i=1; AFNElJ+3NriIhOwK4f2fsz+2mdNSlvpdauMDhMvkiTExKQNcTf7CuO4dSE+ZW/nINd9hWtHVuIh3nydJuct2@vger.kernel.org
X-Gm-Message-State: AOJu0YyP3R4wOlbppJYXn/W/dKb1CWcNrzk+8lLuqx4fwsaXRQKW0xXT
	KwZFQogOmdt53wbV22YGyord0AuoU1GH0QP+gZ5tJcuCrUU4PTGL3huG
X-Gm-Gg: Acq92OGl4v8Bo5axetQj+UWgR+xHyqXYmVXtFpvZGuelqM8pBorBIV4rpuG3G2sZDqB
	OjaDjxt0t94PlvScLFzdyRvqRN7oOXzq0kHxulXRUeb13ty/vGS3XnqgpfhHxB8U72QlTukw1yz
	bC3/v5HsQyFi3Ylui3s4lkzsWhupYkcPVqcZ91/+4SmaxwYSuKUYfzTlTD7lD4c6yUXQHqAFjE2
	zJizwpAizYO0ctk7pmup/hb38JV1EJySHb/Ov1/vornlemv5BZPZzrPh9N0TPsAiy/G48BE+APK
	UvHnImQI3veF1rwr6QWdkjEKxECNZaKxW0CrSRJggdPMZK5yIs+LbluWPh3aYLysFsaJ+dyzMV9
	KPt17k+EQ9aNEo6xufYfANTiAy39QBwtJgx+e/UJPyjWWPNzHr9QlUuwRKSxDHR7/j2WXa1pyjq
	AoaJwdtDjSgBhJfQDuNWUROrya2Ns=
X-Received: by 2002:a05:6a21:68f:b0:3b1:a9ce:5095 with SMTP id adf61e73a8af0-3b328d940ebmr19169216637.22.1779808774114;
        Tue, 26 May 2026 08:19:34 -0700 (PDT)
Received: from [192.168.50.90] ([116.87.14.48])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c8520561e94sm11447223a12.22.2026.05.26.08.19.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 May 2026 08:19:33 -0700 (PDT)
Message-ID: <e8d0caf9-df8b-415e-9f89-bc71e73a0e32@gmail.com>
Date: Tue, 26 May 2026 23:19:30 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 03/10] fstests: add test for inotify isolation on
 cloned devices
To: Christoph Hellwig <hch@infradead.org>
Cc: Anand Jain <asj@kernel.org>, fstests@vger.kernel.org,
 linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
 linux-xfs@vger.kernel.org, amir73il@gmail.com, zlang@redhat.com
References: <cover.1779367627.git.asj@kernel.org>
 <1c60be06ce79778404079c8b1c1d2e09f64cb38e.1779367627.git.asj@kernel.org>
 <ahP1tCc81ascjwxJ@infradead.org>
 <edadc872-5796-4cff-934b-cee66fde79d2@gmail.com>
 <ahU9hpwrXyZChw9X@infradead.org>
Content-Language: en-US
From: Anand Jain <anajain.sg@gmail.com>
In-Reply-To: <ahU9hpwrXyZChw9X@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 26/5/26 14:28, Christoph Hellwig wrote:
> On Mon, May 25, 2026 at 04:35:58PM +0800, Anand Jain wrote:
>>> Also any reason to rely on the obsolete inotify instead of fsnotify?
>>
>> fsnotify is exercised in patch 4/10.
>> IMO, exercising inotify ensures we don't break legacy stuff.
> 
> fanotity and inotify use exactly the same backends, so I'm not sure
> why testing both matters. 

I noticed that back then I decided to keep both.
Since fsnotifywait -F is only supported from kernel 5.1x.
inotifywait serves the legacy LTS kernels where required.


> Not that I care very strongly, I'm just a
> bit confused.

I am happy dropping inotifywait if unnecessary and confusing.

Thanks.
