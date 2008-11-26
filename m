From: Arturas K <arturas@cerberis.soften.ktu.lt>
Subject: Re: rm: cannot remove `???': No such file or directory
Date: Wed, 26 Nov 2008 11:47:50 +0200
Message-ID: <492D1B46.8020204@cerberis.soften.ktu.lt>
References: <492AB6C5.1050609@cerberis.soften.ktu.lt> <20081125063558.GG20928@mit.edu> <492BCA76.50308@cerberis.soften.ktu.lt> <20081125202841.GF525@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cerberis.soften.ktu.lt ([193.219.33.193]:33298 "EHLO
	cerberis.soften.ktu.lt" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751364AbYKZJr6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 26 Nov 2008 04:47:58 -0500
In-Reply-To: <20081125202841.GF525@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso wrote:
> On Tue, Nov 25, 2008 at 11:50:46AM +0200, Arturas K wrote:
>> as I written before:
> 
> Sorry I missed that before.  Yeah, known problem, fixed in git commit
> 3c37fc86 in the 2.6.28-rc development cycle.  The patch has been
> queued to the stable kernel maintainers for inclusion in an upcoming
> 2.6.27.y release, but it hasn't made it out yet.  I can file a request
> to include a set of patches into a future Ubuntu kernel update, but I
> don't know how quickly Ubuntu will push out a new kernel.
> 
>       	       	       	      	   	    - Ted

hello,

I tested 2.6.28-rc6 - problem gone :D

it would be grate if you filed appropriate bug for ubuntu. updated 
ubuntu kernel will follow at worst than more bugs acumulate

---
ArturasK.
