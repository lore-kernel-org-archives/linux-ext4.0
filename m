From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] xfstests-bld:  remove inline.exclude
Date: Wed, 10 Jun 2015 15:28:32 -0400
Message-ID: <20150610192832.GC24181@thunk.org>
References: <20150610181804.GC23530@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Eric Whitney <enwlinux@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:58416 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933519AbbFJT2e (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 10 Jun 2015 15:28:34 -0400
Content-Disposition: inline
In-Reply-To: <20150610181804.GC23530@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jun 10, 2015 at 02:18:04PM -0400, Eric Whitney wrote:
> Once upon a time, xfstest generic/027 would fail consistently when run
> in the inline test configuration, and an inline.exclude file was
> created containing it to suppress the resulting failure messages.
> However, generic/027 has been running and completing successfully in
> weekly -rc regression runs for more than six months on test systems
> not using the exclude file.  We should be able to stop excluding it now.
> 
> Signed-off-by: Eric Whitney <enwlinux@gmail.com>

This is already in my tree, thanks.

						- Ted
