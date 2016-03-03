From: lokesh jaliminche <lokesh.jaliminche@gmail.com>
Subject: Re: ext2/3 using ext4 module mkdir IO error on pmem DAX mount
Date: Thu, 3 Mar 2016 22:49:51 +0530
Message-ID: <CAKJOkCoLEs2cQuS+CeciUY39ErQeOYmkQ_Jj4gHePPTUTMngrA@mail.gmail.com>
References: <20160302064304.GA15559@dhcp12-144.nay.redhat.com>
	<20160303002824.GA31238@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Xiong Zhou <xzhou@redhat.com>, Andreas Dilger <adilger@dilger.ca>,
	"Theodore Ts'o" <tytso@mit.edu>, linux-nvdimm@ml01.01.org,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <20160303002824.GA31238@linux.intel.com>
Sender: linux-next-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi,
   I have tested it locally I am also getting same error but not
consistently. I have put some debug logs for debugging, as per the logs
it seems that block_group is not getting initialized properly. I am
not sure weather this is because of my patch. Need to debug more.

commands :
=========
[root@cli02-ws Desktop]# dd if=/dev/zero of=/mnt/test bs=1024 count=100000
[root@cli02-ws Desktop]# losetup /dev/loop4 /mnt/test
[root@cli02-ws Desktop]# mkfs.ext2 /mnt/test
[root@cli02-ws Desktop]# mount -t ext2 -o loop /mnt/test /mnt/test_ext4
[root@cli02-ws Desktop]# cd /mnt/test_ext4/
[root@cli02-ws test_ext4]# mkdir 1
mkdir: cannot create directory `1': Input/output error
[root@cli02-ws test_ext4]# mkdir 2
[root@cli02-ws test_ext4]# mkdir 3
mkdir: cannot create directory `3': Input/output error
[root@cli02-ws test_ext4]# mkdir 4

debug_logs :
=========
[root@cli02-ws Desktop]# tail -f /var/log/messages 2>&1 | tee faillog
Mar  3 13:13:27 cli02-ws kernel: [  228.167307] EXT4-fs (loop0):
mounting ext2 file system using the ext4 subsystem
Mar  3 13:13:27 cli02-ws kernel: [  228.169634] EXT4-fs (loop0):
mounted filesystem without journal. Opts: (null)
Mar  3 13:13:42 cli02-ws kernel: [  243.506280] max_blocks_per_group : 7949
Mar  3 13:13:42 cli02-ws kernel: [  243.506285] stats.free_clusters  : 7949
Mar  3 13:13:42 cli02-ws kernel: [  243.506287] inodes_per_group*f   : 1928
Mar  3 13:13:42 cli02-ws kernel: [  243.506290] stats.free_inodes    : 1928
Mar  3 13:13:42 cli02-ws kernel: [  243.506292] block_group
:2103884794 <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
Mar  3 13:13:42 cli02-ws kernel: [  243.506295] group_count : 13
Mar  3 13:13:42 cli02-ws kernel: [  243.506298] EXT4-fs error (device
loop0): ext4_get_group_desc:291: comm mkdir: block_group >=
groups_count - block_group = 2103884794, groups_count = 13
Mar  3 13:14:09 cli02-ws kernel: [  270.809734] max_blocks_per_group : 7949
Mar  3 13:14:09 cli02-ws kernel: [  270.809739] stats.free_clusters  : 1452
Mar  3 13:14:09 cli02-ws kernel: [  270.809742] inodes_per_group*f   : 1928
Mar  3 13:14:09 cli02-ws kernel: [  270.809744] stats.free_inodes    : 1928
Mar  3 13:14:09 cli02-ws kernel: [  270.809747] max_blocks_per_group : 7949
Mar  3 13:14:09 cli02-ws kernel: [  270.809750] stats.free_clusters  : 7677
Mar  3 13:14:09 cli02-ws kernel: [  270.809752] inodes_per_group*f   : 1928
Mar  3 13:14:09 cli02-ws kernel: [  270.809755] stats.free_inodes    : 1917
Mar  3 13:14:09 cli02-ws kernel: [  270.809757] max_blocks_per_group : 7949
Mar  3 13:14:09 cli02-ws kernel: [  270.809760] stats.free_clusters  : 7691
Mar  3 13:14:09 cli02-ws kernel: [  270.809762] inodes_per_group*f   : 1928
Mar  3 13:14:09 cli02-ws kernel: [  270.809765] stats.free_inodes    : 1928
Mar  3 13:14:09 cli02-ws kernel: [  270.809767] max_blocks_per_group : 7949
Mar  3 13:14:09 cli02-ws kernel: [  270.809770] stats.free_clusters  : 7949
Mar  3 13:14:09 cli02-ws kernel: [  270.809772] inodes_per_group*f   : 1928
Mar  3 13:14:09 cli02-ws kernel: [  270.809775] stats.free_inodes    : 1928
Mar  3 13:14:38 cli02-ws kernel: [  299.081995] max_blocks_per_group : 7949
Mar  3 13:14:38 cli02-ws kernel: [  299.082038] stats.free_clusters  : 7949
Mar  3 13:14:38 cli02-ws kernel: [  299.082040] inodes_per_group*f   : 1928
Mar  3 13:14:38 cli02-ws kernel: [  299.082042] stats.free_inodes    : 1928
Mar  3 13:14:38 cli02-ws kernel: [  299.082045] block_group
:1066167208<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
Mar  3 13:14:38 cli02-ws kernel: [  299.082048] group_count : 13
Mar  3 13:14:38 cli02-ws kernel: [  299.082051] EXT4-fs error (device
loop0): ext4_get_group_desc:291: comm mkdir: block_group >=
groups_count - block_group = 1066167208, groups_count = 13
Mar  3 13:14:48 cli02-ws kernel: [  309.138432] max_blocks_per_group : 7949
Mar  3 13:14:48 cli02-ws kernel: [  309.138436] stats.free_clusters  : 7949
Mar  3 13:14:48 cli02-ws kernel: [  309.138439] inodes_per_group*f   : 1928
Mar  3 13:14:48 cli02-ws kernel: [  309.138452] stats.free_inodes    : 1928

Regards,
Lokesh

On Thu, Mar 3, 2016 at 5:58 AM, Ross Zwisler
<ross.zwisler@linux.intel.com> wrote:
> On Wed, Mar 02, 2016 at 02:43:04PM +0800, Xiong Zhou wrote:
>> Hi,
>>
>> mkdir failed IO error on pmem DAX ext2/3 fs mount using ext4 module.
>>
>> This happends only on -next tree, not on Linus' tree,
>> at least from 4.5.0-rc5-next-20160224.
>
> I was able to reproduce this and bisect it to the following commit:
>
> commit 1f2d779fed21 ("ext4: optimize group search for inode allocation")
>
> The fact that DAX was enabled in this failure was a red herring - it fails
> without DAX as well.  The key is just that we're mounting an ext2 formatted
> filesystem using the ext4 module, I think.
>
> - Ross
