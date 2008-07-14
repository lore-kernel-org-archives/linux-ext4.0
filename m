From: Theodore Tso <tytso@mit.edu>
Subject: Re: ext4 64bit (disk >16TB) question
Date: Mon, 14 Jul 2008 19:46:16 -0400
Message-ID: <20080714234616.GD3382@mit.edu>
References: <87bq10w8gv.fsf@frosties.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Goswin von Brederlow <goswin-v-b@web.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:53440 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932080AbYGNXq3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 14 Jul 2008 19:46:29 -0400
Content-Disposition: inline
In-Reply-To: <87bq10w8gv.fsf@frosties.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jul 14, 2008 at 09:50:56PM +0200, Goswin von Brederlow wrote:
> 
> we are using lustre on a cluster of servers and raid boxes. Currently
> lustre is based on the ext3 code and has a limit of 8TiB for each
> filesystem. For us that results on having to split a servers storage
> into up to 4 chunks and run one fs on each which I would rather avoid.
> The solution for this would be to rebase the lustre patches to use
> ext4 instead, which should also reduce the patch set considerably.
> Lustre already patches a lot of ext4 features into the ext3 base.
> 
> 
> But before I start rebasing lustre I though I would first test out
> plain ext4 so I know any bugs I find will be from my rebasing and not
> already existing in ext4 itself. And there I run into a big problem:
> Current e2fsprogs (1.41) seem to be totaly unable to handle the ext4 64BIT
> feature, i.e. filesystems larger than 16TiB. The mkfs.ext4 always
> stops saying the disk exceeds the 32bit block count. And looking at
> the code I see a lot of blk_t (instead of blk64_t) and unsigned long
> (instead of unsigned long long [or even better blk64_t]) usage.
> 
> I found ext4 64bit patches for e2fsprogs 1.39 that fix at least
> mkfs. Does anyone know if there is an updated patch set for 1.41
> anywhere? And when will that be added to e2fsprogs upstream?

Yes, this is correct.  The 1.39 64-bit patches break the shared
library ABI, and also there were some long-term problems with having
super-large bitmaps taking huge amounts of memory without some kind of
run-length encoding or other compression technique.  I decided to
reject the 1.39 approach because it would have caused short- and
long-term maintenance issues.

At the moment 1.41 does not support > 32 bit block numbers.  The
priority was to get something which supported all of the other ext4
features out the door, since that would allow much better testing of
the ext4 code base.  We are now working on 64-bit support in
e2fsprogs, with mke2fs coming first, and the other tools coming later.
But yeah, good quality 64-bit e2fsprogs support is going to lag for a
bit.  Sorry, we're working as fast as we can, given the resources we
have.

Regards,

						- Ted



