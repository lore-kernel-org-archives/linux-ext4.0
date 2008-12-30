From: Alex Tomas <bzzz@Sun.COM>
Subject: Re: [dm-devel] Re: jbd2 inside a device mapper module
Date: Tue, 30 Dec 2008 09:55:57 +0300
Message-ID: <4959C5FD.3050305@sun.com>
References: <20081225143535.GA4127@blitiri.com.ar>
 <20081227200127.GX5000@webber.adilger.int>
 <46A00B48CC54E4468EF6911F877AC4CA01DDBB66@blrx3m10.blr.amer.dell.com>
 <20081229210537.GN4127@blitiri.com.ar>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=ISO-8859-1
Content-Transfer-Encoding: 7BIT
Cc: Shyam_Iyer@Dell.com, dm-devel@redhat.com,
	linux-ext4@vger.kernel.org, tytso@MIT.EDU,
	linux-kernel@vger.kernel.org
To: Alberto Bertogli <albertito@blitiri.com.ar>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from gmp-eb-inf-1.sun.com ([192.18.6.21]:48822 "EHLO
	gmp-eb-inf-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751524AbYL3HJC (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 30 Dec 2008 02:09:02 -0500
In-reply-to: <20081229210537.GN4127@blitiri.com.ar>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

one good thing about JBD is that you can't update target block and csum
atomically. so, either you use some form of COW or you use journalling.
given we already have JBD it'd make sense to use it?

thanks, Alex

Alberto Bertogli wrote:
> I think I'll go with the "two metadatas" approach and see how it goes.
> Worst case scenario is that I have to drop that code, which means to be
> back where I am now, only with one less option.
> 
> Thanks,
> 		Alberto
> 

