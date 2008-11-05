From: Theodore Tso <tytso@mit.edu>
Subject: Re: data corruption with ext4 (from 2.6.27.4) exposed by rtorrent
Date: Wed, 5 Nov 2008 14:57:13 -0500
Message-ID: <20081105195713.GB9266@mit.edu>
References: <3d3ce57e0811030442o377cf2bet212eefba79d714bb@mail.gmail.com> <20081103134008.GE29102@mit.edu> <319012f0811030734s6d14b2b3t13c32a41ac48e852@mail.gmail.com> <20081103165144.6514f003@starbug.prg01.itonis.net> <18705.63392.489856.682976@frecb006361.adech.frec.bull.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jindrich Makovicka <makovick@gmail.com>, linux-ext4@vger.kernel.org
To: Solofo.Ramangalahy@bull.net
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:51619 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755408AbYKET5R (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 5 Nov 2008 14:57:17 -0500
Content-Disposition: inline
In-Reply-To: <18705.63392.489856.682976@frecb006361.adech.frec.bull.fr>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Nov 05, 2008 at 08:44:32PM +0100, Solofo.Ramangalahy@bull.net wrote:
> Hi Jindrich,
> 
> Jindrich Makovicka writes:
>  > The following testcase was used to trigger the infamous MAP_SHARED
>  > dirty flag bug. Maybe it could be of some help here too:
>  > 
>  > http://lkml.org/lkml/2006/12/27/180
> 
> Thanks for remembering!
> 
> The test case triggers corruption with 2.6.28-rc3 + ext4 patch queue:
> . bunch of errors like
>   Chunk 71637 corrupted (0-1339)  (2756-4095)
>   Expected 213, got 0
>   with default mount.
> . nodelalloc is ok.

It's useful to know that you were able to trigger corruption using the
test case.

How much memory did you have on your system, and how much memory was
free when you ran the test case?  I wasn't able to reproduce it using
the test case, but I have 4 gigs of memory.  One theory which is
currently being kicked around is that it is a combination of delayed
allocation and memory pressure.  Disabling delayed allocation by
mounting with -o nodelalloc does seem to make the problem go away.
The next question is whether the problem is more easily triggerred
when under memory pressure.

						- Ted
