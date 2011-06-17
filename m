From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] e2fsprogs: create com_err.h symlink in includedir
Date: Thu, 16 Jun 2011 21:54:20 -0600
Message-ID: <1A2DB8F9-BD3B-436E-886D-431A15796AC3@dilger.ca>
References: <4D5C1103.8060403@redhat.com> <20110220231015.GA4001@thunk.org> <4D84C5C9.1060507@redhat.com> <4DFA69EB.3060907@redhat.com> <20110617023149.GD29725@thunk.org>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Eric Sandeen <sandeen@redhat.com>,
	ext4 development <linux-ext4@vger.kernel.org>, mitchb@mit.edu,
	Bruce Cassidy <bruce@whamcloud.com>
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:24120 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756732Ab1FQDye convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 16 Jun 2011 23:54:34 -0400
In-Reply-To: <20110617023149.GD29725@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-06-16, at 8:31 PM, Ted Ts'o wrote:
> On Thu, Jun 16, 2011 at 03:39:07PM -0500, Eric Sandeen wrote:
>>> Hm, now in a "make rpm" build which has source in one place and rpm build
>>> area in another:
>>> 
>>> /bin/ln: creating hard link `/home/sandeen/rpmbuild/BUILDROOT/e2fsprogs-1.41.14-0.x86_64/usr/include/com_err.h' => `/usr/include/et/com_err.h': Invalid cross-device link
>>> 
>>> so I'm not quite sure how to work around this.
>>> 
>>> Maybe in the end it does have to be packaging-specific, with the
>>> link created by the distro pkg scripts...?
>> 
>> Ted, your change broke any builds span 2 different filesystems.
> 
> I thought I fixed this with commit 1e082c62?
> 
> Which Makefile is breaking?  Is this the one in lib/et/Makefile.in?
> It currently reads:
> 
>  $(Q) (cd $(DESTDIR)$(includedir) ;\
>  	$(LN) $(LINK_INSTALL_FLAGS) et/com_err.h . )
> 
> and I don't see how that could have generated the error you've cited
> above...

I had to return the "-s" back as well, but the current code looks OK.
The chance of separate filesystems for /usr/include and /usr/include/et
being used seems vanishingly small.

Cheers, Andreas





