From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] xfstests-bld: exclude ext4 defrag tests from unsupported
 configurations
Date: Wed, 10 Jun 2015 15:28:10 -0400
Message-ID: <20150610192810.GB24181@thunk.org>
References: <20150610181319.GA23530@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Eric Whitney <enwlinux@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:58411 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932757AbbFJT2N (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 10 Jun 2015 15:28:13 -0400
Content-Disposition: inline
In-Reply-To: <20150610181319.GA23530@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jun 10, 2015 at 02:13:19PM -0400, Eric Whitney wrote:
> Online defrag is not currently implemented for journaled data and
> bigalloc ext4 file systems.  The xfstests that exercise online defrag
> do not verify that the test file system supports that feature before
> executing, resulting in spurious test failures.  (In the case of
> ext4/307, the test reports success but actually fails because the
> e4compact test component is ignoring failures.)
> 
> For the time being, simply exclude these tests to eliminate the test
> failure noise.
> 
> Signed-off-by: Eric Whitney <enwlinux@gmail.com>

Thanks, applied.  BTW, I had since removed data_journal.exclude
because generic/068 should be passing with data journalling enabled.

		    	      	      	   - Ted
