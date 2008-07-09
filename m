From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] do not set extents feature from the kernel
Date: Tue, 8 Jul 2008 23:10:49 -0400
Message-ID: <20080709031049.GH9957@mit.edu>
References: <48727954.1080406@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:58640 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752952AbYGIDKz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 8 Jul 2008 23:10:55 -0400
Content-Disposition: inline
In-Reply-To: <48727954.1080406@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jul 07, 2008 at 03:15:16PM -0500, Eric Sandeen wrote:
> We've talked for a while about getting rid of any feature-
> setting from the kernel; this gets rid of the code which would
> set the INCOMPAT_EXTENTS flag on the first file write when mounted
> as ext4[dev].
> 
> With this patch, if the extents feature is not already set on disk,
> then mounting as ext4 will fall back to noextents with a warning,
> and if -o extents is explicitly requested, the mount will fail,
> also with warning.
> 

Looks good, I've added it to the patch queue.

						- Ted
