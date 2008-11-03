From: "Roc Valles" <vallesroc@gmail.com>
Subject: Re: data corruption with ext4 (from 2.6.27.4) exposed by rtorrent
Date: Mon, 3 Nov 2008 14:09:34 +0000
Message-ID: <3d3ce57e0811030609x7d72380coa75f96e7a0cefe5d@mail.gmail.com>
References: <3d3ce57e0811030442o377cf2bet212eefba79d714bb@mail.gmail.com>
	 <20081103134008.GE29102@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
To: cryptooctoploid@gmail.com, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.159]:5586 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754209AbYKCOJg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 3 Nov 2008 09:09:36 -0500
Received: by fg-out-1718.google.com with SMTP id 19so2243696fgg.17
        for <linux-ext4@vger.kernel.org>; Mon, 03 Nov 2008 06:09:34 -0800 (PST)
In-Reply-To: <20081103134008.GE29102@mit.edu>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Ok. It's a recently made ext4 using mkfs.ext4dev from latest
sysresccd. Inmediatly after making it, I moved in my root from an old
500GB ext3 hard disk.

This is the output:

kaguya ~ # dumpe2fs -h /dev/sda3
dumpe2fs 1.41.3 (12-Oct-2008)
Filesystem volume name:   <none>
Last mounted on:          <not available>
Filesystem UUID:          07520665-bfed-4d37-a38e-0a7cb04cff59
Filesystem magic number:  0xEF53
Filesystem revision #:    1 (dynamic)
Filesystem features:      has_journal ext_attr resize_inode dir_index
filetype needs_recovery extent flex_bg sparse_super large_file
huge_file uninit_bg dir_nlink extra_isize
Filesystem flags:         signed_directory_hash test_filesystem
Default mount options:    (none)
Filesystem state:         clean
Errors behavior:          Continue
Filesystem OS type:       Linux
Inode count:              91430912
Block count:              365693619
Reserved block count:     0
Free blocks:              245016006
Free inodes:              90916075
First block:              0
Block size:               4096
Fragment size:            4096
Reserved GDT blocks:      936
Blocks per group:         32768
Fragments per group:      32768
Inodes per group:         8192
Inode blocks per group:   512
Flex block group size:    16
Filesystem created:       Fri Oct 31 13:43:31 2008
Last mount time:          Mon Nov  3 11:17:20 2008
Last write time:          Mon Nov  3 11:17:20 2008
Mount count:              5
Maximum mount count:      31
Last checked:             Fri Oct 31 13:43:31 2008
Check interval:           15552000 (6 months)
Next check after:         Wed Apr 29 13:43:31 2009
Reserved blocks uid:      0 (user root)
Reserved blocks gid:      0 (group root)
First inode:              11
Inode size:               256
Required extra isize:     28
Desired extra isize:      28
Journal inode:            8
Default directory hash:   half_md4
Directory Hash Seed:      ba0cc33f-c339-4fd9-aa04-bfdad45ecf92
Journal backup:           inode blocks
Journal size:             128M

On Mon, Nov 3, 2008 at 13:40, Theodore Tso <tytso@mit.edu> wrote:
> Can both of you send the output of "dumpe2fs -h /dev/<disk device>" of
> the filesystem in question?  The thing which I'm most interested in is
> whether the extents feature was enabled or not.  (i.e., was this a
> freshly made ext4 filesystem, or a ext3 filesystem mounted under ext4,
> and with which features eanbled?)
>
> Thanks,
>
>                                                - Ted
