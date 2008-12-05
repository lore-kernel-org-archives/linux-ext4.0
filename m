From: Theodore Tso <tytso@mit.edu>
Subject: Re: tune2fs -I seems dangerous
Date: Thu, 4 Dec 2008 20:25:23 -0500
Message-ID: <20081205012523.GD1323@mit.edu>
References: <49385927.9070003@redhat.com> <4938645C.5010601@x2a.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Jonathan Bastien-Filiatrault <joe@x2a.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:50770 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752022AbYLEBZh (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 4 Dec 2008 20:25:37 -0500
Content-Disposition: inline
In-Reply-To: <4938645C.5010601@x2a.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Dec 04, 2008 at 06:14:36PM -0500, Jonathan Bastien-Filiatrault wrote:
> I have had a similar experience converting from 128 to 256 bytes inodes.
> After a while, tune2fs -I would simply stop doing IO and using a lot of
> CPU with a few IO bursts every half-hour or so. This is on a recent/fast
> x86-64 computer. I had to cancel the thing after leaving it running for
> over 24 hours.

The speed problems have been reported and mostly addressed in the
e2fsprogs git repository.  There's one more patch that should
completely solve the tune2fs -I performance problem, but I haven't had
time to audit the patch just yet.  It is on my to do list.

     	      	  	     	      	       	  - Ted
