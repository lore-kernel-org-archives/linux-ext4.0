From: Bas van Schaik <bas@tuxes.nl>
Subject: Re: e2fsck dies with error "this should never happen!!!"
Date: Fri, 22 Feb 2008 14:14:40 +0100
Message-ID: <47BECAC0.5010707@tuxes.nl>
References: <47BEBAF1.4090505@tuxes.nl> <20080222123852.GI20118@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from pollux.sshunet.nl ([145.97.192.42]:38101 "EHLO
	pollux.sshunet.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755626AbYBVNOi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 22 Feb 2008 08:14:38 -0500
In-Reply-To: <20080222123852.GI20118@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso wrote:
> On Fri, Feb 22, 2008 at 01:07:13PM +0100, Bas van Schaik wrote:
>   
>> Hi all,
>>
>> Currently, I have a big problem: e2fsck refuses to fix my currupted
>> filesystem...
>>     
>
> The things that I would suggest first of all is upgrading to the
> latest version of e2fsprogs.  If that doesn't fix it, I'm going to
> need either a compressed e2image file (see the e2image man page) or
> login access to see what is up.
Thanks for the suggestion, I was naively assuming that e2fsck wasn't
under active development. I've installed the statically linked 1.40.6
from Debian Lenny and it's running. However, it will take quite a long
time before it will actually hit the point where the old version found
problems.
I'll let you know what the results are!

Regards,

  -- Bas
