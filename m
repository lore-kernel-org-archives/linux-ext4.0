From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH 1/2] fs: Do not dispatch FITRIM through separate
 super_operation
Date: Fri, 19 Nov 2010 19:14:21 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1011191913260.3238@dhcp-lab-213.englab.brq.redhat.com>
References: <1290100750.3041.72.camel@mulgrave.site> <x494obe4kd5.fsf@segfault.boston.devel.redhat.com> <1290102098.3041.77.camel@mulgrave.site> <AANLkTim=SkqBehcCvEME7YVHk3S0dLdmBS8ooRF+-BuW@mail.gmail.com> <4CE59E57.2090009@teksavvy.com>
 <yq1r5eiw5os.fsf@sermon.lab.mkp.net> <4CE5C616.7070706@teksavvy.com> <AANLkTikgEeUL2NVLLdoT3RX0r=v0Pzfp9-==F39DVRgN@mail.gmail.com> <20101119115516.GA1152@infradead.org> <AANLkTimQZKLtKpKRUJ-KyCyo29F_Mnws8J54G3CeMkyc@mail.gmail.com> <20101119163828.GA8023@infradead.org>
 <alpine.LFD.2.00.1011191853210.3238@dhcp-lab-213.englab.brq.redhat.com> <alpine.LFD.2.00.1011191907250.3238@dhcp-lab-213.englab.brq.redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Christoph Hellwig <hch@infradead.org>,
	Greg Freemyer <greg.freemyer@gmail.com>,
	Mark Lord <kernel@teksavvy.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	James Bottomley <James.Bottomley@suse.de>,
	Jeff Moyer <jmoyer@redhat.com>,
	Matthew Wilcox <matthew@wil.cx>,
	Josef Bacik <josef@redhat.com>, tytso@mit.edu,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, sandeen@redhat.com
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:14072 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755607Ab0KSSOo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 19 Nov 2010 13:14:44 -0500
In-Reply-To: <alpine.LFD.2.00.1011191907250.3238@dhcp-lab-213.englab.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 19 Nov 2010, Lukas Czerner wrote:
> 
> 1. mkfs
> 2. mount -o (nodiscard|discard)
> 3. ./postmark
> 4. umount
> 5. repeat 1. - 4. ten times for each mnt option
> 
> -snip-

Done on 2.6.37-rc2 kernel.

-Lukas
