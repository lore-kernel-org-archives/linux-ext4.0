Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B3623D8120
	for <linux-ext4@vger.kernel.org>; Thu, 23 Apr 2026 08:44:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776933895; cv=pass; b=VLACj0cSyHeQyFMpmHuhEo4jUu4pybJlX39snKXfY8c7agHaFycNNrn53MV8fZDgOlxpatIDTgx2YwNYuvyyt0LJgSKvm27bQFfoR9nN2hFyRZ0Z+gt9GZK7Z9XEJy0WjSHPg6ZYf/D5IMiatlSorcGmM9+F/VnKay0jxmX/trc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776933895; c=relaxed/simple;
	bh=BkHQvLayOxx925RpqmFBcGRh5pDK2pwDTGlSpcMw9yw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YuzDKgeyqjWeuoeKTmZnH+wNMtrfzMLdOBtFTQcrjk+p0V54sHGTHhZCwBQmE/dFBVCBUa49liCywW1me3foQXSrvVyNl7+dtjDbidfGdZzGtaF6ryK+X/++oo0MkWCPLcUxKAmO90/wMqdA8oBRp3JRA/T8PInJPBO+aCWcQIw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hlOQbGCM; arc=pass smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hlOQbGCM"
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-676e62faf2bso3317547a12.1
        for <linux-ext4@vger.kernel.org>; Thu, 23 Apr 2026 01:44:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776933893; cv=none;
        d=google.com; s=arc-20240605;
        b=ZDwWi+TtWV2JKVX5rUsJvtIHryd4Qm+D40wYFnL313o76bkQ25Vs80fxLjwbCllAB2
         K9gp1aM8JunjjgRTMJiPhJMqO5GUHlveDiCxPQ1AXo7rSW8/X5VwDqEuE+2mKtITtBql
         59HZSLPzsaMNKp5U6YhOkbgzBdQCTFaKKl4AnIfifUYfYJwRQJdmyRMiIxHnNC9cymj/
         IJVOVLiKXUZBZTLj0NwGJgqRGEuJ4FFDMBDlnoHbZVQdCU1aFORYnmqjuPwnqZZHI4F9
         06CDz+3rlqsMXz2bgJILtpOpekgBASq8sIiL2lrPA4l40D+iqdzDRKct4QoEs15msM1l
         mq4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=cr2DxCftNoLGV0XgJFquO+Wug9SkaXdAg2c0Mitnj8A=;
        fh=t00VtV74mgPtu15sCkCSnxgVg/2XYefBkosAxFzJg5s=;
        b=PVKuiJ5rk+XlhPkdfebKBL7LZx4uZLe6mYIKkVyKuSd9umxlu1aKz84mXjrf2C98p+
         mS5w5TO6Hd0wTaQbZzssMZtVLzuOwlYcNpOhU8rcl8+9iiwd26KPnmVBZvw8P3j6fX/l
         hp9/RnEsaKvfsT3gzC4xFLbi8Gbb1xjfzvG+yHNmMvG3CAbQnaUKuAIddghs9PBNZ0u3
         Q2lbgfRy/a2ZONbmxOUGAjv4wG7Rp+wg3JUtNbuXH2rCdX5HkKEcShOLhoHjx+aPqXNQ
         dWVxBQQ6BtlmOxF3DQV6ZUVDvP/76hVohXA5jzLftgUfG8eysMvcMCkuQiCSaRWgR1s3
         +O+w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776933893; x=1777538693; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cr2DxCftNoLGV0XgJFquO+Wug9SkaXdAg2c0Mitnj8A=;
        b=hlOQbGCMn+QoYeswiujVFHFNxherkFoV2OI6z3ErU+dyNVljXc5OB/Q5OA09qEJJGj
         HshcQz3IZAcJSBeviFPR9cDn8RnobdIwjb4FmQCL9/BTN+kkwBdCcb7T7RWdl2GW0S8S
         qEkMiXcleMxu6kiz/9X26qzrldgFJ5V+vMjjjR3NunMsyoytAdB+NJa4CxKpvwgOo3Fp
         B4VSOLr4xXeVxGE8SllRSqteW36TArkpOEk5IWacy7HGWxldWLazH0wT3OvMPf3lGkPp
         UjjHc5FaJfz4yy7JMrvtwSn2FZzXtiBKvYVcoIoDg/yvcRm2QAIUN+z7lk0l4NCLXQzc
         BUdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776933893; x=1777538693;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=cr2DxCftNoLGV0XgJFquO+Wug9SkaXdAg2c0Mitnj8A=;
        b=o9q11TVjwiGuU3JW/6SB0fPipmwfhnNVmLKpru5TRBu+oyGk2EpaDME6wqSfaK0efu
         WdMlI6cc+I7yAB1p4NHme4Xfdy11nKsKXGyU74jQha5nmmZPmKMFtwAxcczhtOZmkVaj
         3qLOUVQElQTVHzyWar9ltoTsNGwsfW6Sxga924njnVA0QoKvUlE8E0OphWES7/xG4k5t
         C9y0DhFvvqiIdvMEkWiox+wNSRUloSBgNy/9J7yg+yGO0wjKeaEr7drZhmdQ4Lc26/FE
         1zSyPqO6wOBdkk6oziRzTb5D3uRSoT61vLbbpXZfG/fw7SHET68sdSFzBJ+mdDSziHvP
         qYEw==
X-Forwarded-Encrypted: i=1; AFNElJ8dbsIIb6rQbO1PUnKr9SMzG59kCbwchdyVx80FEE/YMQYT8UB7D08x67Dch0UkC86FEH4e7NTcWREQ@vger.kernel.org
X-Gm-Message-State: AOJu0YwdTND0FYAO1qsr31tEfVtlEXCG2pFQR0nXxZfFaC6/hjtO5KpT
	jP1hfgr6kE4xH/5AEJFX9RW4MEHruqynSkjWcrurxgOBpJWl+zD/8e8+mJhkVtH/1TTnxAJgcdW
	3Z2HLBMelH4+C+CF8rvoeuM1lBNWI3Tk=
X-Gm-Gg: AeBDieuXdDrgEbpvE4lolW5Q3P7Qr1IrLiWOJrh+5/2lZrj11AcOd9tl9rMLK0eE+oE
	4k1escicqcCRHkEYIEbzAO09EHaZOrjvQ8ytggtP5lML6etSLhRnFF5Tv74dhsf+1gG5W7vt2bL
	aHD5YqQZ/aYa/+YWMj+lLCXrbUlspyBIqZ9xNL1VJtupweICTDvBuyKh4QD+DdAagCJ6MfYZyN7
	SpMkIDmbzbCYvRog6cdnFzrPENOIna5VySuEZcoC6EjDKcRDrBeEpa8pHuzKvxT/L+9VwEq+DVm
	SeCe855zOW15cHjjXBJKHLQej3V/9RBWrd/aK0Bz88Q7dJsAxtZ8
X-Received: by 2002:a17:907:970a:b0:ba7:9885:b56e with SMTP id
 a640c23a62f3a-ba79885ba4amr816855366b.20.1776933882752; Thu, 23 Apr 2026
 01:44:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260422231518.GA7717@frogsfrogsfrogs>
In-Reply-To: <20260422231518.GA7717@frogsfrogsfrogs>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 23 Apr 2026 10:44:31 +0200
X-Gm-Features: AQROBzDxnRHLctVJUca6bIp8OO4TE6wlUznX6wKwx0EA_yNWOAIcr1mgvh7h0ws
Message-ID: <CAOQ4uxhEmbFWuM80F+Tq7TbDWjrL-znkwu=O=P7Ng2P5dksXsg@mail.gmail.com>
Subject: Re: [PATCHBOMB v5] fuse/libfuse/e2fsprogs/etc: containerize ext4 for
 safer operation
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>, 
	fuse-devel <fuse-devel@lists.linux.dev>, Miklos Szeredi <miklos@szeredi.hu>, 
	Bernd Schubert <bernd@bsbernd.com>, Joanne Koong <joannelkoong@gmail.com>, 
	"Theodore Ts'o" <tytso@mit.edu>, Neal Gompa <neal@gompa.dev>, Christian Brauner <brauner@kernel.org>, 
	demiobenour@gmail.com, Naoki MATSUMOTO <m.naoki9911@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 23, 2026 at 1:15=E2=80=AFAM Darrick J. Wong <djwong@kernel.org>=
 wrote:
>
> Hi everyone,
>
> This *would have been* the eight public draft of the gigantic patchset
> to connect the Linux fuse driver to fs-iomap for regular file IO
> operations to and from files whose contents persist to locally attached
> storage devices.
>
> However, the previous submission was too large, and I didn't even send
> half the patches!  I have therefore split the work into two sections.
> This first section covers setting up fuse servers to run as contained
> systemd services; I previously sent only the libfuse changes, without
> any of the surrounding pieces.  Now I'm ready to send them all.
>
> To summarize this patchbomb: fuse servers can now run as non-root users,
> with no privilege, no access to the network or hardware, etc.  The only
> connection to the outside is an ephemeral AF_UNIX socket.  The process
> on the other end is a helper program that acquires resources and calls
> fsmount().
>
> Why would you want to do that?  Most filesystem drivers are seriously
> vulnerable to metadata parsing attacks, as syzbot has shown repeatedly
> over almost a decade of its existence.  Faulty code can lead to total
> kernel compromise, and I think there's a very strong incentive to move
> all that parsing out to userspace where we can containerize the fuse
> server process.  Runtime filesystem metadata parsing is no longer a
> privileged (=3D=3D risky) operation.
>
> The consequences of a crashed driver is a dead mount, instead of a
> crashed or corrupt OS kernel.
>
> Note that contained fuse filesystem servers are no faster than regular
> fuse.  The redesign of the fuse IO path via iomap will be the subject of
> the second patchbomb.  The containerization code only requires changes
> to libfuse and is ready to go today.
>
> Since the seventh submission, I have made the following changes:
>
> 1) Added a couple of simple fuse service drivers to the example code
>
> 2) Adapted fuservicemount to be runnable as a setuid program so that
> unprivileged users can start up a containerized filesystem driver
>
> 3) Fixed some endianness handling errors in the socket protocol between
> the new mount helper and the fuse server
>
> 4) Added a high level fuse_main function so that fuse servers that use
> the high level api can containerize without a total rewrite
>
> 5) Adapted mount.fuse to call the new mount helper code so that mount -t
> fuse.XXX can try to start up a contained server
>
> 6) Cleaned up a lot of cppcheck complaints and refactored a bunch of
> repetitious code
>
> 7) Started using codex to try to find bugs and security problems with
> the new mount helper
>
> There are a few unanswered questions:
>
> a. How to integrate with the SYNC_INIT patches that Bernd is working on
> merging into libfuse
>
> b. If /any/ of the new fsopen/fsconfig/fsmount/move_mount calls fail,
> do we fall back to the old mount syscall?  Even after printing errors?
>
> c. Are there any Linux systems where some inetd implementation can
> actually handle AF_UNIX sockets?  Does it make sense to try to do the
> service isolation without the convenience of systemd directives?

A large part of the world is running container workloads on kubernetes
and my understanding is that k8s does not mix well with systemd.

We have successfully used the fusetmount3-proxy [1] approach by Naoki
MATSUMOTO as a way for unprivileged containers to delegate fuse mount
by a (non-systemd) service, running in another container.

[1] https://github.com/pfnet-research/meta-fuse-csi-plugin#fusermount3-prox=
y-modified-fusermount3-approach

The README says that sshfs, s3fs and other high profile fuse fs have been
tested with this approach and they do not require any rebuild.

So it bears the question...

>
> d. meson/autoconf/cmake are a pain to deal with, hopefully the changes I
> made are correct
>
> I have also converted a handful more fuse servers (fat, exfat, iso,
> http) to the new service architecture so that I can run a (virtual)
> Debian system with EFI completely off of containerized fuse servers.
> These will be sent at the end.
>

... what is the added value of rebuilding those packages with systemd
service support?

I am not implying that there is no added value, I just am not well versed
in the world of container and system services.

Thanks,
Amir.
