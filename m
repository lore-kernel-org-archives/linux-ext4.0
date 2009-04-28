From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH 1/2] have e2fsck/problem.c verify problem.h error codes
Date: Tue, 28 Apr 2009 13:03:03 -0600
Message-ID: <20090428190303.GB18963@webber.adilger.int>
References: <20090427225924.GG3209@webber.adilger.int>
 <20090428020805.GF22104@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:52830 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753866AbZD1TDV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 28 Apr 2009 15:03:21 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n3SJ3JWp017743
	for <linux-ext4@vger.kernel.org>; Tue, 28 Apr 2009 12:03:19 -0700 (PDT)
Content-disposition: inline
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java(tm) System Messaging Server 7.0-5.01 64bit (built Feb 19 2009))
 id <0KIT00900R2WJV00@fe-sfbay-10.sun.com> for linux-ext4@vger.kernel.org; Tue,
 28 Apr 2009 12:03:19 -0700 (PDT)
In-reply-to: <20090428020805.GF22104@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Apr 27, 2009  22:08 -0400, Theodore Ts'o wrote:
> On Mon, Apr 27, 2009 at 04:59:24PM -0600, Andreas Dilger wrote:
> > We've hit a number of cases where the error codes in problem.h have
> > been assigned duplicate values compared to problems in our own e2fsck
> > patches, and this can lead to confusing and difficult to find bugs
> > in e2fsck (e.g. wrong problem messages, incorrect repair action, etc).
> > 
> > Attached is a test case for the problem.c file to ensure that the
> > problem table is sorted and does not contain any duplicate values.
> > Having the problem table sorted allows the correctness checking to be
> > very simple, and if it ever became important for performance we could
> > use binary searching of the problem table for the specific problem code.
> 
> Hmm, I wonder if we should be doing this a different way.  Maybe what
> we should do is to have a single file, call it problem_codes.in, that
> has a format somewhat like this:
> 
> DEFINE_PROBLEM(PR_1_ROOT_NO_DIR, 0x010001, "@r is not a @d.  ", 
> 	       PROMPT_CLEAR, 0)

I was wondering the same, but that would involve a huge amount of
code churn and it probably isn't something you'd accept from someone
else in the end...  It would still likely be desirable to have some
indicator of which phase the problem is related to.

> ... which then generates problem_code.h and problem_code.c.  That way
> there is a single place where these things are defined, and it
> wouldn't be that hard to create a perl script which looks for multiply
> assigned problem assignments.
> 
> In the short term, we can also code up the test script much more
> simply:
> 
> awk '/^#define/ {print $3}' < e2fsck/problem.h   | sort | uniq -d

Sure, but my patch exists now, and doesn't add any overhead to the
runtime.  The fact that the test keeps the table sorted also allows
the ability to do a binary search on the table, should we want to.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

