Return-Path: <SRS0=DZYj=RU=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20555C43381
	for <linux-ext4@archiver.kernel.org>; Sun, 17 Mar 2019 22:51:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DC05D20857
	for <linux-ext4@archiver.kernel.org>; Sun, 17 Mar 2019 22:51:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727173AbfCQWvd (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sun, 17 Mar 2019 18:51:33 -0400
Received: from mail.worldserver.net ([217.13.200.37]:50194 "EHLO
        mail.worldserver.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726735AbfCQWvd (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sun, 17 Mar 2019 18:51:33 -0400
Received: from mail.nebelschwaden.de (port-92-193-119-66.dynamic.qsc.de [92.193.119.66])
        (Authenticated sender: postmaster@nebelschwaden.de)
        by mail.worldserver.net (Postfix) with ESMTPSA id D56C63004E9
        for <linux-ext4@vger.kernel.org>; Sun, 17 Mar 2019 23:51:29 +0100 (CET)
Received: from [172.16.37.5] (kaperfahrt.nebelschwaden.de [172.16.37.5])
        by mail.nebelschwaden.de (Postfix) with ESMTP id 87B90506830
        for <linux-ext4@vger.kernel.org>; Sun, 17 Mar 2019 23:51:28 +0100 (CET)
Reply-To: listac@nebelschwaden.de
Subject: Re: e2fsck fails on non journalled partition
To:     linux-ext4@vger.kernel.org
References: <bfa8103e-cf07-ca8d-f1f2-df60ea5bd915@nebelschwaden.de>
 <22AA9175-3D96-424E-BC91-6232100B170D@dilger.ca>
 <c2be64f5-d0fc-f66b-36ab-ab601301cbed@nebelschwaden.de>
 <20190317215315.GD23356@mit.edu>
From:   Ede Wolf <listac@nebelschwaden.de>
Message-ID: <4868703d-f937-5e3d-3336-1e6247001435@nebelschwaden.de>
Date:   Sun, 17 Mar 2019 23:51:28 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <20190317215315.GD23356@mit.edu>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

 > I'm still really wondering how this could have happened, though...

Not sure wether this is an explanation, but I suspect the SSD to be in a 
dying state. It's really old (5 years at least, probably even more) and 
has been used for tempfiles and caching for at least the last 3 years, 
so it has seen quite a bit of IO by now.

Further, currently after each mount tune2fs reports a "not clean" 
Filesystem state. I can fsck it all I want, mount it and after not too 
long time the state changes from clean.

Smartctl however logs no errors so far.

But, the journal inode and UUID are still at zero - or non existing - 
and it mounts cleanly even with a unclean state:

  EXT4-fs (sdd1): mounted filesystem without journal. Opts: noacl

In case it helps, one more tune2fs output, otherwise sorry for the noise:


tune2fs 1.44.5 (15-Dec-2018)
Filesystem volume name:   USERDATA
Last mounted on:          /mnt/userdata
Filesystem UUID:          241d6272-a004-44ef-9998-7fbc3ef98972
Filesystem magic number:  0xEF53
Filesystem revision #:    1 (dynamic)
Filesystem features:      ext_attr resize_inode dir_index filetype 
extent 64bit large_dir sparse_super large_file
Filesystem flags:         signed_directory_hash
Default mount options:    user_xattr acl
Filesystem state:         not clean
Errors behavior:          Continue
Filesystem OS type:       Linux
Inode count:              4669440
Block count:              9338880
Reserved block count:     0
Overhead blocks:          1536
Free blocks:              5576918
Free inodes:              4246457
First block:              0
Block size:               4096
Fragment size:            4096
Group descriptor size:    64
Reserved GDT blocks:      1024
Blocks per group:         32768
Fragments per group:      32768
Inodes per group:         16384
Inode blocks per group:   1024
Filesystem created:       Wed Jan 30 18:42:35 2019
Last mount time:          Sun Mar 17 15:08:30 2019
Last write time:          Sun Mar 17 15:08:30 2019
Mount count:              2
Maximum mount count:      -1
Last checked:             Sun Mar 17 01:17:43 2019
Check interval:           0 (<none>)
Lifetime writes:          206 GB
Reserved blocks uid:      0 (user root)
Reserved blocks gid:      0 (group root)
First inode:              11
Inode size:	          256
Required extra isize:     32
Desired extra isize:      32
Default directory hash:   half_md4
Directory Hash Seed:      2416ec00-bef9-437a-a3b1-f626303d72a2



However, I am quite thankful that the kernel has let me mount this drive 
until the issue was resolved.  And I am aware I can remove the noacl 
option from fstab.

Thanks again.


Ede


Am 17.03.19 um 22:53 schrieb Theodore Ts'o:
> I'm really curious how the superblock got into this configuration:
> 
>>>> ~ # tune2fs -l /dev/sde1
>>>> tune2fs 1.44.5 (15-Dec-2018)
>>>> Filesystem volume name:   USERDATA
>    ...
>>>> Filesystem features:      ext_attr resize_inode dir_index filetype extent 64bit large_dir sparse_super large_file
> 
> There is no journal features here at all
> 
>>>> Journal UUID:             00000000-1b00-0000-0000-000000000000
>>>> Journal inode:            131072
> 
> A journal UUID and inode should never be set at the same time.  But
> this is a lot more than a single bit flip.  The rest of the sueprblock
> looks sane, so it's not a matter of someone writing garbage over the
> on-disk copy.
> 
> Maybe a wild pointer smashing two bytes in the middle of the
> superblock?
> 
> In any case, this is something where we should probably add sanity
> checks so kernel will refuse to mount a file system like this --- and
> e2fsck should also try to see if the backup superblock is sane and try
> using it.  (We could also teach e2fsck to offer to clear these fields so
> a user won't have to use debugfs's ssv command if falling back to
> backup superblock doesn't work.)
> 

> 
>      	  	 	       	    	  - Ted
> 					
> 

