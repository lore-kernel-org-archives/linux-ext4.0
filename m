From: Theodore Tso <tytso@mit.edu>
Subject: Re: Simple inode question (ext2/3)
Date: Wed, 25 Feb 2009 09:38:21 -0500
Message-ID: <20090225143821.GH7064@mit.edu>
References: <20090224210515.GA7064@mit.edu> <alpine.DEB.2.00.0902242148450.13652@pintail.doc.ic.ac.uk> <20090225040654.GT3199@webber.adilger.int> <417E5333-32B8-42AA-A498-011DF1DDB074@doc.ic.ac.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@sun.com>, linux-ext4@vger.kernel.org
To: Felipe Franciosi <ozzy@doc.ic.ac.uk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:33561 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753627AbZBYOi1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 25 Feb 2009 09:38:27 -0500
Content-Disposition: inline
In-Reply-To: <417E5333-32B8-42AA-A498-011DF1DDB074@doc.ic.ac.uk>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Feb 25, 2009 at 10:59:22AM +0000, Felipe Franciosi wrote:
> As a matter of fact, I didn't see any critics to the question below. I  
> can only assume that messing with inodes can look academic or not  
> depending on the phase of the moon or something.
>
> On 6 Jan 2009, at 10:36, Rohit Sharma wrote:
>> I want to read data blocks from one inode
>> and copy it to other inode.
>>
>> I mean to copy data from data blocks associated with one inode
>> to the data blocks associated with other inode.
>>
>> Is that possible in kernel space.?
>> --

Actually, I asked Rohit what they were doing back September, 2008.

http://article.gmane.org/gmane.comp.file-systems.ext4/9142

Personally, I'm not really convinced by the approach which the fscops
project is adopting, but that's up to them to figure out.  I was
amused though by their powerpoint slides which claim that they are "on
the way to being accepted in the mainline kernel" --- that seems a
little gradious, given that they haven't even submitted any code for
review yet.

					- Ted
