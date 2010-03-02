From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [ext3] Changes to block device after an ext3 mount point has been remounted readonly
Date: Tue, 02 Mar 2010 13:01:52 +0300
Message-ID: <874okz6nzj.fsf@openvz.org>
References: <baaef4711002180845n29561ccif451fae62e49e520@mail.gmail.com>
	<9F53CAF8-B6B4-40EB-89FA-CD6779D17DBE@sun.com>
	<baaef4711002182338g17e42a7dpa47242dd334a27c2@mail.gmail.com>
	<20100222223252.GA13882@atrey.karlin.mff.cuni.cz>
	<20100222230552.GB13882@atrey.karlin.mff.cuni.cz>
	<16F918FB-F45D-478E-9358-550BB39E277E@sun.com>
	<baaef4711002230042p3d6fa7fam5a80174269773d48@mail.gmail.com>
	<20100223135531.GA7699@atrey.karlin.mff.cuni.cz>
	<877hq2tyg8.fsf@openvz.org> <20100224165646.GL3687@quack.suse.cz>
	<20100302093431.GB5106@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Camille Moncelier <pix@devlife.org>,
	"linux-fsdevel\@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	ext4 development <linux-ext4@vger.kernel.org>,
	viro@zeniv.linux.org.uk
To: Christoph Hellwig <hch@lst.de>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20100302093431.GB5106@lst.de> (Christoph Hellwig's message of
	"Tue, 2 Mar 2010 10:34:31 +0100")
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Christoph Hellwig <hch@lst.de> writes:

> On Wed, Feb 24, 2010 at 05:56:46PM +0100, Jan Kara wrote:
>>   OK, I see that in theory a process can open file for writing after
>> fs_may_remount_ro() before MS_RDONLY flag gets set. That could be really
>> nasty.
>
> Not just in theory, but also in practice.  We can easily hit this under
> load with XFS.
>
>> But by no means we should solve this VFS problem by spilling error
>> messages from the filesystem.
>
> Exactly.

>
>>   Al, Christoph, do I miss something or there is really nothing which
>> prevents a process from opening a file after the fs_may_remount_ro() check
>> in do_remount_sb()?
>
> No, there is nothing.  We really do need a multi-stage remount read-only
> process:
>
>  1) stop any writes from userland, that is opening new files writeable
This is not quite good idea because sync may take really long time,
#fsstress -p32 -d /mnt/TEST -l9999999 -n99999999 -z -f creat=100 -f write=100
#sleep 60;
#killall -9 fsstress
#time mount mnt -oremount,ro
it take several minutes to complete.
And at the end it may fail but other reason.
>  2) stop any periodic writeback from the VM or filesystem-internal
>  3) write out all filesystem data and metadata
>  4) mark the filesystem fully read-only

I've tried to sole the issue in lightly another way
Please take a look on this 
http://marc.info/?l=linux-fsdevel&m=126723036525624&w=2
1) Mark fs as GOING_TO_REMOUNT
2) any new writer will clear this flag
   This allow us to not block 
3) check flag before fssync and after and return EBUSY in this case. 
4) At this time we may to block writers (this is absent in my patch)
   It is acceptable to block writers at this time because later stages
   doesn't take too long.
5) perform fs-specific remount method.
6) Marks filesystem as MS_RDONLY.
