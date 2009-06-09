From: Michael Rubin <mrubin@google.com>
Subject: Re: Mild filesystem corruption on ext4 (no journal)
Date: Mon, 8 Jun 2009 21:15:01 -0700
Message-ID: <532480950906082115u77918911m2d44953014053c9b@mail.gmail.com>
References: <4A28F83F.4030704@tuffmail.co.uk> <4A292E61.3050204@gmail.com>
	 <20090605180125.GB6442@mit.edu>
	 <6601abe90906051442t294c2e79i3c6dc38c1d53e5e0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@mit.edu>, Aioanei Rares <krnl.list@gmail.com>,
	Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
	linux-ext4@vger.kernel.org,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Curt Wohlgemuth <curtw@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.33.17]:42624 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834AbZFIEPE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 9 Jun 2009 00:15:04 -0400
In-Reply-To: <6601abe90906051442t294c2e79i3c6dc38c1d53e5e0@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jun 5, 2009 at 2:42 PM, Curt Wohlgemuth<curtw@google.com> wrote:
> Just FYI: Frank Mayhar has recreated this issue in a recent kernel
> (though we're not seeing it with our 2.6.26 kernel + ext4 patches),
> and is actively working on it.

Sorry about this. We had a bunch of sick engineers in the last week or
so (including Frank). Hopefully he will be able to devote time to this
bug as he is getting back. We need it fixed for ourselves so we are
going to root cause it if no one beats us to it.

mrubin
