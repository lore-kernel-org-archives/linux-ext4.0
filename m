From: Ted Ts'o <tytso@mit.edu>
Subject: Re: I/O topology fixes for big physical block size
Date: Fri, 1 Oct 2010 22:31:13 -0400
Message-ID: <20101002023113.GJ21129@thunk.org>
References: <4CA17B13.7080801@redhat.com>
 <20100928141545.GA21587@redhat.com>
 <20100928205741.GA22257@thunk.org>
 <yq162xpa7dj.fsf@sermon.lab.mkp.net>
 <4CA25FEA.6040505@redhat.com>
 <20100930163047.GA4098@thunk.org>
 <4CA4C3B6.9000104@redhat.com>
 <20100930173342.GB31945@redhat.com>
 <20101001142441.GF21129@thunk.org>
 <yq1y6ah4kuu.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Mike Snitzer <snitzer@redhat.com>,
	Eric Sandeen <sandeen@redhat.com>,
	Jens Axboe <jaxboe@fusionio.com>,
	"James.Bottomley@hansenpartnership.com"
	<James.Bottomley@hansenpartnership.com>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:37145 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752237Ab0JBCbX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 1 Oct 2010 22:31:23 -0400
Content-Disposition: inline
In-Reply-To: <yq1y6ah4kuu.fsf@sermon.lab.mkp.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Oct 01, 2010 at 06:19:21PM -0400, Martin K. Petersen wrote:
> Since not all drives guarantee that read-modify-write cycle on a 4 KiB
> physical block won't clobber adjacent 512-byte logical blocks it may be
> a good idea to look at physical block size if there are atomicity
> concerns.  I.e. filesystems that depend on atomic journal writes may
> want to look at the reported physical block size.

OK, but what do we do when we start seeing devices with 8k or 16k
physical block sizes?  The VM doesn't deal well with block sizes >
page size.

					- Ted
