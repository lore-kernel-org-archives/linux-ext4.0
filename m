From: Jan Kara <jack@suse.cz>
Subject: Re: writev corruption and 64-bit quota patches for 2.6.33-rc1?
Date: Wed, 9 Dec 2009 11:08:38 +0100
Message-ID: <20091209100837.GA4863@quack.suse.de>
References: <20091208110043.GC4095@quack.suse.de>
 <87ein5bdpu.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org, tytso@mit.edu
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:45602 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754930AbZLIKIh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 9 Dec 2009 05:08:37 -0500
Content-Disposition: inline
In-Reply-To: <87ein5bdpu.fsf@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hi,

On Tue 08-12-09 20:03:09, Dmitry Monakhov wrote:
> Jan Kara <jack@suse.cz> writes:
> >   Hi Ted,
> >
> >   do you plan on merging my fixes for writev filesystem corruption and
> > 64-bit quota patches? The writev patch is independent of any other patch
> > and should go in ASAP, 64-bit quota patch depends on generic quota code
> BTW, where can I find this changes for generic quota code.
> Your linux-quota-2.6.git disappeared from kernel.org couple weeks ago,
> so I can't find in anywhere.
  There's linux-fs-2.6.git which now carries also the quota changes (they
are scarce enough that I've decided to merge quota tree into my
linux-fs-2.6 tree).

									Honza
