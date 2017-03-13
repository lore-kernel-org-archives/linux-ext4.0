From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: v4.7--v4.10+: ext4: repeatable inline-data oops (and fs
 corruption) caused by msync() of shared writable mmap (with recipe)
Date: Sun, 12 Mar 2017 17:52:32 -0700
Message-ID: <20170313005232.GA593@zzz>
References: <874lzdcj9r.fsf@esperi.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Nick Alcock <nick.alcock@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:34220 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750986AbdCMAwg (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sun, 12 Mar 2017 20:52:36 -0400
Content-Disposition: inline
In-Reply-To: <874lzdcj9r.fsf@esperi.org.uk>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Mar 01, 2017 at 11:45:52AM +0000, Nick Alcock wrote:
> [Resend, after the first attempt, from my home address, failed with
>  endless greylisting followed by "4.5.0 Interactive router timed out"
>  from all but the lowest-priority MX for vger, and "Name server:
>  bl-ckh-le.kernel.org.: host not found" for the apparently-nonexistent
>  lowest-priority MX. Maybe it'll work better from here.]
> 
> I first spotted this -- or it spotted me -- back in the v4.7.x days. It
> is still present in v4.10.
> 
> Here's a replication recipe, given a reasonable rootfs with a compiler
> on it, and assuming a blank virtio disk on /dev/vdb:
> 

Hi Nick, thanks for reporting this.  I've sent a patch which should fix this,
and Cc'ed you.  This actually seems to been a bug for a very long time, maybe
even ever since the inline_data feature was introduced.  (I was able to
reproduce it in a 3.18 kernel, at least.)  I'm not sure why it didn't get
noticed earlier --- maybe hardly anyone ever writes to small files with mmap...

- Eric
