From: Adrian Bunk <bunk@stusta.de>
Subject: Re: [patch 15/23] ext3 -nobh option causes oops
Date: Fri, 17 Nov 2006 17:47:39 +0100
Message-ID: <20061117164739.GB31879@stusta.de>
References: <20060804053258.391158155@quad.kroah.org> <20060804054003.GP769@kroah.com> <20061116225154.GK31879@stusta.de> <1163718474.7662.26.camel@dyn9047017100.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:64785 "HELO
	mailout.stusta.mhn.de") by vger.kernel.org with SMTP
	id S1755685AbWKQQrk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 17 Nov 2006 11:47:40 -0500
To: Badari Pulavarty <pbadari@us.ibm.com>
Content-Disposition: inline
In-Reply-To: <1163718474.7662.26.camel@dyn9047017100.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Nov 16, 2006 at 03:07:54PM -0800, Badari Pulavarty wrote:
> 
> On Thu, 2006-11-16 at 23:51 +0100, Adrian Bunk wrote:
> > It seems this patch that went into 2.6.17.8 should also be included in 
> > the 2.6.16.x branch, or do I miss anything?
> > 
> 
> Yes. This is needed for 2.6.16.x branch also.

Thanks, I've applied it.

> Thanks,
> Badari

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed
