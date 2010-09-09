From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH 0/5 v2] Lazy itable initialization for Ext4
Date: Thu, 9 Sep 2010 12:30:46 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1009091109240.2889@dhcp-lab-213.englab.brq.redhat.com>
References: <1283965160-31597-1-git-send-email-lczerner@redhat.com> <0D67E41D-A502-4BEA-B412-148CEA20815D@dilger.ca>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org,
	rwheeler@redhat.com, sandeen@redhat.com, tytso@mit.edu
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52444 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754478Ab0IIKaw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 9 Sep 2010 06:30:52 -0400
In-Reply-To: <0D67E41D-A502-4BEA-B412-148CEA20815D@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 8 Sep 2010, Andreas Dilger wrote:

> On 2010-09-08, at 10:59, Lukas Czerner wrote:
> >  Second patch adds new pair of mount
> > options (inititable/noinititable), so you can enable or disable this
> > feature. In default it is off (noinititable), so in order to try the new
> > code you should moutn the fs like this:
> typo             ^^^^^^
> 
> >  mount -o noinititable /dev/sda /mnt/
> typo       ^^^
> 
> It should use "inititable" if you want to try the new code.

Of course, thanks.

> 
> > To Andreas:
> > You suggested the approach with reading the table first to
> > determine if the device is sparse, or thinly provisioned, or trimmed SSD.
> > In this case the reading would be much more efficient than writing, so it
> > would be a win. But I just wonder, if we de believe the device, that
> > when returning zeroes it is safe to no zero the inode table, why not do it
> > at mkfs time instead of kernel ?
> 
> Good question, but I think the answer is that reading the full itable at
> mke2fs time, just like writing it at mke2fs time, is _serialized_ time
> spent waiting for the filesystem to become useful.  Doing it in the
> background in the kernel can happen in parallel with other operations
> (e.g. formatting other disks, waiting for user input from the installer,
> downloading updates, etc).

I think that important thing is how long it will take to verify that the
device is, or is not sparse. Obviously (in almost all cases) we won't be
reading all inode tables from usual physical disk, because there will be
some garbage, so we will just mark everything not zeroed.

In case of SSD we can just do the trim and verify that it really returns
zeroes. If there are some devices which will return zeroes after trim,
but after one power cycle it will return garbage, we do not care that
much about it, because obviously when we do not believe the device in
mkfs, we can't believe it in kernel.

In the case of sparse and thinly provisioned devices reads will be
fairly quick, so it should not take long to verify that it really return
zeroes for all inode tables. The question is, how long exactly will it
take.

> 
> > To Ted:
> > You were suggesting that it would be nice if the thread will not run, or
> > just quits when the system runs on the battery power. I agree that in that
> > case we probably should not do this to save some battery life. But is it
> > necessary, or wise to do this in kernel ? What we should do when the
> > system runs on battery and user still want to run the lazy initialization
> > ? I would rather let the userspace handle it. For example just remount the
> > filesystem with -o noinititable.
> 
> I would tend to agree with Ted.  There will be _some_ time that the system
> is plugged in to charge the battery, and this is very normal when installing
> the system initially, so delaying the zeroing will not affect most users.
> For the case where the user IS on battery power for some reason, I think it
> is better to avoid consuming the battery in that case.
> 
> Maybe a good way to compromise is to just put the thread to sleep for 5- or
> 10-minute intervals while on battery power, and only start zeroing once
> plugged in.  That solves the situation where (like me) the laptop stays on
> for months at a time with only suspend/resume, and is only rarely rebooted,
> but it is plugged in to recharge often.
> 
> Since we don't expect to need the itable zeroing unless there is corruption
> of the on-disk group descriptor data, I don't think that it is urgent to do
> this immediately after install.  If there is corruption within hours of
> installing a system, there are more serious problems with the system that
> we cannot fix.

I still do not see the reason why not to do simply

 mount -o remount,noinititable <dir>

I believe that there are daemons which are adjusting system settings
when the system is running on battery. I really do not like the kernel
solution for this because once it is hardcoded in kernel I can not do
anything about it, even if I want to run ext4lazyinit no matter what.
I really think that there is no way we should hard code it in the kernel
without any possibility for user to decide on his own.

> 
> > In my benchmark I have set different values of multipliers
> > (EXT4_LI_WAIT_MULT) to see how it affects performance. As a tool for
> > performance measuring I have used postmark (see parameters bellow). I have
> > created average from five postmark runs to gen more stable results. In
> > each run I have created ext4 filesystem on the device (with
> > lazy_itable_init set properly), mounted with inititable/noinititable mount
> > option and run the postmark measuring the running time and number of
> > groups the ext4lazyinit thread initializes in one run. 
> > 
> > Type                              |NOPATCH      MULT=10      DIFF    |
> > ==================================+==================================+
> > Total_duration                    |130.00       132.40       1.85%   |
> > Duration_of_transactions          |77.80        80.80        3.86%   |
> > Transactions/s                    |642.73       618.82       -3.72%  |
> > [snip]
> > Read_B/s                          |21179620.40  20793522.40  -1.82%  |
> > Write_B/s                         |66279880.00  65071617.60  -1.82%  |
> > ==================================+==================================+
> > RUNTIME:	2m13	GROUPS ZEROED: 156
> 
> This is a relatively minor overhead, and when one considers that this is
> a very metadata-heavy benchmark being run immediately after reformatting
> the filesystem, it is not a very realistic real-world situation.
> 
> The good (expected) news is that there is no performance impact when the
> thread is not active, so this is a one-time hit.  In fairness, the
> "NOPATCH" test times should include the full mke2fs time as well, if one
> wants to consider the real-world impact of a much faster mke2fs run and
> a slightly-slower runtime for a few minutes.
> 
> Do you have any idea of how long the zeroing takes to complete in
> the case of MULT=10 without any load, as a function of the filesystem
> size?  That would tell us what the minimum time after startup that the
> system might be slowed down by the zeroing thread.

Well, that depends on how fast the device is. In this case zeroing one
single group takes approx. 28ms without any load. So we can do a little
math to figure out average time to complete the task (assume 4k block
size).

149GB filesystem - the one I was using in the test.
1192 groups -> 1192 inode tables
1 inode table takes (28ms zeroing + 28*10ms waiting) = 308ms
1192 inode tables takes 367136ms = 367.136s = 6m7.136s

In the real test it took 6m22s which is pretty close to my calculation.

> 
> > The benchmark showed, that patch itself does not introduce any performance
> > loss (at least for postmark), when ext4lazyinit thread is not activated.
> > However, when it is activated, there is explicit performance loss due to
> > inode table zeroing, but with EXT4_LI_WAIT_MULT=10 it is just about 1.8%,
> > which may, or may not be much, so when I think about it now we should
> > probably make this settable via sysfs. What do you think ?
> 
> I don't think it is necessary to have a sysfs parameter for this.  Instead
> I would suggest making the "inititable" mount option take an optional
> numeric parameter that specifies the MULT factor.  The ideal solution is
> to make the zeroing happen with a MULT=100 under IO load, but run full-out (i.e. MULT=0?) while there is no IO load.  That said, I don't think it is
> critical enough to delay this patch from landing to implement that.

Right, mount option parameter would be even better.

> 
> Cheers, Andreas
> 

Thanks!
-Lukas
