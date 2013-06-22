From: "Sidorov, Andrei" <Andrei.Sidorov@arrisi.com>
Subject: RE: ext4 file replace guarantees
Date: Sat, 22 Jun 2013 14:01:39 +0000
Message-ID: <C0F0BC787567C848B2C90989451123DA2363CBCC@ATLEXMBX4.ARRS.ARRISI.com>
References: <1371764058.18527.140661246414097.671B4999@webmail.messagingengine.com>
 <20130621005937.GB10730@thunk.org>
 <1371818596.20553.140661246775057.0F7160F3@webmail.messagingengine.com>
 <20130621131521.GE10730@thunk.org>
 <1371822707.3188.140661246795017.2D10645B@webmail.messagingengine.com>
 <bf675d01f2290be4e38f602ce78643c9@josephdwagner.info>
 <20130621210556.GB10582@thunk.org>
 <C0F0BC787567C848B2C90989451123DA2363CAFF@ATLEXMBX4.ARRS.ARRISI.com>,<20130622125604.GD4727@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "Joseph D. Wagner" <joe@josephdwagner.info>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Ryan Lortie <desrt@desrt.ca>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.arrisi.com ([216.234.147.109]:38282 "EHLO mail.arrisi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754882Ab3FVOCH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 22 Jun 2013 10:02:07 -0400
In-Reply-To: <20130622125604.GD4727@thunk.org>
Content-Language: en-US
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> So if you want to use the +j flag, you have to mount the file system
> with the non-standard nodelalloc mount option.  And that's actually
> sufficient to be bug-for-bug compatible with ext3 in terms of the
> commit of the transaction which contains the rename operation first
> forcing the file out to disk first.

Thanks for pointing this, I didn't know that. In my appliance I don't benefit
from delalloc, so that's not a problem.

> The best choice for an application rewriting files <= a single 4k
> block is to use O_DIRECT to rewrite the contents of the file, using a
> 4k buffer which is zero padded.  This is the most performant, uses the
> fewest write cycles for a SSD, etc.

This doesn't work in power loss scenario.
First of all majority of hdd's still have 512b sectors, so it is possible that
hdd won't have a chance to write all 8 sectors.
This doesn't work even with 4k drives because they are susceptible to spliced
sector writes. Well, 512b are susceptible too, but 4k drives have wider
window.
That's why for rewrite to be completely safe data has to be written twice. And
that's where inode's data journalling is a win.
I guess this isn't an issue for SSD's provided they properly order remapping
(which is a bug otherwise).

Regards,
Andrey.