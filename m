From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/5] ext4: fix removing status extents in
 ext4_collapse_range()
Date: Fri, 18 Apr 2014 10:44:36 -0400
Message-ID: <20140418144436.GC19131@thunk.org>
References: <004401cf59ff$ff136f30$fd3a4d90$@samsung.com>
 <005e01cf5a01$78bc0990$6a341cb0$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: 'Lukas Czerner' <lczerner@redhat.com>, linux-ext4@vger.kernel.org
To: Namjae Jeon <namjae.jeon@samsung.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:48225 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751143AbaDROoi (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 18 Apr 2014 10:44:38 -0400
Content-Disposition: inline
In-Reply-To: <005e01cf5a01$78bc0990$6a341cb0$@samsung.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Apr 17, 2014 at 02:54:18PM +0900, Namjae Jeon wrote:
> > Currently in ext4_collapse_range() when calling ext4_es_remove_extent() to
> > remove status extents we're passing (EXT_MAX_BLOCKS - punch_start - 1)
> > in order to remove all extents from start of the collapse range to the
> > end of the file. However this is wrong because we might miss the
> > possible extent covering the last block of the file.
> > 
> > Fix it by removing the -1.
> > 
> > Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> Looks good to me! 
> 
> Reviewed-by: Namjae Jeon <namjae.jeon@samsung.com>

Thanks, applied.

					- Ted
