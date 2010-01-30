From: tytso@mit.edu
Subject: Re: need help with getting into a corrupted sub directory
Date: Sat, 30 Jan 2010 12:44:04 -0500
Message-ID: <20100130174404.GC788@thunk.org>
References: <004d01caa172$8d846c10$6401a8c0@kyle>
 <27FC5E2E-2F85-478A-95F2-1B9ED9D07690@sun.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kyle <kylewong@southa.com>, linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:39092 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752600Ab0A3RoJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 30 Jan 2010 12:44:09 -0500
Content-Disposition: inline
In-Reply-To: <27FC5E2E-2F85-478A-95F2-1B9ED9D07690@sun.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Jan 30, 2010 at 12:24:09AM -0700, Andreas Dilger wrote:
> On 2010-01-29, at 23:07, kyle wrote:
> >I have a ext3 filesystem created inside a problematic seagate
> >ST3500320AS
> >drive. The drive will just shut itself down automatically whenever
> >it hits
> >any read error. Only way to wake it up it to cold power off / on the
> >computer.
> 
> Strange, I had to do the same for a friend, and I think it was the
> same drive.
> You should put it into a USB enclosure - it speeds things up a lot.
> 
> >'sde' will disappeared from the system, need power off / on can
> >get it back.
> 
> To get most of the data off the dying drive, use rsync -v, and
> create a list
> of files to exclude, when you detect they cause the drive to die.

An image copy of the disk will tend to recover more than accessing the
disk via the file system.  I haven't run across the failure mode where
accessing a certain magic block causes the disk to die and require a
power cycle, but in that case what I'd probably do is enhance the
dd_rescue program to take a list of block numbers which it should skip
over....

This will require some programming, but it's probably the best way to
recover the most amount of data.  (Oh, and afterwards someone should
send the changes back to Kurt Garloff, since it would be a very useful
enhancement to dd_rescue.)

						- Ted
