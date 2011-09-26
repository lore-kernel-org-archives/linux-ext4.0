From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] Add better example about how to compress e2image raw
 image
Date: Mon, 26 Sep 2011 11:24:31 -0500
Message-ID: <4E80A73F.2070205@redhat.com>
References: <1316803672-25550-1-git-send-email-cmaiolino@redhat.com> <BAB1C1C4-D0BB-4398-89A5-EC8B1E20801B@dilger.ca> <20110923205124.GD26962@andromeda.usersys.redhat.com> <20110924163153.GB2779@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Carlos Maiolino <cmaiolino@redhat.com>,
	Andreas Dilger <adilger@dilger.ca>, linux-ext4@vger.kernel.org
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:62441 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751172Ab1IZQYf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 26 Sep 2011 12:24:35 -0400
In-Reply-To: <20110924163153.GB2779@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 9/24/11 11:31 AM, Ted Ts'o wrote:
> On Fri, Sep 23, 2011 at 05:51:24PM -0300, Carlos Maiolino wrote:
>> On Fri, Sep 23, 2011 at 02:24:23PM -0600, Andreas Dilger wrote:
>>> On 2011-09-23, at 12:47 PM, Carlos Maiolino wrote:
>>>> The current example in the man page uses bzip2 to compress
>>>> the raw image file created by the e2image, but, bzip2 does
>>>> not honors sparse files, which causes the image to have the
>>>> same size of the filesystem.
>>>> Using tar together with bzip2 will make the compressed file
>>>> to honor the sparsed file, which makes it more transportable
>>>> than the current one if the filesystem is large.
> 
> The problem with using tar is that it requires extra disk space by the
> user --- somewhere a bit more than double the extra disk space
> (because you need to have space for the hda1.e2i file before it gets
> compressed).  For very large file systems, this can be quite
> significant.  My general philosophy has been to make things easy as
> possible for the users as being more important for the developers.
> 
> For the developers, we do have contrib/make-sparse.c.  All we have to do is:
> 
>     bunzip2 < hda1.e2i.bz2 | make-sparse hda1.e2i
> 
> ... and this creates a sparse file in hda1.e2i.

or | cp --sparse=always /dev/stdin sparse.img works too.

But have you ever tried this with a multi-terabyte image?

It takes -forever- to process all those 0s, with cpus pegged.

The tar command seems to actually annotate the sparseness efficiently.

Ted, your concern about space - it doesn't take the full fs size worth
of space, right, just the metadata space?  So in general it should not
be THAT much ...

-Eric

>>> Even better would be the use of the QCOW2 format that Lukas added,
>>> if it could also be operated on directly by the e2fsprogs utils (I
>>> don't know if that is possible or not).
>>>
>> The QCOW2 format can only be operated with qcow2 capable tools like
>>> qemu-img to use directly with e2fsprogs tools, we still need to
>>> use raw images.
> 
> Yeah, it would be nice if we had an io_manager implementation that
> understood qcow2, which could then be used by dumpe2fs and debugfs.
> Hopefully at some point someone will implement it.
> 
> 						- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

