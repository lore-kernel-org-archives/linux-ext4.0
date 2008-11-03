From: Cryptooctoploid <cryptooctoploid@gmail.com>
Subject: Re: data corruption with ext4 (from 2.6.27.4) exposed by rtorrent
Date: Mon, 3 Nov 2008 14:47:10 +0100
Message-ID: <319012f0811030547s714a06a8od77cffaa103994db@mail.gmail.com>
References: <3d3ce57e0811030442o377cf2bet212eefba79d714bb@mail.gmail.com>
	 <20081103134008.GE29102@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Roc Valles" <vallesroc@gmail.com>, linux-ext4@vger.kernel.org
To: "Theodore Tso" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.30]:4215 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754760AbYKCNrM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 3 Nov 2008 08:47:12 -0500
Received: by yx-out-2324.google.com with SMTP id 8so954287yxm.1
        for <linux-ext4@vger.kernel.org>; Mon, 03 Nov 2008 05:47:10 -0800 (PST)
In-Reply-To: <20081103134008.GE29102@mit.edu>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Nov 3, 2008 at 2:40 PM, Theodore Tso <tytso@mit.edu> wrote:
> On Mon, Nov 03, 2008 at 12:42:11PM +0000, Roc Valles wrote:
>> Some person already reported this. I'm having the same problem.
>> http://marc.info/?l=linux-ext4&m=122557056518246&w=2
>>
>> rtorrent is a bittorrent client that makes heavy use of mmap instead
>> of read/write to avoid needless duplication of data. It has exposed
>> other bugs in the past (mmap bug in 2.6.19).
>> http://libtorrent.rakshasa.no
>> Downloading a big torrent (>2GB) with rtorrent triggers it more times
>> than not. The bigger the torrent, the higher the likeliness of
>> failure. When the torrent is finished, if a hash check is forced by
>> pressing control-r on the torrent, some blocks will fail.
>
> Can both of you send the output of "dumpe2fs -h /dev/<disk device>" of
> the filesystem in question?  The thing which I'm most interested in is
> whether the extents feature was enabled or not.  (i.e., was this a
> freshly made ext4 filesystem, or a ext3 filesystem mounted under ext4,
> and with which features eanbled?)
>

OK. In my case it's a freshly made  default ext4 filesystem.
I'm running 2.6.28-rc3 x86_64.

dumpe2fs 1.41.3 (12-Oct-2008)
Filesystem volume name:   <none>
Last mounted on:          <not available>
Filesystem UUID:          511e7636-5196-4095-8654-bca756102d8d
Filesystem magic number:  0xEF53
Filesystem revision #:    1 (dynamic)
Filesystem features:      has_journal ext_attr resize_inode dir_index
filetype needs_recovery extent flex_bg sparse_super large_file
huge_file uninit_bg dir_nlink extra_isize
Filesystem flags:         signed_directory_hash
Default mount options:    (none)
Filesystem state:         clean
Errors behavior:          Continue
Filesystem OS type:       Linux
Inode count:              6406144
Block count:              25599569
Reserved block count:     1279978
Free blocks:              19257546
Free inodes:              5623009
First block:              0
Block size:               4096
Fragment size:            4096
Reserved GDT blocks:      1017
Blocks per group:         32768
Fragments per group:      32768
Inodes per group:         8192
Inode blocks per group:   512
Flex block group size:    16
Filesystem created:       Fri Oct 24 15:48:46 2008
Last mount time:          Mon Nov  3 09:59:24 2008
Last write time:          Mon Nov  3 09:59:24 2008
Mount count:              20
Maximum mount count:      28
Last checked:             Sat Nov  1 20:07:13 2008
Check interval:           15552000 (6 months)
Next check after:         Thu Apr 30 21:07:13 2009
Reserved blocks uid:      0 (user root)
Reserved blocks gid:      0 (group root)
First inode:              11
Inode size:               256
Required extra isize:     28
Desired extra isize:      28
Journal inode:            8
First orphan inode:       294551
Default directory hash:   half_md4
Directory Hash Seed:      847df4ea-f163-404b-bc41-07a5a5245911
Journal backup:           inode blocks
Journal size:             128M
