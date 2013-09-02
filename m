From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [RFC 00/10] e2fsprogs/mke2fs: add an option: -d root-directory
Date: Mon, 2 Sep 2013 20:27:19 +0800
Message-ID: <20130902122719.GA6382@gmail.com>
References: <1377667560-20089-1-git-send-email-liezhi.yang@windriver.com>
 <20130901032654.GA21899@gmail.com>
 <52243449.1070203@windriver.com>
 <20130902115510.GA1106@gmail.com>
 <52248272.2000907@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, dvhart@linux.intel.com
To: Robert Yang <liezhi.yang@windriver.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f174.google.com ([209.85.192.174]:34097 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758083Ab3IBM0S (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 2 Sep 2013 08:26:18 -0400
Received: by mail-pd0-f174.google.com with SMTP id y13so4734369pdi.33
        for <linux-ext4@vger.kernel.org>; Mon, 02 Sep 2013 05:26:17 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <52248272.2000907@windriver.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Sep 02, 2013 at 08:20:02PM +0800, Robert Yang wrote:
> 
> 
> On 09/02/2013 07:55 PM, Zheng Liu wrote:
> >On Mon, Sep 02, 2013 at 02:46:33PM +0800, Robert Yang wrote:
> >>
> >>
> >>On 09/01/2013 11:26 AM, Zheng Liu wrote:
> >>>Hi Robert,
> >>>
> >>>On Wed, Aug 28, 2013 at 01:25:50PM +0800, Robert Yang wrote:
> >>>>This option is used for adding the files from the root-directory to the
> >>>>filesystem, it is similiar to genext2fs, but genext2fs doesn't fully
> >>>>support ext4.
> >>>>
> >>>>* Questions
> >>>>   - Is such an option acceptable ?
> >>>>
> >>>>   - Most of the code have been in debugfs/debugfs.c already, I moved them to
> >>>>     misc/util.c and modified them to let both mke2fs and debugfs can use them,
> >>>>     maybe we should put these code in another separate file ?
> >>>>
> >>>>   - Where can I get the up-to-date development git repo, please? I think that
> >>>>     there would be conflicts with the dev git repo, I'd like to rebase it if I
> >>>>     can get the repo, currently, I'm using this one:
> >>>>
> >>>>     http://git.kernel.org/cgit/fs/ext2/e2fsprogs.git
> >>>>
> >>>>* The size impact on misc/mke2fs:
> >>>>    1,677,297 -> 1,728,110 (non stripped, about 50K increases)
> >>>>    316,968 -> 325,160 (stripped, 8K increases)
> >>>>
> >>>>Please feel free to give your comments.
> >>>
> >>>If I understand correctly, after applied this patch set, we can copy
> >>>some files from a directory that is indicated by '-d' option when we
> >>>create a new ext4 file system.  My concern is why we need to add this
> >>>option?  Without this option I can use 'mkfs.ext4 ${DEV}', 'mount ${DEV}
> >>>${MNT}' and 'cp ${SRC} ${MNT}' to do the same thing.  I am not
> >>>convinced.  Could you please describe more details for this patch set?
> >>>
> >>
> >>Hi Zheng,
> >>
> >>Yes, you are right, we can run mkfs/mount/cp to do the same thing,
> >>but the problem is that the "mount" command requires the root privilege,
> >>but we may not have it when we are working on a sever (the mkfs doesn't
> >>need the root privilege), for example
> >>
> >>$ dd if=/dev/zero of=test.img count=0 bs=1k seek=2M
> >>$ mke2fs -t ext4 -F test.img -d <root-dir>
> >>
> >>Will create an ext4 image with the files copied without the root privilege.
> >
> >Interesting.  As you said above, if you haven't the root privilege, you
> >won't use this file system.  But at least this file system will be used
> >by some one who have the root privilege.  He/she can do the rest of
> >works.  That means that you do 'dd/mke2fs' and he or she does
> >'mount/cp'.  I don't see any reason that all dirs and files must be
> >created by mke2fs.  Any real case that needs to do this?
> >
> 
> Hi Zheng,
> 
> For example, in Linux embedded development, we usually create a filesystem
> image which contains the linux embedded OS, this image can be used by qemu,
> Live CD and so on.

Ah, got it.  After adding this option, you can create a USB Live CD
directly and don't need to get the root privilege.  Thanks for your
explanation.

                                                - Zheng
