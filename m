From: Larkin Lowrey <llowrey@nuclearwinter.com>
Subject: Re: Q wrt LVM snapshot of ext4 w/ external journal
Date: Tue, 13 Apr 2010 16:06:41 -0500
Message-ID: <4BC4DCE1.3050600@nuclearwinter.com>
References: <4BC4B66B.9000205@nuclearwinter.com> <20100413192257.GP1849@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from titan.nuclearwinter.com ([209.40.204.131]:36256 "EHLO
	titan.nuclearwinter.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752246Ab0DMVGn (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 13 Apr 2010 17:06:43 -0400
In-Reply-To: <20100413192257.GP1849@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 4/13/2010 2:22 PM, tytso@mit.edu wrote:
> It's safe to mount the LVM2 snapshot only if you use the mount option
> noload.  This will prevent it from using the journal, which is good,
> since the journal is in use by the original file system.  :-)
>
>   
I was able to verify that mounting with noload worked as advertised.
Thank you. The exact message was "mounted filesystem without journal".
> Hopefully, mounting the snapshot without using noload _should_ fail,
> since the journal is already in use, but I'm not sure we have that
> check in place, so I don't recommend trying it on a production file
> system.
I also verified that mounting w/o noload causes the mount operation to
fail. The message was "failed to claim external journal device".

When I unmounted the original fs so that the journal device was not in
use and then tried to mount the snapshot w/o noload, the mounted
snapshot was able to claim the journal. Of course I would never do that
on purpose but I wanted to see what would happen. I believe this falls
under the "don't do that or bad things will happen" category.

Thank you very much for your response to my query.

--Larkin
