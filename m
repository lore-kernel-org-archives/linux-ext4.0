From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [RFC][PATCH 0/3] add FALLOC_FL_NO_HIDE_STALE flag in fallocate
Date: Wed, 18 Apr 2012 20:03:08 +0800
Message-ID: <20120418120307.GB3447@gmail.com>
References: <1334681618-9452-1-git-send-email-wenqing.lz@taobao.com>
 <4F8DAAFE.40500@redhat.com>
 <20120418040842.GA11684@gmail.com>
 <alpine.LFD.2.00.1204180919500.5310@dhcp-27-109.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Zheng Liu <wenqing.lz@taobao.com>
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1204180919500.5310@dhcp-27-109.brq.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Apr 18, 2012 at 09:48:45AM +0200, Lukas Czerner wrote:
> On Wed, 18 Apr 2012, Zheng Liu wrote:
> 
> > On Tue, Apr 17, 2012 at 12:40:14PM -0500, Eric Sandeen wrote:
> > > On 4/17/12 11:53 AM, Zheng Liu wrote:
> > > > Hi list,
> > > > 
> > > > fallocate is a useful system call because it can preallocate some disk blocks
> > > > for a file and keep blocks contiguous.  However, it has a defect that file
> > > > system will convert an uninitialized extent to be an initialized when the user
> > > > wants to write some data to this file, because file system create an
> > > > unititalized extent while it preallocates some blocks in fallocate (e.g. ext4).
> > > 
> > > That's a security-driven design feature, not a defect.  :)
> 
> Exactly! It really surprise me that you call it a defect, moreover the
> name you've chosen for the flag is IMO wrong. With security hole like
> this you really want give user very strong feeling that he is NOT supposed
> to use it if he does not know what he is doing. Maybe something like
> FALLOC_FL_EXPOSE_USER_DATA because that is what it does.
> 
> > > 
> > > > Especially, it causes a severe degradation when the user tries to do some
> > > > random write operations, which frequently modifies the metadata of this file.
> > > > We meet this problem in our product system at Taobao.  Last month, in ext4
> > > > workshop, we discussed this problem and the Google faces the same problem.  So
> > > > a new flag, FALLOC_FL_NO_HIDE_STALE, is added in order to solve this problem.
> > > 
> > > Which then opens up severe security problems.
> > > 
> > > > When this flag is set, file system will create an inititalized extent for this
> > > > file.  So it avoids the conversion from uninitialized to initialized.  If users
> > > > want to use this flag, they must guarantee that file has been initialized by
> > > > themselves before it is read at the same offset.  This flag is added in vfs so
> > > > that other file systems can also support this flag to improve the performance.
> > > > 
> > > > I try to make ext4 support this new flag, and run a simple test in my own
> > > > desktop to verify it.  The machine has a Intel(R) Core(TM)2 Duo CPU E8400, 4G
> > > > memory and a WDC WD1600AAJS-75M0A0 160G SATA disk.  I use the following script
> > > > to tset the performance.
> > > > 
> > > > #/bin/sh
> > > > mkfs.ext4 ${DEVICE}
> > > > mount -t ext4 ${DEVICE} ${TARGET}
> > > > fallocate -l 27262976 ${TARGET}/test # the size of the file is 256M (*)
> > > 
> > > That's only 26MB, but the below loop writes to a max offset of around
> > > 256M.
> > 
> > Yes, you are right.  I preallocate a file that is 256MB.
> > 
> > > 
> > > > time for((i=0;i<2000;i++)); do dd if=/dev/zero of=/mnt/sda1/test_256M \
> > > > 	conv=notrunc bs=4k count=1 seek=`expr $i \* 16` oflag=sync,direct \
> > > > 	2>/dev/null; done
> > > 
> > > You fallocate ${TARGET}/test but dd to /mnt/sda1/test_256M ?  I presume
> > > those should be the same file.
> > 
> > Yes, it is the same file.
> 
> But it is not in your test case. Does it mean that your test case is
> wrong ?
> 
> > 
> > > 
> > > So the testcase as shown above seems fairly wrong, no?  Is that what you
> > > used for the numbers below?
> > > 
> > > > * I write a wrapper program to call fallocate(2) with FALLOC_FL_NO_HIDE_STALE
> > > >   flag because the userspace tool doesn't support the new flag.
> > > > 
> > > > The result:
> > > > 	w/o 		w/
> > > > real	1m16.043s	0m17.946s	-76.4%
> > > > user	0m0.195s	0m0.192s	-1.54%
> > > > sys	0m0.468s	0m0.462s	-1.28%
> > > 
> > > I think that the missing information here is some profiling to show where
> > > the time was spent in the "w/o" case.  What, exactly, in ext4 extent
> > > management is so darned slow that we have to poke security holes in the
> > > filesytem to get decent performance?
> > > 
> > > However,, the above also seems like an alarmingly large difference, and
> > > one that I can't attribute to unwritten extent conversion overhead.
> > > 
> > > If I test the seeky dd to a prewritten file (to eliminate extent
> > > conversion):
> > > 
> > > # dd if=/dev/zero of=/mnt/scratch/test bs=1M count=256
> > > # sync
> > > 
> > > vs. to a fallocated file (which requires extent conversion):
> > > 
> > > # fallocate -l 256m /mnt/scratch/test
> > > 
> > > and then do your seeky dd test after each of the above:
> > > 
> > > # time for((i=0;i<2000;i++)); do dd if=/dev/zero of=/mnt/scratch/test \
> > > 	conv=notrunc bs=4k count=1 seek=`expr $i \* 16` oflag=sync,direct \
> > > 	2>/dev/null; done
> > > 
> > > On ext4, I get about 59.9 seconds in the pre-written case, 65.2 seconds in the fallocated case.
> > > 
> > > On xfs, I get about 52.5 seconds in the pre-written case, 52.7 seconds in the fallocated case.
> > > 
> > > I don't see anywhere near the slowdown you show above, certainly
> > > nothing bad enough to warrant opening the big security hole.
> > > Am I missing something?
> > 
> > I will run more detailed benchmarks to trace this issue.  If I have a
> > lastest result, I will send a new mail to let you know. :)
> 
> Yes, please do. I do not think that in this case simply doing 'time
> dd' is enough. We need to know what is happening inside the kernel to see
> what is causing the slowdown. It may very well be that we might be able
> to fix it, rather than introduce crazy security hole to bypass the
> problem.

Sorry, maybe my expression is not clear.  Now we have two problems that
need to be discussed in this thread.  One is my patch set about adding a
new fallocate flag, and another is that the result of preallocated case
with conversion is too slower than the result of the case without
conversion.

For new flag, last year we have encountered this problem in our product
system.  We decide to add this flag to avoid the overhead because our
application can guarantee to initialize the file before it read data
from this file.  As I said before, last month on ext4 workshop, we
discussed this problem and Ted said that the Google has the same problem
too.  So we think that maybe this flag is useful for other users.  That
is reason why I send this patch set to mailing list. 

For benchmark result, that is a simple test.  When I send this patch set
to mailing list, I think that I need to get some data to compare the
performance of w/ and w/o this new flag.  I am astonished by the result.
So, as I said above, the target of my patch set is not to solve this issue.

I have run a more detailed benchmark and I will post it to mailing list.
Please review it after I send it.  Any comments are welcomed.

Regards,
Zheng

> 
> > 
> > I fully understand that this flag will bring a security hole, and I
> > totally agree that we should dig *root cause* in ext4.  But, IMHO, a
> > proper interface, which is limited by a proper capabilities, might be
> > useful for the user.  
> 
> No, you're not getting the point. In kernel (or fs) we are supposed to
> prevent from security problems as much as possible and it is
> indisputably the job of file systems to prevent reading data which are
> NOT in the file system and might have belonged to the other user. If you
> want to do this, just use raw device.
> 
> Limiting this by proper capabilities is so not enough from tons of
> reasons. Application have bugs, which may very well cause the stale data
> to be exported directly to the user of the application which might not
> even have root capabilities. Consider buggy database returning stale
> data (possibly deleted secret informations) from the on user to
> another, it _is_ possible and things like that _will_ happen with
> this "feature", what is even worse that in this case the application
> writers do actually use the fallocate flag right.
> 
> Moreover, a lot of application are getting rid of the root capabilities
> once they are executed and initialized from the obvious reason. Consider
> the case where the application is doing fallocate-expose-stale-data
> before betting rid of the root cap, then after it gets rid of the root
> cap, the "regular user" have access to the other users old data.
> 
> And it might not even be the case of buggy application, consider very
> simple case where root fallocate-expose-stale-data a file and did not
> set read permission right, then *any* user can read other users data.
> This will definitely happen as this kind of errors happens all the time.
> 
> And also you're assuming that the application developer or root
> administrator know exactly what the problem is and can see all the
> corner cases as are the few I've described above, that's not the case,
> they will get it wrong in some cases especially when it will be promoted
> as performance boost.
> 
> I do not like this "feature" at all, what about rather fixing the
> problem ? Xfs does not seem to have this issue, at least not as
> noticeable, so it is definitely possible.
> 
> Thanks!
> -Lukas
> 
> > 
> > Regards,
> > Zheng
> > 
> > > 
> > > The ext4 delta is a bit larger, though, so it seems worth investigating
> > > the *root cause* of the extra overhead if it's problematic in your
> > > workloads...
> > > 
> > > -Eric
> > > 
> > > 
> > > > Obviously, this flag will bring an secure issue because the malicious user
> > > > could use this flag to get other user's data if (s)he doesn't do a
> > > > initialization before reading this file.  Thus, a sysctl parameter
> > > > 'fs.falloc_no_hide_stale' is defined in order to let administrator to determine
> > > > whether or not this flag is enabled.  Currently, this flag is disabled by
> > > > default.  I am not sure whether this is enough or not.  Another option is that
> > > > a new Kconfig entry is created to remove this flag during the kernel is
> > > > complied.  So any suggestions or comments are appreciated.
> > > > 
> > > > Regards,
> > > > Zheng
> > > > 
> > > > Zheng Liu (3):
> > > >       vfs: add FALLOC_FL_NO_HIDE_STALE flag in fallocate
> > > >       vfs: add security check for _NO_HIDE_STALE flag
> > > >       ext4: add FALLOC_FL_NO_HIDE_STALE support
> > > > 
> > > >  fs/ext4/extents.c      |    7 +++++--
> > > >  fs/open.c              |   12 +++++++++++-
> > > >  include/linux/falloc.h |    5 +++++
> > > >  include/linux/sysctl.h |    1 +
> > > >  kernel/sysctl.c        |   10 ++++++++++
> > > >  5 files changed, 32 insertions(+), 3 deletions(-)
> > > > --
> > > > To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> > > > the body of a message to majordomo@vger.kernel.org
> > > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> 
> -- 
