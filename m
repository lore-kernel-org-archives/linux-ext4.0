From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: [RFC v2] ext4: Don't send extra barrier during fsync if there
 are no dirty pages.
Date: Fri, 06 Aug 2010 06:17:42 -0400
Message-ID: <4C5BE146.5060407@redhat.com>
References: <20100429235102.GC15607@tux1.beaverton.ibm.com> <1272934667.2544.3.camel@mingming-laptop> <4BE02C45.6010608@redhat.com> <1273002566.3755.10.camel@mingming-laptop> <20100629205102.GM15515@tux1.beaverton.ibm.com> <20100805164008.GH2901@thunk.org> <20100805164504.GI2901@thunk.org> <20100806070424.GD2109@tux1.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "Ted Ts'o" <tytso@mit.edu>, Mingming Cao <cmm@us.ibm.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Keith Mannthey <kmannth@us.ibm.com>,
	Mingming Cao <mcao@us.ibm.com>
To: djwong@us.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:6398 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761115Ab0HFKRy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 6 Aug 2010 06:17:54 -0400
In-Reply-To: <20100806070424.GD2109@tux1.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  On 08/06/2010 03:04 AM, Darrick J. Wong wrote:
> On Thu, Aug 05, 2010 at 12:45:04PM -0400, Ted Ts'o wrote:
>> P.S.  If it wasn't clear, I'm still in favor of trying to coordinate
>> barriers across the whole file system, since that is much more likely
>> to help use cases that arise in real life.
> Ok.  I have a rough sketch of a patch to do that, and I was going to send it
> out today, but the test machine caught on fire while I was hammering it with
> the fsync tests one last time and ... yeah.  I'm fairly sure the patch didn't
> cause the fire, but I'll check anyway after I finish cleaning up.
>
> "[PATCH] ext4: Don't set my machine ablaze with barrier requests" :P
>
> (The patch did seem to cut barrier requests counts by about 20% though the
> impact on performance was pretty small.)
>
> --D

Just a note, one thing that we have been doing is trying to get a reasonable 
regression test in place for testing data integrity. That might be useful to 
share as we float patches around barrier changes.

Basic test:

(1) Get a box with an external e-sata (or USB) connected drive

(2) Fire off some large load on that drive (Chris Mason had one, some of our QE 
engineers have been using fs_mark (fs_mark -d /your_fs/test_dir -S 0 -t 8 -F)

(3) Pull the power cable to that external box.

Of course, you can use any system and drop power, but the above setup will make 
sure that we kill the write cache on the device without letting the firmware 
destage the cache contents.

The test passes if you can now do the following:

(1) Mount the file system without error

(2) Unmount and force an fsck - that should run without reporting errors as well.

Note that the above does not use fsync in the testing.

Thanks!

Ric

