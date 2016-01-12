From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstests-bld: add exclude file for data_journal_noleak
 tests
Date: Wed, 13 Jan 2016 07:35:54 +1100
Message-ID: <20160112203554.GH6033@dastard>
References: <20160112195248.GA1941@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
To: Eric Whitney <enwlinux@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:61846 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753752AbcALUf5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 12 Jan 2016 15:35:57 -0500
Content-Disposition: inline
In-Reply-To: <20160112195248.GA1941@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jan 12, 2016 at 02:52:48PM -0500, Eric Whitney wrote:
> Duplicate the contents of the data_journal exclude file for the
> data_journal_noleak test case.  This will prevent failure reports from
> tests already known to exercise unsupported online defrag functionality.
> Add an explanatory comment to both exclude files for future reference.
> 
> Signed-off-by: Eric Whitney <enwlinux@gmail.com>

Can you please make these changes directly to xfstests rather than
keeping information about what tests run under what circumstances in
some external test wrapper?  i.e. this can be implementing by adding
a _requires_no_data_journal() check and adding it to each test.

That way every one who runs xfstests on ext4 benefit from this
exclusion, rather than just kvm-xfstests users.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
