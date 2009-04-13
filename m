From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH, RFC 2/2] ext4: Convert instrumentation from markers to
	tracepoints
Date: Mon, 13 Apr 2009 06:14:56 -0400
Message-ID: <20090413101456.GA4716@infradead.org>
References: <1239479167-804-1-git-send-email-tytso@mit.edu> <1239479167-804-2-git-send-email-tytso@mit.edu> <20090413065910.GA23795@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:49826 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756079AbZDMKO5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 13 Apr 2009 06:14:57 -0400
Content-Disposition: inline
In-Reply-To: <20090413065910.GA23795@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Apr 13, 2009 at 12:29:10PM +0530, Aneesh Kumar K.V wrote:
> We moved all the ext4 headers to fs/ext4/  Can this be
> fs/ext4/ext4_trace_types.h ?

With the current event tracer in mainline those files get included
into kernel/trace/events.o so it is required to be global.  Steve
has some patches in his queue to allow TRACE_EVENT to work in
modules which losens that requirement.  Last time I talked to him
he still wants to have the headers in include/trace/ as a policy
but I hope we can get away from that.

