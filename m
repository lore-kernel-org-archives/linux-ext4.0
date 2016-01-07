From: "HUANG Weller (CM/ESW12-CN)" <Weller.Huang@cn.bosch.com>
Subject: RE: ext4 out of order when use cfq scheduler
Date: Thu, 7 Jan 2016 11:02:29 +0000
Message-ID: <f0c925079bb4450380c019a7455a2537@SGPMBX1004.APAC.bosch.com>
References: <697280a570654ae0aa1723fb7d11f51e@SGPMBX1004.APAC.bosch.com>
 <20151222150037.GB18178@quack.suse.cz>
 <c67f356b63d94d35ad010a6e987b68f0@SGPMBX1004.APAC.bosch.com>
 <20160105153050.GF14464@quack.suse.cz>
 <c73ca48af09742318189c61d167c4459@SGPMBX1004.APAC.bosch.com>
 <20160106100621.GA24046@quack.suse.cz>
 <3ab48fa47e434455b101251730e69bd2@SGPMBX1004.APAC.bosch.com>
 <20160107102420.GB8380@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"Li, Michael" <huayil@qti.qualcomm.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp6-v.fe.bosch.de ([139.15.237.11]:41556 "EHLO
	smtp6-v.fe.bosch.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752128AbcAGLCf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 7 Jan 2016 06:02:35 -0500
In-Reply-To: <20160107102420.GB8380@quack.suse.cz>
Content-Language: en-US
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>



> -----Original Message-----
> From: Jan Kara [mailto:jack@suse.cz]
> Sent: Thursday, January 07, 2016 6:24 PM
> To: HUANG Weller (CM/ESW12-CN) <Weller.Huang@cn.bosch.com>
> Cc: Jan Kara <jack@suse.cz>; linux-ext4@vger.kernel.org
> Subject: Re: ext4 out of order when use cfq scheduler
> 
> On Thu 07-01-16 06:43:00, HUANG Weller (CM/ESW12-CN) wrote:
> > > -----Original Message-----
> > > From: Jan Kara [mailto:jack@suse.cz]
> > > Sent: Wednesday, January 06, 2016 6:06 PM
> > > To: HUANG Weller (CM/ESW12-CN) <Weller.Huang@cn.bosch.com>
> > > Subject: Re: ext4 out of order when use cfq scheduler
> > >
> > > On Wed 06-01-16 02:39:15, HUANG Weller (CM/ESW12-CN) wrote:
> > > > > So you are running in 'ws' mode of your tool, am I right? Just
> > > > > looking into the sources you've sent me I've noticed that
> > > > > although you set O_SYNC in openflg when mode == MODE_WS, you do
> > > > > not use openflg at all. So file won't be synced at all. That
> > > > > would well explain why you see that not all file contents is
> > > > > written. So did you just send me a different version of the
> > > > > source or is your test program
> > > really buggy?
> > > > >
> > > >
> > > > Yes, it is a bug of the test code. So the test tool create files
> > > > without O_SYNC flag actually.  But , even in this case, is the out
> > > > of order acceptable ? or is it normal ?
> > >
> > > Without fsync(2) or O_SYNC, it is perfectly possible that some files
> > > are written and others are not since nobody guarantees order of
> > > writeback of inodes. OTOH you shouldn't ever see uninitialized data
> > > in the inode (but so far it isn't clear to me whether you really see
> > > unitialized data or whether we really wrote zeros to those blocks -
> > > ext4 can sometimes decide to do so).  Your traces and disk contents
> > > show that the problematic inode has extent of length 128 blocks
> > > starting at block
> > > 0x12c00 and then extent of lenght 1 block starting at block 0x1268e.
> > > What is the block size of the filesystem?  Because inode size is only 0x40010.
> > >
> > > Some suggestions to try:
> > > 1) Print also length of a write request in addition to the starting
> > > block so that we can see how much actually got written
> >
> > Please see below failure analysis.
> >
> > > 2) Initialize the device to 0xff so that we can distinguish
> > > uninitialized blocks from zeroed-out blocks.
> >
> > Yes, i Initialize the device to 0xff this time.
> >
> > > 3) Report exactly for which 512-byte blocks checksum matches and for
> > > which it is wrong.
> > The wrong contents are old file contents which are created in previous
> > test round.  It is caused by the "wrong" sequence inode data(in
> > journal) and  the file contents. So the file contents are not updated.
> 
> So this confuses me somewhat. You previously said that you always remove files
> after each test round and then new ones are created. Is it still the case? So the old
> file contents you speak about above is just some random contents that happened
> to be in disk blocks we freshly allocated to the file, am I right?

Yes. You are right.
 The "old file contents" means that the disk blocks which the contents is generated from last test round, and they are allocated to a new file in new test round.


> 
> OK, so I was looking into the code and indeed, reality is correct and my mental
> model was wrong! ;) I thought that inode gets added to the list of inodes for which
> we need to wait for data IO completion during transaction commit during block
> allocation. And I was wrong. It used to happen in
> mpage_da_map_and_submit() until commit f3b59291a69d (ext4: remove calls to
> ext4_jbd2_file_inode() from delalloc write path) where it got removed. And that was
> wrong because although we submit data writes before dropping handle for
> allocating transaction and updating i_size, nobody guarantees that data IO is not
> delayed in the block layer until transaction commit.
> Which seems to happen in your case. I'll send a fix. Thanks for your report and
> persistence!
> 

Thanks a lot for your feedback :-)
Because I am not familiar with the detail of the ext4 internal code.  I will try to understand your explanation which you describe above.  And have a look on related funcations.
Could you send the fix in this mail ?
And whether the kernel 3.14 also have such issue, right ?

> 								Honza
> --
> Jan Kara <jack@suse.com>
> SUSE Labs, CR
