From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH] Make some ext3 kernel messages useful by showing device
Date: Mon, 09 Jun 2008 16:08:02 -0600
Message-ID: <20080609220802.GF3726@webber.adilger.int>
References: <1212951761.32756.4.camel@localhost>
 <20080609025926.0ecb6aea.akpm@linux-foundation.org>
 <484D3378.9090708@redhat.com>
 <20080609134918.ed83d0d7.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: Andrew Morton <akpm@linux-foundation.org>, lkml@metanurb.dk,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Eric Sandeen <esandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:50546 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751760AbYFIWI0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 9 Jun 2008 18:08:26 -0400
In-reply-to: <20080609134918.ed83d0d7.akpm@linux-foundation.org>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Eric Sandeen <sandeen@redhat.com> wrote:
> The patch itself looks fine to me, and is a good idea.  I recently saw a
> confused user on another fs where successful mount messages were
> followed by failure mount messages with no indication of which fs had
> the trouble...
> 
> There probably are more spots in extX which could use this treatment...
> should we maybe just be using ext3_warning in more places, which
> automatically prints the sb, function name, etc?

Most of the messages in ext[234]_fill_super() should really be ext3_error(),
but because the superblock isn't properly set up calling ext3_error() is a
way to oops the kernel.

Probably the cleanest solution is to split ext3_error() into a helper function
ext3_error_msg() that can be called from ext3_fill_super(), and the rest
of the code that now lives in ext3_handle_error().

Alternately, a flag could be set in the superblock ("EXT3_SETUP_DONE")
once everything is initialized, and then ext3_error() calls
ext3_handle_error(), and otherwise just prints the message and the
mount will fail by itself.  This has the benefit that we can use
ext3_error() everywhere there is a fatal problem, but the drawback that
it may become confusing due to the added "errors=*" semantics that will
not behave as they do in other functions.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

