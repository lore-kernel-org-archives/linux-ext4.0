From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Recovering a damaged ext4 fs - revisited.
Date: Thu, 05 Feb 2009 22:02:05 -0600
Message-ID: <498BB63D.50503@redhat.com>
References: <p06240517c5b14e12f7d1@[10.1.5.33]>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: "J.D. Bakker" <jdb@lartmaker.nl>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:57262 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751766AbZBFEEN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 5 Feb 2009 23:04:13 -0500
In-Reply-To: <p06240517c5b14e12f7d1@[10.1.5.33]>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

J.D. Bakker wrote:
> Hi,
> 
> My 4TB ext4 RAID-6 has just become damaged for the second time in two 
> months. While I do have backups for most of my data, it would be good 
> to know if there is a recovery procedure or a way to avoid these 
> crashes. The symptoms are massive group descriptor corruption, 
> similar to what was mentioned in 
> http://thread.gmane.org/gmane.comp.file-systems.ext4/10844 and 
> http://article.gmane.org/gmane.comp.file-systems.ext4/11195 .

.... snip ....

>    Error writing block 1 (Attempt to write block from filesystem 
> resulted in short write).  Ignore error? no
>    Error writing block 2 (Attempt to write block from filesystem 
> resulted in short write).  Ignore error? no
>    Error writing block 3 (Attempt to write block from filesystem 
> resulted in short write).  Ignore error? no
>    [...]
>    Error writing block 231 (Attempt to write block from filesystem 
> resulted in short write).  Ignore error? no
>    Error writing block 232 (Attempt to write block from filesystem 
> resulted in short write).  Ignore error? no
> 
> (full log at http://lartmaker.nl/ext4/e2fsck-md0.txt)

Those seem a bit odd; why are these write failing?  Anything in the
kernel logs when this happens?  I'm just wondering if there could be
some underlying storage problem?

Thanks,
-Eric
