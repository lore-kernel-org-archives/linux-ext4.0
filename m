From: Nikolay Borisov <kernel@kyup.com>
Subject: Re: kernel BUG at fs/ext4/inode.c:2428!
Date: Mon, 21 Nov 2016 17:32:24 +0200
Message-ID: <8b7f233c-9921-d5e9-f2c5-55d13586994c@kyup.com>
References: <c2a82d58-c696-33f5-1187-ea79df0f9dc8@kyup.com>
 <20161114134929.GJ2524@quack2.suse.cz>
 <090c368c-8141-0a28-4104-56d0ee683f8a@kyup.com>
 <20161121142723.GF8207@quack2.suse.cz>
 <093b94ca-0e61-fddd-db6a-97456b50b6cc@kyup.com>
 <20161121152004.3lncvufymfs6ze3y@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: Jan Kara <jack@suse.cz>, linux-ext4 <linux-ext4@vger.kernel.org>,
        Jan Kara <jack@suse.com>,
        Andreas Dilger <adilger.kernel@dilger.ca>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wm0-f46.google.com ([74.125.82.46]:37337 "EHLO
        mail-wm0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752859AbcKUPc1 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 21 Nov 2016 10:32:27 -0500
Received: by mail-wm0-f46.google.com with SMTP id t79so150932787wmt.0
        for <linux-ext4@vger.kernel.org>; Mon, 21 Nov 2016 07:32:26 -0800 (PST)
In-Reply-To: <20161121152004.3lncvufymfs6ze3y@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>



On 11/21/2016 05:20 PM, Theodore Ts'o wrote:
> Can you try getting the inode number and then trying to get a pathname
> to the inode?  And then get the on-disk stat information?  You can do
> this using debugfs, for example:
> 
> debugfs /dev/sda3
> debugfs:  ncheck 2621442
> Inode	Pathname
> 2621442	/u1/Doctor-Who-medley.flac
> debugfs:  stat /u1/Doctor-Who-medley.flac
> Inode: 2621442   Type: regular    Mode:  0644   Flags: 0x80000
> Generation: 3942406670    Version: 0x00000000:00000001
> User: 18209   Group: 18209   Project:     0   Size: 500591580
> File ACL: 0    Directory ACL: 0
> Links: 1   Blockcount: 977608
> Fragment:  Address: 0    Number: 0    Size: 0
>  ctime: 0x57e99a99:57d3bfbc -- Mon Sep 26 18:00:57 2016
>  atime: 0x57eef0af:64fe6c84 -- Fri Sep 30 19:09:35 2016
>  mtime: 0x56b18898:00000000 -- Tue Feb  2 23:56:56 2016
> crtime: 0x57e99a95:91002508 -- Mon Sep 26 18:00:53 2016
> Size of extra inode fields: 32
> Inode checksum: 0xfe12a620
> EXTENTS:
> (ETB0):10543077, (0-2):649216-649218, (18-6143):649234-655359, (6144-16383):7106
> 56-720895, (16384-24575):696320-704511, (24576-36863):806912-819199, (36864-4505
> 5):794624-802815, (45056-47103):882688-884735, (47104-71679):892928-917503, (716
> 80-75775):937984-942079, (75776-77823):1003520-1005567, (77824-83967):1009664-10
> 15807, (83968-88063):991232-995327, (88064-92159):999424-1003519, (92160-94207):
> 1021952-1023999, (94208-96255):1028096-1030143, (96256-98303):1040384-1042431, (
> 98304-106495):1032192-1040383, (106496-120831):1095680-1110015, (120832-122214):
> 1085440-1086822
> 
> And then can you see if there's any commonality in terms of the
> workload associated with that inode, or whether or not that inode was
> likely to be in the process of being modified?
> 


Unfortunately the files involved in those workloads have since been
migrated to BTRFS. However, I have full crashdumps and can extract any
information from the in-memory data structures. I'd really like to get
this resolved and hope the in-memory information will suffice.

> Thanks,
> 
> 					- Ted
> 
