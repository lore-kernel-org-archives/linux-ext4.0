From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: ext4_mb_generate_buddy and double-free errors
Date: Thu, 12 Mar 2009 21:03:53 -0500
Message-ID: <49B9BF09.6010306@redhat.com>
References: <1236904175.731.12.camel@bobble.smo.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Frank Mayhar <fmayhar@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:54912 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751150AbZCMCEE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 12 Mar 2009 22:04:04 -0400
In-Reply-To: <1236904175.731.12.camel@bobble.smo.corp.google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Frank Mayhar wrote:
> We're seeing errors like:
>   EXT4-fs error (device sda3): ext4_mb_generate_buddy: EXT4-fs: group 3049: 21020 blocks in bitmap, 21529 in gd
> 
> Usually after this the system is cleaned and in the process we see many
> "mb_free_blocks: double-free of inode x's block y(bit z in group d)".
> (In fact, we see exactly as many of these as the difference between the
> group and computed count of free blocks.)
> 
> It looks like the bitmap itself is getting messed up somehow, at least
> enough to make the free count disagree with the map itself.  Has anyone
> else seen something like this?  Any pointers as to where to look for
> potential culprits?

Which kernel, for starters?

I saw some of those reports a while back; haven't since, though don't
know offhand what might have been the root cause or fix...

-Eric
