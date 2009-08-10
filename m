From: Mingming <cmm@us.ibm.com>
Subject: Re: Data loss/corruption when using fallocate/ftruncate.
Date: Mon, 10 Aug 2009 14:10:39 -0700
Message-ID: <1249938639.4136.6.camel@mingming-laptop>
References: <1249930770.22656.14.camel@bobble.smo.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Frank Mayhar <fmayhar@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e37.co.us.ibm.com ([32.97.110.158]:48863 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753128AbZHJVKo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 10 Aug 2009 17:10:44 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e37.co.us.ibm.com (8.14.3/8.13.1) with ESMTP id n7AL9q12023659
	for <linux-ext4@vger.kernel.org>; Mon, 10 Aug 2009 15:09:52 -0600
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id n7ALAgn6118474
	for <linux-ext4@vger.kernel.org>; Mon, 10 Aug 2009 15:10:42 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n7ALAgw7015782
	for <linux-ext4@vger.kernel.org>; Mon, 10 Aug 2009 15:10:42 -0600
In-Reply-To: <1249930770.22656.14.camel@bobble.smo.corp.google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 2009-08-10 at 11:59 -0700, Frank Mayhar wrote:
> Hello again, folks.  We've got an app that needs to use O_DIRECT for
> performance and is using fallocate() to make sure the files are all in
> one extent.  Unfortunately the end size isn't always the fallocated size
> so it has to do a truncate when it's done; the sequence is generally:
> 
> 	create(file)
> 	fallocate(file, KEEP_SIZE, 0, maxlen)
> 	write/write/write/write...
> 	fallocate(file, 0, 0. maxlen-minus a bit)
> 	ftruncate(file, actual-len)
> 
> We've been seeing some of these files end up all or partly zero after
> (but not before) the truncate.  After further analysis, it's clear that
> the last extent (possibly the only extent) is being marked uninit for
> some reason.  The actual blocks on disk are nonzero but due to the
> extent being marked uninit they are being read as zero.
> 
> Note that this isn't easy to reproduce; lots of other stuff is going on
> when this happens.  Our feeling is that there's a race somewhere, quite
> possibly between fallocate and ftruncate, but it's not clear.  Certainly
> a single-threaded application doesn't see this, nor does an application
> that uses mutexes to serialize access to the file.
> 
> This is a heads-up to point out a real problem.  We're still analyzing
> and trying to track down the bug but it may take a little while.


Which kernel you are running? Two month ago a similar data "lose" issue
caused by mismark an previously-preallocated-but-later-filled trunk as
uninitialized after truncate. The following patch has been in 2.6.31-rc1
http://lists.openwall.net/linux-ext4/2009/06/10/30

Mingming


