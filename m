From: "Mike Snitzer" <snitzer@gmail.com>
Subject: Re: Online ext4 defragmention
Date: Mon, 12 Jan 2009 09:44:17 -0500
Message-ID: <170fa0d20901120644g3f208430y46d129facbebb38b@mail.gmail.com>
References: <20090111134443.581cfc83@lithium.local.net>
	 <20090111202838.GA29383@mit.edu>
	 <170fa0d20901120539w4e3bbc03na39f01edde206d25@mail.gmail.com>
	 <20090112141539.GD21793@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Alex Buell" <alex.buell@munted.org.uk>,
	"Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org
To: "Theodore Tso" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.24]:61196 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755081AbZALOoU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 12 Jan 2009 09:44:20 -0500
In-Reply-To: <20090112141539.GD21793@mit.edu>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 1/12/09, Theodore Tso <tytso@mit.edu> wrote:
> On Mon, Jan 12, 2009 at 08:39:33AM -0500, Mike Snitzer wrote:
>  >
>  > Hi Ted,
>  >
>  > Could you elaborate on which allocation patches you're referring to in
>  > the ext4 patch queue (2.6.28-ext4-3?) ?
>
>
> They haven't been implemented yet.  They've been discussed on the ext4
>  mailing list, however.  Basically, the Orlov algorithm was disabled
>  for flex_bg, and I want to optimize how directory blocks are allocated
>  to hopefully speed up fsck times a tad bit more.  The design has been
>  roughly worked out; but it's a matter of me finding time to code and
>  test it...

Ah, that ext4 thread is here:
http://kerneltrap.org/mailarchive/linux-ext4/2008/12/12/4403324

Thanks for clarifying,
Mike
