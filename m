Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75F9438F234
	for <linux-ext4@vger.kernel.org>; Wed, 25 Mar 2026 09:58:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774432699; cv=none; b=tWvZfXoaY1Jluur4owBTLj3vQNjivzREuiwsZpzpnBKoICjTB/v4tVYJNWnepyEdqpOrSG/ocJTZeJW8UcpV6jUNis7f9cRRu0N0WOudumUZDiysbklPUfSrXpnSuE/s3IzLWMzhQa9JBzqi5RekRXdppddfWY+LzKqTlmznOsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774432699; c=relaxed/simple;
	bh=hzZ6/op2g3F67XFCQL6RSZD3FXfQqffbdJUyoXA3zbE=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=Wpu288V+NK2hRTH0k6LL/WghHtMkovbGXCzGb7CRVATl2CeZRzsH4y0fAXW4Rv+/Dv87YRyqCVcWKF9lFHnDh8pOACyqqunWJlR7KhuhamEKvYQMEcg4MT26dRTeNR6P/2I+aeT6pNJekdY+/jL/EU2XZG46A6bMqcLL5cR0QY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dilger.ca; spf=pass smtp.mailfrom=dilger.ca; dkim=pass (2048-bit key) header.d=dilger-ca.20230601.gappssmtp.com header.i=@dilger-ca.20230601.gappssmtp.com header.b=Nn7RVfFf; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dilger.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dilger.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dilger-ca.20230601.gappssmtp.com header.i=@dilger-ca.20230601.gappssmtp.com header.b="Nn7RVfFf"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2b0603ee486so15793245ad.0
        for <linux-ext4@vger.kernel.org>; Wed, 25 Mar 2026 02:58:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dilger-ca.20230601.gappssmtp.com; s=20230601; t=1774432697; x=1775037497; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6ySQX1bYaFtB+temqyqED5nWAImH+Dkzo6iJEBKw1nM=;
        b=Nn7RVfFfpSRwJgV3SExb1F3ofqEYfiYRpqMr3BcR+CLouv4kddzA9TCVJarD8d5MIb
         ZDSryj9n9hkkh74IARm0qN/pq1dfnZs8mD/wA3DSI8wNh/OovRZWLP3mMasUnhwU+gqP
         eUutkiSPZvBXDwBKULgHkrEZXa2ndxDo0CBGjFjWgr2ayjQsCa9RwyAo8HT2s1E2I7q2
         WD+UTdjP2zsRtOD4xfMAh6l6oGsfUm4ogoNloB8EY+rX4oDGsdWcho31CktyzktTs8Ob
         jvMNrv5e2PGACFJ/0z7rR2RFB1OEyEhJ8Lq5XuriT4ECxJlCUuldZGGIQNINTog1hg7T
         R4zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774432697; x=1775037497;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6ySQX1bYaFtB+temqyqED5nWAImH+Dkzo6iJEBKw1nM=;
        b=lDNTDjMHUsSx21pFBFfAju7K+nOsBF5NyTo2YXTAhHn1EQbLLcu4XcBmGWb31GRLbN
         rIuaJgDXtJ8q/m27s9/GsWa2tKBEuQ3qmoWkxgdjcjCGsXYwIUAYobZxD+slKlIWaA9S
         k1CLzAxRg8UiBKW9Jw4MPR+c40plrQD7+KMGIZPjjcN7yU6Bo4PZyX+OpiQqcoShejAI
         tTvy/DMiWt60dnouF3jcfVCzoud4TMku4u1fG3zxOg/LaNSlqAsv6YoQ/xQGD42OEIPd
         uSbkjRbiVhhdZv3gpYprj8swSFR0i9ys/sw9Xxs7YQFwrbbpkmxqVs5oY8llQLaXd7lZ
         5UYQ==
X-Forwarded-Encrypted: i=1; AJvYcCVCOk5jFqSVaW42imGyHdTCh4VgQ4gulYQFajb/+n94ikg5XXTKYAFrJHffo6BDjp9ltstnq/MwA47b@vger.kernel.org
X-Gm-Message-State: AOJu0YyGG994nMMWQ3EOUXbtu3pwd9P6lcfKaO9yu5GkJixkhzAh0GT1
	1AB25skLy2p7CjFnm+tw//GOvwv8ka96yemcRa/YDs1d5Qy1QZLv+xCD9Lc6JFLIDtQ=
X-Gm-Gg: ATEYQzwyATipZTVx4nI0Lksq/Vps0JIJ6uP/vN84WhhnoYvhdbefViUhr4qpiHdaMg4
	mWsCIcgy7zUR7WYdkk6zSlq185sjtx7IgSjJQhN1H5V41mYhFlxJmYx9rhnuNuVwyIXDJhRzZ1r
	b12nRDnXIRUia7e7WxSVaBoubWQ2DZCps4bNYB4gZOJs9jZI4BMT1IkAbwE7iX3cJJfwl5K31pl
	bqaGuEOm1OcBYd1cDO2vJrp9YURfo7rgDkBCGKkPWMG8DO6D2WNDiHzf4bQjsFg6EUv+EodLA3F
	lFFMB5DQVu7XzTV1xSnDb6LVf2AyXjdZKSH5KemOZs4HPMfJT9YqK9h2iSY6PKsH4kKmPEry/Fa
	VrSKHggwrJCfKtTdtV8ZkbL26FH9ggw3pbPTGscO+7yf8Stuopa85vOVHQWKmm5IpOgd5BBPPgM
	YzOSbT+Woxz4/g6lStuuTpwI5EvxSFziElvP2SpcUyQ9zljS+463WBpM7dUUpEeGklUyxe0jSL3
	bOjGg==
X-Received: by 2002:a17:902:e54d:b0:2b0:608d:d8a8 with SMTP id d9443c01a7336-2b0b09a0addmr31739585ad.1.1774432696787;
        Wed, 25 Mar 2026 02:58:16 -0700 (PDT)
Received: from smtpclient.apple (S01068c763f81ca4b.cg.shawcable.net. [70.77.200.158])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b08366c74dsm239318035ad.62.2026.03.25.02.58.15
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 25 Mar 2026 02:58:16 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.100.1.1.5\))
Subject: =?utf-8?Q?Re=3A_=5BRFC=5D_Proposal=3A_provenance=5Ftime_=28ptime?=
 =?utf-8?Q?=29_=E2=80=94_a_settable_timestamp_for_cross-filesystem_migrati?=
 =?utf-8?Q?on?=
From: Andreas Dilger <adilger@dilger.ca>
In-Reply-To: <CAOx6djP4hb-Cd1Zk07SNfFfLc8irjNmbVqq+58h1Whz+h1wSFA@mail.gmail.com>
Date: Wed, 25 Mar 2026 03:58:04 -0600
Cc: linux-fsdevel@vger.kernel.org,
 linux-ext4@vger.kernel.org,
 tytso@mit.edu,
 dsterba@suse.com,
 david@fromorbit.com,
 brauner@kernel.org,
 osandov@osandov.com
Content-Transfer-Encoding: 7bit
Message-Id: <A9DCEEDC-5F71-465C-A519-244853CF3069@dilger.ca>
References: <CAOx6djP4hb-Cd1Zk07SNfFfLc8irjNmbVqq+58h1Whz+h1wSFA@mail.gmail.com>
To: Sean Smith <defendthedisabled@gmail.com>
X-Mailer: Apple Mail (2.3864.100.1.1.5)

On Mar 24, 2026, at 22:26, Sean Smith <defendthedisabled@gmail.com> wrote:
> 
> [Email draft produced by AI agent. Reviewed, revised, and submitted by
> Sean Smith.]
> 
> Hello,
> 
> I am writing as a user whose work is directly harmed by the absence
> of a settable file creation timestamp in the Linux kernel. I am not a
> kernel developer, but I believe this use case may help inform the
> ongoing design discussion about btime semantics.

Implementing a new timestamp for every filesystem is unlikely to happen
any time soon.  Even if the implementation was finished tomorrow, it
would be many years before a large number of users were running those
kernels, and tools had been modified to process the extra timestamps.


A simple solution that would work today would be to write a script for
Windows that extracted the creation time from NTFS and saved it as an
xattr on each file like "user.ptime" before they are copied to Linux.

Many tools today handle backup/restore and copying of xattrs already,
and since the goal of "ptime" is that it stays the same across copies,
then copying the xattr preserves the correct semantics with low effort.

The xattrs can be written in ASCII ISO8601 format like "date +%Is" does,
"2026-03-25T03:43:21-06:00", so that it sorts properly and is easily parsed.
It would be easy to set this via normal command-line tools on Linux, like:

$ setfattr -n user.ptime -v $(date -Is --date=@$(stat -c %W FILE)) FILE
$ getfattr -d -m user.ptime FILE
# file: FILE
user.ptime="2013-10-11T13:46:10-06:00"

to extract the (local) birth time in seconds, convert to ISO8601 format
and store it in the "user.ptime" xattr where it will stay unchanged.

To expand this further, you might consider submitting patches to Windows
tools (where file creation time can be set) like 7zip, rclone, etc.) to
save and restore the "user.ptime" xattr from creation time automatically.
If a few popular tools start doing this, it is more likely others would
follow suit.

Cheers, Andreas


