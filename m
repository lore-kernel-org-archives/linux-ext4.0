Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2C0D27AC4D;
	Tue, 10 Feb 2026 09:03:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=83.149.199.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770714221; cv=none; b=cAR0YJtF4isllZhCNpi+5hGD+H2NXf9upbSXhgCaq9b6is1K3elQD4SXSR6GbmZgUHIgPlLw/2RaJRP+VUJAmtAEWwCBT5DHqOzvFctx/POUzTZaHkQE17jb/6n5IYo3O5821CTrYKi2NxkIG829vzCwsqCMVeKL4aOeNDx6Arg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770714221; c=relaxed/simple;
	bh=Nng69iqAPw+o32S33yUBs45sHPkloSOPTy0Plxsl+GU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NOLBl3jnVCKyu4xbcz3jLC2DBO3NyYTk6PR8nUyT+0fzi1WLi5mXIvecBNsSKRghAc/TQQMj1utbEScr1FpsRhF3YQvg48exeAVgoH/Xu/iLyyN7K6eqaLtFtESe4rIwnGlByEOVY7qvJtuRd3yaNuT2krIoOdGL8ubhsHrDgLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ispras.ru; spf=pass smtp.mailfrom=ispras.ru; dkim=pass (1024-bit key) header.d=ispras.ru header.i=@ispras.ru header.b=KPoaIoMx; arc=none smtp.client-ip=83.149.199.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ispras.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ispras.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ispras.ru header.i=@ispras.ru header.b="KPoaIoMx"
Received: from localhost (unknown [79.139.249.127])
	by mail.ispras.ru (Postfix) with ESMTPSA id 0C943413A4D8;
	Tue, 10 Feb 2026 09:03:36 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.ispras.ru 0C943413A4D8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ispras.ru;
	s=default; t=1770714216;
	bh=AnkvOa2Gky14QzjdML5HzhN5tDlpfoHiOi44Pmq3hK4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KPoaIoMxpd6vXRjhP2OACAUGwFZBrofXtzHNd4bxVMINcrsPwtseRfUEj7ORqKVsF
	 t3KlUmdBhci+LL4puxpoNJ0um3QBn8y8ZFuExB0SPZgAlf3NlA+HZsGjqRshAJ5C8H
	 DG+XgSxWYL4I6POg98HyNce+uzoCyKwN+Zq57GNc=
Date: Tue, 10 Feb 2026 12:03:35 +0300
From: Fedor Pchelkin <pchelkin@ispras.ru>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Kees Cook <kees@kernel.org>, Theodore Ts'o <tytso@mit.edu>, 
	=?utf-8?B?5p2O6b6Z5YW0?= <coregee2000@gmail.com>, Andreas Dilger <adilger.kernel@dilger.ca>, 
	Andy Shevchenko <andriy.shevchenko@intel.com>, linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-hardening@vger.kernel.org, Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext4: Reject on-disk mount options with missing
 NUL-terminator
Message-ID: <20260210115731-8a60c77ca684b6684fb8955f-pchelkin@ispras>
References: <20260206212654.work.035-kees@kernel.org>
 <20260209193945-80d9bfc8aa82b0eb1b764c7f-pchelkin@ispras>
 <202602091148.EDBFECE686@keescook>
 <20260210050124.GR7686@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260210050124.GR7686@frogsfrogsfrogs>

On Mon, 09. Feb 21:01, Darrick J. Wong wrote:
> On Mon, Feb 09, 2026 at 12:00:36PM -0800, Kees Cook wrote:
> > Okay, great. I figure I can do two things:
> > 
> > 1) rework this patch with adjusted commit log to reflect the notes
> >    raised so far, so that we reject mounts that lack a NUL-terminated
> >    s_mount_opts (as silent truncation may induce an unintended option
> >    string, e.g. "...,journal_path=/dev/sda2" into "...,journal_path=/dev/sda"
> >    or something weird like that).
> > 
> > 2) Leave everything as-is, live with above corner case since it should
> >    be unreachable with userspace tooling as they have always existed.
> > 
> > I'm fine either way! :)
> 
> I'd pick #1, unless someone knows of a userspace program that could have
> set a 64-byte s_mount_ops string with no null terminator.  I didn't find
> any, but there are many implementations of ext4 out there. :/
> 
> (and yes, it's better to reject an unterminated s_mount_opts than
> accidentally point the kernel at the wrong block device)

If I understand the issue correctly, it's already being rejected with the
existing check:

	if (strscpy_pad(s_mount_opts, sbi->s_es->s_mount_opts) < 0)
		return -E2BIG;

If the source string is truncated at least by one symbol (which is the
case for unterminated string), strscpy_pad() returns -E2BIG and the mount
fails.
