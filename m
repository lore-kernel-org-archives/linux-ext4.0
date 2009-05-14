From: Kevin Shanahan <kmshanah@ucwb.org.au>
Subject: Re: More ext4 acl/xattr corruption - 4th occurence now
Date: Fri, 15 May 2009 06:32:45 +0930
Message-ID: <20090514210244.GL5146@kulgan>
References: <20090513062634.GE4972@kulgan> <20090514044011.GC11352@mit.edu> <20090514110659.GA5146@kulgan> <20090514132506.GD5146@kulgan> <20090514140732.GI11352@mit.edu> <20090514143014.GH5146@kulgan> <20090514161254.GJ11352@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Andreas Dilger <adilger@sun.com>, Alex Tomas <bzzz@sun.com>,
	linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bowden.ucwb.org.au ([203.122.237.119]:52145 "EHLO
	mail.ucwb.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752047AbZENVCt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 14 May 2009 17:02:49 -0400
Content-Disposition: inline
In-Reply-To: <20090514161254.GJ11352@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, May 14, 2009 at 12:12:54PM -0400, Theodore Tso wrote:
> On Fri, May 15, 2009 at 12:00:15AM +0930, Kevin Shanahan wrote:
> > > debugfs: stat <759>
> > 
> > hermes:~# debugfs /dev/dm-0
> > debugfs 1.41.3 (12-Oct-2008)
> > debugfs:  stat <759>
> > 
> > Inode: 759   Type: regular    Mode:  0660   Flags: 0x80000
> > Generation: 3979120103    Version: 0x00000000:00000001
> > User:     0   Group: 10140   Size: 14615630848
> > File ACL: 0    Directory ACL: 0
> > Links: 1   Blockcount: 28546168
> > Fragment:  Address: 0    Number: 0    Size: 0
> >  ctime: 0x4a0acdb5:2a88cbec -- Wed May 13 23:10:05 2009
> >  atime: 0x4a0ac45b:10899618 -- Wed May 13 22:30:11 2009
> >  mtime: 0x4a0acdb5:2a88cbec -- Wed May 13 23:10:05 2009
> > crtime: 0x4a0ac45b:10899618 -- Wed May 13 22:30:11 2009
> 
> > Inode   Pathname
> > 759     /local/dumps/exchange/exchange-2000-UCWB-KVM-18.bkfB-KVM-18.bkf
> 
> Do you know how the system was likely writing into
> /local/dumps/exhcnag/eexchange-2000-UCWB-KVM-18.bkf?  What this a
> backup via rsync or tar?  Was this some application writing into a
> pre-existing file via NFS, or via local disk access?

This file was getting written by a windows server via samba. The
backup script on the windows side deletes the file before writing a
new copy each night. It's a fairly large file, about 14GB.

> Given the ctime/atime fields, I'm inclined to guess the latter, but it
> would be good to know.
> 
> The stat dump for the inode 759 does *not* show logical block 1741329
> getting mapped to physical block 529.  So the question is how did that
> happen?
> 
> I've started looking, and one thing popped up at me.  I need to check
> in with the Lustre folks who originally donated the code, but I don't
> see any spinlock or mutexes protecting the inode's extent cache.  So
> if you are on an SMP machine, this could potentially have caused the
> problem.  How many CPU's or cores do you have?  What does
> /proc/cpuinfo report?  Also, would it be correct to assume this file
> is getting served up via Samba.  My theory is that we might be running
> into problems when two threads are simultaneously trying read and
> write to a single file at the same time.

Yes, it's SMP (4 cores):

processor       : 0
vendor_id       : GenuineIntel
cpu family      : 6
model           : 23
model name      : Intel(R) Xeon(R) CPU           X3350  @ 2.66GHz
stepping        : 7
cpu MHz         : 2666.000
cache size      : 6144 KB
physical id     : 0
siblings        : 4
core id         : 0
cpu cores       : 4
apicid          : 0
initial apicid  : 0
fpu             : yes
fpu_exception   : yes
cpuid level     : 10
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx lm constant_tsc arch_perfmon pebs bts rep_good pni dtes64 monitor ds_cpl vmx smx est tm2 ssse3 cx16 xtpr pdcm sse4_1 lahf_lm tpr_shadow vnmi flexpriority
bogomips        : 5322.33
clflush size    : 64
cache_alignment : 64
address sizes   : 36 bits physical, 48 bits virtual
power management:  

> Hmm, what is accessing your files on this system?  Are you just doing
> backups?  Is it just a backup server?  Or are you serving up files
> using Samba and there are clients which are accessing those files?

This is a Samba server serving up files to clients and also a backup
server. That particular file is unlikely to have seen concurrent
access from multiple clients - the folder is only accessible to that
windows server to dump its exchange store overnight.

> So if this the problem the following experiment should be able to
> confirm whether it's the problem, by seeing if the problem goes away
> if we short-circuit the inode's extent cache.  In fs/ext4/extents.c,
> try inserting a "return" statement to in ext4_ext_put_in_cache():
> 
> static void
> ext4_ext_put_in_cache(struct inode *inode, ext4_lblk_t block,
> 			__u32 len, ext4_fsblk_t start, int type)
> {
> 	struct ext4_ext_cache *cex;
> 
> 	return;		      <---- insert this line
> 	BUG_ON(len == 0);
> 	cex = &EXT4_I(inode)->i_cached_extent;
> 	cex->ec_type = type;
> 	cex->ec_block = block;
> 	cex->ec_len = len;
> 	cex->ec_start = start;
> }
> 
> This should short circuit the i_cached_extent cache, and this may be
> enough to make your problem go away.  (If this theory is correct,
> using mount -o nodelalloc probably won't make a difference, although
> it might change the timing enough to make the bug harder to see.)
> 
> If that solves the problem, the right long-term fix will be to drop bin
> a spinlock to protect i_cached_extent.

Okay, nodelalloc was enough get through the backup process again at
least once (wrote the whole exchange-2000-UCWB-KVM-18.bkf file out in
full) without triggering the check_block_validity error.

To make sure I had something reproducable on the current kernel
(2.6.29.3 + check_block_validity patch), I re-mounted without
nodelalloc again and tried running just that exchange backup - the bug
did trigger again.

May 15 05:30:55 hermes kernel: EXT4-fs error (device dm-0): check_block_validity: inode #759 logical block 2509617 mapped to 0 (size 1)
May 15 05:30:55 hermes kernel: Aborting journal on device dm-0:8.
May 15 05:30:55 hermes kernel: ext4_da_writepages: jbd2_start: 775 pages, ino 759; err -30
May 15 05:30:55 hermes kernel: Pid: 5026, comm: pdflush Tainted: G        W  2.6.29.3 #1
May 15 05:30:55 hermes kernel: Call Trace:
May 15 05:30:55 hermes kernel:  [<ffffffff802fdce3>] ext4_da_writepages+0x211/0x427
May 15 05:30:55 hermes kernel:  [<ffffffff8055b44f>] thread_return+0x3d/0xc3
May 15 05:30:55 hermes kernel:  [<ffffffff802fef56>] ext4_da_get_block_write+0x0/0x12d
May 15 05:30:55 hermes kernel:  [<ffffffff802757df>] do_writepages+0x20/0x2d
May 15 05:30:55 hermes kernel:  [<ffffffff802aa359>] __writeback_single_inode+0x196/0x3a4
May 15 05:30:55 hermes kernel:  [<ffffffff802542aa>] del_timer_sync+0xc/0x16
May 15 05:30:55 hermes kernel:  [<ffffffff802aa9b9>] generic_sync_sb_inodes+0x2a7/0x439
May 15 05:30:55 hermes kernel:  [<ffffffff802aacfa>] writeback_inodes+0x7d/0xcc
May 15 05:30:55 hermes kernel:  [<ffffffff8027591e>] wb_kupdate+0x9f/0x116
May 15 05:30:55 hermes kernel:  [<ffffffff802764bf>] pdflush+0x125/0x1d2
May 15 05:30:55 hermes kernel:  [<ffffffff8027587f>] wb_kupdate+0x0/0x116
May 15 05:30:55 hermes kernel:  [<ffffffff8027639a>] pdflush+0x0/0x1d2
May 15 05:30:55 hermes kernel:  [<ffffffff8025c8cc>] kthread+0x47/0x73
May 15 05:30:55 hermes kernel:  [<ffffffff80225f7a>] child_rip+0xa/0x20
May 15 05:30:55 hermes kernel:  [<ffffffff8025c885>] kthread+0x0/0x73
May 15 05:30:55 hermes kernel:  [<ffffffff80225f70>] child_rip+0x0/0x20
May 15 05:30:55 hermes kernel: Remounting filesystem read-only
May 15 05:30:56 hermes kernel: ------------[ cut here ]------------
May 15 05:30:56 hermes kernel: WARNING: at fs/ext4/inode.c:1066 check_block_validity+0xd8/0xff()
May 15 05:30:56 hermes kernel: Hardware name: S3210SH
May 15 05:30:56 hermes kernel: Pid: 6196, comm: smbd Tainted: G        W  2.6.29.3 #1
May 15 05:30:56 hermes kernel: Call Trace:
May 15 05:30:56 hermes kernel:  [<ffffffff8024c0b0>] warn_slowpath+0xd3/0x10d
May 15 05:30:56 hermes kernel:  [<ffffffff8025cc0e>] wake_bit_function+0x0/0x23
May 15 05:30:56 hermes kernel:  [<ffffffff802afbec>] sync_dirty_buffer+0x5f/0x97
May 15 05:30:56 hermes kernel:  [<ffffffff8030589e>] ext4_commit_super+0xbc/0x103
May 15 05:30:56 hermes kernel:  [<ffffffff80307f92>] ext4_handle_error+0x83/0xa9
May 15 05:30:56 hermes kernel:  [<ffffffff803081cb>] ext4_error+0x83/0x90
May 15 05:30:56 hermes kernel:  [<ffffffff8040c772>] scsi_done+0x0/0xc
May 15 05:30:56 hermes kernel:  [<ffffffff80245f5c>] dequeue_task_fair+0x45/0x167
May 15 05:30:56 hermes kernel:  [<ffffffff802fd222>] check_block_validity+0xd8/0xff
May 15 05:30:56 hermes kernel:  [<ffffffff802febe1>] ext4_get_blocks_wrap+0xb5/0x24f
May 15 05:30:56 hermes kernel:  [<ffffffff802fee2d>] ext4_da_get_block_prep+0x58/0x181
May 15 05:30:56 hermes kernel:  [<ffffffff802b0187>] __block_prepare_write+0x150/0x2c4
May 15 05:30:56 hermes kernel:  [<ffffffff802fedd5>] ext4_da_get_block_prep+0x0/0x181
May 15 05:30:56 hermes kernel:  [<ffffffff802701e4>] add_to_page_cache_locked+0x73/0x95
May 15 05:30:56 hermes kernel:  [<ffffffff802b0447>] block_write_begin+0x7a/0xc7
May 15 05:30:56 hermes kernel:  [<ffffffff802fce53>] ext4_da_write_begin+0x166/0x1ed
May 15 05:30:56 hermes kernel:  [<ffffffff802fedd5>] ext4_da_get_block_prep+0x0/0x181
May 15 05:30:56 hermes kernel:  [<ffffffff80270b94>] generic_file_buffered_write+0x12c/0x2e8
May 15 05:30:56 hermes kernel:  [<ffffffff80271145>] __generic_file_aio_write_nolock+0x25f/0x293
May 15 05:30:56 hermes kernel:  [<ffffffff80271928>] generic_file_aio_write+0x64/0xc4
May 15 05:30:56 hermes kernel:  [<ffffffff802f8d33>] ext4_file_write+0x93/0x118
May 15 05:30:56 hermes kernel:  [<ffffffff80292f9c>] do_sync_write+0xce/0x113
May 15 05:30:56 hermes kernel:  [<ffffffff802bc5a0>] vfs_test_lock+0x2e/0x32
May 15 05:30:56 hermes kernel:  [<ffffffff8025cbe0>] autoremove_wake_function+0x0/0x2e
May 15 05:30:56 hermes kernel:  [<ffffffff802bd116>] fcntl_setlk+0x24b/0x25c
May 15 05:30:56 hermes kernel:  [<ffffffff8029373f>] vfs_write+0xa5/0xde
May 15 05:30:56 hermes kernel:  [<ffffffff802937cf>] sys_pwrite64+0x57/0x77
May 15 05:30:56 hermes kernel:  [<ffffffff8029d8c9>] sys_fcntl+0x312/0x31e
May 15 05:30:56 hermes kernel:  [<ffffffff8022501b>] system_call_fastpath+0x16/0x1b
May 15 05:30:56 hermes kernel: ---[ end trace df4d7250236f7466 ]---
May 15 05:30:56 hermes kernel: EXT4-fs error (device dm-0) in ext4_da_write_begin: IO failure
May 15 05:30:56 hermes kernel: __journal_remove_journal_head: freeing b_frozen_data

debugfs:  stat <759>

Inode: 759   Type: regular    Mode:  0660   Flags: 0x80000
Generation: 2963762165    Version: 0x00000000:00000001
User:     0   Group: 10140   Size: 14814860288
File ACL: 0    Directory ACL: 0
Links: 1   Blockcount: 28935288
Fragment:  Address: 0    Number: 0    Size: 0
 ctime: 0x4a0c363e:77c84a60 -- Fri May 15 00:48:22 2009
 atime: 0x4a0c2ce8:55358578 -- Fri May 15 00:08:32 2009
 mtime: 0x4a0c363e:77c84a60 -- Fri May 15 00:48:22 2009
crtime: 0x4a0c2ce8:55358578 -- Fri May 15 00:08:32 2009
Size of extra inode fields: 28
Extended attributes stored in inode body: 
   = "01 00 00 00 01 00 06 00 02 00 07 00 12 27 00 00 04 00 05 00 08 00 05 00 57 27 00 00 08 00 07 00 98 27 00 00 10 00 06 00 20 00 00 00 " (44)
  DOSATTRIB = "0x20" (4)
BLOCKS:
(IND):6603263, (0):6604364, (1-511):6602752-6603262, (512-1023):6586368-6586879, (1024-2047):6587392-6588415, (2048-14335):6590464-6602751, (14336-188415):6641664-6815743, (188416-417791):6914048-7143423, (417792-419839):7172096-7174143, (419840-423935):7168000-7172095, (423936-448511):7143424-7167999, (448512-450559):7182336-7184383, (450560-452607):7192576-7194623, (452608-456703):7188480-7192575, (456704-600063):7196672-7340031, (600064-602111):7380992-7383039, (602112-604159):7387136-7389183, (604160-696319):7444480-7536639, (696320-763903):7567360-7634943, (763904-978943):7649280-7864319, (978944-1044479):7897088-7962623, (1044480-1046527):7979008-7981055, (1046528-1079295):7995392-8028159, (1079296-1081343):8048640-8050687, (1081344-1085439):8044544-8048639, (1085440-1101823):8028160
 -8044543, (1101824-1112063):8052736-8062975, (1112064-1114111):8081408-8083455, (1114112-1118207):8065024-8069119, (1118208-1122303):8077312-8081407, (1122304-1130495):8069120-8077311, (1130496-1138687):8085504-8093695, (1138688-1140735):8110080-8112127, (1140736-1142783):8114176-8116223, (1142784-1148927):8120320-8126463, (1148928-1150975):8136704-8138751, (1150976-1155071):8126464-8130559, (1155072-1241087):8138752-8224767, (1241088-1243135):8241152-8243199, (1243136-1245183):8249344-8251391, (1245184-1247231):8253440-8255487, (1247232-1251327):8245248-8249343, (1251328-1267711):8224768-8241151, (1267712-1269759):8292352-8294399, (1269760-1273855):8298496-8302591, (1273856-1275903):8398848-8400895, (1275904-1277951):8402944-8404991, (1277952-1282047):8407040-8411135, (1282048-1288191):
 8417280-8423423, (1288192-1306623):8501248-8519679, (1306624-1310719):8536064-8540159, (1310720-1327103):8519680-8536063, (1327104-1329151):8710144-8712191, (1329152-1331199):8718336-8720383, (1331200-1345535):8726528-8740863, (1345536-1347583):8749056-8751103, (1347584-1349631):8761344-8763391, (1349632-1351679):8779776-8781823, (1351680-1353727):8806400-8808447, (1353728-1357823):8790016-8794111, (1357824-1386495):8818688-8847359, (1386496-1388543):8859648-8861695, (1388544-1390591):8863744-8865791, (1390592-1394687):8855552-8859647, (1394688-1402879):8847360-8855551, (1402880-1404927):8923136-8925183, (1404928-1474559):11603968-11673599, (1474560-1484799):12998656-13008895, (1484800-1486847):13037568-13039615, (1486848-1490943):13033472-13037567, (1490944-1515519):13008896-13033471, (
 1515520-1517567):13070336-13072383, (1517568-1521663):13058048-13062143, (1521664-1525759):13066240-13070335, (1525760-1542143):13041664-13058047, (1542144-1546239):16058368-16062463, (1546240-1550335):16084992-16089087, (1550336-1552383):16119808-16121855, (1552384-1554431):16150528-16152575, (1554432-1558527):16138240-16142335, (1558528-1562623):16146432-16150527, (1562624-1579007):16121856-16138239, (1579008-1581055):16154624-16156671, (1581056-1587199):16160768-16166911, (1587200-1589247):16199680-16201727, (1589248-1591295):16203776-16205823, (1591296-1593343):16226304-16228351, (1593344-1595391):16359424-16361471, (1595392-1599487):16369664-16373759, (1599488-1601535):16377856-16379903, (1601536-1603583):16388096-16390143, (1603584-1605631):16394240-16396287, (1605632-1607679):1640
 0384-16402431, (1607680-1611775):16396288-16400383, (1611776-1615871):16455680-16459775, (1615872-1619967):16467968-16472063, (1619968-1624063):16461824-16465919, (1624064-1626111):16574464-16576511, (1626112-1628159):16578560-16580607, (1628160-1630207):16609280-16611327, (1630208-1638399):16601088-16609279, (1638400-1646591):16580608-16588799, (1646592-1650687):16652288-16656383, (1650688-1652735):16662528-16664575, (1652736-1656831):18202624-18206719, (1656832-1658879):18262016-18264063, (1658880-1660927):18276352-18278399, (1660928-1673215):18264064-18276351, (1673216-1677311):18296832-18300927, (1677312-1689599):18305024-18317311, (1689600-1693695):18706432-18710527, (1693696-1695743):18712576-18714623, (1695744-1699839):18728960-18733055, (1699840-1701887):18735104-18737151, (17018
 88-1714175):18714624-18726911, (1714176-1716223):18753536-18755583, (1716224-1718271):18757632-18759679, (1718272-1720319):18767872-18769919, (1720320-1728511):18759680-18767871, (1728512-1789951):18780160-18841599, (1789952-1794047):18857984-18862079, (1794048-1810431):18841600-18857983, (1810432-1818623):18866176-18874367, (1818624-1820671):18884608-18886655, (1820672-2035711):18888704-19103743, (2035712-2037759):19132416-19134463, (2037760-2041855):19128320-19132415, (2041856-2066431):19103744-19128319, (2066432-2328575):19136512-19398655, (2328576-2330623):19408896-19410943, (2330624-2332671):19419136-19421183, (2332672-2340863):19410944-19419135, (2340864-2447359):19423232-19529727, (2447360-2478079):19531776-19562495, (2478080-2482175):19576832-19580927, (2482176-2486271):19593216-
 19597311, (2486272-2488319):19601408-19603455, (2488320-2783231):19628032-19922943, (2783232-2838527):19933184-19988479, (2838528-2842623):19998720-20002815, (2842624-2846719):20006912-20011007, (2846720-2854911):19988480-19996671, (2854912-3248127):20054016-20447231, (3248128-3252223):20457472-20461567, (3252224-3254271):20471808-20473855, (3254272-3262463):20463616-20471807, (3262464-3264511):20484096-20486143, (3264512-3266559):20502528-20504575, (3266560-3268607):20523008-20525055, (3268608-3270655):20533248-20535295, (3270656-3616909):20578304-20924557
TOTAL: 3616911

debugfs:  ncheck 759
Inode   Pathname
759     /local/dumps/exchange/exchange-2000-UCWB-KVM-18.bkfB-KVM-18.bkf

hermes:~# e2fsck -pfv /dev/dm-0
/dev/dm-0: recovering journal
/dev/dm-0: Inode 7 has illegal block(s).  

/dev/dm-0: UNEXPECTED INCONSISTENCY; RUN fsck MANUALLY.
        (i.e., without -a or -p options)

hermes:~# e2fsck -fv /dev/dm-0
e2fsck 1.41.3 (12-Oct-2008)
Pass 1: Checking inodes, blocks, and sizes
Inode 7 has illegal block(s).  Clear<y>? yes

Illegal block #181260 (1109068081) in inode 7.  CLEARED.
Illegal block #181261 (2437571651) in inode 7.  CLEARED.
Illegal block #181262 (892263544) in inode 7.  CLEARED.
Illegal block #181263 (1023380360) in inode 7.  CLEARED.
Illegal block #181264 (1152724232) in inode 7.  CLEARED.
Illegal block #181265 (2602060959) in inode 7.  CLEARED.
Illegal block #181266 (754287188) in inode 7.  CLEARED.
Illegal block #181267 (2833437713) in inode 7.  CLEARED.
Illegal block #181268 (1495914360) in inode 7.  CLEARED.
Illegal block #181269 (1583358807) in inode 7.  CLEARED.
Illegal block #181271 (1514245352) in inode 7.  CLEARED.
Too many illegal blocks in inode 7.
Clear inode<y>? yes

Restarting e2fsck from the beginning...
Resize inode not valid.  Recreate<y>? yes

Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
Free blocks count wrong for group #0 (4275, counted=4276).
Fix<y>? yes

Free blocks count wrong for group #142 (30919, counted=199).
Fix<y>? yes

Free blocks count wrong for group #143 (32768, counted=0).
Fix<y>? yes

Free blocks count wrong for group #159 (13307, counted=11259).
Fix<y>? yes

Free blocks count wrong for group #164 (7197, counted=5149).
Fix<y>? yes

Free blocks count wrong for group #165 (18691, counted=2307).
Fix<y>? yes

Free blocks count wrong for group #167 (31325, counted=2653).
Fix<y>? yes

Free blocks count wrong for group #168 (32768, counted=0).
Fix<y>? yes

Free blocks count wrong for group #169 (32768, counted=0).
Fix<y>? yes

Free blocks count wrong for group #170 (32768, counted=0).
Fix<y>? yes

Free blocks count wrong for group #171 (32768, counted=0).
Fix<y>? yes

Free blocks count wrong for group #172 (32768, counted=0).
Fix<y>? yes

Free blocks count wrong for group #173 (32768, counted=0).
Fix<y>? yes

Free blocks count wrong for group #174 (32768, counted=0).
Fix<y>? yes

Free blocks count wrong for group #175 (32768, counted=0).
Fix<y>? yes

Free blocks count wrong for group #186 (14647, counted=2359).
Fix<y>? yes

Free blocks count wrong for group #187 (32768, counted=0).
Fix<y>? yes

Free blocks count wrong for group #188 (32768, counted=0).
Fix<y>? yes

Free blocks count wrong for group #189 (32768, counted=0).
Fix<y>? yes

Free blocks count wrong for group #190 (32768, counted=0).
Fix<y>? yes

Free blocks count wrong for group #191 (32768, counted=0).
Fix<y>? yes

Free blocks count wrong for group #196 (3955, counted=1907).
Fix<y>? yes

Free blocks count wrong for group #197 (4901, counted=805).
Fix<y>? yes

Free blocks count wrong for group #198 (26087, counted=1511).
Fix<y>? yes

Free blocks count wrong for group #199 (27516, counted=892).
Fix<y>? yes

Free blocks count wrong for group #200 (32768, counted=0).
Fix<y>? yes

Free blocks count wrong for group #201 (18382, counted=6094).
Fix<y>? yes

Free blocks count wrong for group #202 (32104, counted=1384).
Fix<y>? yes

Free blocks count wrong for group #203 (32768, counted=0).
Fix<y>? yes

Free blocks count wrong for group #204 (32768, counted=0).
Fix<y>? yes

Free blocks count wrong for group #205 (32768, counted=0).
Fix<y>? yes

Free blocks count wrong for group #206 (32768, counted=0).
Fix<y>? yes

Free blocks count wrong for group #207 (32768, counted=0).
Fix<y>? yes

Free blocks count wrong for group #211 (32768, counted=0).
Fix<y>? yes

Free blocks count wrong for group #212 (32768, counted=0).
Fix<y>? yes

Free blocks count wrong for group #213 (32768, counted=0).
Fix<y>? yes

Free blocks count wrong for group #214 (32768, counted=0).
Fix<y>? yes

Free blocks count wrong for group #215 (32768, counted=0).
Fix<y>? yes

Free blocks count wrong for group #216 (32768, counted=0).
Fix<y>? yes

Free blocks count wrong for group #217 (32768, counted=0).
Fix<y>? yes

Free blocks count wrong for group #218 (31158, counted=438).
Fix<y>? yes

Free blocks count wrong for group #219 (23522, counted=3042).
Fix<y>? yes

Free blocks count wrong for group #220 (32768, counted=0).
Fix<y>? yes

Free blocks count wrong for group #221 (32768, counted=0).
Fix<y>? yes

Free blocks count wrong for group #222 (32768, counted=0).
Fix<y>? yes

Free blocks count wrong for group #223 (32768, counted=0).
Fix<y>? yes

Free blocks count wrong for group #225 (14501, counted=10405).
Fix<y>? yes

Free blocks count wrong for group #227 (27863, counted=1239).
Fix<y>? yes

Free blocks count wrong for group #228 (32768, counted=0).
Fix<y>? yes

Free blocks count wrong for group #229 (32768, counted=0).
Fix<y>? yes

Free blocks count wrong for group #230 (2780, counted=732).
Fix<y>? yes

Free blocks count wrong for group #231 (32768, counted=0).
Fix<y>? yes

Free blocks count wrong for group #232 (32768, counted=2481).
Fix<y>? yes

Free blocks count wrong (222364420, counted=220943542).
Fix<y>? yes


/dev/dm-0: ***** FILE SYSTEM WAS MODIFIED *****

  331810 inodes used (0.49%)
   16104 non-contiguous inodes (4.9%)
         # of inodes with ind/dind/tind blocks: 0/0/0
         Extent depth histogram: 331389/351
47491914 blocks used (17.69%)
       0 bad blocks
       2 large files

  305051 regular files
   26686 directories
       0 character device files
       0 block device files
       0 fifos
       0 links
      64 symbolic links (60 fast symbolic links)
       0 sockets
--------
  331801 files

Okay, so now I've booted into 2.6.29.3 + check_block_validity patch +
short circuit i_cached_extent patch, mounted the fs without
nodelalloc. I was able to run the full exchange backup without
triggering the check_block_validity error.

Regards,
Kevin.
