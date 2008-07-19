From: Theodore Tso <tytso@mit.edu>
Subject: Re: delalloc is crippling fs_mark performance
Date: Sat, 19 Jul 2008 13:20:15 -0400
Message-ID: <20080719172015.GB9424@mit.edu>
References: <4880C0B2.9040706@redhat.com> <4881207C.1040004@redhat.com> <48820BE2.6080800@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:51070 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754118AbYGSRUR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 19 Jul 2008 13:20:17 -0400
Content-Disposition: inline
In-Reply-To: <48820BE2.6080800@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Jul 19, 2008 at 10:44:34AM -0500, Eric Sandeen wrote:
> 
> With delalloc, the lg_prealloc list seems to just grow & grow in
> ext4_mb_use_preallocated, searching up to 90,000 entries before finding
> something, I think this is what's hurting - I need to look into how this
> should work.

Hmm, this may explain Holger's benchmark regressions.

							- Ted
