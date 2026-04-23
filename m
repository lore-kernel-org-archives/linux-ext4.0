Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B969225788;
	Thu, 23 Apr 2026 14:50:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776955827; cv=none; b=BnVMGjvNl3HCTfVkeKTp3/yHYXAHiPRw97FIY4SLVhVHXjzN5mY2udd7+N1zWTBU8OwkyLS5SrSw2/mzpYz6VyjdzyKKLFLbiqkaGZj+kaE59HN+jFT/npkRqJUXPx1j/AGa20PAk7bF0iHqEaSNc4QNOdNxeram7l5P/lktYQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776955827; c=relaxed/simple;
	bh=jswnJoKDx4tKl10WGUL7n0/MeD2pRoH+k6W0/ZeuDy8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uvLdL3K+vKNzrWt8P9cAOXcUYBwfsJtw87QSO78PhqvbVVQJ3dbNFLNXHhGVyhdk9XtXe9DlhrO/z1wxHciSQS1g/JCmrE4g+acDoTh5j29wOIFIrxnT0uZ3GGcPzpPCFbto38JkLQsQrsbKKSl0jDHZ2PobaA5xZl3Aj6JJHaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WjfX0RgA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WjfX0RgA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3424C2BCAF;
	Thu, 23 Apr 2026 14:50:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776955826;
	bh=jswnJoKDx4tKl10WGUL7n0/MeD2pRoH+k6W0/ZeuDy8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WjfX0RgAVAkp+sbfTbdOVkzIbkAUH6vHobudqqXIOdlH0RBSqHKeaXSlk/QbqljyH
	 1YaNI9zE+iaNbwqR1AZUtX5ay/2Yp/7Ge5qfBsO47A34l3K3T+CI55qLAWqcZQWPB3
	 tXD80zFwIU/Y4zssNgYbKGUI8gKg4nm5xULF2yAs91xJLaEA9Z3xAH+m5zfRlSeFgu
	 3lwvHlHhGBs/bBkANZj5E9RK0N3zG3bdeyYJhvyFn/UFM/vTflZTe/5HPaR7v7PtkR
	 9EaOgOlmzvCfG3f9WdmgtaGPLBcrqFae3u5tym3MJHg0L+H3KyCMMOe8S4mhbFHYD1
	 /Fa6u7perzgtA==
Date: Thu, 23 Apr 2026 07:50:26 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Amir Goldstein <amir73il@gmail.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	fuse-devel <fuse-devel@lists.linux.dev>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Bernd Schubert <bernd@bsbernd.com>,
	Joanne Koong <joannelkoong@gmail.com>,
	Theodore Ts'o <tytso@mit.edu>, Neal Gompa <neal@gompa.dev>,
	Christian Brauner <brauner@kernel.org>, demiobenour@gmail.com,
	Naoki MATSUMOTO <m.naoki9911@gmail.com>
Subject: Re: [PATCHBOMB v5] fuse/libfuse/e2fsprogs/etc: containerize ext4 for
 safer operation
Message-ID: <20260423145026.GC3778109@frogsfrogsfrogs>
References: <20260422231518.GA7717@frogsfrogsfrogs>
 <CAOQ4uxhEmbFWuM80F+Tq7TbDWjrL-znkwu=O=P7Ng2P5dksXsg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOQ4uxhEmbFWuM80F+Tq7TbDWjrL-znkwu=O=P7Ng2P5dksXsg@mail.gmail.com>

On Thu, Apr 23, 2026 at 10:44:31AM +0200, Amir Goldstein wrote:
> On Thu, Apr 23, 2026 at 1:15 AM Darrick J. Wong <djwong@kernel.org> wrote:
> >
> > Hi everyone,
> >
> > This *would have been* the eight public draft of the gigantic patchset
> > to connect the Linux fuse driver to fs-iomap for regular file IO
> > operations to and from files whose contents persist to locally attached
> > storage devices.
> >
> > However, the previous submission was too large, and I didn't even send
> > half the patches!  I have therefore split the work into two sections.
> > This first section covers setting up fuse servers to run as contained
> > systemd services; I previously sent only the libfuse changes, without
> > any of the surrounding pieces.  Now I'm ready to send them all.
> >
> > To summarize this patchbomb: fuse servers can now run as non-root users,
> > with no privilege, no access to the network or hardware, etc.  The only
> > connection to the outside is an ephemeral AF_UNIX socket.  The process
> > on the other end is a helper program that acquires resources and calls
> > fsmount().
> >
> > Why would you want to do that?  Most filesystem drivers are seriously
> > vulnerable to metadata parsing attacks, as syzbot has shown repeatedly
> > over almost a decade of its existence.  Faulty code can lead to total
> > kernel compromise, and I think there's a very strong incentive to move
> > all that parsing out to userspace where we can containerize the fuse
> > server process.  Runtime filesystem metadata parsing is no longer a
> > privileged (== risky) operation.
> >
> > The consequences of a crashed driver is a dead mount, instead of a
> > crashed or corrupt OS kernel.
> >
> > Note that contained fuse filesystem servers are no faster than regular
> > fuse.  The redesign of the fuse IO path via iomap will be the subject of
> > the second patchbomb.  The containerization code only requires changes
> > to libfuse and is ready to go today.
> >
> > Since the seventh submission, I have made the following changes:
> >
> > 1) Added a couple of simple fuse service drivers to the example code
> >
> > 2) Adapted fuservicemount to be runnable as a setuid program so that
> > unprivileged users can start up a containerized filesystem driver
> >
> > 3) Fixed some endianness handling errors in the socket protocol between
> > the new mount helper and the fuse server
> >
> > 4) Added a high level fuse_main function so that fuse servers that use
> > the high level api can containerize without a total rewrite
> >
> > 5) Adapted mount.fuse to call the new mount helper code so that mount -t
> > fuse.XXX can try to start up a contained server
> >
> > 6) Cleaned up a lot of cppcheck complaints and refactored a bunch of
> > repetitious code
> >
> > 7) Started using codex to try to find bugs and security problems with
> > the new mount helper
> >
> > There are a few unanswered questions:
> >
> > a. How to integrate with the SYNC_INIT patches that Bernd is working on
> > merging into libfuse
> >
> > b. If /any/ of the new fsopen/fsconfig/fsmount/move_mount calls fail,
> > do we fall back to the old mount syscall?  Even after printing errors?
> >
> > c. Are there any Linux systems where some inetd implementation can
> > actually handle AF_UNIX sockets?  Does it make sense to try to do the
> > service isolation without the convenience of systemd directives?
> 
> A large part of the world is running container workloads on kubernetes
> and my understanding is that k8s does not mix well with systemd.
> 
> We have successfully used the fusetmount3-proxy [1] approach by Naoki
> MATSUMOTO as a way for unprivileged containers to delegate fuse mount
> by a (non-systemd) service, running in another container.
> 
> [1] https://github.com/pfnet-research/meta-fuse-csi-plugin#fusermount3-proxy-modified-fusermount3-approach
> 
> The README says that sshfs, s3fs and other high profile fuse fs have been
> tested with this approach and they do not require any rebuild.
> 
> So it bears the question...
> 
> >
> > d. meson/autoconf/cmake are a pain to deal with, hopefully the changes I
> > made are correct
> >
> > I have also converted a handful more fuse servers (fat, exfat, iso,
> > http) to the new service architecture so that I can run a (virtual)
> > Debian system with EFI completely off of containerized fuse servers.
> > These will be sent at the end.
> >
> 
> ... what is the added value of rebuilding those packages with systemd
> service support?
> 
> I am not implying that there is no added value, I just am not well versed
> in the world of container and system services.

From the discussion of fusermount3-proxy:
https://github.com/pfnet-research/meta-fuse-csi-plugin/raw/main/assets/inside-fusermount3-proxy.png
or
https://tech.preferred.jp/wp-content/uploads/2023/11/figures-6.png

Their approach spins up a second "CSI driver pod" (aka another contained
environment) to run fusermount3 with CAP_SYS_ADMIN.  This means that the
"user pod" has to be able to access all resources necessary to mount the
filesystem, e.g. virtual disk images, actual block devices, networking,
etc.  Once the fuse server is running, it's obviously still running in
the same environment as the user pod.

With my approach, resource acquisition can be done up front, and the
fuse server can run in a very sealed environment.  No block devices, no
networking, no /home, and the minimal root filesystem.  It's systemd, so
you can be more permissive with the environment if you'd like.

The downside is that requires code changes in the fuse server because
open() won't work if you've trimmed the directory tree.  Hmm, there's
not much provision for sockets, maybe I need to extend the protocol.

A big roadblock: none of that code can be merged into libfuse because
it's all Apache 2.0 licensed, whereas libfuse is GPL2/LGPL2.  LLMwash
notwithstanding.

--D
