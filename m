From: Matthias Koenig <mkoenig@suse.de>
Subject: Re: [PATCH] obsolete libcom-err for SuSE e2fsprogs
Date: Tue, 25 Sep 2007 11:27:30 +0200
Message-ID: <n7xmyvbccxp.fsf@sor.suse.de>
References: <20070919061404.GA1628@schatzie.adilger.int>
	<46F1CFC0.3070801@redhat.com>
	<20070920050923.GX32520@schatzie.adilger.int>
	<46F2D678.4060203@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@clusterfs.com>,
	"Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35663 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750786AbXIYJX4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 25 Sep 2007 05:23:56 -0400
In-Reply-To: <46F2D678.4060203@redhat.com> (Eric Sandeen's message of "Thu\, 20
	Sep 2007 15\:22\:16 -0500")
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Eric Sandeen <sandeen@redhat.com> writes:

> Andreas Dilger wrote:
>> On Sep 19, 2007  20:41 -0500, Eric Sandeen wrote:
>>> Andreas Dilger wrote:
>>>> It isn't possible to build an e2fsprogs via "make rpm" on SuSE and have it
>>>> install cleanly, because they split out some of the libraries into separate
>>>> packages.
>>>>
>>>> We've got the current patch to the .spec file, but I'm open to discussion
>>>> if it is more desirable to change the .spec to continue to build separate
>>>> RPMs (though that is more of a distribution hassle and might need major
>>>> changes in the .spec file).
>>> FWIW, I also have an RFE assigned to me for RHEL/Fedora to split up our
>>> e2fsprogs packages for libcom_err and libuuid... since many
>>> non-filesystem things now require them.   So, this is sort of going in
>>> the opposite direction.  :)
>>>
>>> Any idea how many distros already split it out?
>> 
>> I know Debian-based distros have done this for ages...
>> 
>> I'd also welcome someone with rpm-fu split it into separate packages.
>
> I'd do this, my rpm-fu is still reasonably strong, though - I'm curious,
> is there a compelling reason to split out just libcom-err?  what about
> libuuid?  libblkid?  e2fsprogs is a bit of a grab bag of things.  What's
> the rationale for the split?

The Suse split out of library packages has been enforced by our new library
packaging policy[1]. I think debian has a similar policy [2].
In openSUSE the splitted out library packages are
libblkid1
libcom_err2
libext2fs2
libuuid1
with the corresponding development packages named with the -devel
postfix but without the soname version appendix. There is currently also
a dummy e2fsprogs-devel package for backwards compatibility.

I am not sure how other RPM based distributions will handle this and
if it is worth the effort to keep track of all this in one specfile.
If needed I could take care for the Suse specific stuff.

Matthias 

[1] http://en.opensuse.org/Shared_Library_Packaging_Policy
[2] http://www.netfort.gr.jp/~dancer/column/libpkg-guide/libpkg-guide.html
