From: Jim Mauro <James.Mauro@Sun.COM>
Subject: Re: ZFS, XFS, and EXT4 compared
Date: Thu, 30 Aug 2007 14:33:48 -0400
Message-ID: <46D70D8C.8010203@sun.com>
References: <1188454611.23311.13.camel@toonses.gghcwest.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: zfs-discuss@opensolaris.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com
To: "Jeffrey W. Baker" <jwbaker@acm.org>
Return-path: <zfs-discuss-bounces@opensolaris.org>
In-reply-to: <1188454611.23311.13.camel@toonses.gghcwest.com>
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


I'll take a look at this. ZFS provides outstanding sequential IO performance
(both read and write). In my testing, I can essentially sustain 
"hardware speeds"
with ZFS on sequential loads. That is, assuming 30-60MB/sec per disk 
sequential
IO capability (depending on hitting inner or out cylinders), I get 
linear scale-up
on sequential loads as I add disks to a zpool, e.g. I can sustain 
250-300MB/sec
on a 6 disk zpool, and it's pretty consistent for raidz and raidz2.

Your numbers are in the 50-90MB/second range, or roughly 1/2 to 1/4 what was
measured on the other 2 file systems for the same test. Very odd.

Still looking...

Thanks,
/jim

Jeffrey W. Baker wrote:
> I have a lot of people whispering "zfs" in my virtual ear these days,
> and at the same time I have an irrational attachment to xfs based
> entirely on its lack of the 32000 subdirectory limit.  I'm not afraid of
> ext4's newness, since really a lot of that stuff has been in Lustre for
> years.  So a-benchmarking I went.  Results at the bottom:
>
> http://tastic.brillig.org/~jwb/zfs-xfs-ext4.html
>
> Short version: ext4 is awesome.  zfs has absurdly fast metadata
> operations but falls apart on sequential transfer.  xfs has great
> sequential transfer but really bad metadata ops, like 3 minutes to tar
> up the kernel.
>
> It would be nice if mke2fs would copy xfs's code for optimal layout on a
> software raid.  The mkfs defaults and the mdadm defaults interact badly.
>
> Postmark is somewhat bogus benchmark with some obvious quantization
> problems.
>
> Regards,
> jwb
>
> _______________________________________________
> zfs-discuss mailing list
> zfs-discuss@opensolaris.org
> http://mail.opensolaris.org/mailman/listinfo/zfs-discuss
>   
