From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Ubuntu Ext4 regression testing
Date: Wed, 12 Sep 2012 18:01:01 -0500
Message-ID: <5051142D.1050603@redhat.com>
References: <50511241.2090603@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, xfs-oss <xfs@oss.sgi.com>
To: Brad Figg <brad.figg@canonical.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39274 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750958Ab2ILXBG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 12 Sep 2012 19:01:06 -0400
In-Reply-To: <50511241.2090603@canonical.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Brad -

(cc: xfs list too)

On 9/12/12 5:52 PM, Brad Figg wrote:
> 
> The Ubuntu kernel team has been putting some automated testing
> infrastructure in place. We are very interested in engaging with
> the appropriate upstream developers. We have been running the
> xfstests that come as part of the autotest testing framework.
> Some of these tests fail or never complete when run against an
> Ext4 file-system. 

Which ones?  Feel free to file bugs or send mail.  Tests should pass.
Sometimes it's a test bug, though, of course ;)

> Our initial questions are:
> 
> 1. Is this an appropriate set of tests to be run as regression
>    tests?

Yes, that's what it's for!

> 2. Is there a list of the xfstests that are appropriate for
>    Ext4?

Any test which says

_supported_fs generic
or
_supported_fs ext4

can run on ext4, and should in theory pass.  I think there are
about 100 of them by now.

There is a "dangerous" group (see groups file) which contains test nrs that
might stop testing via a hang or panic.  But don't skip those by
default; newer kernels with those bugs fixed _should_ pass them too.

> 3. Are there additional regression tests that would be beneficial
>    to the Linux community for us to be running?

We've been encouraging new tests to be written for xfstests lately,
and it's gotten a good amount of traction.  There certainly may be
other things out there, though.

-Eric


> Test results can be found at:
>     http://kernel.ubuntu.com/testing/index.html
> 
> 
> Thanks
> Brad
> 

