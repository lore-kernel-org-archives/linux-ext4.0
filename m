From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] xfstests-bld: fix check script argument ordering bug
Date: Fri, 14 Oct 2016 12:25:30 -0400
Message-ID: <20161014162530.4fyhcvycteourlo6@thunk.org>
References: <20161012213812.GA8131@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Eric Whitney <enwlinux@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:33964 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754862AbcJNQ0N (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 14 Oct 2016 12:26:13 -0400
Content-Disposition: inline
In-Reply-To: <20161012213812.GA8131@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Oct 12, 2016 at 05:38:12PM -0400, Eric Whitney wrote:
> The check script called by runtests.sh in the test appliance to control
> xfstest execution requires that all optional arguments precede any test
> names on its command line.  Violation of this requirement results in an
> error message ("Arguments before tests, please!") and an immediate exit
> without test execution.
> 
> runtests.sh violates this requirement when it runs a specific test in a
> configuration that defines TEST_SET_EXCLUDE (contains -x argument).
> 
> To reproduce the bug, run "kvm-xfstests -c bigalloc generic/375".
> 
> Signed-off-by: Eric Whitney <enwlinux@gmail.com>

Thanks, applied!

					- Ted
