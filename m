Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 389031DFD96;
	Mon, 16 Mar 2026 23:41:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773704498; cv=none; b=nWUkDXUGrZUUpi/PtvatTNi52X/5pjDKBR+/HgNR+1DAwQoQTnuVue+GAt4Otnz0Av2hXFhPANkFbTHuZbZehKKEMaWhFHCExZsRqGhBIVu1xmZW7XGbWhBxW55dczmcss76okw13Ge2DRJp885iMIOI9kQWpzaMzAx13IZuxxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773704498; c=relaxed/simple;
	bh=9uiCqGnbSqPhfoTIaiNM8CkxTkZTnOzNiroU99fnTHg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OjP0wFlOxfbu2RR4NgA2Vrd0AFILu/JFvwQmwBHT0ocTtcX0UWzNL+T8HQdOyo2yXyLoAze7niFQyfk1vqcSXSOW9WNfZstHmEp/Gd1X4t7ff82nAeTyVLv3Sxo4xFdUSKoJ2/lN6XelrnwG6X+4jiGW2Yqgmu4liQ+KPaqkH1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=vMU/P+0X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vMU/P+0X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5DB6C19421;
	Mon, 16 Mar 2026 23:41:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773704497;
	bh=9uiCqGnbSqPhfoTIaiNM8CkxTkZTnOzNiroU99fnTHg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=vMU/P+0XDhwKJNIs9JwFJjfbd02zAfOiY/euOT51RHRJQFX9kY8Sodn9/mvrgCHLY
	 apdQXaqfpZ8/xrlQ9r2aR4kqpLZv5akKx5AE8MNVB76avA4Oz3ENj8eSlO0Jdkv4I3
	 dRcTl5mHe7zw6y5wIAwgBJl7xswgVzeMwFD1Fw+rnQbriERonbJWZZYgJq9Wo9zfwc
	 I0n8vWJSvjURubx99DSoE/hOVyx6d30zv3bR4HPjSgy2RapgoD2cRHZoj9mHJAYQDi
	 MCyZDJes+05OAoGxEcrbzdNi1aLUSp9TS9CwDuLWDYo7ex+KhtbEN1DGneKSvvW0tA
	 0bt6EeWkDtlaQ==
Date: Mon, 16 Mar 2026 16:41:37 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, bpf@vger.kernel.org,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Bernd Schubert <bernd@bsbernd.com>, Theodore Ts'o <tytso@mit.edu>,
	Neal Gompa <neal@gompa.dev>, Amir Goldstein <amir73il@gmail.com>,
	Christian Brauner <brauner@kernel.org>,
	Jeff Layton <jlayton@kernel.org>, John@groves.net,
	demiobenour@gmail.com
Subject: Re: [PATCHBLIZZARD v7] fuse/libfuse/e2fsprogs: containerize ext4 for
 safer operation
Message-ID: <20260316234137.GJ1742010@frogsfrogsfrogs>
References: <20260223224617.GA2390314@frogsfrogsfrogs>
 <CAJnrk1Yd1J60-Ek=O7jzZQg454pbr3O=b71yZHzYbrWfqJr__w@mail.gmail.com>
 <20260316180408.GN6069@frogsfrogsfrogs>
 <CAJnrk1bmJYMt27xedN2Xza0KPXfYEbh-9g=3fNWru-HRM9WFEw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJnrk1bmJYMt27xedN2Xza0KPXfYEbh-9g=3fNWru-HRM9WFEw@mail.gmail.com>

On Mon, Mar 16, 2026 at 04:08:55PM -0700, Joanne Koong wrote:
> On Mon, Mar 16, 2026 at 11:04 AM Darrick J. Wong <djwong@kernel.org> wrote:
> >
> > On Mon, Mar 16, 2026 at 10:56:21AM -0700, Joanne Koong wrote:
> > > On Mon, Feb 23, 2026 at 2:46 PM Darrick J. Wong <djwong@kernel.org> wrote:
> > > >
> > > > There are some warts remaining:
> > > >
> > > > a. I would like to continue the discussion about how the design review
> > > >    of this code should be structured, and how might I go about creating
> > > >    new userspace filesystem servers -- lightweight new ones based off
> > > >    the existing userspace tools?  Or by merging lklfuse?
> > >
> > > What do you mean by "merging lklfuse"?
> >
> > Merging the lklfuse project into upstream Linux, which involves running
> > the whole kit and caboodle through our review process, and then fixing
> 
> Gotcha, so it would basically be having to port this arch/lkl
> directory [1] into the linux tree

Right.

> > user-mode-linux to work anywhere other than x86.
> 
> Are lklfuse and user-mode-linux (UML) two separate things or is
> lklfuse dependent on user-mode-linux?

I was under the impression that lklfuse uses UML.  Given the weird
things in arch/lkl/Kconfig:

config 64BIT
	bool "64bit kernel"
	default y if OUTPUT_FORMAT = "pe-x86-64"
	default $(success,$(srctree)/arch/lkl/scripts/cc-objdump-file-format.sh|grep -q '^elf64-') if OUTPUT_FORMAT != "pe-x86-64"

I was kinda guessing x86_64 was the primary target of the developers?

/me notes that he's now looked into libguestfs per Demi Marie's comments
and some curiosity on the part of ngompa and i>

Whatever it is that libguestfs does to stand up unprivileged fs mounts
also could fit this bill.  It's *really* slow to start because it takes
the booted kernel, creates a largeish initramfs, boots that combo via
libvirt, and then fires up a fuse server to talk to the vm kernel.

I think all you'd have to do is change libguestfs to start the VM and
run the fuse server inside a systemd container instead of directly from
the CLI.

> > > Could you explain what the limitations of lklfuse are compared to the
> > > fuse iomap approach in this patchset?
> >
> > The ones I know about are:
> >
> > 1> There's no support for vmapped kernel memory in UML mode, so anyone
> > who requires a large contiguous memory buffer cannot assemble them out
> > of "physical" pages.  This has been a stumbling block for XFS in the
> > past.
> >
> > 2> LKLFUSE still uses the classic fuse IO paths, which means that at
> > best you can directio the IO through the lklfuse kernel.  At worst you
> > have to use the pagecache inside the lklfuse kernel, which is very
> > wasteful.
> 
> For the security / isolation use cases you've described, is
> near-native performance a hard requirement?

Not a hard requirement, just a means to convince people that they can
choose containment without completely collapsing performance.

> As I understand it, the main use cases of this will be for mounting
> untrusted disk images and CI/filesystem testing, or are there broader
> use cases beyond this?

That covers nearly all of it.

> >
> > 3> lklfuse hasn't been updated since 6.6.
> 
> Gotcha. So if I'm understanding it correctly, the pros/cons come down to:
> lklfuse pros:
> - (arguably) easier setup cost. once it's setup (assuming it's
> possible to add support for the vmapped kernel memory thing you
> mentioned above), it'll automatically work for every filesystem vs.
> having to implement a fuse-iomap server for every filesystem

Or even a good non-iomap fuse server for every filesystem.  Admittedly
the weak part of fuse4fs is that libext2fs is not as robust as the
kernel is.

> - easier to maintain vs. having to maintain each filesystem's
> userspace server implementation

Yeah.

> lklfuse cons:
> - worse (not sure by how much) performance

Probably a lot, because now you have to run a full IO stack all the way
through lklfuse.

> - once it's merged into the kernel, we can't choose to not
> maintain/support it in the future

Correct.

> Am I understanding this correctly?
> 
> In my opinion, if near-native performance is not a hard requirement,
> it seems like less pain overall to go with lklfuse. lklfuse seems a
> lot easier to maintain and I'm not sure if some complexities like
> btrfs's copy-on-write could be handled properly with fuse-iomap.

btrfs cow can be done with iomap, at least on the directio end.  It's
the other features like fsverity/fscrypt/data checksumming that aren't
currently supported by iomap.

> What are your thoughts on this?

"Gee, what if I could simplify most of my own work out of existence?"

--D

> Thanks,
> Joanne
> 
> [1] https://github.com/lkl/linux/tree/master/arch/lkl
> 
> >
> > --D
> >
> > > Thanks,
> > > Joanne
> > >
> > > >
> > > > b. ext4 doesn't support out of place writes so I don't know if that
> > > >    actually works correctly.
> > > >
> > > > c. fuse2fs doesn't support the ext4 journal.  Urk.
> > > >
> > > > d. There's a VERY large quantity of fuse2fs improvements that need to be
> > > >    applied before we get to the fuse-iomap parts.  I'm not sending these
> > > >    (or the fstests changes) to keep the size of the patchbomb at
> > > >    "unreasonably large". :P  As a result, the fstests and e2fsprogs
> > > >    postings are very targeted.
> > > >
> > > > e. I've dropped the fstests part of the patchbomb because v6 was just
> > > >    way too long.
> > > >
> > > > I would like to get the main parts of this submission reviewed for 7.1
> > > > now that this has been collecting comments and tweaks in non-rfc status
> > > > for 3.5 months.
> > > >
> > > > Kernel:
> > > > https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git/log/?h=fuse-iomap-bpf
> > > >
> > > > libfuse:
> > > > https://git.kernel.org/pub/scm/linux/kernel/git/djwong/libfuse.git/log/?h=fuse-iomap-bpf
> > > >
> > > > e2fsprogs:
> > > > https://git.kernel.org/pub/scm/linux/kernel/git/djwong/e2fsprogs.git/log/?h=fuse-iomap-bpf
> > > >
> > > > fstests:
> > > > https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfstests-dev.git/log/?h=fuse2fs
> > > >
> > > > --Darrick
> 
