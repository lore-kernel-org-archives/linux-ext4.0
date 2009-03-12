From: Andreas Dilger <adilger@sun.com>
Subject: Re: e2fsprogs w/64-bit patches: make check gets one failure
Date: Wed, 11 Mar 2009 22:02:10 -0600
Message-ID: <20090312040210.GQ3199@webber.adilger.int>
References: <12304.1236797612@alphaville.usa.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org
To: Nick Dokos <nicholas.dokos@hp.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:42373 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750754AbZCLECZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 12 Mar 2009 00:02:25 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n2C42Nx4003590
	for <linux-ext4@vger.kernel.org>; Wed, 11 Mar 2009 21:02:23 -0700 (PDT)
Content-disposition: inline
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java(tm) System Messaging Server 7.0-5.01 64bit (built Feb 19 2009))
 id <0KGD00700KE62G00@fe-sfbay-10.sun.com> for linux-ext4@vger.kernel.org; Wed,
 11 Mar 2009 21:02:23 -0700 (PDT)
In-reply-to: <12304.1236797612@alphaville.usa.hp.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mar 11, 2009  14:53 -0400, Nick Dokos wrote:
> I followed the workflow that Ted described in the following message:
> 
>    http://marc.info/?l=linux-ext4&m=123367642710241&w=2
> 
> with the patch series from git://github.com/tytso/e2fsprogs-64bit.git
> 
> With all the patches in the series file applied, make check gives
> me the following error:
> 
> ...
> f_h_reindex: reindex HTREE Directory with different hash seed: failed
> ...
> 100 tests succeeded	1 tests failed
> make[1]: *** [check] Error 1
> make[1]: Leaving directory `/home/nick/src/e2fsprogs/standard/build/tests'
> make: *** [check-recursive] Error 1

Including the content of the tests/f_h_reindex.failed file might make
the problem obvious.  Possibly it is just some change in the output
format that is causing expect to fail.

> I bisected the series and found that the culprit seems to be
> 
>   0024-Miscellaneous-e2fsck-related-64-bit-fixes.patch
> 
> Unfortunately, a bunch of later patches don't apply cleanly without
> this one, so the most complete series file that does not get the
> error is the following - uncommenting 0024 gives the error:

Well, "make check" should pass after every patch in the series, so the
fact that later ones do not pass is irrelevant.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

