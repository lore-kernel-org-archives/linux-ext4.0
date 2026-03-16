Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7990C374E5C
	for <linux-ext4@vger.kernel.org>; Mon, 16 Mar 2026 23:09:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773702549; cv=pass; b=dhxTB1qjJXWsG6DM2UY0GBfHWoCyAeCA0FSn5xxvZ2M/HIk8vr29tn2z2uNx231rphnjjngW5hbWPfFRlH7i1A6tL+GOLW8SWk2+ZwU7PHPXEjbO+rIuZpBXreN0tl3ws6uhubah5GxYf2AUwbRZWu8FUYC8tB0sMYQQOQs1n1M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773702549; c=relaxed/simple;
	bh=+cAJ4iIFIxRHig92sYo84qvhIaHp9W4lFkHVoCvc15Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UVjCvoRSzxxNDo+MHL/ZcvN1NOonSwstLbNqecdl33RIWcVFlREceHN5fT4qWtAJhp5Qddy8MvBPSDfvCfj5vhl1d8U/XWB2Q/m5HkJ3o6KFuc1bT6moptekEeJs8VKD16Ow2+Aua9Jzc2xNCTj16SfffJWMlVMrd1qWDQ1NNG4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=D6IntPEf; arc=pass smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="D6IntPEf"
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-43b47b95a77so869778f8f.0
        for <linux-ext4@vger.kernel.org>; Mon, 16 Mar 2026 16:09:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773702547; cv=none;
        d=google.com; s=arc-20240605;
        b=dqCvHgMz6CX0+e3jIYb00NMM5iBU6xl+/Hm71caCYQNPH6E+1N4cax9V+qoMmI1TgY
         0hdZN9sbJzNoWBcB3OBLmkkircGp2qoWaL9PSdNJ+Ez5ouHG9jom7oGNDMcfGeqPpsBB
         nsnzgZsyaNlcdqFVkcV1XssA7pjerLwg/wfa8BPlMOoJ4RP3Jx804IYBFKe1U02BQVrx
         hxMjOqAKsJSEI6cYVJPe1I9OAaZNzdCnSgWn2w0Owit5X74KljPdYlcNf4w5+MZXcGWX
         sZngL06HlnPPVmzK+kCGQVQ/RolnBF9JEAwpyfaUzauh1VD6NEnfTSHZhqkG1cN8omHl
         okLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=YTcEvH+GjDpjQFw+Gwl6J2Beep0t2E3u6sg9IRtiNzE=;
        fh=N9NJY8E1gN8ClfdeMbN6ak7o+zrr6MLkgkGTvsmkmfo=;
        b=CYhyPkj3x0Uv5H8hmmZtNJPPKGLrQbLvdwEb+Krx17J0cQjNrY7ov86E1jDDuu0xmB
         QZlGWXzsDUSxSP1ZpArtDilxfCJa1/cZsnoifLIbarvleuyoly85MHikhAQOFfgfZAM0
         nqxhdLuIX5lsY0OuXGzQ9NQlkwS4uqulka4KGa8Wld0U1IkPh+2A13GVuoo+x/3KFi1e
         3l8QyL3Xfh8aYwryqL3P8D6A4PSdrhPqJYvbmJBYkfsyDLVs4Zo1Hn+8tPCKHAxaXZyj
         qixTHFaYOuc+VEBxaKWCjBTK/5zZj1w888NuVzIMf1AdiSmN63OrzWwS4prRSAnO8X4K
         U5Dw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773702547; x=1774307347; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YTcEvH+GjDpjQFw+Gwl6J2Beep0t2E3u6sg9IRtiNzE=;
        b=D6IntPEfYTZg7kuSqNZ0xwoTJK/di7+wNmv9xTRAPJh5ttY158d3g3/AzB7k89M0UD
         skF+XyXEA6cLESYOW1zdWFQ17weizHtb5Gt5qDukO1DwPh3jyGt7eMU+QbqvginTkvFF
         R6Zp7n1uvzGcSSV385Z0RkxSRU5ReYA9DTbEBnyTkMtqcdveekmreDSIoJ5G0q3XA32v
         U8+2gVKFYZkxke14ocXHcYnVYSpzxP0N57boHVZ0B7z2jlHOmW7va+hBjXqfzkkuW4BF
         qWcfzP5fAK5BJR1zdz9KG+8vghwKFvnyHAGE4aNKdkv+lJSmFC84F/1o3ebPYt/0eHoo
         vGiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773702547; x=1774307347;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=YTcEvH+GjDpjQFw+Gwl6J2Beep0t2E3u6sg9IRtiNzE=;
        b=rdTk2XMwR2gmrVcN++eSZgHSm3G/uDVcAgx/Z2mV16SB/rptwQjXDITzx3meAFd5dh
         sErnWXX/npMUIA62dA57CwWwwJc22c3ZALx8y2Y+ceWnz6feT9RRrZoAfzSBBIFbvJRT
         nRR9E0MIlVms5NjKmO4ajuqpr1KHnyHzb5LnaR/NZmYnCzgJOS3UylYvA1i2JdvupZRe
         PYhLuUyWwha4D9DFsLtFN3mFYS77Oxtbon6WZWfV01I2SwtayEJu95UaMMP1JJYEzCuh
         p4XIfloPi4lMYlQ+h71vH8kWekircUKF4EH7czrHwMr3Mh960zSigmJPDfHSvUd65stM
         hP9Q==
X-Forwarded-Encrypted: i=1; AJvYcCVKQHhVvnNItgJ0OdEr8uFrM4JrF4slXWIvMM1y2K3UfRN6ysCJ/pBqh3FfTYYXNYIfwMuFeketOQBU@vger.kernel.org
X-Gm-Message-State: AOJu0Yy2oeq2vguNrEVnmT37vPj1VtV660TMQidDEoSi72C6ukhBW/Jb
	hPCWeXIBeTGEmtsTBd4Xs6TZ/Bd76B9CZIirwuf6UMrzIOhuZBDySx5HPe3JW5WR+TFVmlHKfVc
	MNVoyXV+Fnfs3ryPvgs3sh8ZaGuG5BDI=
X-Gm-Gg: ATEYQzwbpmfu6Xlf8M3h4rNOHkyj+qfWUJKiwOKTAzaqjGEC4HqmvLoqoa0ti8e4KTM
	mGCEigEyC+MhnGJ15BU6PZhqLBrckcEePoWaZmswF2F4K94M/57o2sCgLpbLgJplpJ4kS3PGsMn
	+yvWkG9bvXT7dU+twi1K70Bk3Zm6WN8Hz2UAPK83lO5B/rJJVRojHdaUW6QDy3m0wBP9AXYmzXk
	9PGUrtkNhldXFCPAA1AzWk+4VKKvdRU8PH8G6jOlbp7obiOFgQ3708joDAD3RZMnL5LPk8O+4Wy
	6smTQA==
X-Received: by 2002:a5d:5f83:0:b0:439:b8b2:fad0 with SMTP id
 ffacd0b85a97d-43a04d83ff6mr28400817f8f.5.1773702546587; Mon, 16 Mar 2026
 16:09:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260223224617.GA2390314@frogsfrogsfrogs> <CAJnrk1Yd1J60-Ek=O7jzZQg454pbr3O=b71yZHzYbrWfqJr__w@mail.gmail.com>
 <20260316180408.GN6069@frogsfrogsfrogs>
In-Reply-To: <20260316180408.GN6069@frogsfrogsfrogs>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Mon, 16 Mar 2026 16:08:55 -0700
X-Gm-Features: AaiRm53xx1udDBBozm1YmDs3kuURdsgNVNQ8IfBAmck4rGWxaKobRoPlK5vEPvg
Message-ID: <CAJnrk1bmJYMt27xedN2Xza0KPXfYEbh-9g=3fNWru-HRM9WFEw@mail.gmail.com>
Subject: Re: [PATCHBLIZZARD v7] fuse/libfuse/e2fsprogs: containerize ext4 for
 safer operation
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, bpf@vger.kernel.org, 
	linux-ext4 <linux-ext4@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, 
	Bernd Schubert <bernd@bsbernd.com>, "Theodore Ts'o" <tytso@mit.edu>, Neal Gompa <neal@gompa.dev>, 
	Amir Goldstein <amir73il@gmail.com>, Christian Brauner <brauner@kernel.org>, 
	Jeff Layton <jlayton@kernel.org>, John@groves.net, demiobenour@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 16, 2026 at 11:04=E2=80=AFAM Darrick J. Wong <djwong@kernel.org=
> wrote:
>
> On Mon, Mar 16, 2026 at 10:56:21AM -0700, Joanne Koong wrote:
> > On Mon, Feb 23, 2026 at 2:46=E2=80=AFPM Darrick J. Wong <djwong@kernel.=
org> wrote:
> > >
> > > There are some warts remaining:
> > >
> > > a. I would like to continue the discussion about how the design revie=
w
> > >    of this code should be structured, and how might I go about creati=
ng
> > >    new userspace filesystem servers -- lightweight new ones based off
> > >    the existing userspace tools?  Or by merging lklfuse?
> >
> > What do you mean by "merging lklfuse"?
>
> Merging the lklfuse project into upstream Linux, which involves running
> the whole kit and caboodle through our review process, and then fixing

Gotcha, so it would basically be having to port this arch/lkl
directory [1] into the linux tree

> user-mode-linux to work anywhere other than x86.

Are lklfuse and user-mode-linux (UML) two separate things or is
lklfuse dependent on user-mode-linux?

>
> > Could you explain what the limitations of lklfuse are compared to the
> > fuse iomap approach in this patchset?
>
> The ones I know about are:
>
> 1> There's no support for vmapped kernel memory in UML mode, so anyone
> who requires a large contiguous memory buffer cannot assemble them out
> of "physical" pages.  This has been a stumbling block for XFS in the
> past.
>
> 2> LKLFUSE still uses the classic fuse IO paths, which means that at
> best you can directio the IO through the lklfuse kernel.  At worst you
> have to use the pagecache inside the lklfuse kernel, which is very
> wasteful.

For the security / isolation use cases you've described, is
near-native performance a hard requirement? As I understand it, the
main use cases of this will be for mounting untrusted disk images and
CI/filesystem testing, or are there broader use cases beyond this?

>
> 3> lklfuse hasn't been updated since 6.6.

Gotcha. So if I'm understanding it correctly, the pros/cons come down to:
lklfuse pros:
- (arguably) easier setup cost. once it's setup (assuming it's
possible to add support for the vmapped kernel memory thing you
mentioned above), it'll automatically work for every filesystem vs.
having to implement a fuse-iomap server for every filesystem
- easier to maintain vs. having to maintain each filesystem's
userspace server implementation

lklfuse cons:
- worse (not sure by how much) performance
- once it's merged into the kernel, we can't choose to not
maintain/support it in the future

Am I understanding this correctly?

In my opinion, if near-native performance is not a hard requirement,
it seems like less pain overall to go with lklfuse. lklfuse seems a
lot easier to maintain and I'm not sure if some complexities like
btrfs's copy-on-write could be handled properly with fuse-iomap.

What are your thoughts on this?

Thanks,
Joanne

[1] https://github.com/lkl/linux/tree/master/arch/lkl

>
> --D
>
> > Thanks,
> > Joanne
> >
> > >
> > > b. ext4 doesn't support out of place writes so I don't know if that
> > >    actually works correctly.
> > >
> > > c. fuse2fs doesn't support the ext4 journal.  Urk.
> > >
> > > d. There's a VERY large quantity of fuse2fs improvements that need to=
 be
> > >    applied before we get to the fuse-iomap parts.  I'm not sending th=
ese
> > >    (or the fstests changes) to keep the size of the patchbomb at
> > >    "unreasonably large". :P  As a result, the fstests and e2fsprogs
> > >    postings are very targeted.
> > >
> > > e. I've dropped the fstests part of the patchbomb because v6 was just
> > >    way too long.
> > >
> > > I would like to get the main parts of this submission reviewed for 7.=
1
> > > now that this has been collecting comments and tweaks in non-rfc stat=
us
> > > for 3.5 months.
> > >
> > > Kernel:
> > > https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git/=
log/?h=3Dfuse-iomap-bpf
> > >
> > > libfuse:
> > > https://git.kernel.org/pub/scm/linux/kernel/git/djwong/libfuse.git/lo=
g/?h=3Dfuse-iomap-bpf
> > >
> > > e2fsprogs:
> > > https://git.kernel.org/pub/scm/linux/kernel/git/djwong/e2fsprogs.git/=
log/?h=3Dfuse-iomap-bpf
> > >
> > > fstests:
> > > https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfstests-dev.g=
it/log/?h=3Dfuse2fs
> > >
> > > --Darrick
