From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 1/2] have e2fsck/problem.c verify problem.h error codes
Date: Mon, 27 Apr 2009 22:08:05 -0400
Message-ID: <20090428020805.GF22104@mit.edu>
References: <20090427225924.GG3209@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:41466 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759209AbZD1CIM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 27 Apr 2009 22:08:12 -0400
Content-Disposition: inline
In-Reply-To: <20090427225924.GG3209@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Apr 27, 2009 at 04:59:24PM -0600, Andreas Dilger wrote:
> We've hit a number of cases where the error codes in problem.h have
> been assigned duplicate values compared to problems in our own e2fsck
> patches, and this can lead to confusing and difficult to find bugs
> in e2fsck (e.g. wrong problem messages, incorrect repair action, etc).
> 
> Attached is a test case for the problem.c file to ensure that the
> problem table is sorted and does not contain any duplicate values.
> Having the problem table sorted allows the correctness checking to be
> very simple, and if it ever became important for performance we could
> use binary searching of the problem table for the specific problem code.

Hmm, I wonder if we should be doing this a different way.  Maybe what
we should do is to have a single file, call it problem_codes.in, that
has a format somewhat like this:

DEFINE_PROBLEM(PR_1_ROOT_NO_DIR, 0x010001, "@r is not a @d.  ", 
	       PROMPT_CLEAR, 0)

... which then generates problem_code.h and problem_code.c.  That way
there is a single place where these things are defined, and it
wouldn't be that hard to create a perl script which looks for multiply
assigned problem assignments.

In the short term, we can also code up the test script much more
simply:

awk '/^#define/ {print $3}' < e2fsck/problem.h   | sort | uniq -d

    		       	      			   - Ted
