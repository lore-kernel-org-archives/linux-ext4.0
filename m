From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] ext4 bugfixes for 3.2-rc5
Date: Wed, 14 Dec 2011 18:50:07 -0800
Message-ID: <CA+55aFw6n=WaDWRn7NqtBei1x0-w1PkH5x6r3iQSSPZvxYvDhQ@mail.gmail.com>
References: <E1RauNd-0008W1-02@tytso-glaptop.cam.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:61278 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758613Ab1LOCub (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 14 Dec 2011 21:50:31 -0500
In-Reply-To: <E1RauNd-0008W1-02@tytso-glaptop.cam.corp.google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Dec 14, 2011 at 11:20 AM, Theodore Ts'o <tytso@mit.edu> wrote:
>
> There is a signed tag tytso-for-linus-20111214 covering these patches,
> which fix a potential hang, crash (on big endian), and data corruption
> bugs which show up when using fsx and/or Hugh's kernel compile/mm
> torture test.

Ok, since I build my own git versions, I have one that can pull signed
tags and automatically verifies them and saves the signed tag
information as part of the commit object.

Which is all fine, but your tag-names are just ugly. I could edit the
end result (another advantage of the new git version - it starts the
editor automatically), but I decided to not do so, and instead use
this as a "teaching moment" for everybody.

Everybody: you can now create a signed tag, and just point me at it.
You don't even have to have a separate branch for me to pull any more,
just the signed tag is fine.

So it would actually be nicer if you used temporary tag names the way
you use temporary branch names when  you ask me to pull. The tag
*content* will be saved from now on (unless I screw up while traveling
or something and pull with a machine that has an older git version),
so there's very little advantage in then saving the tags separately by
having ugly tag-names with long lifetimes.

I pushed out, so you can see this in action in the current git tree by doing

 [torvalds@i5 linux]$ git show --abbrev-commit 2240a7bb479c

to see the normal commit message. And then to see the actual
saved-away signed tag information, do

  [torvalds@i5 linux]$ git cat-file commit 2240a7bb479c

which should all work with old versions of git too - it's just the
merger that needs a new version of git. It's easy to parse: it's the
standard "git tag" format, except it is indented by a space to show
that it's part of the header (and then the first empty line is what
ends the commit object headers). So you can basically do something
like

   git cat-file commit 2240a7bb479c |
        awk '/^mergetag /,/^$/ { print }' |
        sed 's/^mergetag//' |
        sed 's/^ //'

to re-create the tag object, and then you can verify it (the part
*before* the "-----BEGIN PGP SIGNATURE-----" line should match the
signature inside the PGP signature - trivial format).

It got verified when I pulled it (the gpg verification output shows up
as part of the comments in the commit message editing thing), but
using the above you can now verify it after-the-fact too, without
having access to your original tag object - since the data is embedded
in the git merge commit.

Hmm?

                              Linus
