From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/5] ext4: Use filemap_write_and_wait_range() correctly
 in collapse range
Date: Fri, 18 Apr 2014 11:03:42 -0400
Message-ID: <20140418150342.GF19131@thunk.org>
References: <1397673182-5326-1-git-send-email-lczerner@redhat.com>
 <alpine.LFD.2.00.1404162035010.2368@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, linkinjeon@gmail.com
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:48296 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751197AbaDRPDo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 18 Apr 2014 11:03:44 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1404162035010.2368@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Apr 16, 2014 at 08:38:01PM +0200, Luk=C3=A1=C5=A1 Czerner wrote=
:
> there are still endianness problems with collapse range, I kind of
> remember seeing some patches to fix that but I can not find those
> anywhere. So let me know if you have those, otherwise I'll send
> some.

Yes, those are in the tree already.  I had to adjust the patch #5
slightly so it would apply as a result.

> Also since this patch set (or rather the patch #5) fixes the
> collapse range so that it does not fail on fsx and fsstress we can
> drop the fallocate mode block patches I think :)

I'll move it to the unstable part of the tree as a debugging patch,
pending the xfstests changes to make it easy to block things like the
on-deck INSERT_RANGE patchset.  (BTW, it would be great if the
xfstests changes for INSERT_RANGE had an easy way to disable
INSERT_RANGE with a single environment variable.)

The point is that otherwise, I can't let the INSERT_RANGE patches into
the dev branch until it's completely regression free, or else it
interferes the testing of other patches during the development cycle.
Of course, if there are still problems that aren't solved by the end
of the development cycle, I'll still drop the patches and hold them
for the next merge window.

Thanks,

					- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
