From: Theodore Tso <tytso@mit.edu>
Subject: Re: Integrating patches in SLES10 e2fsprogs
Date: Mon, 28 Jan 2008 00:24:15 -0500
Message-ID: <20080128052415.GA23482@mit.edu>
References: <20080124211728.GA24900@webber.adilger.int> <n7xir1iq69b.fsf@sor.suse.de> <20080127050543.GC24842@mit.edu> <479C9E13.8040209@redhat.com> <20080127202725.GA2545@mit.edu> <479D5CB9.5060801@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Matthias Koenig <mkoenig@suse.de>, linux-ext4@vger.kernel.org,
	hvogel@suse.de, Girish Shilamkar <Girish.Shilamkar@Sun.COM>,
	Eric Sandeen <esandeen@redhat.com>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:34840 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750976AbYA1FYZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 28 Jan 2008 00:24:25 -0500
Content-Disposition: inline
In-Reply-To: <479D5CB9.5060801@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Jan 27, 2008 at 10:40:25PM -0600, Eric Sandeen wrote:
> 
> %build
> aclocal
> autoconf
> %configure --enable-elf-shlibs --enable-nls --disable-e2initrd-helper
> --enable-blkid-devmapper --enable-blkid-selinux --enable-dynamic-e2fsck
> make %{?_smp_mflags}
> 

It should be fine if you eliminate the "aclocal" call.  And I've never
understood why people like to regenerate configure scripts from
configure.in in the first place....

In any case, I've just released e2fsprogs 1.40.6.  It contains some of
obviously correct patches from the Novell and Red Hat packages.  More
importantly, it includes the "mke2fs -E test_fs" feature which will be
needed once we push test_fs ext4 patches to mainline, which I plan to
push to Linus in the next day or two.

						- Ted
