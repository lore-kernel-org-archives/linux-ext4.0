From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH -v3] ext4: implementation of a new ioctl called EXT4_IOC_SWAP_BOOT
Date: Sun, 7 Apr 2013 15:29:03 -0600
Message-ID: <9E765F01-4954-4182-91F5-8E1F476720CC@dilger.ca>
References: <51023FEA.7000802@reinform.de> <20130126184927.GB20005@thunk.org> <op.wt48ybxow201t7@cnd0370px4.ent.rt.verigy.net> <20130407024701.GC7816@thunk.org> <45E0D5C6-50E8-4F2E-83DC-3E24A31D7573@dilger.ca> <20130407194855.GA5292@thunk.org>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: "Dr. Tilmann Bubeck" <t.bubeck@reinform.de>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-da0-f53.google.com ([209.85.210.53]:61897 "EHLO
	mail-da0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759587Ab3DGV3H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 7 Apr 2013 17:29:07 -0400
Received: by mail-da0-f53.google.com with SMTP id n34so2314352dal.40
        for <linux-ext4@vger.kernel.org>; Sun, 07 Apr 2013 14:29:05 -0700 (PDT)
In-Reply-To: <20130407194855.GA5292@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2013-04-07, at 13:48, Theodore Ts'o <tytso@mit.edu> wrote:
> On Sun, Apr 07, 2013 at 11:09:58AM -0600, Andreas Dilger wrote:
>>> +    if (inode_bl->i_nlink == 0) {
>>> +        /* this inode has never been used as a BOOT_LOADER */
>>> +        set_nlink(inode_bl, 1);
>>> +        i_uid_write(inode_bl, 0);
>>> +        i_gid_write(inode_bl, 0);
>>> +        inode_bl->i_flags = 0;
>>> +        ei_bl->i_flags = 0;
>>> +        inode_bl->i_version = 1;
>>> +        i_size_write(inode_bl, 0);
>>> +        inode_bl->i_mode = S_IFREG;
>>> +        if (EXT4_HAS_INCOMPAT_FEATURE(sb,
>>> +                          EXT4_FEATURE_INCOMPAT_EXTENTS)) {
>>> +            ext4_set_inode_flag(inode_bl, EXT4_INODE_EXTENTS);
>>> +            ext4_ext_tree_init(handle, inode_bl);
>>> +        } else
>>> +            memset(ei_bl->i_data, 0, sizeof(ei_bl->i_data));
>> 
>> I don't understand this. Wouldn't this clobber the block pointers if 
>> an existing boot inode and cause them to leak?  This seems broken to me. 
> 
> If i_nlink is zero, then there is no existing boot loader inode.  In
> theory the rest of the inode is zero, but this is to make sure the
> inode is initialized to something sane before we swap it into the
> user-visible inode.

Oh, my bad. I thought the else was for the nlink != 0 case, not the !extent case (the danger of reading email on my phone, I guess). Looks fine. 

> 

Cheers, Andreas