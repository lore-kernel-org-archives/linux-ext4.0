From: Jan Kara <jack@suse.cz>
Subject: Re: ext4+quota+nfs issue
Date: Mon, 14 Sep 2009 19:50:56 +0200
Message-ID: <20090914175056.GE25549@duck.suse.cz>
References: <4AA5E5F3.30309@primeinteractive.net> <4AA72C14.1020005@primeinteractive.net> <alpine.LRH.2.00.0909091141300.25928@twin.jikos.cz> <4AA7C38E.8020306@redhat.com> <150c16850909091045h1962fd67n77c265c9b99c5f44@mail.gmail.com> <4AA7FBD7.9080406@primeinteractive.net> <4AAA5FCC.2010707@primeinteractive.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Justin Maggard <jmaggard10@gmail.com>,
	Eric Sandeen <sandeen@redhat.com>,
	Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
	Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
	aneesh.kumar@linux.vnet.ibm.com
To: Pavol Cvengros <pavol.cvengros@primeinteractive.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57471 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755363AbZINRu4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 14 Sep 2009 13:50:56 -0400
Content-Disposition: inline
In-Reply-To: <4AAA5FCC.2010707@primeinteractive.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hello,

On Fri 11-09-09 16:33:48, Pavol Cvengros wrote:
> On 9/9/2009 9:02 PM, Pavol Cvengros wrote:
>> On 9/9/2009 7:45 PM, Justin Maggard wrote:
>>> On Wed, Sep 9, 2009 at 8:02 AM, Eric Sandeen<sandeen@redhat.com>  wrote:
>>>>> On Wed, 9 Sep 2009, Pavol Cvengros wrote:
>>>>>
>>>>>> Hi,
>>>>>>
>>>>>> can somebody who is aware of ext4 and quota have a look on this one?
>>>>>>
>>>> This was also just reported at:
>>>>
>>>> https://bugzilla.redhat.com/show_bug.cgi?id=521914
>>>>
>>>> -Eric
>>>>
>>> I've seen exactly the same thing myself as well, but on local I/O.
>>> The only difference I was able to find between filesystems I saw this
>>> on, versus filesystems that I didn't see this on, was how it was
>>> created.  The filesystems without this issue were made using
>>> mkfs.ext4, and the ones that _did_ have the issue were created with
>>> mkfs.ext3, and then mounted -t ext4.  Pavol, can you check your
>>> filesystem features from "dumpe2fs -h [your_device]"?
>>>
>>> -Justin
>>> -- 
>>
>> here is the dump....
>>
>> host_stor0 ~ # dumpe2fs -h /dev/sdb1
>> dumpe2fs 1.41.9 (22-Aug-2009)
>> Filesystem volume name: <none>
>> Last mounted on: <not available>
>> Filesystem UUID:          f8aef49b-1903-4e25-9a7b-a3f5557107fb
>> Filesystem magic number:  0xEF53
>> Filesystem revision #:    1 (dynamic)
>> Filesystem features:      has_journal ext_attr resize_inode dir_index 
>> filetype needs_recovery extent flex_bg sparse_super large_file huge_file 
>> uninit_bg dir_nlink extra_isize
>> Filesystem flags:         signed_directory_hash
>> Default mount options:    (none)
>> Filesystem state:         clean
>> Errors behavior:          Continue
>> Filesystem OS type:       Linux
>> Inode count:              305176576
>> Block count:              1220689911
>> Reserved block count:     12206899
>> Free blocks:              977820919
>> Free inodes:              250981592
>> First block:              0
>> Block size:               4096
>> Fragment size:            4096
>> Reserved GDT blocks:      732
>> Blocks per group:         32768
>> Fragments per group:      32768
>> Inodes per group:         8192
>> Inode blocks per group:   512
>> Flex block group size:    16
>> Filesystem created:       Tue Jun 30 20:04:20 2009
>> Last mount time:          Tue Aug 18 12:21:18 2009
>> Last write time:          Tue Aug 18 12:21:18 2009
>> Mount count:              10
>> Maximum mount count:      -1
>> Last checked:             Tue Jun 30 20:04:20 2009
>> Check interval:           0 (<none>)
>> Lifetime writes:          73 GB
>> Reserved blocks uid:      0 (user root)
>> Reserved blocks gid:      0 (group root)
>> First inode:              11
>> Inode size:               256
>> Required extra isize:     28
>> Desired extra isize:      28
>> Journal inode:            8
>> Default directory hash:   half_md4
>> Directory Hash Seed:      317c2fc4-9c86-42ca-a3c3-0d6c632dcb46
>> Journal backup:           inode blocks
>> Journal size:             128M
  I've found some time to look into this and I can see a few problems in
the code. Firstly, what may cause your problems:
  vfs_dq_claim_blocks() is called in ext4_mb_mark_diskspace_used(). But
as far as I can understand the code, ext4_mb_normalize_request() can
increase the amount of space we really allocate and thus we try to
allocate more blocks than we have actually reserved in quota. Aneesh, is
that right?
  Secondly, ext4_da_reserve_space() seems to have a bug that it can reserve
quota blocks multiple times if ext4_claim_free_blocks() fail and we retry
the allocation. We should release the quota reservation before restarting.
Actually, when we find out we cannot reserve quota space, we could force
some delayed allocated writes to disk (thus possibly release some quota
in case we have overestimated the amount of blocks needed). But that's
a different issue.
  Thirdly, ext4_indirect_calc_metadata_amount() is wrong for sparse files.
The worst case is 3 metadata blocks per data block if we make the file
sufficiently sparse and there's no easy way around that...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
