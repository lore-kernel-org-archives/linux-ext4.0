From: Ric Wheeler <ricwheeler@gmail.com>
Subject: Re: Feature request: e2fsck -z
Date: Wed, 10 Aug 2011 07:34:46 +0100
Message-ID: <4E422686.8080207@gmail.com>
References: <4E4173D4.9010104@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ww0-f47.google.com ([74.125.82.47]:41127 "EHLO
	mail-ww0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164Ab1HJGlm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 10 Aug 2011 02:41:42 -0400
Received: by wwf4 with SMTP id 4so665557wwf.4
        for <linux-ext4@vger.kernel.org>; Tue, 09 Aug 2011 23:41:41 -0700 (PDT)
In-Reply-To: <4E4173D4.9010104@zytor.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 08/09/2011 06:52 PM, H. Peter Anvin wrote:
> Hi all,
>
> This is something I've wanted to see for a very long time, and it
> finally occurred to me that perhaps I should say something about it!
>
> It would be a very nice thing to have a flag to e2fsck, presumably -z,
> to zero out any unused data blocks, inodes and so on.  The goal is to
> minimize the amount of space required after compressing a virtual disk
> image or similar, and to make sure any non-data isn't lying around.
>
> 	-hpa
>

Do you need it to be in the fsck tool?

If you have a sparsely allocated block map under your file system, doing a zero 
of all blocks could add hours for a big, slow S-ATA drives (2-3 hours for a 1TB 
drive).

An alternative for SSD's and devices that do TRIM/UNMAP would be to use one of 
the batched discard tools (that would make discarded data read back as zeroed).

Thanks!

Ric

