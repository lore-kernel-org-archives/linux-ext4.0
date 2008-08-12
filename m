From: Theodore Tso <tytso@mit.edu>
Subject: Re: tracepoints in ext4 (and/or ext3?)
Date: Mon, 11 Aug 2008 23:23:35 -0400
Message-ID: <20080812032335.GC21194@mit.edu>
References: <48A09E7F.7060605@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:42342 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751211AbYHLDX6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 11 Aug 2008 23:23:58 -0400
Content-Disposition: inline
In-Reply-To: <48A09E7F.7060605@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Aug 11, 2008 at 03:18:07PM -0500, Eric Sandeen wrote:
> As just an initial inquiry, I'm wondering how people would feel about
> putting some tracepoints (trace_mark()) into ext[34] for monitoring the
> fs behavior.

I think it's a great idea!  Do you have some specific tracepoints in
mind?

						- Ted
