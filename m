From: Frank Mayhar <fmayhar@google.com>
Subject: Re: Question on fallocate/ftruncate sequence
Date: Thu, 23 Jul 2009 15:46:05 -0700
Message-ID: <1248389165.17459.3.camel@bobble.smo.corp.google.com>
References: <6601abe90907200936w61ebda92reae368a2b9efac66@mail.gmail.com>
	 <4A64F37D.7020803@redhat.com>
	 <1248211771.20743.2.camel@bobble.smo.corp.google.com>
	 <20090721215421.GM4231@webber.adilger.int>
	 <1248304214.14463.17.camel@bobble.smo.corp.google.com>
	 <4A67D36D.20708@redhat.com>
	 <1248366422.27509.1.camel@bobble.smo.corp.google.com>
	 <4A689723.7000805@redhat.com>
	 <1248372301.31323.2.camel@bobble.smo.corp.google.com>
	 <20090723215614.GF4231@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Eric Sandeen <sandeen@redhat.com>,
	Curt Wohlgemuth <curtw@google.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.33.17]:44515 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754495AbZGWWqv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 23 Jul 2009 18:46:51 -0400
In-Reply-To: <20090723215614.GF4231@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 2009-07-23 at 15:56 -0600, Andreas Dilger wrote:
> On Jul 23, 2009  11:05 -0700, Frank Mayhar wrote:
> > On Thu, 2009-07-23 at 12:00 -0500, Eric Sandeen wrote:
> > > Sorry I skimmed to fast, skipped over the fsck part.  But:
> > > 
> > > # touch /mnt/test/testfile
> > > # /root/fallocate -n -l 16m /mnt/test/testfile
> > > # ls -l /mnt/test/testfile
> > > -rw-r--r-- 1 root root 0 Jul 23 12:13 /mnt/test/testfile
> > > # du -h /mnt/test/testfile
> > > 16M	/mnt/test/testfile
> > > 
> > > there doesn't seem to be a problem in fsck w/ block past EOF, or am I
> > > missing something else?
> > 
> > I was taking Andreas' word for it but now that you mention it, I see the
> > same thing.  Andreas, did you have a specific case in mind?
> 
> Ted and I had discussed this in the past, maybe he fixed e2fsck to not
> change the file size when there are blocks allocated beyond EOF.  Having
> a flag wouldn't be a terrible idea, IMHO, so that e2fsck can make a
> better decision on whether the size or the blocks count are more correct.
> I'm not dead set on it.

For the moment I'm going to table the e2fsck change and make the flag
memory-only.  It'll be easy enough to change this if and when you guys
come to an agreement about what is right.

As for the flag itself, I'll pick a bit that doesn't conflict with
anything else and leave reconciling the already-conflicting bits to you
guys.
-- 
Frank Mayhar <fmayhar@google.com>
Google, Inc.

