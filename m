From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: DIO process stuck apparently due to dioread_nolock (3.0)
Date: Thu, 18 Aug 2011 10:49:20 +0400
Message-ID: <4E4CB5F0.6000202@msgid.tls.msk.ru>
References: <4E48390E.9050102@msgid.tls.msk.ru> <4E488625.609@tao.ma> <4E48D231.5060807@msgid.tls.msk.ru> <4E48DF31.4050603@msgid.tls.msk.ru> <CAFgt=MAfbU_muEzmxx-8CK8w7=nGR5dUZSgBQ1dN6XkyrTbO9g@mail.gmail.com> <20110816135325.GD23416@quack.suse.cz> <4E4A86D0.2070300@tao.ma> <CAFgt=MCQttE5Vv_4W=hFWU_L_FvELnY6bnFQ3uSOu07VkDm6rA@mail.gmail.com> <4E4AEF13.7070504@msgid.tls.msk.ru> <CAFgt=MBMyf=n2GM6iNPdOoBiC2o0PqLSi7yrssHn562K96wn_g@mail.gmail.com> <20110817170236.GB6901@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Jiaying Zhang <jiayingz@google.com>, Tao Ma <tm@tao.ma>,
	Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
	sandeen@redhat.com
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from isrv.corpit.ru ([86.62.121.231]:33496 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751772Ab1HRGte (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 18 Aug 2011 02:49:34 -0400
In-Reply-To: <20110817170236.GB6901@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

17.08.2011 21:02, Ted Ts'o wrote:
[]
> What I'd like to do long-term here is to change things so that (a)
> instead of instantiating the extent as uninitialized, writing the
> data, and then doing the uninit->init conversion to writing the data
> and then instantiated the extent as initialzied.  This would also
> allow us to get rid of data=ordered mode.  And we should make it work
> for fs block size != page size.
> 
> It means that we need a way of adding this sort of information into an
> in-memory extent cache but which isn't saved to disk until the data is
> written.  We've also talked about adding the information about whether
> an extent is subject to delalloc as well, so we don't have to grovel
> through the page cache and look at individual buffers attached to the
> pages.  And there are folks who have been experimenting with an
> in-memory extent tree cache to speed access to fast PCIe-attached
> flash.
> 
> It seems to me that if we're careful a single solution should be able
> to solve all of these problems...

What about current situation, how do you think - should it be ignored
for now, having in mind that dioread_nolock isn't used often (but it
gives _serious_ difference in read speed), or, short term, fix this
very case which have real-life impact already, while implementing a
long-term solution?

Thank you!

/mjt
