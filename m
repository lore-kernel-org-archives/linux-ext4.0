From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: fix a big-endian bug when an extent is zeroed out
Date: Wed, 3 Apr 2013 10:41:14 -0400
Message-ID: <20130403144114.GB13668@thunk.org>
References: <alpine.DEB.2.10.1304012249440.5874@trent.utfs.org>
 <877gkls1q7.fsf@openvz.org>
 <alpine.DEB.2.10.1304021430480.13746@trent.utfs.org>
 <87r4isd1vn.fsf@openvz.org>
 <alpine.DEB.2.10.1304021611020.13746@trent.utfs.org>
 <87li90q9mx.fsf@openvz.org>
 <87hajoq6s2.fsf@openvz.org>
 <20130403102204.GA15383@gmail.com>
 <20130403122058.GB7741@thunk.org>
 <20130403143406.GA3006@wallace>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dmitry Monakhov <dmonakhov@openvz.org>,
	Christian Kujau <lists@nerdbynature.de>,
	CAI Qian <caiqian@redhat.com>,
	LKML <linux-kernel@vger.kernel.org>,
	linux-s390 <linux-s390@vger.kernel.org>,
	Steve Best <sbest@redhat.com>, linux-ext4@vger.kernel.org
To: Eric Whitney <enwlinux@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:58937 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758968Ab3DCOlU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 3 Apr 2013 10:41:20 -0400
Content-Disposition: inline
In-Reply-To: <20130403143406.GA3006@wallace>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Apr 03, 2013 at 10:34:06AM -0400, Eric Whitney wrote:
> 
> The TI OMAP4 processor on my Pandaboard test system is little endian.

Ah... so basically, we need to find a test platform which allows us to
boot arbitrary kernels and allows us to have root access (which means
it's unlikely we'll be able to do this via remote access) and which
doesn't have exotic power requirements (which as far as I know rules
out pSeries and zSeries systems....) 

It would also be nice if we could run tests in finite time, which
probably rules out the Hercules emulator (it runs at one-tenth zSeries
processor speeds, which doesn't win speed competitions by default, and
I suspect their storage speeds are even worse).

Anyone else have any suggestions?  Or anyone willing to help us run
ext4 regression tests on the ext4 dev tree, so we can find these
problems before we merge into mainline?

Thanks,

						- Ted
