From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/3] Fiemap, an extent mapping ioctl
Date: Wed, 10 Sep 2008 11:46:12 -0700
Message-ID: <20080910114612.314978a8.akpm@linux-foundation.org>
References: <20080825202250.GY3392@webber.adilger.int>
	<20080910124005.GA4563@wotan.suse.de>
	<20080910124934.GB4563@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger@sun.com>,
	Eric Sandeen <esandeen@redhat.com>, linux-ext4@vger.kernel.org
To: Mark Fasheh <mfasheh@suse.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55200 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751377AbYIJSqb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 10 Sep 2008 14:46:31 -0400
In-Reply-To: <20080910124934.GB4563@wotan.suse.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 10 Sep 2008 05:49:34 -0700 Mark Fasheh <mfasheh@suse.com> wrote:

> Hello,
> 
> 	The following patches are the latest attempt at implementing a
> fiemap ioctl, which can be used by userspace software to get extent
> information for an inode in an efficient manner.

As these are applicable to all filesystems, Cc:ing only linux-ext4 is
not sufficient.  All filesystem developers (at least) need an
opportunity to review and understand these changes.

> 
> ...
>
> The fiemap ioctl is an efficient method for userspace to get file
> extent mappings. Instead of block-by-block mapping (such as bmap), fiemap
> returns a list of extents.
> 

The above is, afacit, the only offered rationale for the addition of
these new feature.  I don't recall seeing anyone complain about bmap()
inefficiency.  In fact I rarely hear of anyone using bmap() at all.

This rationale needs expanding, please.  A lot.
