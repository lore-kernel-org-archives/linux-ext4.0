From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/3 v2] fs: Prevent doing FALLOC_FL_ZERO_RANGE on append
 only file
Date: Tue, 15 Apr 2014 22:51:34 -0400
Message-ID: <20140416025134.GB21807@thunk.org>
References: <1397580076-19826-1-git-send-email-lczerner@redhat.com>
 <1397580076-19826-2-git-send-email-lczerner@redhat.com>
 <20140415220220.GR15995@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Lukas Czerner <lczerner@redhat.com>, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org, xfs@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:54904 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751099AbaDPCvn (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 15 Apr 2014 22:51:43 -0400
Content-Disposition: inline
In-Reply-To: <20140415220220.GR15995@dastard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Apr 16, 2014 at 08:02:20AM +1000, Dave Chinner wrote:
> On Tue, Apr 15, 2014 at 06:41:15PM +0200, Lukas Czerner wrote:
> > Currently punch hole and collapse range fallocate operation are not
> > allowed on append only file. This should be case for zero range as well.
> > Fix it by allowing only pure fallocate (possibly with keep size set).
> > 
> > Signed-off-by: Lukas Czerner <lczerner@redhat.com>

Thanks, updated with Dave's suggested added parenthesis.

						- Ted
