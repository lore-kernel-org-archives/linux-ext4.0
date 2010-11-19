From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2] fs: Do not dispatch FITRIM through separate
 super_operation
Date: Fri, 19 Nov 2010 09:10:07 -0500
Message-ID: <20101119141007.GB25488__7679.3089313016$1290175852$gmane$org@infradead.org>
References: <1290065809-3976-1-git-send-email-lczerner@redhat.com>
 <20101118130630.GJ6178@parisc-linux.org>
 <20101118134804.GN5618@dhcp231-156.rdu.redhat.com>
 <20101118141957.GK6178@parisc-linux.org>
 <20101118142918.GA18510@infradead.org>
 <1290100750.3041.72.camel@mulgrave.site>
 <alpine.LFD.2.00.1011181826550.15886@dhcp-lab-213.englab.brq.redhat.com>
 <1290168976.2570.45.camel@dolmen>
 <4CE68155.50705@teksavvy.com>
 <20101119140203.GC10039@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Ted Ts'o <tytso@mit.edu>, Mark Lord <kernel@teksavvy.com>,
	Steven Whitehouse <swhiteho@redhat.com>,
	Lukas Czerner <lczerner@redhat.com>,
	James Bottomley <James.Bottomley@suse.de>,
	Ch
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:54774 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754554Ab0KSOKL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 19 Nov 2010 09:10:11 -0500
Content-Disposition: inline
In-Reply-To: <20101119140203.GC10039@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Nov 19, 2010 at 09:02:03AM -0500, Ted Ts'o wrote:
> Deterministic TRIM is an option.  It doesn't have to be implemented.

For reasonable use it has to.  That rationale for it is pretty clearly
outline in ftp://ftp.t10.org/t10/document.08/08-347r1.pdf.

