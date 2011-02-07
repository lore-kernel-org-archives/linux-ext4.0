From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH] ext4: Adjust trim start with first_data_block.
Date: Mon, 7 Feb 2011 14:03:34 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1102071349380.3927@dhcp-27-109.brq.redhat.com>
References: <1295618707-3677-1-git-send-email-tm@tao.ma> <20110204054012.GD2623@thunk.org> <4D4D69DF.1070105@tao.ma>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="571140353-93472829-1297083817=:3927"
Cc: "Ted Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	Lukas Czerner <lczerner@redhat.com>
To: Tao Ma <tm@tao.ma>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40931 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751954Ab1BGNDk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 7 Feb 2011 08:03:40 -0500
In-Reply-To: <4D4D69DF.1070105@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--571140353-93472829-1297083817=:3927
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT

On Sat, 5 Feb 2011, Tao Ma wrote:

> Hi Ted,
> On 02/04/2011 01:40 PM, Ted Ts'o wrote:
> > On Fri, Jan 21, 2011 at 10:05:07PM +0800, Tao Ma wrote:
> >    
> > > From: Tao Ma<boyu.mt@taobao.com>
> > > 
> > > As we have make the consense in the e-mail[1], the trim start should
> > > be added with first_data_block. So this patch fulfill it and remove
> > > the check for start<  first_data_block.
> > >      
> >    
> > > [1] http://www.spinics.net/lists/linux-ext4/msg22737.html
> > > 
> > >      
> > Sorry, I was away at Linux.conf.au and didn't have a chance to respond
> > this.
> >    
> np.
> > Fundamentally I think we need to understand what the arguments to the
> > trim ioctl is supposed to *mean*.  Are they supposed to be physical
> > block numbers, or some thing else?  If we just bump everything by the
> > first_data_block, (which is non-zero only for the 1k case), that will
> > screw up the length argument, because the userspace program isn't
> > going to know that (a) the file system is using 1k blocks, and (b) on
> > ext2/3/4 that means that first_data_block is 1.
> >    
> fair enough.
> > So instead of saying that the arguments to trim mean "the data blocks"
> > --- which is a concept that doesn't really have any meaning to the
> > caller of the trim ioctl, without forcing it to know a lot more about
> > the physical layout of filesystems, I think the argument to trim
> > should be the physical block numbers.
> > 
> > And just as we don't trim blocks that contain data that should be
> > saved, we should just simply not trim block #0 (the boot block) and
> > and block #1 (the superblock) on 1k block filesystems, and not trim
> > block #0 (the boot block as well as the superblock) on 4k block
> > filesystems.  But we shouldn't be doing this by taking block number
> > passed to trim and just adding first_data_block to it.
> >    
> I am open to any suggestion as:
> 1) you are the original author of ext2/3/4. ;)
> 2) I am not the original author of trim in ext3/4 and this patch is suggested
> by Lucas. So Lucas, do you agree with it?

Well, originally (when I suggested that we should just add
first_data_block) the intention was for the arguments to be "bytes of
data". I am not sure what exactly is counted into filesystem size
(device size - metadata blocks - reserved bocks - first data block etc.. ??),
but the idea was (since FITRIM is called on mounted filesystem), that
start=0 means first data block for the user, but if it is counted into
filesystem size (marked as used space) it does not really make sense to
add fist_data_block to the start argument.

Does it make sense ?

Thanks!
-Lukas

(BTW, my name is spelled with 'k' in it, so it is "Lukas", or "Luká¨" to be
exact, but the first one is just fine :) )

> > I know a patch to do that has already merged into ext3, but with the
> > indulgence of the folks on linux-ext4, could we reopen this question?
> >    
> Never mind.
> So if you has the objection to this patch, please consider merging another
> patch.
> It fix an underflow problem and treat 'start' as the first physical block
> number.
> http://marc.info/?l=linux-ext4&m=129543034911496&w=2
> 
> As for ext3, I will contact Jan for the update if you decide to abandon this
> patch and accept the patch for 'underflow'.
> 
> Regards,
> Tao
> 
--571140353-93472829-1297083817=:3927--
