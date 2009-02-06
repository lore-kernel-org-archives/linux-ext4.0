From: "J.D. Bakker" <jdb@lartmaker.nl>
Subject: Re: Recovering a damaged ext4 fs - revisited.
Date: Fri, 6 Feb 2009 13:18:38 +0100
Message-ID: <p06240522c5b1d7426151@[10.1.5.33]>
References: <p06240517c5b14e12f7d1@[10.1.5.33]> <498BB63D.50503@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii" ; format="flowed"
Cc: linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.lartmaker.nl ([69.93.127.100]:51016 "EHLO www.lartmaker.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752239AbZBFMSn (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 6 Feb 2009 07:18:43 -0500
In-Reply-To: <498BB63D.50503@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

At 22:02 -0600 05-02-2009, Eric Sandeen wrote:
>J.D. Bakker wrote:
>  >    Error writing block 1 (Attempt to write block from filesystem
>>  resulted in short write).  Ignore error? no
>>     Error writing block 2 (Attempt to write block from filesystem
>>  resulted in short write).  Ignore error? no
>>     Error writing block 3 (Attempt to write block from filesystem
>>  resulted in short write).  Ignore error? no
>>     [...]
>>     Error writing block 231 (Attempt to write block from filesystem
>>  resulted in short write).  Ignore error? no
>>     Error writing block 232 (Attempt to write block from filesystem
>>  resulted in short write).  Ignore error? no
>>
>>  (full log at http://lartmaker.nl/ext4/e2fsck-md0.txt)
>
>Those seem a bit odd; why are these write failing?  Anything in the
>kernel logs when this happens?  I'm just wondering if there could be
>some underlying storage problem?

No, nothing in the logs.

Isn't this a side-effect of me passing the -n option to e2fsck? I 
haven't traced the full path in the e2fsprogs-source, but it would 
appear that the -n option sets E2F_OPT_NO, which sets 
E2F_OPT_READONLY, which clears EXT2_FLAG_RW, which (in a few places) 
clears IO_FLAG_RW, which appears to open the fs RO (as expected).

JDB.
[I passed -n to e2fsck as I want to keep the fs as untouched as 
possible, and I don't have 4TB in scratch space handy to park a copy]
-- 
LART. 250 MIPS under one Watt. Free hardware design files.
http://www.lartmaker.nl/
