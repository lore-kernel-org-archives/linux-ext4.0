From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: /dev/disk/by-label missing after upgrade to 1.42.7
Date: Thu, 20 Jun 2013 20:23:14 -0400
Message-ID: <20130621002314.GA10730@thunk.org>
References: <CADzUK1+bAEXgXag+frRJBBH8A0rgbu-YUHOp0KG9jNJ_a0OG2A@mail.gmail.com>
 <CADzUK1+D2NJ3WC4jz-HKHQGyF7GGKGytLnA=bvGHsL5iNa-hMw@mail.gmail.com>
 <51BA3B3B.9090508@redhat.com>
 <20130614012600.GA3220@thunk.org>
 <CADzUK1+ykJ9uZjHkCuVrc5_kHyXwVsngfYBKJcd0qdtSZJGNOQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org
To: Autif Khan <autif.mlist@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:59948 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161097Ab3FUAXS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 20 Jun 2013 20:23:18 -0400
Content-Disposition: inline
In-Reply-To: <CADzUK1+ykJ9uZjHkCuVrc5_kHyXwVsngfYBKJcd0qdtSZJGNOQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jun 20, 2013 at 07:08:35PM -0400, Autif Khan wrote:
> I have updated our scripts to overwrite only those binaries that
> originated from the e2fsprogs package. In our build/CI system it would
> be (relatively) hard to build a debian package using fakeroot
> dpkg-buildpackages, instead, we run dpkg -S /bin/binary to find if the
> package originated in e2fsprogs and if it did, we copy it over,
> otherwise not. For now this works, we will pay the technical debt
> if/when we need to - chances are this will go away in Ubuntu 14.04 LTS
> which should have the latest version of e2fsprogs.

If you're not willing to use dpkg-buildpackage, I strongly recommend
that you add the following configure options:

     --disable-libblkid --disable-libuuid --disable-fsck --disable-uuidd

... especially if you are building with shared libraries.  Otherwise,
you'll be building with one version of the shared libraries, and
running with a different shared libraries.

						- Ted

