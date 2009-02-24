From: Felipe Franciosi <ozzy@doc.ic.ac.uk>
Subject: Re: Simple inode question (ext2/3)
Date: Tue, 24 Feb 2009 19:32:53 +0000 (GMT)
Message-ID: <alpine.DEB.2.00.0902241932530.2000@pintail.doc.ic.ac.uk>
References: <20090224190709.GG5482@mit.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cardinal.doc.ic.ac.uk ([146.169.1.194]:39165 "EHLO
	cardinal.doc.ic.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753730AbZBXTc4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 24 Feb 2009 14:32:56 -0500
In-Reply-To: <20090224190709.GG5482@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,

At this stage, it is just for practice. I'm building a kernel module that communicates with user space using a chardev and is able to take requests in order to read or change specific inode data. Right now, I'm just trying to dump the whole inode table.

Cheers,
Felipe

On Tue, 24 Feb 2009, Theodore Tso wrote:

> On Tue, Feb 24, 2009 at 05:13:52PM +0000, Felipe Franciosi wrote:
>> Hi there!
>>
>> I've been trying to write a kernel module that is capable of locating a specific mounted filesystem (ext2/3) and dump all the inode entries that are in use. I have two questions:
>
> Why are you doing this in a kernel module?  What is this for?
>
>    	    	       	    	   	    	 - Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

