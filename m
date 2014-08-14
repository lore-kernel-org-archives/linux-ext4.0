From: Li Xi <pkuelelixi@gmail.com>
Subject: Re: [PATCH v2 0/4] quota: add project quota support
Date: Thu, 14 Aug 2014 09:34:55 +0800
Message-ID: <CAPTn0cAqLGVJpx9eUhpAyOgFHFx1e5aKHcJpDwOgUaoVEGUB1g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Dmitry Monakhov <dmonakhov@openvz.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	"viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
	"hch@infradead.org" <hch@infradead.org>, Jan Kara <jack@suse.cz>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ig0-f171.google.com ([209.85.213.171]:63477 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751984AbaHNBez (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 13 Aug 2014 21:34:55 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Aug 13, 2014 at 9:22 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> On Wed, Aug 13, 2014 at 10:32:31AM +0800, Li Xi wrote:
>> Yeah, we were using non-journaled quota. And we were doing this
>> benchmark to confirm that xattr based implementation has extra
>> overhead. We will run benchmarks on journaled-quota, and let's see
>> what is the performance difference between non-journaled and
>> journaled quotas.
>
> Can you give a lot of details about exactly how you ran the benchmark
> (and run future benchmarks)?  Was this on a ramdisk?  An SSD?  A HDD?
> How many CPU's, how many threads were creating files, etc.  And do you
> understand where the performance overhead was coming from?  Was it CPU
> overhead?  Locking overhead?
>
> It just doesn't make sense that storing the value in the xattr, when
> the xattr is stored in the on-disk inode, that it should make a huge
> difference; the cost of the I/O should completely dominate the cost of
> whether we format the bytes as an integer or storing it in the
> in-inode xattr.  So either there is a bug in the benchmark, or a bug
> in our code somewhere.  Either way, we should find and fix it.
All these tests were running on following environment:

Kernel: 3.16.0-rc5
Server: Dell R620 (2 x E5-2667@3.3GHz, 16 CPU cores, 256GB memory(1866MHz))
Storage: Dothill 3730(10 x 15K RPM SAS, RAID1+0, 2GB RAID Cache, 8Gbps FC)
Test tool: mdtest-1.9.3. Mdtest created 800K files in total. Each
thread created files in unique directory.

And we are using default settings of ext4, execept journal size is set
to 4GB. Following is the output of dumpe2fs:

Filesystem volume name:   <none>
Last mounted on:          <not available>
Filesystem UUID:          98b77829-6154-4c5f-a0a5-da1306e82d8d
Filesystem magic number:  0xEF53
Filesystem revision #:    1 (dynamic)
Filesystem features:      has_journal ext_attr resize_inode dir_index
filetype extent flex_bg sparse_super large_file huge_file uninit_bg
dir_nlink extra_isize
Filesystem flags:         signed_directory_hash
Default mount options:    user_xattr acl
Filesystem state:         clean
Errors behavior:          Continue
Filesystem OS type:       Linux
Inode count:              6111232
Block count:              24414048
Reserved block count:     1220702
Free blocks:              22966646
Free inodes:              6111221
First block:              0
Block size:               4096
Fragment size:            4096
Reserved GDT blocks:      1018
Blocks per group:         32768
Fragments per group:      32768
Inodes per group:         8192
Inode blocks per group:   512
RAID stripe width:        256
Flex block group size:    16
Filesystem created:       Wed Aug 13 23:52:54 2014
Last mount time:          n/a
Last write time:          Wed Aug 13 23:52:57 2014
Mount count:              0
Maximum mount count:      -1
Last checked:             Wed Aug 13 23:52:54 2014
Check interval:           0 (<none>)
Lifetime writes:          4104 MB
Reserved blocks uid:      0 (user root)
Reserved blocks gid:      0 (group root)
First inode:              11
Inode size:              256
Required extra isize:     28
Desired extra isize:      28
Journal inode:            8
Default directory hash:   half_md4
Directory Hash Seed:      96a5bb0c-3fcf-4114-bba3-049f15a2d8f4
Journal backup:           inode blocks
Journal features:         (none)
Journal size:             4096M
Journal length:           1048576
Journal sequence:         0x00000001
Journal start:            0

We did several rounds of file creation and removal:
1) vanilla kernel
 1a) diabling quota
 1b) enabling user/group quota

2) vanilla kernel with remove-dqptr_sem patches
 2a) diabling quota
 2b) enabling user/group quota

3) kernel with xattr based project quota
 3a) diabling quota
 3b) enabling user/group quota
 3c) enabling user/group/project quota

4) kernel with remove-dqptr_sem patches as well as xattr based project quota
 4a) diabling quota
 4b) enabling user/group quota
 4c) enabling user/group/project quota

5) kernel with remove-dqptr_sem patches as well as inode-internal project
quota
 5a) diabling quota
 5b) enabling user/group quota
 5c) enabling user/group/project quota

6) kernel with remove-dqptr_sem patches as well as xattr based project quota,
 but skipped writing the project ID xattr onto disk.
 6a) diabling quota
 6b) enabling user/group quota
 6c) enabling user/group/project quota

7) kernel with remove-dqptr_sem patches, but test in a directory with
default ACL. That means file creation will have to inherit ACL xattr from
the directory too.
 7a) diabling quota
 7b) enabling user/group quota


We got following conclusion:

A) The results of 1a) and 1b) shows that quota enforcement brings
significant performance regression, especially to file removal, if
remove-dqptr_sem patches are not landed.

B) The results of 1b) and 2b) shows that remove-dqptr_sem patches indeed
improves performance when quota is enabled.

C) The results of 2a) and 2b) shows that remove-dqptr_sem patches elimits
the overhead of enforcing quota.

D) The results of 3a) and 1a) shows that xattr based quota brings
significant performance regression to file creation. Even the quota
enforcement is disabled, the iheriting of project ID harms the
performance.

E) The results of 3b) and 2b) confirms D).

F) The results of 3c) and 3b) shows that extra quota enforcement
brings performance regression both to file creation and removal, if
remove-dqptr_sem patches are not landed.

G) The results of 4b) and 3b) confirms B).

H) The results of 4a), 4b) and 4c) confirms C). Extra quota enforcement
does not necessarily harms performance if remove-dqptr_sem patches
are landed.

I) The results of 4c) and 3c) confirms C).

J) The results of 5a) and 4a) shows that inode-internal based project ID
improves performance, especially for file creation. Since the quota
enforcement is not disabled, the overhead of inheriting project ID harms
the performance of 4a).

K) The results of 5b) and 4b) confirms J).

L) The results of 5c) and 4c) confirms J).

M) The results of 6) and 4) confirms saving xattr of project ID is the main
cause of the performance regression.

N) The result of 7) and 2) shows that iheriting default ACL
causes performance regression for file creation. This result confirms M).


Following are the test results:
File Creation:
                     1thr     2thr     4thr     8thr    16thr
1) vanilla
1a) quota disabled  66094   105781   178968   186647   172536
1b) quotaon(ug)     60337    99582   157396   171463   162872

2) vanilla + remove-dqptr_sem patches
2a) quota disabled  65955   112082   185550   181511   171988
2b) quotaon(ug)     62391   101905   171013   190570   168914

3) prjquota(xattr)
3a) quota disabled  61396    97580   147852   146423   164895
3b) quotaon(ug)     57009    93435   140589   135748   153196
3c) quotaon(ugP)    57500    89419   133604   125291   105127

4) prjquota(xattr) + remove-dqptr_sem patches
4a) quota disabled  64053   100078   147608   139403   163960
4b) quotaon(ug)     60754   104726   149231   139053   165990
4c) quotaon(ugP)    59238    93606   148921   138434   163931

5) prjquota(internal) + remove-dqptr_sem patches
5a) quota disabled  65826   111828   181486   189227   171241
5b) quotaon(ug)     65418   107745   173584   180562   173752
5c) quotaon(ugP)    64669   103890   169176   186426   172192

6) prjquota(xattr) + remove-dqptr_sem patches + skip xattr saving
6a) quota disabled  68590   112022   181028   185626   174231
6b) quotaon(ug)     58189    99716   167318   179360   180188
6c) quotaon(ugP)    59049    99110   172885   181841   172034

7) vanilla + remove-dqptr_sem patches + in directory with default ACL
7a) quota disabled  63630   103930   134828   114534   137676
7b) quotaon(ug)     62274    93960   130317   111247   138620

File Removal:
                     1thr     2thr     4thr     8thr    16thr
1) vanilla
1a) quota disabled 118059   169825   234661   291812   345656
1b) quotaon(ug)    106675   135834   153532   100437    87489

2) vanilla + remove-dqptr_sem patches
2a) quota disabled 120374   168437   236818   291754   331141
2b) quotaon(ug)    110709   161954   238333   293700   329015

3) prjquota(xattr)
3a) quota disabled 116680   161662   229190   295642   332959
3b) quotaon(ug)    104783   134359   154950   100516    87923
3c) quotaon(ugP)   100240   125978   108653    68286    58991

4) prjquota(xattr) + remove-dqptr_sem patches
4a) quota disabled 116281   168938   233733   286663   344002
4b) quotaon(ug)    109775   164995   236001   299389   340683
4c) quotaon(ugP)   113935   162979   236112   300033   356117

5) prjquota(internal) + remove-dqptr_sem patches
5a) quota disabled 119537   171565   247418   291068   350138
5b) quotaon(ug)    121756   159580   240778   298012   342437
5c) quotaon(ugP)   118954   168022   241206   289055   334008

6) prjquota(xattr) + remove-dqptr_sem patches + skip xattr saving
6a) quota disabled 120573   170316   239318   300070   344562
6b) quotaon(ug)    102690   156876   233259   302307   330111
6c) quotaon(ugP)   104816   161109   239573   294188   332578

7) vanilla + remove-dqptr_sem patches + in directory with default ACL
7a) quota disabled 123580   173847   246271   302456   335549
7b) quotaon(ug)    115557   156577   236049   305340   339873


115557   156577   236049   305340   339873

Following is the script we used to get result 3), 4), 5) and 6). (Please
note that we wrote a xattr interface for inode-internal implementation too.
That is why we are able to use this script to get result of 5).)
--
#!/bin/sh

export PATH=/work/tools/openmpi-1.6.2/bin:/usr/local/projquota/bin:/usr/local/projquota/sbin:$PATH
export LD_LIBRARY_PATH=/work/tools/openmpi-1.6.2/lib/
NFILES=800000
DIR=/mnt/ext4/testdir/
DEV=/dev/mapper/LUN01
MNTPT=/mnt/ext4
MPIRUN="mpirun -mca btl ^openib"
USER_ID=1000
PROJ_ID=1000

do_mount()
{
    local opts="$1"

    sudo sh -c "sync; echo 3 > /proc/sys/vm/drop_caches"
    sudo umount $MNTPT
    sudo sh -c "echo y | mkfs.ext4 -J size=4096 $DEV"
    sudo mount -t ext4 $DEV $opts $MNTPT
    sudo mkdir $DIR
    #sudo setfacl -m d:user1:--- $DIR
    sudo chmod 777 $DIR
}

quota_on()
{
    local opts="$1"

    sudo -i quotacheck $opts $MNTPT
    sudo -i quotaon $opts $MNTPT
}

run_pretest()
{
    local logfile=$1
    local opts=$2
    local nfiles=1000

    $MPIRUN -np 1 ./mdtest -n $nfiles -u -i 1 -F -C -d $DIR
    echo "#### quota $opts after file creation ####" > $logfile 2>&1
    sudo -i quota $opts >> $logfile 2>&1
    $MPIRUN -np 1 ./mdtest -n $nfiles -u -i 1 -F -r -d $DIR
    echo "#### quota $opts after file removal ####" >> $logfile 2>&1
    sudo -i quota $opts >> $logfile 2>&1
}

run_mdtest()
{
    local logfile=$1

    for n in 1 2 4 8 16; do
        nfiles=$((NFILES/n))
        $MPIRUN -np $n ./mdtest -n $nfiles -u -i 5 -F -d $DIR >> $logfile 2>&1
    done
}

# test with disabled quota
test_disable_quota()
{
    do_mount
    run_mdtest mdtest-disable-noopt.log
}

# test with enabled quota, but only user/group quota enforced
test_enable_quota_ug()
{
    do_mount "-o usrquota,grpquota"
    quota_on "-ug"
    sudo -i setquota -u $USER_ID 0 0 0 0 $MNTPT
    run_pretest "mdtest-enable-ug.log" "-vu $USER_ID"
    run_mdtest mdtest-enable-ug.log
}

# test with enabled quota and enforced project quota as well as user/group quota
test_enable_quota_ugP()
{
    do_mount "-o usrquota,grpquota,prjquota"
    quota_on "-ugP"
    sudo -i setfattr -n "system.project" -v $PROJ_ID $DIR
    sudo -i setquota -P $PROJ_ID 0 0 0 0 $MNTPT
    run_pretest "mdtest-enable-ugP.log" "-vP $PROJ_ID"
    run_mdtest mdtest-enable-ugP.log
}

sudo sh -c ./tune.sh

test_disable_quota
test_enable_quota_ug
test_enable_quota_ugP
