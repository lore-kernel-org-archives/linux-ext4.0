From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Possible ext4 data corruption with large files and async I/O
Date: Fri, 29 Jan 2010 09:30:53 -0600
Message-ID: <4B62FF2D.2070001@redhat.com>
References: <4B62F688.70404@vectorwise.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Giel de Nijs <giel@vectorwise.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52565 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753847Ab0A2Pa5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 29 Jan 2010 10:30:57 -0500
In-Reply-To: <4B62F688.70404@vectorwise.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Giel de Nijs wrote:
> Dear ext4 devs,
> 
> Today I hit a situation where seemingly blocks did not get written to
> disk. I've narrowed it down to the following test case.
> 
> Running Fedora Core 12 with kernel 2.6.31.9-174.fc12.x86_64, both on an
> i7 920 and a Core2 Q6600, I executed the following steps:
> 
> - create a file
> - with kernel async i/o, write a 512kb (haven't tried other sizes) block
> to an offset >4GB, effectively creating a large sparse file
> - again with async i/o, write a 512kb block to an offset smaller than
> the previous write, but >4GB
> - wait for the kernel async i/o to tell you the writes have succeeded
> 
> Now, looking at the file, the second write never seems to have happened.
> When doing this on the same machines on ext3, the behavior is as expected.
> 
> As far as I can tell (from the bigger program that triggered this), all
> writes >4GB but < EOF to a sparse file with async i/o aren't executed.
> When creating a large file first (i.e., with dd), everything does work
> as expected.
> 
> Attached is some C code that triggers this bug for me.
> 
> If you need more information or want me to test some more things, please
> do ask.

Thanks, I can reproduce this as well - and yep works ok on ext3 & xfs,
so looks like an ext4 bug indeed.  I'll look into it.

-Eric

> Thanks,
> Giel de Nijs
> VectorWise
> 

