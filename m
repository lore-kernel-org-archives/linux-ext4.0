From: Jan Kara <jack@suse.cz>
Subject: Re: Online defragmentation and ext4migrate
Date: Mon, 21 May 2007 12:38:28 +0200
Message-ID: <20070521103828.GB29416@atrey.karlin.mff.cuni.cz>
References: <464DA4ED.9040408@linux.vnet.ibm.com> <019c01c79b92$627b3280$4168010a@bsd.tnes.nec.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	linux-ext4@vger.kernel.org
To: Takashi Sato <sho@tnes.nec.co.jp>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:39812 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757324AbXEUKi3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 21 May 2007 06:38:29 -0400
Content-Disposition: inline
In-Reply-To: <019c01c79b92$627b3280$4168010a@bsd.tnes.nec.co.jp>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

  Hello,

> >While doing online defragmentation do we move the blocks corresponding to 
> >extent index ? The reason why i am asking this is to understand the
> >usefulness of doing a ext4migrate followed by defrag. I understand that 
> >defragmentation in general will improve the performance. But with respect 
> >to ext4migrate we are not touching the data blocks. Instead we build the 
> >extent map and if that requires to have an extent index block then we 
> >allocate one. I am trying to understand what would be the performance 
> >impact of this and whether doing a defrag really improve the performance.
> 
> I think converting a file to extents has the benefit for the performance of
> block searching. If we want to improve also the performance of  reading
> file data, we have to run the defrag after that.
  Yes. On the other hand I believe that some people would like to use
defragmentation but stay with ext3. For them conversion to extents is
no-go.

> >Also looking at the version 0.4 I see that defrag ioctl only work if we 
> >have EXT4_EXTENTS_FL flag set. What are the plans for making defrag work 
> >with indirect block map inode ?
> 
> Unfortunately, my defrag doesn't support an indirect block file.
> But we can reduce fragments in the file with the defrag just after
> ext4migrate.
> 
> In my opinion, to keep the ioctl simple and small is very important
> for ease of maintenance.  So I would rather not support indirect block
> files in the ioctl.  Instead, I can add the call of the migration
> ioctl to my defrag tool in order to defragment indirect block files.
> How do you think of it?
  Yes that could be useful but I don't think it's a complete solution
for people that don't want to migrate.

								Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
