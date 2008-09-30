From: godfroy@clipper.ens.fr (Quentin)
Subject: Re: possible (ext4 related?) memory leak in kernel 2.6.26
Date: Wed,  1 Oct 2008 00:23:58 +0200 (CEST)
Message-ID: <20080930222358.1FF30EAC415@quatramaran.ens.fr>
References: <20080930211854.GZ10831@mit.edu>
To: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from nef2.ens.fr ([129.199.96.40]:3018 "EHLO nef2.ens.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751264AbYI3XP4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 30 Sep 2008 19:15:56 -0400
In-Reply-To: <20080930211854.GZ10831@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Dans l'article <20080930211854.GZ10831@mit.edu> tu as ecrit :
> [ Reply-to set to linux-ext4@vger.kernel.org ]
> 
> On Tue, Sep 30, 2008 at 10:27:29PM +0200, Quentin Godfroy wrote:
>> Hi lists,
>> I'd like to report the following problem : after ~ 10 days' uptime on a
>> Debian 2.6.26-1-686 kernel, my system becomes extremely sluggish and
>> unresponsive and the OOM-killer starts targeting even innocent processes like
>> identd or rsync (when the swap is disabled). The machine is low on RAM (192
>> MB) but this has never been a problem before. As for the slowness, strace
>> shows that the brk() syscall takes ages to complete; the blocking processes
>> are in the D state (and for some reason the kernel gives no wchan info).
>>
>> Config has nothing unusual except that all fs are ext4, which I am begining
>> to suspect may be the culprit, as every night some process stat()s and
>> read()s something like 850,000 files, which is maybe fs-stressing; also,
>> umounting then remounting /home makes the 'buffers' drop from 127304 to
>> 55920 and partially solves the problem.
[...]
> 
> Can you send the output of /proc/meminfo and /proc/slabinfo?

Of course. However since I unmounted and remounted /home the 'buffer' line
is now only 59megs, and they are still not dropped when a program tries to
malloc all the memory. I'll tell next time the problem shows up (it
can take ten days)

MemTotal:       190356 kB
MemFree:         12300 kB
Buffers:         59652 kB
Cached:          21612 kB
SwapCached:       5508 kB
Active:          84868 kB
Inactive:        78116 kB
HighTotal:           0 kB
HighFree:            0 kB
LowTotal:       190356 kB
LowFree:         12300 kB
SwapTotal:      506036 kB
SwapFree:       474880 kB
Dirty:            1252 kB
Writeback:           0 kB
AnonPages:        8268 kB
Mapped:           5484 kB
Slab:             8488 kB
SReclaimable:     4472 kB
SUnreclaim:       4016 kB
PageTables:       1192 kB
NFS_Unstable:        0 kB
Bounce:              0 kB
WritebackTmp:        0 kB
CommitLimit:    601212 kB
Committed_AS:   139452 kB
VmallocTotal:   835576 kB
VmallocUsed:      4344 kB
VmallocChunk:   830840 kB
HugePages_Total:     0
HugePages_Free:      0
HugePages_Rsvd:      0
HugePages_Surp:      0
Hugepagesize:     4096 kB


slabinfo - version: 2.1
# name            <active_objs> <num_objs> <objsize> <objperslab> <pagesperslab> : tunables <limit> <batchcount> <sharedfactor> : slabdata <active_slabs> <num_slabs> <sharedavail>
nfsd4_delegations      0      0    212   18    1 : tunables  120   60    0 : slabdata      0      0      0
nfsd4_stateids         0      0     72   53    1 : tunables  120   60    0 : slabdata      0      0      0
nfsd4_files            0      0     40   92    1 : tunables  120   60    0 : slabdata      0      0      0
nfsd4_stateowners      0      0    344   11    1 : tunables   54   27    0 : slabdata      0      0      0
nfs_direct_cache       0      0     76   50    1 : tunables  120   60    0 : slabdata      0      0      0
nfs_write_data        36     36    416    9    1 : tunables   54   27    0 : slabdata      4      4      0
nfs_read_data         32     36    416    9    1 : tunables   54   27    0 : slabdata      4      4      0
nfs_inode_cache        0      0    636    6    1 : tunables   54   27    0 : slabdata      0      0      0
nfs_page               0      0     64   59    1 : tunables  120   60    0 : slabdata      0      0      0
rpc_buffers            8      8   2048    2    1 : tunables   24   12    0 : slabdata      4      4      0
rpc_tasks              8     24    160   24    1 : tunables  120   60    0 : slabdata      1      1      0
rpc_inode_cache        6      8    480    8    1 : tunables   54   27    0 : slabdata      1      1      0
fib6_nodes             9    113     32  113    1 : tunables  120   60    0 : slabdata      1      1      0
ip6_dst_cache         13     30    256   15    1 : tunables  120   60    0 : slabdata      2      2      0
ndisc_cache            1     20    192   20    1 : tunables  120   60    0 : slabdata      1      1      0
ip6_mrt_cache          0      0    128   30    1 : tunables  120   60    0 : slabdata      0      0      0
RAWv6                  4      6    672    6    1 : tunables   54   27    0 : slabdata      1      1      0
UDPLITEv6              0      0    640    6    1 : tunables   54   27    0 : slabdata      0      0      0
UDPv6                 10     12    640    6    1 : tunables   54   27    0 : slabdata      2      2      0
tw_sock_TCPv6          0      0    224   17    1 : tunables  120   60    0 : slabdata      0      0      0
request_sock_TCPv6      0      0    128   30    1 : tunables  120   60    0 : slabdata      0      0      0
TCPv6                 14     15   1312    3    1 : tunables   24   12    0 : slabdata      5      5      0
ext2_inode_cache       1      8    488    8    1 : tunables   54   27    0 : slabdata      1      1      0
ext2_xattr             0      0     48   78    1 : tunables  120   60    0 : slabdata      0      0      0
fuse_request           0      0    376   10    1 : tunables   54   27    0 : slabdata      0      0      0
fuse_inode             0      0    448    9    1 : tunables   54   27    0 : slabdata      0      0      0
bridge_fdb_cache       5     59     64   59    1 : tunables  120   60    0 : slabdata      1      1      0
sgpool-128             2      3   2560    3    2 : tunables   24   12    0 : slabdata      1      1      0
sgpool-64              2      3   1280    3    1 : tunables   24   12    0 : slabdata      1      1      0
sgpool-32              2      6    640    6    1 : tunables   54   27    0 : slabdata      1      1      0
sgpool-16              2     12    320   12    1 : tunables   54   27    0 : slabdata      1      1      0
sgpool-8               2     24    160   24    1 : tunables  120   60    0 : slabdata      1      1      0
scsi_bidi_sdb          0      0     20  169    1 : tunables  120   60    0 : slabdata      0      0      0
scsi_io_context        0      0    104   37    1 : tunables  120   60    0 : slabdata      0      0      0
uhci_urb_priv          0      0     28  127    1 : tunables  120   60    0 : slabdata      0      0      0
ext4_inode_cache     636    889    536    7    1 : tunables   54   27    0 : slabdata    127    127      0
ext4_xattr             0      0     48   78    1 : tunables  120   60    0 : slabdata      0      0      0
ext4_alloc_context     16     36    108   36    1 : tunables  120   60    0 : slabdata      1      1      0
ext4_prealloc_space     11     59     64   59    1 : tunables  120   60    0 : slabdata      1      1      0
jbd2_journal_handle      2    169     20  169    1 : tunables  120   60    0 : slabdata      1      1      0
jbd2_journal_head    276    288     52   72    1 : tunables  120   60    0 : slabdata      4      4      0
jbd2_revoke_table      4    254     12  254    1 : tunables  120   60    0 : slabdata      1      1      0
jbd2_revoke_record      0      0     32  113    1 : tunables  120   60    0 : slabdata      0      0      0
flow_cache             0      0     80   48    1 : tunables  120   60    0 : slabdata      0      0      0
cfq_io_context        72     80     96   40    1 : tunables  120   60    0 : slabdata      2      2      0
cfq_queue             73     92     84   46    1 : tunables  120   60    0 : slabdata      2      2      0
bsg_cmd                0      0    284   14    1 : tunables   54   27    0 : slabdata      0      0      0
mqueue_inode_cache      1      7    544    7    1 : tunables   54   27    0 : slabdata      1      1      0
hugetlbfs_inode_cache      1     11    340   11    1 : tunables   54   27    0 : slabdata      1      1      0
dnotify_cache          2    169     20  169    1 : tunables  120   60    0 : slabdata      1      1      0
dquot                  0      0    128   30    1 : tunables  120   60    0 : slabdata      0      0      0
inotify_event_cache      0      0     28  127    1 : tunables  120   60    0 : slabdata      0      0      0
inotify_watch_cache      5     92     40   92    1 : tunables  120   60    0 : slabdata      1      1      0
kioctx                 0      0    192   20    1 : tunables  120   60    0 : slabdata      0      0      0
kiocb                  0      0    160   24    1 : tunables  120   60    0 : slabdata      0      0      0
fasync_cache           0      0     16  203    1 : tunables  120   60    0 : slabdata      0      0      0
shmem_inode_cache    746    747    444    9    1 : tunables   54   27    0 : slabdata     83     83      0
pid_namespace          0      0     36  101    1 : tunables  120   60    0 : slabdata      0      0      0
nsproxy                0      0     28  127    1 : tunables  120   60    0 : slabdata      0      0      0
posix_timers_cache      0      0    128   30    1 : tunables  120   60    0 : slabdata      0      0      0
uid_cache             10     59     64   59    1 : tunables  120   60    0 : slabdata      1      1      0
UNIX                  40     45    448    9    1 : tunables   54   27    0 : slabdata      5      5      0
ip_mrt_cache           0      0     96   40    1 : tunables  120   60    0 : slabdata      0      0      0
UDP-Lite               0      0    544    7    1 : tunables   54   27    0 : slabdata      0      0      0
tcp_bind_bucket       35    113     32  113    1 : tunables  120   60    0 : slabdata      1      1      0
inet_peer_cache        0      0     64   59    1 : tunables  120   60    0 : slabdata      0      0      0
secpath_cache          0      0     32  113    1 : tunables  120   60    0 : slabdata      0      0      0
xfrm_dst_cache         0      0    288   13    1 : tunables   54   27    0 : slabdata      0      0      0
ip_fib_alias           0      0     16  203    1 : tunables  120   60    0 : slabdata      0      0      0
ip_fib_hash            9    101     36  101    1 : tunables  120   60    0 : slabdata      1      1      0
ip_dst_cache          36     45    256   15    1 : tunables  120   60    0 : slabdata      3      3      0
arp_cache              2     24    160   24    1 : tunables  120   60    0 : slabdata      1      1      0
RAW                    3      8    512    8    1 : tunables   54   27    0 : slabdata      1      1      0
UDP                   34     35    544    7    1 : tunables   54   27    0 : slabdata      5      5      0
tw_sock_TCP            1     20    192   20    1 : tunables  120   60    0 : slabdata      1      1      0
request_sock_TCP       0     40     96   40    1 : tunables  120   60    0 : slabdata      0      1      0
TCP                   35     36   1216    3    1 : tunables   24   12    0 : slabdata     12     12      0
eventpoll_pwq          8    101     36  101    1 : tunables  120   60    0 : slabdata      1      1      0
eventpoll_epi          8     40     96   40    1 : tunables  120   60    0 : slabdata      1      1      0
blkdev_queue          20     21   1124    7    2 : tunables   24   12    0 : slabdata      3      3      0
blkdev_requests       60     60    196   20    1 : tunables  120   60    0 : slabdata      3      3      0
blkdev_ioc            72     78     48   78    1 : tunables  120   60    0 : slabdata      1      1      0
biovec-256             2      2   3072    2    2 : tunables   24   12    0 : slabdata      1      1      0
biovec-128             2      5   1536    5    2 : tunables   24   12    0 : slabdata      1      1      0
biovec-64             10     10    768    5    1 : tunables   54   27    0 : slabdata      2      2      0
biovec-16             10     20    192   20    1 : tunables  120   60    0 : slabdata      1      1      0
biovec-4              10     59     64   59    1 : tunables  120   60    0 : slabdata      1      1      0
biovec-1              70    203     16  203    1 : tunables  120   60    0 : slabdata      1      1      0
bio                   80     80     96   40    1 : tunables  120   60    0 : slabdata      2      2      0
sock_inode_cache     156    160    384   10    1 : tunables   54   27    0 : slabdata     16     16      0
skbuff_fclone_cache     10     10    384   10    1 : tunables   54   27    0 : slabdata      1      1      0
skbuff_head_cache    106    460    192   20    1 : tunables  120   60    0 : slabdata     23     23      0
file_lock_cache       31     39    100   39    1 : tunables  120   60    0 : slabdata      1      1      0
Acpi-Operand         579    644     40   92    1 : tunables  120   60    0 : slabdata      7      7      0
Acpi-ParseExt          0      0     48   78    1 : tunables  120   60    0 : slabdata      0      0      0
Acpi-Parse             0      0     32  113    1 : tunables  120   60    0 : slabdata      0      0      0
Acpi-State             0      0     44   84    1 : tunables  120   60    0 : slabdata      0      0      0
Acpi-Namespace       320    338     20  169    1 : tunables  120   60    0 : slabdata      2      2      0
task_delay_info      121    156     48   78    1 : tunables  120   60    0 : slabdata      2      2      0
taskstats              2     12    312   12    1 : tunables   54   27    0 : slabdata      1      1      0
proc_inode_cache      49    132    356   11    1 : tunables   54   27    0 : slabdata     12     12      0
sigqueue              16     27    144   27    1 : tunables  120   60    0 : slabdata      1      1      0
radix_tree_node     1697   2574    288   13    1 : tunables   54   27    0 : slabdata    198    198      0
bdev_cache             8      9    448    9    1 : tunables   54   27    0 : slabdata      1      1      0
sysfs_dir_cache     6015   6048     44   84    1 : tunables  120   60    0 : slabdata     72     72      0
mnt_cache             27     30    128   30    1 : tunables  120   60    0 : slabdata      1      1      0
inode_cache          111    187    340   11    1 : tunables   54   27    0 : slabdata     17     17      0
dentry              1985   4350    132   29    1 : tunables  120   60    0 : slabdata    150    150      0
filp                1056   1056    160   24    1 : tunables  120   60    0 : slabdata     44     44      0
names_cache            3      3   4096    1    1 : tunables   24   12    0 : slabdata      3      3      0
key_jar                0      0     96   40    1 : tunables  120   60    0 : slabdata      0      0      0
buffer_head        32890  39329     56   67    1 : tunables  120   60    0 : slabdata    587    587      0
mm_struct             72     72    416    9    1 : tunables   54   27    0 : slabdata      8      8      0
vm_area_struct      2263   2300     84   46    1 : tunables  120   60    0 : slabdata     50     50      0
fs_cache              84    118     64   59    1 : tunables  120   60    0 : slabdata      2      2      0
files_cache           68     68    224   17    1 : tunables  120   60    0 : slabdata      4      4      0
signal_cache          96     96    480    8    1 : tunables   54   27    0 : slabdata     12     12      0
sighand_cache         96     96   1312    3    1 : tunables   24   12    0 : slabdata     32     32      0
task_xstate           52     64    512    8    1 : tunables   54   27    0 : slabdata      8      8      0
task_struct          112    112   1056    7    2 : tunables   24   12    0 : slabdata     16     16      0
anon_vma            1114   1270     12  254    1 : tunables  120   60    0 : slabdata      5      5      0
pid                  118    118     64   59    1 : tunables  120   60    0 : slabdata      2      2      0
idr_layer_cache      174    174    136   29    1 : tunables  120   60    0 : slabdata      6      6      0
size-4194304(DMA)      0      0 4194304    1 1024 : tunables    1    1    0 : slabdata      0      0      0
size-4194304           0      0 4194304    1 1024 : tunables    1    1    0 : slabdata      0      0      0
size-2097152(DMA)      0      0 2097152    1  512 : tunables    1    1    0 : slabdata      0      0      0
size-2097152           0      0 2097152    1  512 : tunables    1    1    0 : slabdata      0      0      0
size-1048576(DMA)      0      0 1048576    1  256 : tunables    1    1    0 : slabdata      0      0      0
size-1048576           0      0 1048576    1  256 : tunables    1    1    0 : slabdata      0      0      0
size-524288(DMA)       0      0 524288    1  128 : tunables    1    1    0 : slabdata      0      0      0
size-524288            0      0 524288    1  128 : tunables    1    1    0 : slabdata      0      0      0
size-262144(DMA)       0      0 262144    1   64 : tunables    1    1    0 : slabdata      0      0      0
size-262144            0      0 262144    1   64 : tunables    1    1    0 : slabdata      0      0      0
size-131072(DMA)       0      0 131072    1   32 : tunables    8    4    0 : slabdata      0      0      0
size-131072            2      2 131072    1   32 : tunables    8    4    0 : slabdata      2      2      0
size-65536(DMA)        0      0  65536    1   16 : tunables    8    4    0 : slabdata      0      0      0
size-65536             0      0  65536    1   16 : tunables    8    4    0 : slabdata      0      0      0
size-32768(DMA)        0      0  32768    1    8 : tunables    8    4    0 : slabdata      0      0      0
size-32768             0      0  32768    1    8 : tunables    8    4    0 : slabdata      0      0      0
size-16384(DMA)        0      0  16384    1    4 : tunables    8    4    0 : slabdata      0      0      0
size-16384             0      0  16384    1    4 : tunables    8    4    0 : slabdata      0      0      0
size-8192(DMA)         0      0   8192    1    2 : tunables    8    4    0 : slabdata      0      0      0
size-8192              2      2   8192    1    2 : tunables    8    4    0 : slabdata      2      2      0
size-4096(DMA)         0      0   4096    1    1 : tunables   24   12    0 : slabdata      0      0      0
size-4096             35     35   4096    1    1 : tunables   24   12    0 : slabdata     35     35      0
size-2048(DMA)         0      0   2048    2    1 : tunables   24   12    0 : slabdata      0      0      0
size-2048            203    242   2048    2    1 : tunables   24   12    0 : slabdata    121    121      0
size-1024(DMA)         0      0   1024    4    1 : tunables   54   27    0 : slabdata      0      0      0
size-1024            212    212   1024    4    1 : tunables   54   27    0 : slabdata     53     53      0
size-512(DMA)          0      0    512    8    1 : tunables   54   27    0 : slabdata      0      0      0
size-512             488    488    512    8    1 : tunables   54   27    0 : slabdata     61     61      0
size-256(DMA)          0      0    256   15    1 : tunables  120   60    0 : slabdata      0      0      0
size-256             135    135    256   15    1 : tunables  120   60    0 : slabdata      9      9      0
size-192(DMA)          0      0    192   20    1 : tunables  120   60    0 : slabdata      0      0      0
size-192             219    240    192   20    1 : tunables  120   60    0 : slabdata     12     12      0
size-128(DMA)          0      0    128   30    1 : tunables  120   60    0 : slabdata      0      0      0
size-128             292    330    128   30    1 : tunables  120   60    0 : slabdata     11     11      0
size-96(DMA)           0      0     96   40    1 : tunables  120   60    0 : slabdata      0      0      0
size-96              607    680     96   40    1 : tunables  120   60    0 : slabdata     17     17      0
size-64(DMA)           0      0     64   59    1 : tunables  120   60    0 : slabdata      0      0      0
size-32(DMA)           0      0     32  113    1 : tunables  120   60    0 : slabdata      0      0      0
size-64             2850   3599     64   59    1 : tunables  120   60    0 : slabdata     61     61      0
size-32             6063   6102     32  113    1 : tunables  120   60    0 : slabdata     54     54      0
kmem_cache           163    180    128   30    1 : tunables  120   60    0 : slabdata      6      6      0
