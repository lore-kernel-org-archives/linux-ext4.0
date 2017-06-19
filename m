From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Regression test (or generic tests) for Linux filesystems
Date: Mon, 19 Jun 2017 01:41:28 -0400
Message-ID: <20170619054128.zwegvknm5uhumlpa@thunk.org>
References: <CABjLfgi=TK6-od5GhL=VtzzLs0bV5GGBrgh2s9WvKaAn5YCCoA@mail.gmail.com>
 <30ec9f1e-f360-c634-727b-ce73e0f352ba@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Danesh Daroui <danesh.daroui@gmail.com>,
        linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Nikolay Borisov <n.borisov.lkml@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <30ec9f1e-f360-c634-727b-ce73e0f352ba@gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sun, Jun 18, 2017 at 11:37:16PM +0300, Nikolay Borisov wrote:
> 
> xfstest is the de-facto testsuite for linux filesystems. It not only has
> generic tests but also fs-specific ones e.g. ext4. So go with it.

If you want a really convenient way of running xfstests, I have a set
of wrapper scripts that make it easy to run xfstests using either KVM
or GCE (Google Compute Engine).  The idea is to do something which is
turn-key and really easy, so that people who are submitting patches
for me to review have no excuse not to run tests first.  :-)

I also was making it easy because there were some graduate students
who were interesting writing their own file system or making changes
to existing file systems, and this made it easy for them to do their
testing.  So it was deisgned for that use case as well.  For more
information, please see these URL's:

	http://thunk.org/gce-xfstests
	https://github.com/tytso/xfstests-bld/blob/master/Documentation/kvm-quickstart.md
	https://github.com/tytso/xfstests-bld/blob/master/Documentation/kvm-xfstests.md
	https://github.com/tytso/xfstests-bld/blob/master/Documentation/gce-xfstests.md

And, for extra fun, we have alpha support for using xfstests in an
Android environment.  This can be used if you need to test some
feature that requires hardware support, such as the ext4 integration
with hardware inline-crypto encryption (ICE):

	https://github.com/tytso/xfstests-bld/blob/master/Documentation/android-xfstests.md

(This is rather bleeding edge code, and it's mainly only been tested
on a small set of devices.  It will also destroy existing user data on
the device, and xfstests can use up a large number of write cycles on
low-end flash.  So I recommend only using android-xfstests on
sacrificial development devices where you don't have a strong
attachment to any data on the device or the longevity of of said
device.  :-)

Cheers!

						- Ted

P.S.  gce-xfstest and kvm-xfstests have support to test file systems
beyond ext4, but to date it's been primarily used to test ext4 file
system code.  I have basic support for btrfs, f2fs, xfs, overlayfs,
tmpfs, and it would be trivial to add support for more file systems,
or for people who want to give me file system test configurations for
file systems beyond ext4.  So if you are interested in using
kvm-xfstests or gce-xfstests for other filesystems --- please drop me
a line and let's chat.
