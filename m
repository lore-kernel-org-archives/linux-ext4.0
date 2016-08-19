From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 6/6] Add dockerfile
Date: Fri, 19 Aug 2016 01:21:06 -0400
Message-ID: <20160819052106.GC10888@thunk.org>
References: <1471553651-9547-1-git-send-email-dmonakhov@openvz.org>
 <1471553651-9547-7-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:43780 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750757AbcHSFVK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 19 Aug 2016 01:21:10 -0400
Content-Disposition: inline
In-Reply-To: <1471553651-9547-7-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Aug 19, 2016 at 12:54:11AM +0400, Dmitry Monakhov wrote:
> Dockerfile is good way to create build environments
> Let's keep it as a reference build script.
> 
> XXX: Currently Ted does not have hub.docker account
>      so this docker file points to my hub. Should be updated.

I guess I'm a little confused about how this Dockerfile works.  First
of all, says "From Debian", so I guess the idea is to be based on an
unspecified version of Debian (why not debian:jessie?).  But then it
has apt-get commands?  How does that work?

And if the idea is to fetch a prebuilt docker image, and we're running
it with docker run --privilege, I'm not sure what value using docker
run is really providing.  We're not using the docker container
features.   And typing

docker run -i -t --privileged ... \
	"kvm-xfstests.sh --kernel /tmp/bzImage --update-files --update-xfstests-tar  smoke"

Is just *awkward*.  The whole point is to let kvm-xfstests read the
kernel from your ~/.config/gce-xfstests, so your work flow can be
something like this:

git am -s ~/mbox/patch.mbox
../make-ext4      # shortcut for something like "make O=/build/ext4 -j16"
kvm-xfstests smoke   # ~/.config/gce-xfststs sets GCE_KERNEL=/build/ext4

needing to type a long docker run command doesn't seem to add any
value.

Confused,

					- Ted
