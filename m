From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Which kernel do I need to use ext4 64-bit.
Date: Tue, 18 Jul 2017 19:31:59 -0400
Message-ID: <20170718233159.4dfolbbgrgw3s7a5@thunk.org>
References: <789629f3-d70f-5588-65ec-a45d5c3259a9@gmail.com>
 <469EA06D-C08B-463E-9511-4C340BED86C8@dilger.ca>
 <57c41e8d-8d81-e43b-e57b-e91daa7bba83@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>, linux-ext4@vger.kernel.org
To: Ram Ramesh <rramesh2400@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:37206 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752692AbdGRXcB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 18 Jul 2017 19:32:01 -0400
Content-Disposition: inline
In-Reply-To: <57c41e8d-8d81-e43b-e57b-e91daa7bba83@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jul 18, 2017 at 05:49:31PM -0500, Ram Ramesh wrote:
> Thanks. I can't update e2fsprogs to 1.43 without knowing that the file
> system it creates can be mounted on my kernel. I am with ubuntu 14.04 which
> only has these. I could manually download and build from source or install
> from another repository only if I know my kernel will support it. So, I
> really need to know if linux 3.13 support ext4-64bit.

Why are you not willing to update to Ubuntu 16.04, or something less
ancient?  The 64-bit feature is "supported" in the sense that the
kernel will understand it.  But if you have a paid support contract
from Canonical, you need to ask them if they will "support" it.  And
if you are hoping that the upstream kernel development community will
provide you free "support" for an ancient enterprise distribution, you
need to understand that this is best efforts only.

Technically speaking it appears that Linux 3.13 understands the 64-bit
feature.  Whether there are any critical bugs that have since been
fixed is a very different question.  Technically speaking, e2fsprogs
1.42.9 also understands the 64-bit feature, but I *know* that there
are a number of off-line resize bugs with the 64-bit features in the
1.42.x e2fsprogs line.

The reason to use 1.43.x is that it will turn on the 64-bit feature
"automatically".  But you could just also reformat the file system
using "mke2fs -t ext4 -O 64bit /dev/xxx" using 1.42.x.  Also note that
depending on which repository that you download e2fsprogs 1.43.x, you
may need to edit /etc/mke2fs.conf so mke2fs doesn't enable the
metadata_csum feature by default (which will not be supported by Linux
3.13).

So it might be that the safer thing to do is to build e2fsprogs 1.43.x
(so you get the latest bug fixes), and then check the /etc/mke2fs.conf
file to make sure it will create the same sort of file system as 1.42.x.

But if this is a critical enterprise/production system, and you are
expecting support by sending e-mail to linux-ext4@vger.kernel.org, I
do feel morally bound to dissuade you from doing that unless you are
prepared to carry most of the support burden yourself.  There is a
reason why companies pay $$$ to Red Hat or SuSE...

Cheers,

						- Ted
