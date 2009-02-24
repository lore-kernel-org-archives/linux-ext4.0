From: Felipe Franciosi <ozzy@doc.ic.ac.uk>
Subject: Re: Simple inode question (ext2/3)
Date: Tue, 24 Feb 2009 21:48:45 +0000 (GMT)
Message-ID: <alpine.DEB.2.00.0902242148450.13652@pintail.doc.ic.ac.uk>
References: <20090224210515.GA7064@mit.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from baza.doc.ic.ac.uk ([146.169.1.193]:49005 "EHLO
	baza.doc.ic.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753220AbZBXWF5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 24 Feb 2009 17:05:57 -0500
In-Reply-To: <20090224210515.GA7064@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 24 Feb 2009, Theodore Tso wrote:

> Yeah, but this is a really bad idea.

I am sure there are tools like debugfs that are capable of doing this in a much fashionable way, but that's not what I've asked and not what we should be discussing, is it?

>   Practice for *what*?

I'm studying the kernel and the ext3fs in order to consider using it as a prototype for some ideas regarding my PhD. Therefore I'm practising developing modules, handling filesystem structures in different ways and the communication with user space using chardevs, debugfs and procfs. It's called PRACTICE. That's usually how people learn things and consolidate knowledge. If I was developing some secret project for NASA, do you really think I would e-mail you to ask these things!?

> This isn't for some college class, is it?

No, it is not. Where would you get that idea from?

To be very honest with you, I don't see why you are wasting your time questioning me about these things instead of simply answering what I've asked or saying something like: "Have a look at brelse() and the inode bitmap manipulation routines used in ialloc.c".

I'm beginning to believe you didn't know the answers to my questions, Ted. How sad.

My very best regards,
Felipe

p.s. if *anyone else* in the list can help me, feel free to reply directly to me and discuss the matter.

