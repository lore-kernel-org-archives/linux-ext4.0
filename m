From: "Aneesh Kumar" <aneesh.kumar@gmail.com>
Subject: Re: Online defragmentation and ext4migrate
Date: Mon, 21 May 2007 14:03:02 +0530
Message-ID: <cc723f590705210133w17e84f17t11aae329d1d3062@mail.gmail.com>
References: <464DA4ED.9040408@linux.vnet.ibm.com>
	 <1179519594.6109.40.camel@eric-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: Eric <erpo41@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.227]:62598 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756213AbXEUIdF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 21 May 2007 04:33:05 -0400
Received: by wr-out-0506.google.com with SMTP id 76so1307845wra
        for <linux-ext4@vger.kernel.org>; Mon, 21 May 2007 01:33:03 -0700 (PDT)
In-Reply-To: <1179519594.6109.40.camel@eric-laptop>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 5/19/07, Eric <erpo41@gmail.com> wrote:
> On Fri, 2007-05-18 at 18:36 +0530, Aneesh Kumar K.V wrote:
> > The reason why i am asking this is to understand the
> > usefulness of doing a ext4migrate followed by defrag.
> > [...]
> > Also looking at the version 0.4 I see that defrag ioctl only work if we
> > have EXT4_EXTENTS_FL flag set.
>
> ext4migrate is necessary because the current ext4 defrag routines will
> only defragment files stored as extents. AFAIK, converting a file to
> extents does not allow the defrag routine to defragment it "better" than
> an indirect block map inode, but converting any file to extents has
> performance benefits regardless of whether it is later defragmented.
>
> > What are the plans for making defrag work
> > with indirect block map inode ?
>
> I think there is a second set of patches to defragment non-extent
> files.
>

I was looking at this and didn't find the changes needed to defrag the
non extent files.

http://www.mail-archive.com/linux-ext4@vger.kernel.org/msg01522.html



> An even better
> defragmentation routine knows how to balance the time lost to
> defragmentation with the performance gained from a defragmented
> filesystem. IMHO, this requires detailed knowledge of the layout of a
> file's blocks on the disk. Right now, we get this information by looping
> over the FIBMAP ioctl, which I understand can take quite a long time.


With the takashi's code we use ext4_ext_alloc_blocks and see if the
number of extents that we got is less than the number of extents
that we have with the original file that we intent to defrag. I am not sure an
ioctl is involved here.


Well the intent of my mail was to find the advantage of doing an
online migration.
If we are not relocating the blocks corresponding to extent index then doing a
online migration doesn't bring any specific performance bonus.



But yes i agree that there is a performance impact with defrag by
moving the data
blocks closer.

-aneesh
