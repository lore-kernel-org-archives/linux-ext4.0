From: "Cyril Plisko" <cyril.plisko@mountall.com>
Subject: Re: ZFS, XFS, and EXT4 compared
Date: Thu, 30 Aug 2007 09:25:04 +0300
Message-ID: <c7dddeaa0708292325l4006775aq827b80117048638@mail.gmail.com>
References: <1188454611.23311.13.camel@toonses.gghcwest.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: zfs-discuss@opensolaris.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com
To: "Jeffrey W. Baker" <jwbaker@acm.org>
Return-path: <zfs-discuss-bounces@opensolaris.org>
In-Reply-To: <1188454611.23311.13.camel@toonses.gghcwest.com>
Content-Disposition: inline
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

Jeffrey,

it would be interesting to see your zpool layout info as well.
It can significantly influence the results obtained in the benchmarks.



On 8/30/07, Jeffrey W. Baker <jwbaker@acm.org> wrote:
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


-- 
Regards,
        Cyril
