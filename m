From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Ubuntu Ext4 regression testing
Date: Wed, 12 Sep 2012 19:20:36 -0500
Message-ID: <505126D4.5030106@redhat.com>
References: <50511241.2090603@canonical.com> <5051142D.1050603@redhat.com> <5051177E.6000903@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, xfs-oss <xfs@oss.sgi.com>
To: Brad Figg <brad.figg@canonical.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:23943 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756220Ab2IMAUp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 12 Sep 2012 20:20:45 -0400
In-Reply-To: <5051177E.6000903@canonical.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 9/12/12 6:15 PM, Brad Figg wrote:
> I'm going to be doing some new runs so anything I find will be reported.

Dave Chinner also pointed out that i.e.

http://kernel.ubuntu.com/beta/testing/test-results/statler.2012-09-11_22-42-47/xfstests/default/control

seems to redefine, re-group, exclude etc various tests, and is taking "intelligence" out of the test suite itself.

I'd be wary of that; xfstests is dynamic - things get fixed, tests get added, groups changed, etc.

If you hard code for example "this test is for xfs" somewhere else, you might miss updates which add coverage.

Another example :

	    #'197' : ['xfs'],# This test is only valid on 32 bit machines

but the test handles that gracefully:

bitsperlong=`src/feature -w`
if [ "$bitsperlong" -ne 32 ]; then
        _notrun "This test is only valid on 32 bit machines"
fi

In general any test should be runnable; it may then issue 'not run' for some reason or other, but there's no harm in it - not as much harm as skipping regression tests because some config file got out of date...

and:

	    #'275' : ['generic'] # ext4 fails

but I just fixed that one up, and it should pass now.  Who will update the 3rd party config?

Failing tests absolutely should be run as well.  That information is as valuable as passing tests.  The goal is getting a complete picture, not just a series of "pass" results.  :)

-Eric
