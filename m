From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] Add better example about how to compress e2image raw
 image
Date: Mon, 26 Sep 2011 11:25:48 -0500
Message-ID: <4E80A78C.4050301@redhat.com>
References: <1316803672-25550-1-git-send-email-cmaiolino@redhat.com> <BAB1C1C4-D0BB-4398-89A5-EC8B1E20801B@dilger.ca> <20110923205124.GD26962@andromeda.usersys.redhat.com> <20110924163153.GB2779@thunk.org> <4E806E84.4090106@itwm.fraunhofer.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Ted Ts'o" <tytso@mit.edu>, Carlos Maiolino <cmaiolino@redhat.com>,
	Andreas Dilger <adilger@dilger.ca>, linux-ext4@vger.kernel.org
To: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:64677 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751385Ab1IZRaO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 26 Sep 2011 13:30:14 -0400
In-Reply-To: <4E806E84.4090106@itwm.fraunhofer.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 9/26/11 7:22 AM, Bernd Schubert wrote:
> On 09/24/2011 06:31 PM, Ted Ts'o wrote:
>> On Fri, Sep 23, 2011 at 05:51:24PM -0300, Carlos Maiolino wrote:
>>> On Fri, Sep 23, 2011 at 02:24:23PM -0600, Andreas Dilger wrote:
>>>> On 2011-09-23, at 12:47 PM, Carlos Maiolino wrote:
>>>>> The current example in the man page uses bzip2 to compress
>>>>> the raw image file created by the e2image, but, bzip2 does
>>>>> not honors sparse files, which causes the image to have the
>>>>> same size of the filesystem.
>>>>> Using tar together with bzip2 will make the compressed file
>>>>> to honor the sparsed file, which makes it more transportable
>>>>> than the current one if the filesystem is large.
>>
>> The problem with using tar is that it requires extra disk space by the
>> user --- somewhere a bit more than double the extra disk space
>> (because you need to have space for the hda1.e2i file before it gets
>> compressed).  For very large file systems, this can be quite
>> significant.  My general philosophy has been to make things easy as
>> possible for the users as being more important for the developers.
>>
>> For the developers, we do have contrib/make-sparse.c.  All we have to do is:
>>
>>      bunzip2<  hda1.e2i.bz2 | make-sparse hda1.e2i
>>
>> ... and this creates a sparse file in hda1.e2i.
> 
> The problem is that the bzip2 run will take a huge amount of time to
> compress all the zeros. In 2009 (with a recent CPU of that time) I
> aborted such a run for a 8TiB file system after a couple of days,
> then stored the e2image directly on disk and compressed it with tar
> and sparse support, which finished after only 12 hours... I don't
> think more modern CPUs are much faster for single threaded runs as
> bzip2 does it. So IMHO the man page should at least warn about that
> issue and suggest to use a similar tar command.

Agreed!

I think they both have their place.

passing images around in qcow format may be best in the long run though.

-Eric

> 
> Cheers,
> Bernd
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

