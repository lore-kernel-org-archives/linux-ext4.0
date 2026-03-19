Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27CFF37F00D;
	Thu, 19 Mar 2026 16:08:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773936517; cv=none; b=QpPjCUIOpHzA0MNrOyJI9EuhSyYUM6kI8CgG3KpvFejD4uWiYLEKMO+ddRzl2zCyi29Ic/HWv7aUcCh79kzZmve7oPnVGBka11TozOIwQ+xK83Yn5jMQcmAtc/gZpPt9QmefSS91mJBuLbnH8XHhGasqgYnHrzZzBMYlHVGv/EY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773936517; c=relaxed/simple;
	bh=o1nEYWZwXDVFpFJjGoVPgZjhYgj+bC+THgG7j4SXdHc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NtbA0y079u+Xhabg+C+apWwB/54mVuOodIZFviI+xJe/r66q/XbiLfCX2n4Z0oB06dF1P4fd95+zg8+k1MfwDcX2zcaVv6cvto8f0i/vNB4nTm9PZlgrPhagr8Q2PK/o7ImIfEfsq85Q4Wm35aV5xuraPxMGxgqMUITD/swAJ04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JFDZ3iii; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JFDZ3iii"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9C7DC19425;
	Thu, 19 Mar 2026 16:08:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773936516;
	bh=o1nEYWZwXDVFpFJjGoVPgZjhYgj+bC+THgG7j4SXdHc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JFDZ3iiirFhuAYssDeT1wsoCsGsbSWhOs4QuenVfwYm0BMehruZ18OS8D5X8SJZOg
	 PJURSw4qEeCt+R1DDRwkaduIGmeArMDl4Csq+XnwCwatKjJ0LK06SjHhG04h4X8VYP
	 ULKdrslnBN8ZbxaTrFJGNGJjdfxh3U0NsM0csnL6jNjShFnZwlXnE8TKAhlWU14mxm
	 98LWzqEiC+37kL80BnB8NpXezUI4gi36e2xD4tYnmhtM4JWULzxbI7fMtw3LBLBIFL
	 rxP66FSYEqbjPn89qOH5VEziSCwmUUadJ/azNWyL6NYuqtqEfmc2sQgSb4oIKAmo3e
	 PAwlxmXoDY1IA==
Date: Thu, 19 Mar 2026 09:08:36 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Demi Marie Obenour <demiobenour@gmail.com>
Cc: Joanne Koong <joannelkoong@gmail.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, bpf@vger.kernel.org,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Bernd Schubert <bernd@bsbernd.com>, Theodore Ts'o <tytso@mit.edu>,
	Neal Gompa <neal@gompa.dev>, Amir Goldstein <amir73il@gmail.com>,
	Christian Brauner <brauner@kernel.org>,
	Jeff Layton <jlayton@kernel.org>, John@groves.net
Subject: Re: [PATCHBLIZZARD v7] fuse/libfuse/e2fsprogs: containerize ext4 for
 safer operation
Message-ID: <20260319160836.GC6004@frogsfrogsfrogs>
References: <20260223224617.GA2390314@frogsfrogsfrogs>
 <CAJnrk1Yd1J60-Ek=O7jzZQg454pbr3O=b71yZHzYbrWfqJr__w@mail.gmail.com>
 <20260316180408.GN6069@frogsfrogsfrogs>
 <CAJnrk1bmJYMt27xedN2Xza0KPXfYEbh-9g=3fNWru-HRM9WFEw@mail.gmail.com>
 <20260316234137.GJ1742010@frogsfrogsfrogs>
 <208bfbd2-d671-462c-925f-4d51b7df1f18@gmail.com>
 <20260318213129.GB6004@frogsfrogsfrogs>
 <c7866006-bd17-4fd8-a603-bd3016fdfeb0@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c7866006-bd17-4fd8-a603-bd3016fdfeb0@gmail.com>

On Thu, Mar 19, 2026 at 03:28:21AM -0400, Demi Marie Obenour wrote:
> On 3/18/26 17:31, Darrick J. Wong wrote:
> > On Mon, Mar 16, 2026 at 08:20:29PM -0400, Demi Marie Obenour wrote:
> >> On 3/16/26 19:41, Darrick J. Wong wrote:
> >>> On Mon, Mar 16, 2026 at 04:08:55PM -0700, Joanne Koong wrote:
> >>>> On Mon, Mar 16, 2026 at 11:04 AM Darrick J. Wong <djwong@kernel.org> wrote:
> >>>>>
> >>>>> On Mon, Mar 16, 2026 at 10:56:21AM -0700, Joanne Koong wrote:
> >>>>>> On Mon, Feb 23, 2026 at 2:46 PM Darrick J. Wong <djwong@kernel.org> wrote:
> >>>>>>>
> >>>>>>> There are some warts remaining:
> >>>>>>>
> >>>>>>> a. I would like to continue the discussion about how the design review
> >>>>>>>    of this code should be structured, and how might I go about creating
> >>>>>>>    new userspace filesystem servers -- lightweight new ones based off
> >>>>>>>    the existing userspace tools?  Or by merging lklfuse?
> >>>>>>
> >>>>>> What do you mean by "merging lklfuse"?
> >>>>>
> >>>>> Merging the lklfuse project into upstream Linux, which involves running
> >>>>> the whole kit and caboodle through our review process, and then fixing
> >>>>
> >>>> Gotcha, so it would basically be having to port this arch/lkl
> >>>> directory [1] into the linux tree
> >>>
> >>> Right.
> >>>
> >>>>> user-mode-linux to work anywhere other than x86.
> >>>>
> >>>> Are lklfuse and user-mode-linux (UML) two separate things or is
> >>>> lklfuse dependent on user-mode-linux?
> >>>
> >>> I was under the impression that lklfuse uses UML.  Given the weird
> >>> things in arch/lkl/Kconfig:
> >>>
> >>> config 64BIT
> >>> 	bool "64bit kernel"
> >>> 	default y if OUTPUT_FORMAT = "pe-x86-64"
> >>> 	default $(success,$(srctree)/arch/lkl/scripts/cc-objdump-file-format.sh|grep -q '^elf64-') if OUTPUT_FORMAT != "pe-x86-64"
> >>>
> >>> I was kinda guessing x86_64 was the primary target of the developers?
> >>>
> >>> /me notes that he's now looked into libguestfs per Demi Marie's comments
> >>> and some curiosity on the part of ngompa and i>
> >>>
> >>> Whatever it is that libguestfs does to stand up unprivileged fs mounts
> >>> also could fit this bill.  It's *really* slow to start because it takes
> >>> the booted kernel, creates a largeish initramfs, boots that combo via
> >>> libvirt, and then fires up a fuse server to talk to the vm kernel.
> >>>
> >>> I think all you'd have to do is change libguestfs to start the VM and
> >>> run the fuse server inside a systemd container instead of directly from
> >>> the CLI.
> >>
> >> The feedback I have gotten from ngompa is that libguestfs is just
> >> too slow for distros to use it to mount stuff.
> > 
> > Yes, libguestfs is /verrrry/ slow to start up.
> > 
> >>>>>> Could you explain what the limitations of lklfuse are compared to the
> >>>>>> fuse iomap approach in this patchset?
> >>>>>
> >>>>> The ones I know about are:
> >>>>>
> >>>>> 1> There's no support for vmapped kernel memory in UML mode, so anyone
> >>>>> who requires a large contiguous memory buffer cannot assemble them out
> >>>>> of "physical" pages.  This has been a stumbling block for XFS in the
> >>>>> past.
> >>>>>
> >>>>> 2> LKLFUSE still uses the classic fuse IO paths, which means that at
> >>>>> best you can directio the IO through the lklfuse kernel.  At worst you
> >>>>> have to use the pagecache inside the lklfuse kernel, which is very
> >>>>> wasteful.
> >>>>
> >>>> For the security / isolation use cases you've described, is
> >>>> near-native performance a hard requirement?
> >>>
> >>> Not a hard requirement, just a means to convince people that they can
> >>> choose containment without completely collapsing performance.
> >>>
> >>>> As I understand it, the main use cases of this will be for mounting
> >>>> untrusted disk images and CI/filesystem testing, or are there broader
> >>>> use cases beyond this?
> >>>
> >>> That covers nearly all of it.
> >>
> >> It's worth noting that on ChromeOS and Android, the only trusted
> >> disk images are those that are read-only and protected by dm-verity.
> >> *Every* writable image is considered untrusted.
> >>
> >> I don't know if doing a full fsck at each boot is considered
> >> acceptable, but I suspect it would slow boot far too much.
> > 
> > Not to mention that an attacker who gained control of the boot process
> > could inject malicious filesystem metadata after fsck completes
> > successfully but before the kernel mount occurs.
> > 
> >> Yes, Google ought to be paying for the kernel changes to fix this mess.
> >>
> >>>>> 3> lklfuse hasn't been updated since 6.6.
> >>>>
> >>>> Gotcha. So if I'm understanding it correctly, the pros/cons come down to:
> >>>> lklfuse pros:
> >>>> - (arguably) easier setup cost. once it's setup (assuming it's
> >>>> possible to add support for the vmapped kernel memory thing you
> >>>> mentioned above), it'll automatically work for every filesystem vs.
> >>>> having to implement a fuse-iomap server for every filesystem
> >>>
> >>> Or even a good non-iomap fuse server for every filesystem.  Admittedly
> >>> the weak part of fuse4fs is that libext2fs is not as robust as the
> >>> kernel is.
> >>>
> >>>> - easier to maintain vs. having to maintain each filesystem's
> >>>> userspace server implementation
> >>>
> >>> Yeah.
> >>>
> >>>> lklfuse cons:
> >>>> - worse (not sure by how much) performance
> >>>
> >>> Probably a lot, because now you have to run a full IO stack all the way
> >>> through lklfuse.
> >>
> >> How much is "a lot"?  Is it "this is only useful for non-interactive
> >> overnight backups", "you will notice this in benchmarks but it's okay
> >> for normal use", or somewhere in between?
> > 
> > Startup is painfully slow.  Normal operation isn't noticeably bad, but I
> > didn't bother doing any performance comparisons.
> > 
> >> Could lklfuse and iomap be combined?
> > 
> > Probably, though you'd have to find a way to route the FUSE_IOMAP_*
> > requests to a filesystem driver.  That's upside-down of the current
> > iomap model where filesystems have to opt into using iomap on a
> > per-IO-path basis, and then iomap calls the filesystem to find mappings.
> 
> If it does get done it would be awesome.  I don't think I'll be able to
> contribute, though.

I wonder if one could export a (pnfs) layout from the lklfuse kernel to
the real one, that's <cough> where struct iomap came from.  A huge
downside to that solution is that layouts don't support out of place
writes because pnfs doesn't support out of place writes.

> >>>> - once it's merged into the kernel, we can't choose to not
> >>>> maintain/support it in the future
> >>>
> >>> Correct.
> >>>
> >>>> Am I understanding this correctly?
> >>>>
> >>>> In my opinion, if near-native performance is not a hard requirement,
> >>>> it seems like less pain overall to go with lklfuse. lklfuse seems a
> >>>> lot easier to maintain and I'm not sure if some complexities like
> >>>> btrfs's copy-on-write could be handled properly with fuse-iomap.
> >>>
> >>> btrfs cow can be done with iomap, at least on the directio end.  It's
> >>> the other features like fsverity/fscrypt/data checksumming that aren't
> >>> currently supported by iomap.
> >>
> >> Pretty much everyone on btrfs uses data checksumming.
> >>
> >>>> What are your thoughts on this?
> >>>
> >>> "Gee, what if I could simplify most of my own work out of existence?"
> >>
> >> What is that work?
> > 
> > Everything I've put out since the end of online fsck for xfs.
> 
> Is pretty much all of that work either on better FUSE performance or
> fixes for problems found by fuzzers?

Mostly the iomap parts of fuse-iomap.  It's a huge complication to add
to the already confusing fuse codebase.

--D
