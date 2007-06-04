From: Theodore Tso <tytso@mit.edu>
Subject: Re: Failures in e2fsprogs-1.39-tyt3 'make check'
Date: Mon, 4 Jun 2007 08:51:09 -0400
Message-ID: <20070604125109.GA20342@thunk.org>
References: <46497.24764.qm@web606.biz.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Kirk True <kirk@mustardgrain.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:56062 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751976AbXFDMvc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 4 Jun 2007 08:51:32 -0400
Content-Disposition: inline
In-Reply-To: <46497.24764.qm@web606.biz.mail.mud.yahoo.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Jun 04, 2007 at 01:18:23AM -0700, Kirk True wrote:
> Hi all,
> 
> I'm getting some errors in the 'make check' step when building 
> e2fsprogs-1.39-tyt3. Many of the errors look to be as a result of
> missing image files, for example:
> 
>     f_orphan_dotdot_ft: filetype of .. in orphaned directories: 
>     ../../tests/run_e2fsck: line 43: 
>     ../../tests/f_orphan_dotdot_ft/image.gz: No such file or directory
>     rm: cannot remove `./test.img': No such file or directory
> 
> Sorry if this is a documented, known issue. I'm just being paranoid and
> don't want to do a 'make install' if it will hose up the box.

Yes, it's known.  Note that e2fsprogs 1.39-tyt3 is really only meant
for ext4 developers.  If you're not trying to use ext4 (and it's
really not meant for production use yet), you should be using
e2fsprogs.1.39 or e2fsprogs WIP-20070407.

Regards,

						- Ted
