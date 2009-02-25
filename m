From: Andreas Dilger <adilger@sun.com>
Subject: Re: Simple inode question (ext2/3)
Date: Tue, 24 Feb 2009 21:06:54 -0700
Message-ID: <20090225040654.GT3199@webber.adilger.int>
References: <20090224210515.GA7064@mit.edu>
 <alpine.DEB.2.00.0902242148450.13652@pintail.doc.ic.ac.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Felipe Franciosi <ozzy@doc.ic.ac.uk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:37670 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753002AbZBYEHN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 24 Feb 2009 23:07:13 -0500
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n1P4786u021741
	for <linux-ext4@vger.kernel.org>; Tue, 24 Feb 2009 20:07:08 -0800 (PST)
Content-disposition: inline
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java(tm) System Messaging Server 7.0-3.01 64bit (built Dec 23 2008))
 id <0KFL00000SO8SW00@fe-sfbay-10.sun.com> for linux-ext4@vger.kernel.org; Tue,
 24 Feb 2009 20:07:08 -0800 (PST)
In-reply-to: <alpine.DEB.2.00.0902242148450.13652@pintail.doc.ic.ac.uk>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Feb 24, 2009  21:48 +0000, Felipe Franciosi wrote:
>> This isn't for some college class, is it?
>
> No, it is not. Where would you get that idea from?

Because there are lots of questions like this from university
students that would rather have the mailing list do their
homework for them.

> To be very honest with you, I don't see why you are wasting your time
> questioning me about these things instead of simply answering what I've
> asked or saying something like: "Have a look at brelse() and the inode
> bitmap manipulation routines used in ialloc.c".
>
> I'm beginning to believe you didn't know the answers to my questions,
> Ted. How sad.

How sad that you have just been rude one of the main ext2/3/4 developers,
e2fsprogs maintainer, and one of the most senior Linux kernel developers.

I would suggest that you look at what ext2_iget->ext2_get_inode() is doing.
You will have a hard time getting much help from the list unless you change
your attitude.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

