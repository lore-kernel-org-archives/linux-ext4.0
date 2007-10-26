From: "Abhishek Rai" <abhishekrai@google.com>
Subject: Re: [PATCH] Clustering indirect blocks in Ext2
Date: Thu, 25 Oct 2007 17:31:45 -0700
Message-ID: <d9885f0f0710251731k46525380o288a3fffca9dff@mail.gmail.com>
References: <d9885f0f0710250320u2af6dd3eq730f460c4ba538fd@mail.gmail.com>
	 <d9885f0f0710250321l5f7b05e0q8990e8e3419c8f4@mail.gmail.com>
	 <20071025202035.GE3042@webber.adilger.int>
	 <d9885f0f0710251556k98fc1e5le2d99167fa880457@mail.gmail.com>
	 <20071025233820.GL3042@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: "Andreas Dilger" <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.45.13]:8764 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752902AbXJZAbu (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 25 Oct 2007 20:31:50 -0400
Received: from zps38.corp.google.com (zps38.corp.google.com [172.25.146.38])
	by smtp-out.google.com with ESMTP id l9Q0VkmR006634
	for <linux-ext4@vger.kernel.org>; Thu, 25 Oct 2007 17:31:46 -0700
Received: from rv-out-0910.google.com (rvfb22.prod.google.com [10.140.179.22])
	by zps38.corp.google.com with ESMTP id l9Q0VC0Z007932
	for <linux-ext4@vger.kernel.org>; Thu, 25 Oct 2007 17:31:46 -0700
Received: by rv-out-0910.google.com with SMTP id b22so559734rvf
        for <linux-ext4@vger.kernel.org>; Thu, 25 Oct 2007 17:31:45 -0700 (PDT)
In-Reply-To: <20071025233820.GL3042@webber.adilger.int>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 10/25/07, Andreas Dilger <adilger@sun.com> wrote:
> On Oct 25, 2007  15:56 -0700, Abhishek Rai wrote:
> > While this patch does add some complexity to ext2, it has the benefit
> > of backward and forward compatibility which will probably make it
> > attractive for more people than any change that changes on-disk
> > format.
>
> To be honest, I think the number of people using ext2 on their systems
> is relatively small compared to ext3 because of the e2fsck hit on each
> boot.  IMHO, that means the engineering effort spent on improving
> e2fsck for ext2 is less worthwhile than if the same effort was spent
> on testing ext4 and the improvements made there.
>
> My understanding is that the primary reason Google is using ext2 instead
> of ext3 is because of the performance impact of journaling.  With the
> performance (and also scalability) improvements in ext4, doesn't it make
> sense to put test/development time and effort toward ext4?

That is true. However, this patch is meant to be a stop gap fix for
ext2 users until ext4 becomes stable enough for them to migrate to it.
However, for reaching a wider user base I'll port it to ext3. On ext3
the benefits won't be seen on every reboot of course, but a full fsck
is nevertheless needed even on ext3 every once in a while. I've seen
this patch reduce e2fsck time by 50-65% without any fsck changes, and
with a minor fsck change we've seen e2fsck time go down by 80%.

> > Thanks for pointing these out. extents and delalloc+mballoc are of
> > course useful but are not a simple transition though I'm definitely
> > considering trying them out.
>
> Note that delalloc and mballoc don't strictly require extents, as
> they are in-memory optimizations only.
>
> > Regarding the uninit_groups patch, I think it can be implemented in a
> > backward compatible way as follows. Instead of modifying the group
> > desc to store the number of unused inodes (bg_itable_inodes), we can
> > alternatively define an implicit boundary in every group's inode
> > bitmap by having a special free "marker" inode with a certain
> > signature. Whenever we need to allocate inodes in a group beyond this
> > boundary, we shift the boundary by using a later inode as the free
> > marker inode. The idea is that new ext2 will try to allocate inodes
> > from before the marker and fsck will not seek past the marker.
>
> The problem with this is that ext2 is not journalled and it is possible
> that updates are not ordered on disk.  The danger is that the update
> of the marker block is lost, but inodes are allocated after it.

I don't agree. Since this is meant to be a rare operation, it should
be OK to do a sync write and really wait for it to complete. It may
get stuck in the disk cache though, but that is true with all kinds of
metadata updates on ext2. Fortunately, even if we don't manage to
write out the new marker-inode, fsck will assume that there is none
which is the same as old behavior anyway. However, I do realize that
storing the inode count in the group descriptor can perform better
than marker-inodes since if bg_itable_inodes == 0, we can entirely
skip reading inodes from a block group (not entirely true). But I
think there is a way or two to achieve the same effect with
marker-inodes as well. I'll work on a patch and see how it goes.

> > - Over time markers drift towards higher inode numbers but never
> > travel backwards, so a pathological workload can kill all markers
> > bringing us back to old behavior, but this is very unlikely.
>
> This is currently true of the uninit_groups feature also, because it
> is a lot easier to avoid the problem of safely shrinking the high
> watermark.  On the next e2fsck it will shrink the high watermark for
> each group again.
>
>
> Cheers, Andreas
> --
> Andreas Dilger
> Sr. Software Engineer, Lustre Group
> Sun Microsystems of Canada, Inc.
>
>

Thanks,
Abhishek
