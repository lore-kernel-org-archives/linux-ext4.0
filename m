From: Andreas Dilger <andreas.dilger@oracle.com>
Subject: Re: [PATCH][BUG] ext4: fix returning with 0 from write system call on ext4 with noextent
Date: Sun, 25 Jul 2010 20:55:36 -0600
Message-ID: <3CB5D95F-5CAB-4ED3-9837-3DF2DF69FA6D@oracle.com>
References: <20100726111636.72264f8c.toshi.okajima@jp.fujitsu.com>
Mime-Version: 1.0 (iPhone Mail 8A306)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: "tytso@mit.edu" <tytso@mit.edu>,
	"adilger@sun.com" <adilger@sun.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"sandeen@redhat.com" <sandeen@redhat.com>
To: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:46821 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753170Ab0GZC5J convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 25 Jul 2010 22:57:09 -0400
In-Reply-To: <20100726111636.72264f8c.toshi.okajima@jp.fujitsu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2010-07-25, at 20:16, Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com> wrote:
> 
> -        if (pos > sbi->s_bitmap_maxbytes)
> +        if (pos > sbi->s_bitmap_maxbytes
> +           || (pos == sbi->s_bitmap_maxbytes && length > 0))
>            return -EFBIG;

Minor note - the kernel coding style is to put the '||' at the end of the first line instead of the start of the second line. 

I thunk it would also be sufficient to do:

        if (pos > sbi->s_bitmap_maxbytes + !!length)
                 return -EFBIG;