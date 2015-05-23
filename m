From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] e2fsprogs: use $DUMPE2FS in resize_test script
Date: Sat, 23 May 2015 18:40:10 -0400
Message-ID: <20150523224010.GA3572@thunk.org>
References: <55353E6F.7020406@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:54796 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751000AbbEWWkO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 23 May 2015 18:40:14 -0400
Content-Disposition: inline
In-Reply-To: <55353E6F.7020406@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Apr 20, 2015 at 12:59:11PM -0500, Eric Sandeen wrote:
> Use $DUMPE2FS in resize tests to be sure it's testing
> the in-tree dumpe2fs, not the system dumpe2fs (which may
> not even be there...)
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Applied, thanks

					- Ted
