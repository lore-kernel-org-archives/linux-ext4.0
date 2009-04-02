From: Theodore Tso <tytso@mit.edu>
Subject: Re: 2.6.29-git: cannot mount ext4/loop
Date: Thu, 2 Apr 2009 01:53:56 -0400
Message-ID: <20090402055356.GC10642@mit.edu>
References: <a4423d670904011423x4174a81cj901bc140944412ea@mail.gmail.com> <20090401225351.GA22621@orion>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Alexander Beregalov <a.beregalov@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:56254 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752542AbZDBFyF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 2 Apr 2009 01:54:05 -0400
Content-Disposition: inline
In-Reply-To: <20090401225351.GA22621@orion>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Apr 02, 2009 at 02:53:51AM +0400, Alexander Beregalov wrote:
> On Thu, Apr 02, 2009 at 01:23:28AM +0400, Alexander Beregalov wrote:
> > Hi Theodore, Jens
> > 
> > kernel is 2.6.29-07099-g8b53ef3
> > 
> > Mount failed:
> > 
> > EXT4-fs: barriers enabled
> > kjournald2 starting: pid 1867, dev loop0:8, commit interval 5 seconds
> > EXT4-fs error (device loop0): ext4_iget: block reference 2703228928 >=
> > max (524288) in inode #2, offset=0
> > EXT4-fs: get root inode failed
> > EXT4-fs (device loop0): mount failed

I don't get this failure in a Linux 2.6 kernel based off of 5d80f8e5
with the )now upstream) ext4 patches merged in.  I'm guessing sometime
between v2.6.29-3652-g5d80f8e and 2.6.29-07099-g8b53ef3 a regression
was introduced into the loop driver?

						- Ted
