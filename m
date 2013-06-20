From: Autif Khan <autif.mlist@gmail.com>
Subject: Re: /dev/disk/by-label missing after upgrade to 1.42.7
Date: Thu, 20 Jun 2013 19:08:35 -0400
Message-ID: <CADzUK1+ykJ9uZjHkCuVrc5_kHyXwVsngfYBKJcd0qdtSZJGNOQ@mail.gmail.com>
References: <CADzUK1+bAEXgXag+frRJBBH8A0rgbu-YUHOp0KG9jNJ_a0OG2A@mail.gmail.com>
	<CADzUK1+D2NJ3WC4jz-HKHQGyF7GGKGytLnA=bvGHsL5iNa-hMw@mail.gmail.com>
	<51BA3B3B.9090508@redhat.com>
	<20130614012600.GA3220@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ee0-f45.google.com ([74.125.83.45]:53426 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757878Ab3FTXIh (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 20 Jun 2013 19:08:37 -0400
Received: by mail-ee0-f45.google.com with SMTP id c1so4247944eek.18
        for <linux-ext4@vger.kernel.org>; Thu, 20 Jun 2013 16:08:35 -0700 (PDT)
In-Reply-To: <20130614012600.GA3220@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I have updated our scripts to overwrite only those binaries that
originated from the e2fsprogs package. In our build/CI system it would
be (relatively) hard to build a debian package using fakeroot
dpkg-buildpackages, instead, we run dpkg -S /bin/binary to find if the
package originated in e2fsprogs and if it did, we copy it over,
otherwise not. For now this works, we will pay the technical debt
if/when we need to - chances are this will go away in Ubuntu 14.04 LTS
which should have the latest version of e2fsprogs.

Thanks for all the help - specially Eric, Ted and Darrick.

Autif

On Thu, Jun 13, 2013 at 9:26 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> On Thu, Jun 13, 2013 at 04:35:55PM -0500, Eric Sandeen wrote:
>
>> ubuntu isn't using blkid from util-linux?
>
> Ubuntu and Debian does use blkid from util-linux.  I'm guessing Autif
> compiled e2fsprogs by hand.
>
> For the record, what I recommend for people who are using debian or
> Ubuntu systems (of whatever vintage) is:
>
> tar xvfz e2fsprogs-1.42.7.tar.gz
> cd e2fsprogs-1.42.7
> ./debian/rules
> fakeroot dpkg-buildpackage
>
> This will build .deb packages that are suitable for whatever version
> of Debian or Ubuntu (including really ancient ones before blkid was
> moved to util-linux) you happen to be using.
>
>> That's really where it's maintained these days, a little surprised that
>> blkid's still in use from e2fsprogs, though I don't know my ubuntu
>> releases.  Maybe this is Crufty Crow?  ;)
>>
>> Fedora has been building w/ --disable-libblkid for quite a while,
>> just FWIW.
>
> I plan to change the default for libblkid before I release 1.43.
>
>                                        - Ted
