From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstests: regression test for ext4 resize with
 non-extent files
Date: Fri, 10 May 2013 14:55:44 +1000
Message-ID: <20130510045544.GQ23072@dastard>
References: <518C1D08.4080309@redhat.com>
 <CA+dCu8_DtrqMy97u9NfHwCC8_-z9uSrF1oR3B=ej15gL6C=W+Q@mail.gmail.com>
 <518C6414.20800@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: guaneryu@gmail.com, ext4 development <linux-ext4@vger.kernel.org>,
	xfs-oss <xfs@oss.sgi.com>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:41292 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750824Ab3EJE4j (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 10 May 2013 00:56:39 -0400
Content-Disposition: inline
In-Reply-To: <518C6414.20800@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, May 09, 2013 at 10:05:56PM -0500, Eric Sandeen wrote:
> On 5/9/13 10:03 PM, Eryu Guan wrote:
> > On Fri, May 10, 2013 at 6:02 AM, Eric Sandeen <sandeen@redhat.com <mailto:sandeen@redhat.com>> wrote:
> > 
> 
> ...
> 
> >     index 53af708..4c3e2f4 100644
> >     --- a/tests/ext4/group
> >     +++ b/tests/ext4/group
> >     @@ -9,3 +9,4 @@
> >      303 aio dangerous ioctl rw stress
> >      304 aio dangerous ioctl rw stress
> >      305 auto
> >     +306 dangerous rw resize quick
> > 
> > 
> > I'm wondering why it's not in auto group :)
> 
> 
> because I forgot about auto! :)
> 
> But it's also somewhat dangerous; it could oops or hang, so perhaps
> auto is not a good idea.

If the bug has already been fixed, then auto rather than dangerous
should be used. If the hang/panic cannot be fixed, or is going to
take some time to be fixed, that's when dangerous should be used.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
