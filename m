From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [dm-devel] do not disable ext4 discards on first discard failure?
 [was: Re: dm snapshot: ignore discards issued to the snapshot-origin
 target]
Date: Wed, 4 May 2011 18:12:49 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1105041812040.7938@dhcp-27-109.brq.redhat.com>
References: <20110413224025.GA18589@redhat.com> <20110413234854.GA19793@redhat.com> <20110426173213.GA19604@redhat.com> <20110428001912.GA14659@redhat.com> <20110428075355.GA2190@infradead.org> <20110428205935.GA24979@redhat.com>
 <alpine.LFD.2.00.1104291117510.5496@dhcp-27-109.brq.redhat.com> <20110429122454.GL32370@agk-dp.fab.redhat.com> <alpine.LFD.2.00.1105020857030.3778@dhcp-27-109.brq.redhat.com> <20110502081308.GC8642@agk-dp.fab.redhat.com> <20110502081925.GA11312@infradead.org>
 <alpine.LFD.2.00.1105021217080.3778@dhcp-27-109.brq.redhat.com> <yq1bozl420p.fsf@sermon.lab.mkp.net> <alpine.LFD.2.00.1105021631590.3778@dhcp-27-109.brq.redhat.com> <yq1tydd2g5h.fsf@sermon.lab.mkp.net> <alpine.LFD.2.00.1105031036090.4250@dhcp-27-109.brq.redhat.com>
 <yq1sjsuzebu.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1232738966-1304525574=:7938"
Cc: Lukas Czerner <lczerner@redhat.com>, Karel Zak <kzak@redhat.com>,
	Christoph Hellwig <hch@infradead.org>,
	device-mapper development <dm-devel@redhat.com>,
	Alasdair G Kergon <agk@redhat.com>, sandeen@redhat.com,
	Mike Snitzer <snitzer@redhat.com>, DarkNovaNick@gmail.com,
	linux-lvm@redhat.com, linux-ext4@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:6489 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751760Ab1EDQNK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 4 May 2011 12:13:10 -0400
In-Reply-To: <yq1sjsuzebu.fsf@sermon.lab.mkp.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1232738966-1304525574=:7938
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Wed, 4 May 2011, Martin K. Petersen wrote:

> >>>>> "Lukas" == Lukas Czerner <lczerner@redhat.com> writes:
> 
> I got tired of poking around in sysfs to find the discard topology.
> Here's a patch against lsblk that adds a -D option to present this
> information in a human-readable form:
> 
> # lsblk -D
> NAME                  DISC-ALN DISC-GRAN DISC-MAX DISC-ZERO
> sda                          0        0B       0B         0
> └─sda1                       0        0B       0B         0
> sdb                          0      512B       2G         1
> └─sdb1                       0      512B       2G         1

Very useful indeed!

Thanks!
-Lukas

> 
> 
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
> 
> diff --git a/misc-utils/lsblk.8 b/misc-utils/lsblk.8
> index 38ff48f..d7d7aa8 100644
> --- a/misc-utils/lsblk.8
> +++ b/misc-utils/lsblk.8
> @@ -29,6 +29,8 @@ Print the SIZE column in bytes rather than in human-readable format.
>  .IP "\fB\-d, \-\-nodeps\fP"
>  Don't print device holders or slaves.  For example "lsblk --nodeps /dev/sda" prints
>  information about the sda device only.
> +.IP "\fB\-D, \-\-discard\fP"
> +Print information about the discard (TRIM, UNMAP) capabilities for each device.
>  .IP "\fB\-e, \-\-exclude \fIlist\fP
>  Exclude the devices specified by a comma-separated \fIlist\fR of major device numbers.
>  Note that RAM disks (major=1) are excluded by default.
> diff --git a/misc-utils/lsblk.c b/misc-utils/lsblk.c
> index 38326d0..671e690 100644
> --- a/misc-utils/lsblk.c
> +++ b/misc-utils/lsblk.c
> @@ -77,6 +77,10 @@ enum {
>  	COL_ROTA,
>  	COL_SCHED,
>  	COL_TYPE,
> +	COL_DALIGN,
> +	COL_DGRAN,
> +	COL_DMAX,
> +	COL_DZERO,
>  
>  	__NCOLUMNS
>  };
> @@ -112,8 +116,11 @@ static struct colinfo infos[__NCOLUMNS] = {
>  	[COL_PHYSEC] = { "PHY-SEC", 7, TT_FL_RIGHT, N_("physical sector size") },
>  	[COL_LOGSEC] = { "LOG-SEC", 7, TT_FL_RIGHT, N_("logical sector size") },
>  	[COL_SCHED]  = { "SCHED",   0.1, 0, N_("I/O scheduler name") },
> -	[COL_TYPE]   = { "TYPE",    4, 0, N_("device type") }
> -
> +	[COL_TYPE]   = { "TYPE",    4, 0, N_("device type") },
> +	[COL_DALIGN] = { "DISC-ALN", 6, TT_FL_RIGHT, N_("discard alignment offset") },
> +	[COL_DGRAN]  = { "DISC-GRAN", 6, TT_FL_RIGHT, N_("discard granularity") },
> +	[COL_DMAX]   = { "DISC-MAX", 6, TT_FL_RIGHT, N_("discard max bytes") },
> +	[COL_DZERO]  = { "DISC-ZERO", 1, TT_FL_RIGHT, N_("discard zeroes data") },
>  };
>  
>  struct lsblk {
> @@ -702,6 +709,33 @@ static void set_tt_data(struct blkdev_cxt *cxt, int col, int id, struct tt_line
>  		if (p)
>  			tt_line_set_data(ln, col, p);
>  		break;
> +	case COL_DALIGN:
> +		p = sysfs_strdup(cxt, "discard_alignment");
> +		if (p)
> +			tt_line_set_data(ln, col, p);
> +		break;
> +	case COL_DGRAN:
> +		p = sysfs_strdup(cxt, "queue/discard_granularity");
> +		if (!lsblk->bytes)
> +			p = size_to_human_string(atoi(p));
> +
> +		if (p)
> +			tt_line_set_data(ln, col, p);
> +		break;
> +	case COL_DMAX:
> +		p = sysfs_strdup(cxt, "queue/discard_max_bytes");
> +
> +		if (!lsblk->bytes)
> +			p = size_to_human_string(atoi(p));
> +
> +		if (p)
> +			tt_line_set_data(ln, col, p);
> +		break;
> +	case COL_DZERO:
> +		p = sysfs_strdup(cxt, "queue/discard_zeroes_data");
> +		if (p)
> +			tt_line_set_data(ln, col, p);
> +		break;
>  	};
>  }
>  
> @@ -930,6 +964,7 @@ static void __attribute__((__noreturn__)) help(FILE *out)
>  		" -a, --all            print all devices\n"
>  		" -b, --bytes          print SIZE in bytes rather than in human readable format\n"
>  		" -d, --nodeps         don't print slaves or holders\n"
> +		" -D, --discard        print discard capabilities\n"
>  		" -e, --exclude <list> exclude devices by major number (default: RAM disks)\n"
>  		" -f, --fs             output info about filesystems\n"
>  		" -h, --help           usage information (this)\n"
> @@ -967,6 +1002,7 @@ int main(int argc, char *argv[])
>  		{ "all",	0, 0, 'a' },
>  		{ "bytes",      0, 0, 'b' },
>  		{ "nodeps",     0, 0, 'd' },
> +		{ "discard",    0, 0, 'D' },
>  		{ "help",	0, 0, 'h' },
>  		{ "output",     1, 0, 'o' },
>  		{ "perms",      0, 0, 'm' },
> @@ -987,7 +1023,7 @@ int main(int argc, char *argv[])
>  	lsblk = &_ls;
>  	memset(lsblk, 0, sizeof(*lsblk));
>  
> -	while((c = getopt_long(argc, argv, "abde:fhlnmo:irt", longopts, NULL)) != -1) {
> +	while((c = getopt_long(argc, argv, "abdDe:fhlnmo:irt", longopts, NULL)) != -1) {
>  		switch(c) {
>  		case 'a':
>  			lsblk->all_devices = 1;
> @@ -998,6 +1034,13 @@ int main(int argc, char *argv[])
>  		case 'd':
>  			lsblk->nodeps = 1;
>  			break;
> +		case 'D':
> +			columns[ncolumns++] = COL_NAME;
> +			columns[ncolumns++] = COL_DALIGN;
> +			columns[ncolumns++] = COL_DGRAN;
> +			columns[ncolumns++] = COL_DMAX;
> +			columns[ncolumns++] = COL_DZERO;
> +			break;
>  		case 'e':
>  			parse_excludes(optarg);
>  			break;
> 

-- 
--8323328-1232738966-1304525574=:7938--
