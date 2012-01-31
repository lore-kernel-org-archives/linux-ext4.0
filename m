From: Tao Ma <tm@tao.ma>
Subject: Re: Bigalloc ENOSPC woes
Date: Wed, 01 Feb 2012 00:03:09 +0800
Message-ID: <4F2810BD.6040806@tao.ma>
References: <4F270949.30800@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Theodore Ts'o <tytso@mit.edu>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:36679 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754675Ab2AaQDY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 31 Jan 2012 11:03:24 -0500
In-Reply-To: <4F270949.30800@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 01/31/2012 05:19 AM, Eric Sandeen wrote:
> I got nervous when I tried this on an -O bigalloc -C 65536 fs:
> 
> # echo foo > blah; du -hc blah; sync; du -hc blah
> 4.0K blah
> 4.0K total
> 64K blah
> 64K total
> 
> Seems that du should never report less than the cluster size, should it?
It is a bug and the corresponding fix is sent with the subject "ext4:
let getattr report the right blocks in delalloc+bigalloc."
> 
> And that made me wonder about ENOSPC handling - are we tracing delalloc allocations correctly?
> 
> From running xfstest 204 on a similarly-created fs, it really seems that we are not.
> 
> A manual test of creating 4-byte files until ENOSPC (which was really when I ran out of inodes) and then issuing a sync led to a storm of kernel messages about allocation failures:
> 
> [  482.154538] EXT4-fs (sdb6): delayed block allocation failed for inode 1664 at logical offset 0 with max blocks 1 with error -28
> [  482.154540] EXT4-fs (sdb6): This should not happen!! Data will be lost
> 
> <ad infinitum, or at least 600 or so in my case>
> 
> and an end result of a bunch of 4 byte long files with no extents.  Almost like files full of NULLs.  Careful - that is hard to live down.  :)
yeah, I can reproduce it easily and more investigation is needed here.

Thanks
Tao
> 
> Ted, are you aware of those issues in bigalloc?
> 
> -Eric
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

