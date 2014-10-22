From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/2] xfstests-bld: Split system images in two parts
Date: Wed, 22 Oct 2014 17:25:35 -0400
Message-ID: <20141022212535.GC6295@thunk.org>
References: <1413990417-18285-1-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, root <root@deb7build>
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:38068 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932399AbaJVVZk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 22 Oct 2014 17:25:40 -0400
Content-Disposition: inline
In-Reply-To: <1413990417-18285-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch is really huge, and unfortunately I've been doing some work
in parallel that hadn't yet gotten pushed to git.kernel.org, so your
patches don't apply cleanly any more.

In particular, I've already added support for config.custom (ala your
2/2 patch) to gen-image.  This can be used in conjuction to a
convenience script which takes the cached packages in
var.cache.apt.archives and var.lib.apt.lists and create a local
mirror.

So now after running:

# ./gen-image --mirror http://snapshot.debian.org/archive/debian/20141013T184415Z
% ./create-local-mirror snapshot.debian.org_archive_debian_20141013T184415Z

you can now run the command:

# ./gen-image --mirror file:mirror

without needing access to the network.

> Currently (1) and (2) are combined together to root_fs.img, but
> it is not always good because (1) is usually very stable, but
> (2) is not especially in case of xfstests development.
> This patch split root_fs image in two parts:
> root_fs.img: contains debian distribution and generic xfstest startup scripts
> test_fs.img: contains xfstests and xfstest-config  (mounted in /tests)

Adding an extra image file makes life a bit harder for people who
aren't actually doing xfstests/kvm-xfstests development, since they
now need to download and install two files.  We also have to worry
about potential incompatibilities in the future that might arise
between the generic xfstest starutp scripts (in root_fs.img) and the
xfstest-config files (in test_fs.img).

So what I suggest instead is that we have a new script, update-image,
which takes an existing root_fs.img, and installs the updated
xfstests, the configuration files, and startup files, leaving the
existing debian base image intact.

The advantage of this is that patch will be much smaller and easier
for me to review :-), and it also makes life easier for end-users who
aren't developing, where having a single image is much, much simpler.
Also, having a single image will also make it simpler to support
deploying an test image to cloud hosting provider.  (One my side
project I've been working on is trying to make kvm-xfststs work on
Google Compute Engine.)

Will creating a new "update-image" script meet your needs of making it
easier to do xfstests development?  (Actually, what I've done when I'm
doing xfstests development is I just copy xfstests.tar.gz to the file
that gets mounted under /vdb, run "./kvm-xfstests maint", and then
unpack the xfstests.tar.gz file.  Or sometimes I'll just copy the
modified xfstests scripts /vdb and just install them so I don't have
to recompile all of the xfstests binaries.)

Cheers,

						- Ted
