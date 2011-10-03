From: Joakim Tjernlund <joakim.tjernlund@transmode.se>
Subject: Re: [PATCH v4] crc32c: Implement CRC32c with slicing-by-8 algorithm
Date: Mon, 3 Oct 2011 22:27:03 +0200
Message-ID: <OFA190E2A9.231A7DD6-ONC125791E.006F1765-C125791E.00705758@transmode.se>
References: <20110930192956.4176.29905.stgit@elm3c44.beaverton.ibm.com> <OF54094699.6F5CF2B6-ONC125791C.004C901C-C125791C.004D1A61@transmode.se> <20111003153634.GA12447@tux1.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	Mingming Cao <cmm@us.ibm.com>,
	David Miller <davem@davemloft.net>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto <linux-crypto@vger.kernel.org>,
	linux-ext4@vger.kernel.org,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Bob Pearson <rpearson@systemfabricworks.com>,
	Theodore Tso <tytso@mit.edu>
To: djwong@us.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from gw1.transmode.se ([195.58.98.146]:55389 "EHLO gw1.transmode.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753172Ab1JCU1G (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 3 Oct 2011 16:27:06 -0400
In-Reply-To: <20111003153634.GA12447@tux1.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

"Darrick J. Wong" <djwong@us.ibm.com> wrote on 2011/10/03 17:36:46:
>
> On Sat, Oct 01, 2011 at 04:02:10PM +0200, Joakim Tjernlund wrote:
> >
> > "Darrick J. Wong" <djwong@us.ibm.com> wrote on 2011/09/30 21:29:56:

[SNIP]

> >
> > This is based on an old version of Bobs slice by 8 that has lots duplication and
> > hard to maintain.
>
> Are you referring to "[PATCH v6 05/10] crc32-misc-cleanup.diff" from 8/31?  I
> haven't seen that one, so I'll go comb the internet.  Thank you for the
> pointer, I'll update my patch.

Not sure what version it was anymore as some time has passed. I think Bob was
supposed to do one more round of polishing the code and resend it.

>
> > Start from Bobs latest patches and add crc32c to lib/crc32.c
>
> If I did that, how should I handle patching in the hardware accelerated version
> on Intel systems?  That switcheroo ability seems to have been Herbert Xu's
> motivation for moving crc32c into crypto/ in the first place:

I don't know, I haven't looked at that problem. I suspect it moved because that
was the easiest solution. Having an identical impl. of crc32(only the table values differ)
in crypto compared to the one in lib is not the way forward though.

Could not someone on the cc list weigh in here? I have no formal right to
demand anything, I am just expressing my opinion.

    Jocke

