From: eric kustarz <eric.kustarz@sun.com>
Subject: Re: ZFS, XFS, and EXT4 compared
Date: Thu, 30 Aug 2007 12:07:59 -0700
Message-ID: <B6314154-AAB2-4955-9CAE-EAF54BB84922@sun.com>
References: <1188454611.23311.13.camel@toonses.gghcwest.com>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: zfs-discuss@opensolaris.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com
To: "Jeffrey W. Baker" <jwbaker@acm.org>
Return-path: <zfs-discuss-bounces@opensolaris.org>
In-Reply-To: <1188454611.23311.13.camel@toonses.gghcwest.com>
List-Unsubscribe: <http://mail.opensolaris.org/mailman/listinfo/zfs-discuss>,
	<mailto:zfs-discuss-request@opensolaris.org?subject=unsubscribe>
List-Archive: <http://mail.opensolaris.org/pipermail/zfs-discuss>
List-Post: <mailto:zfs-discuss@opensolaris.org>
List-Help: <mailto:zfs-discuss-request@opensolaris.org?subject=help>
List-Subscribe: <http://mail.opensolaris.org/mailman/listinfo/zfs-discuss>,
	<mailto:zfs-discuss-request@opensolaris.org?subject=subscribe>
Sender: zfs-discuss-bounces@opensolaris.org
Errors-To: zfs-discuss-bounces@opensolaris.org
List-Id: linux-ext4.vger.kernel.org


On Aug 29, 2007, at 11:16 PM, Jeffrey W. Baker wrote:

> I have a lot of people whispering "zfs" in my virtual ear these days,
> and at the same time I have an irrational attachment to xfs based
> entirely on its lack of the 32000 subdirectory limit.  I'm not  
> afraid of
> ext4's newness, since really a lot of that stuff has been in Lustre  
> for
> years.  So a-benchmarking I went.  Results at the bottom:
>
> http://tastic.brillig.org/~jwb/zfs-xfs-ext4.html
>
> Short version: ext4 is awesome.  zfs has absurdly fast metadata
> operations but falls apart on sequential transfer.  xfs has great
> sequential transfer but really bad metadata ops, like 3 minutes to tar
> up the kernel.
>
> It would be nice if mke2fs would copy xfs's code for optimal layout  
> on a
> software raid.  The mkfs defaults and the mdadm defaults interact  
> badly.
>
> Postmark is somewhat bogus benchmark with some obvious quantization
> problems.
>
> Regards,
> jwb
>

Hey jwb,

Thanks for taking up the task, its benchmarking so i've got some  
questions...

What does it mean to have an external vs. internal journal for ZFS?

Can you show the output of 'zpool status' when using software RAID  
vs. hardware RAID for ZFS?

The hardware RAID has a cache on the controller.  ZFS will flush the  
"cache" when pushing out a txg (essentially before writing out the  
uberblock and after writing out the uberblock).  When you have a non- 
volatile cache with battery backing (such as your setup), its safe to  
disable that via putting 'set zfs:zfs_nocacheflush = 1' in /etc/ 
system and rebooting.  Its ugly but we're going through the final  
code review of a fix for this (its partly we aren't sending down the  
right command and partly even if we did, no storage devices actually  
support it quite yet).

What parameters did you give bonnie++?  compiled 64bit, right?

For the randomio test, it looks like you used an io_size of 4KB.  Are  
those aligned?  random?  How big is the '/dev/sdb' file?

Do you have the parameters given to FFSB?

eric
