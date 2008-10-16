From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: ext4: oops on boot with root fs needing recovery
Date: Thu, 16 Oct 2008 15:42:55 -0500
Message-ID: <48F7A74F.5050807@redhat.com>
References: <48F7A013.6060508@goop.org> <20081016203257.GI12962@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: Theodore Tso <tytso@mit.edu>,
	Jeremy Fitzhardinge <jeremy@goop.org>,
	Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:51614 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754266AbYJPUnY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 16 Oct 2008 16:43:24 -0400
In-Reply-To: <20081016203257.GI12962@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso wrote:
> On Thu, Oct 16, 2008 at 01:12:03PM -0700, Jeremy Fitzhardinge wrote:
>> I had a crash and rebooted.  The root filesystem needed journal  
>> recovery, but ext4 crashed.
>>
>> My root fs is ext3 (no extents), but I've been mounting it as ext4 to  
>> see how it turns out.
> 
> Yeah, known bug.  I'll push a patch to Linus to fix this.
> 
>       	    	       	      	       	     - Ted
>

Jeremy, I see you're using an f10 kernel; it'll be in the next kernel
build there, as well.

-Eric
