From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/2] Jbd2: fix a bug of leaking jh->b_jcount
Date: Wed, 25 May 2011 18:14:15 -0400
Message-ID: <20110525221415.GE9520@thunk.org>
References: <-1724257416234743088@unknownmsgid>
 <BANLkTikbgiS+3U9HXRoLOxWih=pGJ2rHgQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: y@mx.nrchpc.ac.cn, linux-ext4@vger.kernel.org,
	Ding Dinghua <dingdinghua@nrchpc.ac.cn>
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:35850 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755212Ab1EYWOT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 25 May 2011 18:14:19 -0400
Content-Disposition: inline
In-Reply-To: <BANLkTikbgiS+3U9HXRoLOxWih=pGJ2rHgQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, May 25, 2011 at 06:49:57PM +0800, Yongqiang Yang wrote:
> Signed-off-by: line was missed.

Ding,

Please resend the patch with the Signed-off-by, or tell me explicitly
that it's OK to add:

Signed-off-by: Ding Dinghua <dingdinghua@nrchpc.ac.cn>

The signed-off-by has legal meaning (see below) so it's not something
I want to add on my own initiative without getting an explicit ack
from the original author.

Regards,

						- Ted

(From /usr/src/linux/Documentation/SubmittingPatches)

12) Sign your work

To improve tracking of who did what, especially with patches that can
percolate to their final resting place in the kernel through several
layers of maintainers, we've introduced a "sign-off" procedure on
patches that are being emailed around.

The sign-off is a simple line at the end of the explanation for the
patch, which certifies that you wrote it or otherwise have the right to
pass it on as a open-source patch.  The rules are pretty simple: if you
can certify the below:

        Developer's Certificate of Origin 1.1

        By making a contribution to this project, I certify that:

        (a) The contribution was created in whole or in part by me and I
            have the right to submit it under the open source license
            indicated in the file; or

        (b) The contribution is based upon previous work that, to the best
            of my knowledge, is covered under an appropriate open source
            license and I have the right under that license to submit that
            work with modifications, whether created in whole or in part
            by me, under the same open source license (unless I am
            permitted to submit under a different license), as indicated
            in the file; or

        (c) The contribution was provided directly to me by some other
            person who certified (a), (b) or (c) and I have not modified
            it.

	(d) I understand and agree that this project and the contribution
	    are public and that a record of the contribution (including all
	    personal information I submit with it, including my sign-off) is
	    maintained indefinitely and may be redistributed consistent with
	    this project or the open source license(s) involved.

then you just add a line saying

	Signed-off-by: Random J Developer <random@developer.example.org>

using your real name (sorry, no pseudonyms or anonymous contributions.)

Some people also put extra tags at the end.  They'll just be ignored for
now, but you can do this to mark internal company procedures or just
point out some special detail about the sign-off. 

