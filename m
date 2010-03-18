From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: >2TB file issue with e2fsck
Date: Thu, 18 Mar 2010 16:57:23 -0500
Message-ID: <4BA2A1C3.3080809@redhat.com>
References: <150c16851003181425s3cea7067o1505279f9d01b0a9@mail.gmail.com> <4BA29D56.4040607@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Justin Maggard <jmaggard10@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:6531 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751824Ab0CRV5b (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 18 Mar 2010 17:57:31 -0400
In-Reply-To: <4BA29D56.4040607@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 03/18/2010 04:38 PM, Eric Sandeen wrote:

> commmit 8a8f36540bbf5d4397cf476e216e9a720b5c1d8e added handling of
> the high i_blocks number, but did not enlarge the container it
> went into:
> 
> -       if ((pb.num_blocks != inode->i_blocks) ||
> +       if ((pb.num_blocks != ext2fs_inode_i_blocks(fs, inode)) ||
> 
> -Eric
> 

Actually, no, that was too quick a skim through, sorry.  :)

does your filesystem end up with the EXT4_FEATURE_RO_COMPAT_HUGE_FILE
feature set after your posix_fallocate test?

-Eric

