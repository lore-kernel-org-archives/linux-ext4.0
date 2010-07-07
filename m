From: "Daniel Taylor" <Daniel.Taylor@wdc.com>
Subject: RE: inconsistent file placement
Date: Tue, 6 Jul 2010 18:08:53 -0700
Message-ID: <469D2D911E4BF043BFC8AD32E8E30F5B24AEDF@wdscexbe07.sc.wdc.com>
References: <469D2D911E4BF043BFC8AD32E8E30F5B24AED8@wdscexbe07.sc.wdc.com> <20100706185548.GA26677@thunk.org> <4C337D16.9000200@redhat.com> <469D2D911E4BF043BFC8AD32E8E30F5B24AEDB@wdscexbe07.sc.wdc.com> <20100706231412.GA7646@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "Eric Sandeen" <sandeen@redhat.com>, <amir73il@gmail.com>,
	<linux-ext4@vger.kernel.org>
To: <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from wdscspam2.wdc.com ([129.253.170.131]:4481 "EHLO
	wdscspam2.wdc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751274Ab0GGBSX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 6 Jul 2010 21:18:23 -0400
Content-class: urn:content-classes:message
In-Reply-To: <20100706231412.GA7646@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> -----Original Message-----
> From: tytso@mit.edu [mailto:tytso@mit.edu] 
> Sent: Tuesday, July 06, 2010 4:14 PM
> To: Daniel Taylor
> Cc: Eric Sandeen; amir73il@gmail.com; linux-ext4@vger.kernel.org
> Subject: Re: inconsistent file placement
> 
> On Tue, Jul 06, 2010 at 03:15:00PM -0700, Daniel Taylor wrote:
> > 
> > It is an unfortunate fact of life that simplistic benchmarks often
> > drive sales.  This product will be a consumer NAS and when our
> > internal runs of the common NAS benchmarks get inconsistent results,
> > it creates a lot of concern.
> 
> Out of curiosity, what *are* the "common NAS benchmarks" in use today,
> and who chooses them?

The benchmarks are chosen by individual reviewers (probably looking over
each others' shoulders).  "smallnetbuilder.com" is a fairly good example.

FWIW:

1) NASPT, PC only
2) IOzone, Mac & PC
3) IOmeter, PC

BTW, the simple test sequence was trying to distill something that our
in-house performance tester was seeing in some SATA traces.  It is NOT
one of the "real" benchmarks.
 
> Speaking of fallocate.... if this is a NAS box than the file is
> probably written using CIFS, right?  Are you using a modern version of
> Samba?  

Currently, we're on 3.2.5 of smdb, but that's because the later versions
work less well with ext3.  We will be testing them with ext4 now that
we see the other options it offers.

Soon as I can get the fallocate utility cross-built, there are some
experiments that I want to run, but those will take a couple of days.

Thanks again for all of your help.
