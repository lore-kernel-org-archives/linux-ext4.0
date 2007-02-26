From: Adrian Bunk <bunk@stusta.de>
Subject: Re: [RFC: 2.6.16 patch] ext3: fix ext3 block bitmap leakage
Date: Mon, 26 Feb 2007 15:35:44 +0100
Message-ID: <20070226143544.GM29575@stusta.de>
References: <45DA2CB2.4080507@redhat.com> <20070220151950.GV13958@stusta.de> <45DB2B15.70603@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: Chuck Ebbert <cebbert@redhat.com>,
	Kirill Korotaev <dev@openvz.org>, sct@redhat.com,
	akpm@linux-foundation.org, adilger@clusterfs.com,
	linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:44662 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030289AbXBZOfo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 26 Feb 2007 09:35:44 -0500
Content-Disposition: inline
In-Reply-To: <45DB2B15.70603@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Feb 20, 2007 at 11:08:37AM -0600, Eric Sandeen wrote:
> Adrian Bunk wrote:
> > On Mon, Feb 19, 2007 at 06:03:14PM -0500, Chuck Ebbert wrote:
> > 
> >> This was dropped from 2.6.16-stable somehow:
> >>
> >> http://lkml.org/lkml/2006/6/30/54
> > 
> > Thanks for forwarding it.
> > 
> > This patch didn't went in this form into Linus' tree, I'd therefore like 
> > to get an ACK from the ext3 maintainers (Cc'ed) before applying it.
> 
> Yep, ACK from me for 2.6.16-stable.

Thanks, I've applied it.

> -Eric

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed
