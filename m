From: Darren Hart <dvhart@linux.intel.com>
Subject: Re: [RFC 00/10] e2fsprogs/mke2fs: add an option: -d root-directory
Date: Mon, 16 Sep 2013 14:04:00 -0700
Message-ID: <1379365440.1285.207.camel@dvhart-mobl4.amr.corp.intel.com>
References: <1377667560-20089-1-git-send-email-liezhi.yang@windriver.com>
	 <20130901032654.GA21899@gmail.com> <52243449.1070203@windriver.com>
	 <20130902115510.GA1106@gmail.com> <52248272.2000907@windriver.com>
	 <20130902122719.GA6382@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Robert Yang <liezhi.yang@windriver.com>,
	linux-ext4@vger.kernel.org, tytso@mit.edu
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:27993 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751296Ab3IPVED (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 16 Sep 2013 17:04:03 -0400
In-Reply-To: <20130902122719.GA6382@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 2013-09-02 at 20:27 +0800, Zheng Liu wrote:
> On Mon, Sep 02, 2013 at 08:20:02PM +0800, Robert Yang wrote:
> > 
> > 
> > On 09/02/2013 07:55 PM, Zheng Liu wrote:
> > >On Mon, Sep 02, 2013 at 02:46:33PM +0800, Robert Yang wrote:
> > >>
> > >>
> > >>On 09/01/2013 11:26 AM, Zheng Liu wrote:
> > >>>Hi Robert,
> > >>>
> > >>>On Wed, Aug 28, 2013 at 01:25:50PM +0800, Robert Yang wrote:
> > >>>>This option is used for adding the files from the root-directory to the
> > >>>>filesystem, it is similiar to genext2fs, but genext2fs doesn't fully
> > >>>>support ext4.
> > >>>>
> > >>>>* Questions
> > >>>>   - Is such an option acceptable ?
> > >>>>
> > >>>>   - Most of the code have been in debugfs/debugfs.c already, I moved them to
> > >>>>     misc/util.c and modified them to let both mke2fs and debugfs can use them,
> > >>>>     maybe we should put these code in another separate file ?
> > >>>>
> > >>>>   - Where can I get the up-to-date development git repo, please? I think that
> > >>>>     there would be conflicts with the dev git repo, I'd like to rebase it if I
> > >>>>     can get the repo, currently, I'm using this one:
> > >>>>
> > >>>>     http://git.kernel.org/cgit/fs/ext2/e2fsprogs.git
> > >>>>
> > >>>>* The size impact on misc/mke2fs:
> > >>>>    1,677,297 -> 1,728,110 (non stripped, about 50K increases)
> > >>>>    316,968 -> 325,160 (stripped, 8K increases)
> > >>>>
> > >>>>Please feel free to give your comments.
> > >>>
> > >>>If I understand correctly, after applied this patch set, we can copy
> > >>>some files from a directory that is indicated by '-d' option when we
> > >>>create a new ext4 file system.  My concern is why we need to add this
> > >>>option?  Without this option I can use 'mkfs.ext4 ${DEV}', 'mount ${DEV}
> > >>>${MNT}' and 'cp ${SRC} ${MNT}' to do the same thing.  I am not
> > >>>convinced.  Could you please describe more details for this patch set?
> > >>>
> > >>
> > >>Hi Zheng,
> > >>
> > >>Yes, you are right, we can run mkfs/mount/cp to do the same thing,
> > >>but the problem is that the "mount" command requires the root privilege,
> > >>but we may not have it when we are working on a sever (the mkfs doesn't
> > >>need the root privilege), for example
> > >>
> > >>$ dd if=/dev/zero of=test.img count=0 bs=1k seek=2M
> > >>$ mke2fs -t ext4 -F test.img -d <root-dir>
> > >>
> > >>Will create an ext4 image with the files copied without the root privilege.
> > >
> > >Interesting.  As you said above, if you haven't the root privilege, you
> > >won't use this file system.  But at least this file system will be used
> > >by some one who have the root privilege.  He/she can do the rest of
> > >works.  That means that you do 'dd/mke2fs' and he or she does
> > >'mount/cp'.  I don't see any reason that all dirs and files must be
> > >created by mke2fs.  Any real case that needs to do this?
> > >
> > 
> > Hi Zheng,
> > 
> > For example, in Linux embedded development, we usually create a filesystem
> > image which contains the linux embedded OS, this image can be used by qemu,
> > Live CD and so on.
> 
> Ah, got it.  After adding this option, you can create a USB Live CD
> directly and don't need to get the root privilege.  Thanks for your
> explanation.
> 

Robert covered this well, but if you want some more context, the
original email kicking this off is here:

http://www.spinics.net/lists/linux-ext4/msg35352.html

Thanks,

-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Linux Kernel


