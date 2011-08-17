From: Ted Ts'o <tytso@mit.edu>
Subject: Re: DIO process stuck apparently due to dioread_nolock (3.0)
Date: Wed, 17 Aug 2011 13:02:36 -0400
Message-ID: <20110817170236.GB6901@thunk.org>
References: <4E48390E.9050102@msgid.tls.msk.ru>
 <4E488625.609@tao.ma>
 <4E48D231.5060807@msgid.tls.msk.ru>
 <4E48DF31.4050603@msgid.tls.msk.ru>
 <CAFgt=MAfbU_muEzmxx-8CK8w7=nGR5dUZSgBQ1dN6XkyrTbO9g@mail.gmail.com>
 <20110816135325.GD23416@quack.suse.cz>
 <4E4A86D0.2070300@tao.ma>
 <CAFgt=MCQttE5Vv_4W=hFWU_L_FvELnY6bnFQ3uSOu07VkDm6rA@mail.gmail.com>
 <4E4AEF13.7070504@msgid.tls.msk.ru>
 <CAFgt=MBMyf=n2GM6iNPdOoBiC2o0PqLSi7yrssHn562K96wn_g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Michael Tokarev <mjt@tls.msk.ru>, Tao Ma <tm@tao.ma>,
	Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
	sandeen@redhat.com
To: Jiaying Zhang <jiayingz@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:54638 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752684Ab1HQRCo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 17 Aug 2011 13:02:44 -0400
Content-Disposition: inline
In-Reply-To: <CAFgt=MBMyf=n2GM6iNPdOoBiC2o0PqLSi7yrssHn562K96wn_g@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Aug 16, 2011 at 04:07:38PM -0700, Jiaying Zhang wrote:
> Good question. At the time when we checked in the code, we wanted to be
> careful that it didn't introduce data corruptions that would affect normal
> workloads. Apparently, the downside is that this code path doesn't get
> a good test coverage. Maybe it is time to reconsider enabling this feature
> by default. I guess we still want to guard it with a mount option given that
> it doesn't work with certain options, like "data=journaled" mode and small
> block size.

What I'd like to do long-term here is to change things so that (a)
instead of instantiating the extent as uninitialized, writing the
data, and then doing the uninit->init conversion to writing the data
and then instantiated the extent as initialzied.  This would also
allow us to get rid of data=ordered mode.  And we should make it work
for fs block size != page size.

It means that we need a way of adding this sort of information into an
in-memory extent cache but which isn't saved to disk until the data is
written.  We've also talked about adding the information about whether
an extent is subject to delalloc as well, so we don't have to grovel
through the page cache and look at individual buffers attached to the
pages.  And there are folks who have been experimenting with an
in-memory extent tree cache to speed access to fast PCIe-attached
flash.

It seems to me that if we're careful a single solution should be able
to solve all of these problems...

						- Ted
