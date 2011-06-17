From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] e2fsprogs: create com_err.h symlink in includedir
Date: Fri, 17 Jun 2011 09:27:07 -0500
Message-ID: <4DFB643B.3020600@redhat.com>
References: <4D5C1103.8060403@redhat.com> <20110220231015.GA4001@thunk.org> <4D84C5C9.1060507@redhat.com> <4DFA69EB.3060907@redhat.com> <20110617023149.GD29725@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>, mitchb@mit.edu,
	Bruce Cassidy <bruce@whamcloud.com>
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:11218 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755401Ab1FQO1L (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 17 Jun 2011 10:27:11 -0400
In-Reply-To: <20110617023149.GD29725@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 6/16/11 9:31 PM, Ted Ts'o wrote:
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

Oh, maybe you did; I didn't see any reply to my original problem report,
and I didn't see the patch sent to the list (maybe I missed it?)

So I assumed it wasn't yet fixed, TBH I don't usually build cross-fs
that way so hadn't actually retested, sorry.  Seems like it should
be fine now, thanks.

As for Andreas' comment:

> I had to return the "-s" back as well, but the current code looks OK.
> The chance of separate filesystems for /usr/include and /usr/include/et
> being used seems vanishingly small.

my problem was actually during the RPM packaging, so a slightly different
situation.

-Eric

> Which Makefile is breaking?  Is this the one in lib/et/Makefile.in?
> It currently reads:
> 
>    $(Q) (cd $(DESTDIR)$(includedir) ;\
>    	$(LN) $(LINK_INSTALL_FLAGS) et/com_err.h . )
> 
> and I don't see how that could have generated the error you've cited
> above...
> 
> 						- Ted
> 
> 

