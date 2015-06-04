From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Which newer kernel is OK with ext4?
Date: Wed, 3 Jun 2015 22:08:52 -0400
Message-ID: <20150604020852.GB5759@thunk.org>
References: <mknlqf$m5d$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "U.Mutlu" <for-gmane@mutluit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:46636 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751038AbbFDCIy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 3 Jun 2015 22:08:54 -0400
Content-Disposition: inline
In-Reply-To: <mknlqf$m5d$1@ger.gmane.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jun 03, 2015 at 09:50:39PM +0200, U.Mutlu wrote:
> I need to switch to a newer kernel than 3.16.0-4.
> But since the new ext4 is not finished yet, I'm concerned
> about the safety of the data on my ext4-hd.
> I don't know how the ext4-inclusion-policy-into-the-kernel is,
> maybe one of you can enlighten me. I mean, the old (ie. the current)
> ext4 seems to be ok, and I would not want to risk the data to a new,
> but unfinished, ext4-module in a newer kernel.
> Is there maybe a kernel-switch to use the old ext4 module?

There really is no such thing as "the new ext4", and talking about
ext4 "is not finished yet" also makes no sense.  We add new features
to ext4 on a rolling basis, just as Linus is adding new features to
Linux, the gcc developers are adding new features to gcc, the emacs
developers are adding new features to emacs, etc., etc.  Just as it
doesn't make sense to talk about "the new gcc is not finished yet", it
doesn't make sense to talk about "the new ext4 is not finished yet".

Various ext4 features are enabled using feature flags when you create
the file system using mke2fs, and some/most features can be
manipulated using the tune2fs command.  Very often features can only
be used when you have upgraded a newer version of e2fsprogs.  So for
example, the metadata checksum feature and the encryption feature
can't be used unless you fetch the development branch of e2fsprogs and
build it yourself.  (Well, there is e2fsprogs 1.43~WIP-2015-05-18-1 as
a Debian experimental package, but you use that at your own risk.)

If you restrict yourself to the file system features in the e2fsprogs
1.42.x branch, you should be fine.

> Can I safely install the "stable 4.0.4" kernel from www.kernel.org?

You can, but the 4.0 kernel is kernel version that is going to be
getting long-term backports of bug fixes, security fixes, etc.  Some
people will regularly track the new kernels, and but if you're someone
who doesn't understand the details of manging kernel upgrades (and
with all due respect, someone who thinks that it's possible to protect
users from root is probably someone who doesn't have the knowledge,
skills, and experience to maintain their own kernel), it might be
better to stick with a distribution supported and maintained kernel.

If you are more adventurous, you could try using one of the long-term
supported kernel (i.e., such as 3.18).  See:

	  https://www.kernel.org/category/releases.html

But remember, now you have to properly configure the kernel, and you
are responsible for checking for new releases of the a long-term
supported kernel.  If you stick with a specific kernel version and
don't upgrade it, then you might be prone to security bugs that would
have been fixed by a newer kernel.

Regards,

					- Ted
