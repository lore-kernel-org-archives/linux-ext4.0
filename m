From: Nick Dokos <nicholas.dokos@hp.com>
Subject: Re: Updated fsx.c program (fixed fallocate)
Date: Fri, 02 Oct 2009 22:40:26 -0400
Message-ID: <8912.1254537626@gamaville.dokosmarshall.org>
References: <20090826052505.GA22238@webber.adilger.int>
 <20090929213859.GB13825@webber.adilger.int>
 <20090929223938.GD3384@webber.adilger.int>
 <1254523031.4095.208.camel@mingming-laptop> <4AC6814C.7070305@redhat.com>
 <1254525965.4095.210.camel@mingming-laptop>
Reply-To: nicholas.dokos@hp.com
Cc: Eric Sandeen <sandeen@redhat.com>,
	Andreas Dilger <adilger@sun.com>, linux-ext4@vger.kernel.org,
	Eric Sandeen <esandeen@redhat.com>,
	Subrata Modak <subrata@linux.vnet.ibm.com>,
	Dave Jones <davej@redhat.com>, linux-fsdevel@vger.kernel.org,
	nicholas.dokos@hp.com
To: Mingming <cmm@us.ibm.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-reply-to: Message from Mingming <cmm@us.ibm.com> of
 "Fri, 02 Oct 2009 16:26:05 PDT." <1254525965.4095.210.camel@mingming-laptop>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Mingming wrote:
> > I think that
> > 
> > #define _GNU_SOURCE
> > 
> > will pull in the glibc headers' definition rather than doing our own....
> > 
> 
> Oh? that's sounds good...
> 
> I tried to replace above with 
> #define _GNU_SOURCE	1
> 
> gcc complained O_DIRECT is still not defined. what did I missing?
> 


,----
| #define _GNU_SOURCE 1
| 
| #include <fcntl.h>
`----

should do it.

Nick
