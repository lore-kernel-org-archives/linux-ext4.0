From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: e2fsck extremly slow after: EXT4-fs.. ext4_check_descriptors:
 Checksum for group .. failed
Date: Thu, 8 Nov 2012 19:01:56 -0500
Message-ID: <20121109000156.GQ19977@thunk.org>
References: <CACDumsQsF4JoqygHT+8wQKz-=zuMPjTccrK1mnHnAZsf36O_Cg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "kaefert@gmail.com" <kaefert@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:60151 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757235Ab2KIAB7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 8 Nov 2012 19:01:59 -0500
Content-Disposition: inline
In-Reply-To: <CACDumsQsF4JoqygHT+8wQKz-=zuMPjTccrK1mnHnAZsf36O_Cg@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Nov 07, 2012 at 09:23:22AM +0100, kaefert@gmail.com wrote:
> Hi there!
> 
> I've got this problem with an ext4 filesystem on an external usb disk
> of mine, I've documented the problem (and my approaches for solving
> it) here:
> http://serverfault.com/questions/446074/e2fsck-extremly-slow-although-enough-memory-exists
> 
> I started gparted and with it e2fsck is around 2012-11-04_2200 and its
> 2012-11-07_0923 right now (CET).
> It used up nearly 57 hours of cpu time since then, and I would like to
> find out if and when it will finish.
> Can somebody tell me if and how I could get this information?

Can you please run e2fsck from the command line, and capture the
output (i.e., using "script").  I really need the e2fsck output to
understand what is going on.  The strace output is really not helpful.

In general, you may be better off simply not trusting gparted to run
e2fsck and resize2fs for you.  If there are no problems I'm sure it's
fine, but it's really hard to debug things if you insist on letting
gparted swallon all of the useful debugging output....

		       	   	  	    - Ted
