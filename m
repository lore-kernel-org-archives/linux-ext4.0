From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: xfstest ext4 'utility required' run stop
Date: Wed, 12 Jun 2013 15:57:14 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1306121555350.14273@localhost.localdomain>
References: <20130612053618.296170@gmx.com> <20130612063132.GA29898@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: jon ernst <jonernst07@gmx.com>, linux-ext4@vger.kernel.org
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:30654 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753181Ab3FLN5V (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 12 Jun 2013 09:57:21 -0400
In-Reply-To: <20130612063132.GA29898@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 12 Jun 2013, Zheng Liu wrote:

> Date: Wed, 12 Jun 2013 14:31:32 +0800
> From: Zheng Liu <gnehzuil.liu@gmail.com>
> To: jon ernst <jonernst07@gmx.com>
> Cc: linux-ext4@vger.kernel.org
> Subject: Re: xfstest ext4 'utility required' run stop
> 
> On Wed, Jun 12, 2013 at 01:36:18AM -0400, jon ernst wrote:
> > Hi,
> > 
> > When I try to run xfstest 301 - 304. They all got error message "utility required, run stop, stkip this test" , test 305 is fine.
> > But it did not tell which utility is required. I do have test patition and scratch partition set up. And I do have e4defrag on my linux.
> > 
> > What could be the reason?please help.
> 
> Hi Jon,
> 
> Could you please check that 'fio' utility has been installed?  You can
> get it from this link:
>   git clone git://git.kernel.dk/fio.git
> 
> Regards,
>                                                 - Zheng

Right, you're missing 'fio' utility. And there is a bug in xfstests
because it should tell you that, I will send patch.

Thanks!
-Lukas

> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
