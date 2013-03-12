From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: a problem about ext4.
Date: Tue, 12 Mar 2013 09:42:29 -0400
Message-ID: <20130312134229.GJ18595@thunk.org>
References: <CAAO_Xo5g2LR54ry=SU7UhGbv-chdkdd6foq+-LjnuE8yAj8ikg@mail.gmail.com>
 <513EDC2B.9020604@gmail.xom>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: zhuyj <zyjzyj2000@gmail.xom>, linux-ext4@vger.kernel.org
To: zhuyj <zyjzyj2000@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:52843 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753694Ab3CLNmc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 12 Mar 2013 09:42:32 -0400
Content-Disposition: inline
In-Reply-To: <513EDC2B.9020604@gmail.xom>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Mar 12, 2013 at 03:41:31PM +0800, zhuyj wrote:
> If I use kernel>=3.0, this will not occur.

Sounds like this is a problem in 2.6.39 that has since been fixed in
newer kernels.

> So is this is a bug?

Sure looks like it's a bug.  :-)

There are so many distributions and other old embedded systems, etc.,
using older kernels that there's just no way that upstream developers
can try to debug every single older kernel --- and 2.6.39 isn't even a
kernel that is being supported by a volunteer as a long-term supported
kernel.

See http://www.kernel.org for a list of kernels which are supported as
long-term kernels, and even then, please remember that unless fixes
are automatically backported, or someone manually backports a fix that
doesn't automatically apply to an older kernel, it's not going to
happen.....

Regards,

					- Ted

P.S.  Your problem appears to be completely unrelated to the thread
which you replied to.  This makes it hard for us to keep track of
questions/bug reports which users submit.
