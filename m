From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.23-rc6: hanging ext3 dbench tests
Date: Mon, 24 Sep 2007 12:12:55 -0700
Message-ID: <20070924121255.2ef7ab3a.akpm@linux-foundation.org>
References: <20070911124202.GI9556@shadowen.org>
	<alpine.LFD.0.999.0709110949250.16478@woody.linux-foundation.org>
	<20070911173049.GA10499@shadowen.org>
	<20070914094905.GA32670@shadowen.org>
	<20070919181546.GA4343@shadowen.org>
	<1190656918.13955.7.camel@dyn9047017100.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Andy Whitcroft <apw@shadowen.org>,
	Linus Torvalds <torvalds@linux-foundation.org>, sct@redhat.com,
	adilger@clusterfs.com, ext4 <linux-ext4@vger.kernel.org>,
	lkml <linux-kernel@vger.kernel.org>, mel@csn.ul.ie,
	Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
	Oleg Nesterov <oleg@tv-sign.ru>
To: Badari Pulavarty <pbadari@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39288 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755322AbXIXTOe (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 24 Sep 2007 15:14:34 -0400
In-Reply-To: <1190656918.13955.7.camel@dyn9047017100.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, 24 Sep 2007 11:01:58 -0700
Badari Pulavarty <pbadari@gmail.com> wrote:

> Hi Andy,
> 
> I managed to reproduce the dbench problem. (not sure if its the same
> thing or not - but symptoms are same). My problem has nothing to do 
> with ext3. I can produce it on ext2, jfs also.
> 
> Whats happening on my machine is ..
> 
> dbench forks of 4 children and sends them a signal to start the work.
> 3 out of 4 children gets the signal and does the work. One of the child
> never gets the signal so, it waits forever in pause(). So, parent waits
> for a longtime to kill it.
> 
> BTW, I was trying to find out when this problem started showing up.
> So far, I managed to track it to 2.6.23-rc4. (2.6.23-rc3 doesn't seem
> to have this problem). I am going to do bi-sect and find out which
> patch caused this.
> 
> I am using dbench-2.0 which consistently reproduces the problem on
> my x86-64 box. Did you find anything new with your setup ?
> 

Thanks, Badari.  That sounds like a bit of a showstopper for 2.6.23.
Michal, do you have this regression in the dirt file?
