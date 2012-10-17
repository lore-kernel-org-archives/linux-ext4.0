From: Zhi Yong Wu <zwu.kernel@gmail.com>
Subject: Re: [RFC v3 00/13] vfs: hot data tracking
Date: Wed, 17 Oct 2012 16:57:14 +0800
Message-ID: <CAEH94Lgfev1qg2S+2-D5VMtVgSES3cFw0KmJSJr5HObyhA8sbg@mail.gmail.com>
References: <1349863655-29320-1-git-send-email-zwu.kernel@gmail.com>
	<20121015204217.GB2739@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	linuxram@linux.vnet.ibm.com, viro@zeniv.linux.org.uk,
	dave@jikos.cz, tytso@mit.edu, cmm@us.ibm.com,
	Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20121015204217.GB2739@dastard>
Sender: linux-btrfs-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Oct 16, 2012 at 4:42 AM, Dave Chinner <david@fromorbit.com> wrote:
> On Wed, Oct 10, 2012 at 06:07:22PM +0800, zwu.kernel@gmail.com wrote:
>> From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
>>
>> NOTE:
>>
>>   The patchset is currently post out mainly to make sure
>> it is going in the correct direction and hope to get some
>> helpful comments from other guys.
>>   For more infomation, please check hot_tracking.txt in Documentation
>>
>> TODO List:
>
> 1) Fix OOM issues - the hot inode tracking caches grow very large
> and don't get trimmed under memory pressure. From slabtop, after
> creating roughly 24 million single byte files(*) on a machine with
> 8GB RAM:
>
>   OBJS ACTIVE  USE OBJ SIZE  SLABS OBJ/SLAB CACHE SIZE NAME
> 23859510 23859476  99%    0.12K 795317       30   3181268K hot_range_item
> 23859441 23859439  99%    0.16K 1037367       23   4149468K hot_inode_item
> 572530 572530 100%    0.55K  81790        7    327160K radix_tree_node
> 241706 241406  99%    0.22K  14218       17     56872K xfs_ili
> 241206 241204  99%    1.06K  80402        3    321608K xfs_inode
>
> The inode tracking is trying to track all 24 million inodes even
> though they have been written only once, and there are only 240,000
> inodes in the cache at this point in time. That was the last update
> that slabtop got, so it is indicative of the impending OOM situation
> that occurred.
>
>> Changelog from v2:
>>  1.) Converted to Radix trees, not RB-tree [Zhiyong, Dave Chinner]
>>  2.) Added memory shrinker [Dave Chinner]
>
> I haven't looked at the shrinker, but clearly it is not working,
> otherwise the above OOM situation would not be occurring.
>
> Cheers,
>
> Dave.
>
> (*) Tested on an empty 17TB XFS filesystem with:
>
> $ sudo mkfs.xfs -f -l size=131072b,sunit=8 /dev/vdc
> meta-data=/dev/vdc               isize=256    agcount=17, agsize=268435455 blks
>          =                       sectsz=512   attr=2, projid32bit=0
> data     =                       bsize=4096   blocks=4563402735, imaxpct=5
>          =                       sunit=0      swidth=0 blks
> naming   =version 2              bsize=4096   ascii-ci=0
> log      =internal log           bsize=4096   blocks=131072, version=2
>          =                       sectsz=512   sunit=1 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> $ sudo mount -o logbsize=256k /dev/vdc /mnt/scratch
> $ sudo chmod 777 /mnt/scratch
> $ fs_mark  -D  10000  -S0  -n  100000  -s  1  -L  63  -d \
> /mnt/scratch/0  -d  /mnt/scratch/1  -d  /mnt/scratch/2  -d \
> /mnt/scratch/3  -d  /mnt/scratch/4  -d  /mnt/scratch/5  -d \
> /mnt/scratch/6  -d  /mnt/scratch/7
> .....
>      0     21600000            1      16679.3         12552262
>      0     22400000            1      15412.4         12588587
>      0     23200000            1      16367.6         14199322
>      0     24000000            1      15680.4         15741205
> <hangs here w/ OOM>
^^^^In this test, i haven't see you enable hot_track function via
mount, why did it meet OOM?
>
> --
> Dave Chinner
> david@fromorbit.com



-- 
Regards,

Zhi Yong Wu
