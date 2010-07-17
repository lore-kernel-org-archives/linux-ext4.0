From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] resize2fs: relax requirements for -P output a bit
Date: Sat, 17 Jul 2010 06:37:50 -0400
Message-ID: <20100717103750.GA4684@thunk.org>
References: <4C3B5EA0.3040904@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:51127 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751003Ab0GRHHz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 18 Jul 2010 03:07:55 -0400
Content-Disposition: inline
In-Reply-To: <4C3B5EA0.3040904@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jul 12, 2010 at 01:27:44PM -0500, Eric Sandeen wrote:
> Requiring an immediate pre-fsck before printing a minimum
> resize size seems a bit draconian; if the fs isn't clean or marked
> with error, then certainly, but for an informational minimum
> size, I don't think we need to require a fsck since last mount.
> 
> I had simply copied the checks from the actual resize path,
> previously.
> 
> Installers use this option (-P) to gather minimum resize info,
> and requiring an actual fsck before use just seems to go too far.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Makes sense.  I've added it to the e2fsprogs maint branch.

      	      	   	       - Ted
