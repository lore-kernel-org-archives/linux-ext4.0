From: "Daniel Taylor" <Daniel.Taylor@wdc.com>
Subject: RE: I/O topology fixes for big physical block size
Date: Fri, 1 Oct 2010 20:03:26 -0700
Message-ID: <469D2D911E4BF043BFC8AD32E8E30F5BF2CFDF@wdscexbe07.sc.wdc.com>
References: <4CA17B13.7080801@redhat.com> <20100928141545.GA21587@redhat.com> <20100928205741.GA22257@thunk.org> <yq162xpa7dj.fsf@sermon.lab.mkp.net> <4CA25FEA.6040505@redhat.com> <20100930163047.GA4098@thunk.org> <4CA4C3B6.9000104@redhat.com> <20100930173342.GB31945@redhat.com> <20101001142441.GF21129@thunk.org> <yq1y6ah4kuu.fsf@sermon.lab.mkp.net> <20101002023113.GJ21129@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
To: <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from wdscspam1.wdc.com ([129.253.170.130]:36446 "EHLO
	wdscspam1.wdc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752126Ab0JBDPi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 1 Oct 2010 23:15:38 -0400
Content-class: urn:content-classes:message
In-Reply-To: <20101002023113.GJ21129@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

 

> -----Original Message-----
> From: linux-ext4-owner@vger.kernel.org 
> [mailto:linux-ext4-owner@vger.kernel.org] On Behalf Of Ted Ts'o
> Sent: Friday, October 01, 2010 7:31 PM
> To: Martin K. Petersen
> Cc: Mike Snitzer; Eric Sandeen; Jens Axboe; 
> James.Bottomley@hansenpartnership.com; 
> linux-scsi@vger.kernel.org; linux-ext4@vger.kernel.org
> Subject: Re: I/O topology fixes for big physical block size
> 
> On Fri, Oct 01, 2010 at 06:19:21PM -0400, Martin K. Petersen wrote:
> > Since not all drives guarantee that read-modify-write cycle 
> on a 4 KiB
> > physical block won't clobber adjacent 512-byte logical 
> blocks it may be
> > a good idea to look at physical block size if there are atomicity
> > concerns.  I.e. filesystems that depend on atomic journal writes may
> > want to look at the reported physical block size.
> 
> OK, but what do we do when we start seeing devices with 8k or 16k
> physical block sizes?  The VM doesn't deal well with block sizes >
> page size.

This is a very real concern.

Those drives already exist, in essence, in RAID configurations, and
we have had to do a workaround that complicates our production process
to handle file systems for embedded devices where the file system block
size is 64K (the kernel block size for the device is also 64K), but
there's no corresponding x86 block size available.

BTW, not all drives with 4096-byte physical blocks are reporting themselves
as such.  Some of them report as 512-byte physical.

> 
> 					- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe 
> linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
