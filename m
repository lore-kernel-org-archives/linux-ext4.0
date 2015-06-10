From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] xfstests-bld: remove nojournal.exclude
Date: Wed, 10 Jun 2015 15:22:23 -0400
Message-ID: <20150610192223.GA24181@thunk.org>
References: <20150610181602.GB23530@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Eric Whitney <enwlinux@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:58393 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752543AbbFJTW2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 10 Jun 2015 15:22:28 -0400
Content-Disposition: inline
In-Reply-To: <20150610181602.GB23530@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jun 10, 2015 at 02:16:02PM -0400, Eric Whitney wrote:
> The xfstests listed in the nojournal.exclude file have all been modified
> so they will only run on a test file system that journals metadata.
> This prevents the spurious test failures previously seen when running
> these tests (including generic/034, generic/311, generic/321,
> generic/322, and generic/325) in the nojournal test configuration.
> 
> Remove nojournal.exclude since it's no longer needed to suppress test
> failure noise.
> 
> Signed-off-by: Eric Whitney <enwlinux@gmail.com>

This change is already in my git tree, but I see I haven't pushed out
an update in a while.

My apologies, I've just my tree to git.kernel.org.  The update
includes some changes assuming that e2fsprogs 1.43.x is used.

						- Ted
