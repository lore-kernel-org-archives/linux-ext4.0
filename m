From: Justin Maggard <jmaggard10@gmail.com>
Subject: Re: >16TB issues
Date: Wed, 22 Jul 2009 15:27:24 -0700
Message-ID: <150c16850907221527l3060aa85h883656bcc7d7e1c4@mail.gmail.com>
References: <150c16850907021523p25ddae32v2eeea54418d2e6d5@mail.gmail.com>
	 <20090703143729.GJ20343@webber.adilger.int>
	 <150c16850907161104j5e059baep988c5f04a0552c8c@mail.gmail.com>
	 <20090721161018.GH4231@webber.adilger.int>
	 <150c16850907211152y3136aadx6ce42a8535a6ed61@mail.gmail.com>
	 <20090721192123.GK4231@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f192.google.com ([209.85.222.192]:36646 "EHLO
	mail-pz0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752366AbZGVW1Y (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 22 Jul 2009 18:27:24 -0400
Received: by pzk30 with SMTP id 30so129398pzk.33
        for <linux-ext4@vger.kernel.org>; Wed, 22 Jul 2009 15:27:24 -0700 (PDT)
In-Reply-To: <20090721192123.GK4231@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jul 21, 2009 at 12:21 PM, Andreas Dilger<adilger@sun.com> wrote:
>> I shouldn't need e2fsprogs to be compiled 64-bit as well, right?
>> Currently I've got a 64-bit kernel with 32-bit userspace.
>
> Yes, that is a potential problem.

It looks like it certainly is a problem with current e2fsprogs "pu"
branch.  My latest findings from basic testing (just mkfs.ext4, then
e2fsck -fy, and -- if e2fsck modified the filesystem -- another e2fsck
-fy) are as follows:

1)  64-bit mke2fs + 64-bit e2fsck
Appears to work fine.  No errors reported anywhere.

2)  64-bit mke2fs + 32-bit e2fsck
Also appears to work fine.  llverfs --partial looked okay, and e2fsck
reported no errors.

3)  32-bit mke2fs + 64-bit e2fsck
Mkfs.ext4 must have done something wrong, but e2fsck was able to fix
it up, and future e2fsck (32 or 64-bit) runs reported no issues.
e2fsck output was:
Block bitmap differences:  +(1063780365--1063780367)
+(1063780381--1063780383) +(1063782048--1063782431)
-(5359140864--5359173631)
Running mkfs through valgrind doesn't show any obvious errors.

4) 32-bit mke2fs + 32-bit e2fsck
Same as (3), for the mkfs and the first e2fsck again reported fixing
the same block bitmap differences.  But after the first e2fsck was
complete, the second e2fsck run reported:
e2fsck: Superblock invalid, trying backup blocks...
Group descriptor 0 checksum is invalid.  Fix? yes
Group descriptor 1 checksum is invalid.  Fix? yes
...
Group descriptor 81774 checksum is invalid.  Fix? yes
followed by tons of block bitmap differences.

-Justin
