From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2] fs: Do not dispatch FITRIM through separate
 super_operation
Date: Fri, 19 Nov 2010 10:34:26 -0500
Message-ID: <20101119153426.GA25655@infradead.org>
References: <4CE59E57.2090009@teksavvy.com>
 <yq1r5eiw5os.fsf@sermon.lab.mkp.net>
 <4CE5C616.7070706@teksavvy.com>
 <AANLkTikgEeUL2NVLLdoT3RX0r=v0Pzfp9-==F39DVRgN@mail.gmail.com>
 <20101119115516.GA1152@infradead.org>
 <4CE6831E.4020606@teksavvy.com>
 <20101119140639.GA25488@infradead.org>
 <4CE68E2C.9070101@teksavvy.com>
 <20101119145423.GA27919@infradead.org>
 <4CE696C4.4030309@teksavvy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@infradead.org>,
	Greg Freemyer <greg.freemyer@gmail.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	James Bottomley <James.Bottomley@suse.de>,
	Jeff Moyer <jmoyer@redhat.com>,
	Matthew Wilcox <matthew@wil.cx>,
	Josef Bacik <josef@redhat.com>,
	Lukas Czerner <lczerner@redhat.com>, tytso@mit.edu,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, sandeen@redhat.com
To: Mark Lord <kernel@teksavvy.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:37045 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754849Ab0KSPej (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 19 Nov 2010 10:34:39 -0500
Content-Disposition: inline
In-Reply-To: <4CE696C4.4030309@teksavvy.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Nov 19, 2010 at 10:24:52AM -0500, Mark Lord wrote:
> I wonder if this can be treated more like how SG_IO does things?
> The SG_IO mechanism seems to have no issues passing through stuff
> like this, so perhaps we could implement something in a similar fashion?

We actually sent discards down as BLOCK_PC commands, which basically
is SG_IO style I/O from kernelspace.  But that caused a lot of problems
with scsi error handling so we moved away from it.  But even when
you do a BLOCK_PC UNMAP command that later gets translated to a TRIM
by libata you have a few issues:

 - you need to get partion offsets in the I/O sumitter to include them
   in every range.  That's doable but a quite nasty layering violation,
   and it also prevents us from ever adding DM/MD support to that
   scheme.
 - you'll have to allocate new memory for the TRIM payload in libata,
   and switch the libata command to use it, instead of the current
   hack to reuse the zeroed page sent down with the WRITE SAME command.
   I tried to get the payload switching in libata to work a few times,
   but never managed to get it right.

