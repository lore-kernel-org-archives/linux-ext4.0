From: Alberto Bertogli <albertito@blitiri.com.ar>
Subject: Re: jbd2 inside a device mapper module
Date: Thu, 25 Dec 2008 12:35:35 -0200
Message-ID: <20081225143535.GA4127@blitiri.com.ar>
References: <20081224211038.GT4127@blitiri.com.ar> <20081224234915.GA23723@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	dm-devel@redhat.com
To: Theodore Tso <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from alerce.vps.bitfolk.com ([212.13.194.134]:4647 "EHLO
	alerce.vps.bitfolk.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751614AbYLYOhF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 25 Dec 2008 09:37:05 -0500
Content-Disposition: inline
In-Reply-To: <20081224234915.GA23723@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Dec 24, 2008 at 06:49:15PM -0500, Theodore Tso wrote:
> On Wed, Dec 24, 2008 at 07:10:38PM -0200, Alberto Bertogli wrote:
> > 
> > I'm writing a small device mapper module, and I'm interested in placing
> > a jbd/jdb2 journal on the backing device.
> > 
> > I started by trying to do a __bread() manually (just for early tests)
> > inside my map function. But it got stucked, as far as I could see,
> > waiting for a buffer head in wait_on_buffer() IIRC (I could track it
> > down again if it's needed). And I couldn't find why it was locked, since
> > it was an unused loopback device, and my code didn't even deal with
> > buffer heads.
> 
> I have no idea why you would need to do manual __breads().  No doubt
> I'm missing some context here.   

I'm writing (just for fun and learning purposes) a device mapper module
that stores checksums on writes and verifies them on reads. The
integrity metadata (currently just the checksum) is interleaved in the
backing device: one sector holding the integrity metadata for the
following 64 data sectors.

The reason for the __bread() is explained below.


> > Then, since I was planning on using jbd/jdb2 anyway, I decided to use it
> > (and went for jbd2).
> > 
> > Now, I'm having issues with journal creation.
> > 
> > I tried using "mkfs.ext3 -O journal_dev", but jbd2_journal_load()
> > complains that it can't find the journal superblock.
> 
> So I'll tell you how to do this via simple hard drives, and you can
> figure out how to make it work with dm.  Note that if the journal
> device isn't on a stand-alone spindle, it's probably not going to help
> you.  The whole point of using an external journal device is to avoid
> the seeking on the journal device, or to take advantage of the speed
> of a battery-backed NVRAM device.  I'm not sure how much sense it
> makes to use dm-based external journal device.... what exactly do you
> hope to achieve.
> 
> To create an external journal device on the device /dev/sda:
> 
>    mke2fs -O journal_dev /dev/sda
> 
> To create a new filesystem on /dev/sdb1 that will use the external
> journal found on /dev/sda:
> 
>    mke2fs -j -J device=/dev/sda /dev/sdb1
> 
> 						- Ted
> 
> P.S.   All of this is in the mke2fs man page....

Thanks. I've found and tried that (that's what I meant with the
paragraph you quote), but I couldn't make it work.

I'll try to make my intentions more clear, but please let me know if I'm
not explaining myself.


For each write on the dm device I should not only write the data in the
backing device, but also upgrade the corresponding integrity metadata.

So, to upgrade the metadata, I should first read that sector from the
backing device, then update it, and finally write it back. As an early
experiment I began to do the first part without caring for the atomicity
of the update. I tried __bread() (just as an experiment, because I've
been using dm-io to do the reads so far) without success.


I then thought of giving jbd2 a try, with the final intention of using
it to update the metadata and the data in an atomic way. I'd devote some
space at the beginning of the backing device for the journal, and use it
internally to that purpose (so it has nothing to do with ext3/4).

The first problem I stumbled upon was that jbd2_journal_create() doesn't
like journals initialized using jbd2_journal_init_dev() (because it has
no j_inode). I had two choices: or try to create the journal some other
way, or remove the j_inode test in jbd2_journal_create().

I suspected the test was there for a reason, but I couldn't find it from
a quick look, so I tried it anyway, which resulted in the warning from
the first email.

Then I tried to create the journal using mke2fs as you described, but
jbd2_journal_load() fails when trying to load it.


To summarize, these are my questions:

 - Why does __bread() gets stucked when called from inside a dm map
   function? It looks like it's waiting on a buffer_head, but why?
 - What is the reason behind the j_inode check in jbd2_journal_create()?
 - Does mke2fs -O journal_dev creates a journal that jbd2_journal_load()
   is supposed to read without any knowledge of ext2/3/4 stuff? If not,
   how can I create such a journal? I'll be looking at the e2fsprogs
   code for the answer to this question later today (I haven't looked at
   it yet).

Obviously, I'm not expected long detailed answers; any tip on where I
can find them would be greatly appreciated.

Thanks a lot,
		Alberto

