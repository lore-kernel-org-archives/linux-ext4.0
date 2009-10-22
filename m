From: Nick Dokos <nicholas.dokos@hp.com>
Subject: e2fsck problem?
Date: Thu, 22 Oct 2009 02:25:09 -0400
Message-ID: <25117.1256192709@gamaville.dokosmarshall.org>
Reply-To: nicholas.dokos@hp.com
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Cc: nicholas.dokos@hp.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from vms173019pub.verizon.net ([206.46.173.19]:63068 "EHLO
	vms173019pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751440AbZJVGZv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 22 Oct 2009 02:25:51 -0400
Received: from gamaville.dokosmarshall.org ([173.76.32.106])
 by vms173019.mailsrvcs.net
 (Sun Java(tm) System Messaging Server 6.3-7.04 (built Sep 26 2008; 32bit))
 with ESMTPA id <0KRW002LOKHTU5KF@vms173019.mailsrvcs.net> for
 linux-ext4@vger.kernel.org; Thu, 22 Oct 2009 01:25:06 -0500 (CDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--=-=-=

Running ffsb (the create workload - the description file is appended)
and then checking with fsck produces errors. This is on an 88TB fs (I
had some hardware (?) problems and had to use a slightly smaller set of
disks than the usual 96TB fs), consisting of 44 2TB LVM volumes (each of those
consisting of 7 300GB disks).

Doing a spot check with debugfs on the first error that e2fsck reports
however, shows that there is no problem there - I think.

I attach the e2fsck report, the spot-check I did with debugfs and the
ffsb workload description file.

This was run on an x86_64 system with 16 CPUs and 128GB of memory,
running a 2.6.32-rc5 kernel and the pu branch of e2fsprogs.

I'm checking things out but if you have any suggestions, please let me
know.

Thanks,
Nick


--=-=-=
Content-Disposition: attachment; filename=e2fsck.log
Content-Description: e2fsck output

Pass 1: Checking inodes, blocks, and sizes
Pass 1: Memory used: 272k/1372220k (67k/206k), time: 16.23/11.18/ 4.44
Pass 1: I/O read: 1MB, write: 0MB, rate: 0.06MB/s
Pass 2: Checking directory structure
First entry '' (inode=739442688) in directory inode 1374757121 (/data) should be '.'
Fix? no

Invalid inode number for '.' in directory inode 1374757121.
Fix? no

Directory entry for '.' in /data (1374757121) is big.
Split? no

Entry '' in /data (1374757121) references inode 739442688 in group 118805 where _INODE_UNINIT is set.
Fix? no

Entry '' in /data (1374757121) has deleted/unused inode 739442688.  Clear? no

Missing '.' in directory inode 4217481985.
Fix? no

Invalid inode number for '.' in directory inode 4217481985.
Fix? no

Directory entry for '.' in /meta (4217481985) is big.
Split? no

Pass 2: Memory used: 272k/18014398507852448k (66k/207k), time:  1.85/ 0.90/ 0.91
Pass 2: I/O read: 1MB, write: 0MB, rate: 0.54MB/s
Pass 3: Checking directory connectivity
Peak memory: Memory used: 272k/18014398508375496k (66k/207k), time: 27.06/19.05/ 7.36
'..' in /data (1374757121) is <The NULL inode> (0), should be / (2).
Fix? no

'..' in /meta (4217481985) is <The NULL inode> (0), should be / (2).
Fix? no

Pass 3: Memory used: 272k/18014398507852448k (66k/207k), time:  0.57/ 0.26/ 0.32
Pass 3: I/O read: 0MB, write: 0MB, rate: 0.00MB/s
Pass 4: Checking reference counts
Inode 2 ref count is 5, should be 3.  Fix? no

Inode 1374757121 ref count is 2, should be 1.  Fix? no

Unattached inode 1374757122
Connect to /lost+found? no

Unattached inode 1374757123
Connect to /lost+found? no

Unattached inode 1374757124
Connect to /lost+found? no

Unattached inode 1374757125
Connect to /lost+found? no

Unattached inode 1374757126
Connect to /lost+found? no

Unattached inode 1374757127
Connect to /lost+found? no

Unattached inode 1374757128
Connect to /lost+found? no

Unattached inode 1374757129
Connect to /lost+found? no

Unattached inode 1374757130
Connect to /lost+found? no

Unattached inode 1374757131
Connect to /lost+found? no

Unattached inode 1374757132
Connect to /lost+found? no

Unattached inode 1374757133
Connect to /lost+found? no

Unattached inode 1374757134
Connect to /lost+found? no

Unattached inode 1374757135
Connect to /lost+found? no

Unattached inode 1374757136
Connect to /lost+found? no

Unattached inode 1374757137
Connect to /lost+found? no

Unattached inode 1374757138
Connect to /lost+found? no

Unattached inode 1374757139
Connect to /lost+found? no

Unattached inode 1374757140
Connect to /lost+found? no

Unattached inode 1374757141
Connect to /lost+found? no

Unattached inode 1374757142
Connect to /lost+found? no

Unattached inode 1374757143
Connect to /lost+found? no

Unattached inode 1374757144
Connect to /lost+found? no

Unattached inode 1374757145
Connect to /lost+found? no

Unattached inode 1374757146
Connect to /lost+found? no

Unattached inode 1374757147
Connect to /lost+found? no

Unattached inode 1374757148
Connect to /lost+found? no

Unattached inode 1374757149
Connect to /lost+found? no

Unattached inode 1374757150
Connect to /lost+found? no

Unattached inode 1374757151
Connect to /lost+found? no

Unattached inode 1374757152
Connect to /lost+found? no

Unattached inode 1374757153
Connect to /lost+found? no

Unattached inode 1374757154
Connect to /lost+found? no

Unattached inode 1374757155
Connect to /lost+found? no

Unattached inode 1374757156
Connect to /lost+found? no

Unattached inode 1374757157
Connect to /lost+found? no

Unattached inode 1374757158
Connect to /lost+found? no

Unattached inode 1374757159
Connect to /lost+found? no

Unattached inode 1374757160
Connect to /lost+found? no

Unattached inode 1374757161
Connect to /lost+found? no

Unattached inode 1374757162
Connect to /lost+found? no

Unattached inode 1374757163
Connect to /lost+found? no

Unattached inode 1374757164
Connect to /lost+found? no

Unattached inode 1374757165
Connect to /lost+found? no

Unattached inode 1374757166
Connect to /lost+found? no

Unattached inode 1374757167
Connect to /lost+found? no

Unattached inode 1374757168
Connect to /lost+found? no

Unattached inode 1374757169
Connect to /lost+found? no

Unattached inode 1374757170
Connect to /lost+found? no

Unattached inode 1374757171
Connect to /lost+found? no

Unattached inode 1374757172
Connect to /lost+found? no

Unattached inode 1374757173
Connect to /lost+found? no

Unattached inode 1374757174
Connect to /lost+found? no

Unattached inode 1374757175
Connect to /lost+found? no

Unattached inode 1374757176
Connect to /lost+found? no

Unattached inode 1374757177
Connect to /lost+found? no

Unattached inode 1374757178
Connect to /lost+found? no

Unattached inode 1374757179
Connect to /lost+found? no

Unattached inode 1374757180
Connect to /lost+found? no

Unattached inode 1374757181
Connect to /lost+found? no

Unattached inode 1374757182
Connect to /lost+found? no

Unattached inode 1374757183
Connect to /lost+found? no

Unattached inode 1374757184
Connect to /lost+found? no

Unattached inode 1374757185
Connect to /lost+found? no

Unattached inode 1374757186
Connect to /lost+found? no

Unattached inode 1374757187
Connect to /lost+found? no

Unattached inode 1374757188
Connect to /lost+found? no

Unattached inode 1374757189
Connect to /lost+found? no

Unattached inode 1374757190
Connect to /lost+found? no

Unattached inode 1374757191
Connect to /lost+found? no

Unattached inode 1374757192
Connect to /lost+found? no

Unattached inode 1374757193
Connect to /lost+found? no

Unattached inode 1374757194
Connect to /lost+found? no

Unattached inode 1374757195
Connect to /lost+found? no

Unattached inode 1374757196
Connect to /lost+found? no

Unattached inode 1374757197
Connect to /lost+found? no

Unattached inode 1374757198
Connect to /lost+found? no

Unattached inode 1374757199
Connect to /lost+found? no

Unattached inode 1374757200
Connect to /lost+found? no

Unattached inode 1374757201
Connect to /lost+found? no

Unattached inode 1374757202
Connect to /lost+found? no

Unattached inode 1374757203
Connect to /lost+found? no

Unattached inode 1374757204
Connect to /lost+found? no

Unattached inode 1374757205
Connect to /lost+found? no

Unattached inode 1374757206
Connect to /lost+found? no

Unattached inode 1374757207
Connect to /lost+found? no

Unattached inode 1374757208
Connect to /lost+found? no

Unattached inode 1374757209
Connect to /lost+found? no

Unattached inode 1374757210
Connect to /lost+found? no

Unattached inode 1374757211
Connect to /lost+found? no

Unattached inode 1374757212
Connect to /lost+found? no

Unattached inode 1374757213
Connect to /lost+found? no

Unattached inode 1374757214
Connect to /lost+found? no

Unattached inode 1374757215
Connect to /lost+found? no

Unattached inode 1374757216
Connect to /lost+found? no

Unattached inode 1374757217
Connect to /lost+found? no

Unattached inode 1374757218
Connect to /lost+found? no

Unattached inode 1374757219
Connect to /lost+found? no

Unattached inode 1374757220
Connect to /lost+found? no

Unattached inode 1374757221
Connect to /lost+found? no

Unattached inode 1374757222
Connect to /lost+found? no

Unattached inode 1374757223
Connect to /lost+found? no

Unattached inode 1374757224
Connect to /lost+found? no

Unattached inode 1374757225
Connect to /lost+found? no

Unattached inode 1374757226
Connect to /lost+found? no

Unattached inode 1374757227
Connect to /lost+found? no

Unattached inode 1374757228
Connect to /lost+found? no

Unattached inode 1374757229
Connect to /lost+found? no

Unattached inode 1374757230
Connect to /lost+found? no

Unattached inode 1374757231
Connect to /lost+found? no

Unattached inode 1374757232
Connect to /lost+found? no

Unattached inode 1374757233
Connect to /lost+found? no

Unattached inode 1374757234
Connect to /lost+found? no

Unattached inode 1374757235
Connect to /lost+found? no

Unattached inode 1374757236
Connect to /lost+found? no

Unattached inode 1374757237
Connect to /lost+found? no

Unattached inode 1374757238
Connect to /lost+found? no

Unattached inode 1374757239
Connect to /lost+found? no

Unattached inode 1374757240
Connect to /lost+found? no

Unattached inode 1374757241
Connect to /lost+found? no

Unattached inode 1374757242
Connect to /lost+found? no

Unattached inode 1374757243
Connect to /lost+found? no

Unattached inode 1374757244
Connect to /lost+found? no

Unattached inode 1374757245
Connect to /lost+found? no

Unattached inode 1374757246
Connect to /lost+found? no

Unattached inode 1374757247
Connect to /lost+found? no

Unattached inode 1374757248
Connect to /lost+found? no

Unattached inode 1374757249
Connect to /lost+found? no

Unattached inode 1374757250
Connect to /lost+found? no

Unattached inode 1374757251
Connect to /lost+found? no

Inode 4217481985 ref count is 2, should be 1.  Fix? no

Pass 4: Memory used: 272k/18014398509138608k (66k/207k), time: 145.87/145.61/ 0.24
Pass 4: I/O read: 1MB, write: 0MB, rate: 0.01MB/s
Pass 5: Checking group summary information
Pass 5: Memory used: 272k/18014398508615560k (66k/207k), time: 238.95/54.46/ 2.69
Pass 5: I/O read: 173MB, write: 0MB, rate: 0.72MB/s

/dev/mapper/bigvg-bigvol: ********** WARNING: Filesystem still has errors **********


     143 inodes used (0.00%)
       0 non-contiguous files (0.0%)
       0 non-contiguous directories (0.0%)
         # of inodes with ind/dind/tind blocks: 0/0/0
         Extent depth histogram: 3/130
303588979 blocks used (1.35%)
       0 bad blocks
       0 large files

     130 regular files
       4 directories
       0 character device files
       0 block device files
       0 fifos
4294967292 links
       0 symbolic links (0 fast symbolic links)
       0 sockets
--------
       1 file
Memory used: 272k/18014398508615560k (66k/207k), time: 411.93/219.12/10.34
I/O read: 215MB, write: 0MB, rate: 0.52MB/s

Pass 1: Checking inodes, blocks, and sizes
Pass 1: Memory used: 272k/1372220k (67k/206k), time: 16.23/11.18/ 4.44
Pass 1: I/O read: 1MB, write: 0MB, rate: 0.06MB/s
Pass 2: Checking directory structure
First entry '' (inode=739442688) in directory inode 1374757121 (/data) should be '.'
Fix? no

Invalid inode number for '.' in directory inode 1374757121.
Fix? no

Directory entry for '.' in /data (1374757121) is big.
Split? no

Entry '' in /data (1374757121) references inode 739442688 in group 118805 where _INODE_UNINIT is set.
Fix? no

Entry '' in /data (1374757121) has deleted/unused inode 739442688.  Clear? no

Missing '.' in directory inode 4217481985.
Fix? no

Invalid inode number for '.' in directory inode 4217481985.
Fix? no

Directory entry for '.' in /meta (4217481985) is big.
Split? no

Pass 2: Memory used: 272k/18014398507852448k (66k/207k), time:  1.85/ 0.90/ 0.91
Pass 2: I/O read: 1MB, write: 0MB, rate: 0.54MB/s
Pass 3: Checking directory connectivity
Peak memory: Memory used: 272k/18014398508375496k (66k/207k), time: 27.06/19.05/ 7.36
'..' in /data (1374757121) is <The NULL inode> (0), should be / (2).
Fix? no

'..' in /meta (4217481985) is <The NULL inode> (0), should be / (2).
Fix? no

Pass 3: Memory used: 272k/18014398507852448k (66k/207k), time:  0.57/ 0.26/ 0.32
Pass 3: I/O read: 0MB, write: 0MB, rate: 0.00MB/s
Pass 4: Checking reference counts
Inode 2 ref count is 5, should be 3.  Fix? no

Inode 1374757121 ref count is 2, should be 1.  Fix? no

Unattached inode 1374757122
Connect to /lost+found? no

Unattached inode 1374757123
Connect to /lost+found? no

Unattached inode 1374757124
Connect to /lost+found? no

Unattached inode 1374757125
Connect to /lost+found? no

Unattached inode 1374757126
Connect to /lost+found? no

Unattached inode 1374757127
Connect to /lost+found? no

Unattached inode 1374757128
Connect to /lost+found? no

Unattached inode 1374757129
Connect to /lost+found? no

Unattached inode 1374757130
Connect to /lost+found? no

Unattached inode 1374757131
Connect to /lost+found? no

Unattached inode 1374757132
Connect to /lost+found? no

Unattached inode 1374757133
Connect to /lost+found? no

Unattached inode 1374757134
Connect to /lost+found? no

Unattached inode 1374757135
Connect to /lost+found? no

Unattached inode 1374757136
Connect to /lost+found? no

Unattached inode 1374757137
Connect to /lost+found? no

Unattached inode 1374757138
Connect to /lost+found? no

Unattached inode 1374757139
Connect to /lost+found? no

Unattached inode 1374757140
Connect to /lost+found? no

Unattached inode 1374757141
Connect to /lost+found? no

Unattached inode 1374757142
Connect to /lost+found? no

Unattached inode 1374757143
Connect to /lost+found? no

Unattached inode 1374757144
Connect to /lost+found? no

Unattached inode 1374757145
Connect to /lost+found? no

Unattached inode 1374757146
Connect to /lost+found? no

Unattached inode 1374757147
Connect to /lost+found? no

Unattached inode 1374757148
Connect to /lost+found? no

Unattached inode 1374757149
Connect to /lost+found? no

Unattached inode 1374757150
Connect to /lost+found? no

Unattached inode 1374757151
Connect to /lost+found? no

Unattached inode 1374757152
Connect to /lost+found? no

Unattached inode 1374757153
Connect to /lost+found? no

Unattached inode 1374757154
Connect to /lost+found? no

Unattached inode 1374757155
Connect to /lost+found? no

Unattached inode 1374757156
Connect to /lost+found? no

Unattached inode 1374757157
Connect to /lost+found? no

Unattached inode 1374757158
Connect to /lost+found? no

Unattached inode 1374757159
Connect to /lost+found? no

Unattached inode 1374757160
Connect to /lost+found? no

Unattached inode 1374757161
Connect to /lost+found? no

Unattached inode 1374757162
Connect to /lost+found? no

Unattached inode 1374757163
Connect to /lost+found? no

Unattached inode 1374757164
Connect to /lost+found? no

Unattached inode 1374757165
Connect to /lost+found? no

Unattached inode 1374757166
Connect to /lost+found? no

Unattached inode 1374757167
Connect to /lost+found? no

Unattached inode 1374757168
Connect to /lost+found? no

Unattached inode 1374757169
Connect to /lost+found? no

Unattached inode 1374757170
Connect to /lost+found? no

Unattached inode 1374757171
Connect to /lost+found? no

Unattached inode 1374757172
Connect to /lost+found? no

Unattached inode 1374757173
Connect to /lost+found? no

Unattached inode 1374757174
Connect to /lost+found? no

Unattached inode 1374757175
Connect to /lost+found? no

Unattached inode 1374757176
Connect to /lost+found? no

Unattached inode 1374757177
Connect to /lost+found? no

Unattached inode 1374757178
Connect to /lost+found? no

Unattached inode 1374757179
Connect to /lost+found? no

Unattached inode 1374757180
Connect to /lost+found? no

Unattached inode 1374757181
Connect to /lost+found? no

Unattached inode 1374757182
Connect to /lost+found? no

Unattached inode 1374757183
Connect to /lost+found? no

Unattached inode 1374757184
Connect to /lost+found? no

Unattached inode 1374757185
Connect to /lost+found? no

Unattached inode 1374757186
Connect to /lost+found? no

Unattached inode 1374757187
Connect to /lost+found? no

Unattached inode 1374757188
Connect to /lost+found? no

Unattached inode 1374757189
Connect to /lost+found? no

Unattached inode 1374757190
Connect to /lost+found? no

Unattached inode 1374757191
Connect to /lost+found? no

Unattached inode 1374757192
Connect to /lost+found? no

Unattached inode 1374757193
Connect to /lost+found? no

Unattached inode 1374757194
Connect to /lost+found? no

Unattached inode 1374757195
Connect to /lost+found? no

Unattached inode 1374757196
Connect to /lost+found? no

Unattached inode 1374757197
Connect to /lost+found? no

Unattached inode 1374757198
Connect to /lost+found? no

Unattached inode 1374757199
Connect to /lost+found? no

Unattached inode 1374757200
Connect to /lost+found? no

Unattached inode 1374757201
Connect to /lost+found? no

Unattached inode 1374757202
Connect to /lost+found? no

Unattached inode 1374757203
Connect to /lost+found? no

Unattached inode 1374757204
Connect to /lost+found? no

Unattached inode 1374757205
Connect to /lost+found? no

Unattached inode 1374757206
Connect to /lost+found? no

Unattached inode 1374757207
Connect to /lost+found? no

Unattached inode 1374757208
Connect to /lost+found? no

Unattached inode 1374757209
Connect to /lost+found? no

Unattached inode 1374757210
Connect to /lost+found? no

Unattached inode 1374757211
Connect to /lost+found? no

Unattached inode 1374757212
Connect to /lost+found? no

Unattached inode 1374757213
Connect to /lost+found? no

Unattached inode 1374757214
Connect to /lost+found? no

Unattached inode 1374757215
Connect to /lost+found? no

Unattached inode 1374757216
Connect to /lost+found? no

Unattached inode 1374757217
Connect to /lost+found? no

Unattached inode 1374757218
Connect to /lost+found? no

Unattached inode 1374757219
Connect to /lost+found? no

Unattached inode 1374757220
Connect to /lost+found? no

Unattached inode 1374757221
Connect to /lost+found? no

Unattached inode 1374757222
Connect to /lost+found? no

Unattached inode 1374757223
Connect to /lost+found? no

Unattached inode 1374757224
Connect to /lost+found? no

Unattached inode 1374757225
Connect to /lost+found? no

Unattached inode 1374757226
Connect to /lost+found? no

Unattached inode 1374757227
Connect to /lost+found? no

Unattached inode 1374757228
Connect to /lost+found? no

Unattached inode 1374757229
Connect to /lost+found? no

Unattached inode 1374757230
Connect to /lost+found? no

Unattached inode 1374757231
Connect to /lost+found? no

Unattached inode 1374757232
Connect to /lost+found? no

Unattached inode 1374757233
Connect to /lost+found? no

Unattached inode 1374757234
Connect to /lost+found? no

Unattached inode 1374757235
Connect to /lost+found? no

Unattached inode 1374757236
Connect to /lost+found? no

Unattached inode 1374757237
Connect to /lost+found? no

Unattached inode 1374757238
Connect to /lost+found? no

Unattached inode 1374757239
Connect to /lost+found? no

Unattached inode 1374757240
Connect to /lost+found? no

Unattached inode 1374757241
Connect to /lost+found? no

Unattached inode 1374757242
Connect to /lost+found? no

Unattached inode 1374757243
Connect to /lost+found? no

Unattached inode 1374757244
Connect to /lost+found? no

Unattached inode 1374757245
Connect to /lost+found? no

Unattached inode 1374757246
Connect to /lost+found? no

Unattached inode 1374757247
Connect to /lost+found? no

Unattached inode 1374757248
Connect to /lost+found? no

Unattached inode 1374757249
Connect to /lost+found? no

Unattached inode 1374757250
Connect to /lost+found? no

Unattached inode 1374757251
Connect to /lost+found? no

Inode 4217481985 ref count is 2, should be 1.  Fix? no

Pass 4: Memory used: 272k/18014398509138608k (66k/207k), time: 145.87/145.61/ 0.24
Pass 4: I/O read: 1MB, write: 0MB, rate: 0.01MB/s
Pass 5: Checking group summary information
Pass 5: Memory used: 272k/18014398508615560k (66k/207k), time: 238.95/54.46/ 2.69
Pass 5: I/O read: 173MB, write: 0MB, rate: 0.72MB/s

/dev/mapper/bigvg-bigvol: ********** WARNING: Filesystem still has errors **********


     143 inodes used (0.00%)
       0 non-contiguous files (0.0%)
       0 non-contiguous directories (0.0%)
         # of inodes with ind/dind/tind blocks: 0/0/0
         Extent depth histogram: 3/130
303588979 blocks used (1.35%)
       0 bad blocks
       0 large files

     130 regular files
       4 directories
       0 character device files
       0 block device files
       0 fifos
4294967292 links
       0 symbolic links (0 fast symbolic links)
       0 sockets
--------
       1 file
Memory used: 272k/18014398508615560k (66k/207k), time: 411.93/219.12/10.34
I/O read: 215MB, write: 0MB, rate: 0.52MB/s


--=-=-=
Content-Disposition: attachment; filename=debugfs.log
Content-Description: debugfs log

# debugfs -c /dev/mapper/bigvg-bigvol 
debugfs 1.41.9 (22-Aug-2009)
/dev/mapper/bigvg-bigvol: catastrophic mode - not reading inode or group bitmaps
debugfs:  stat <1374757121>
Inode: 1374757121   Type: directory    Mode:  0700   Flags: 0x80000
Generation: 3074310533    Version: 0x00000000:00000083
User:     0   Group:     0   Size: 4096
File ACL: 0    Directory ACL: 0
Links: 2   Blockcount: 8
Fragment:  Address: 0    Number: 0    Size: 0
 ctime: 0x4adfdda6:9fdcba8c -- Thu Oct 22 00:20:54 2009
 atime: 0x4adfdc7a:66134bb4 -- Thu Oct 22 00:15:54 2009
 mtime: 0x4adfdda6:9fdcba8c -- Thu Oct 22 00:20:54 2009
crtime: 0x4adfdc7a:66134bb4 -- Thu Oct 22 00:15:54 2009
Size of extra inode fields: 28
EXTENTS:
(0): 7237802096
debugfs:  ls <1374757121>
 1374757121  (12) .    2  (12) ..    1374757122  (20) datafile0   
 1374757123  (20) datafile1    1374757124  (20) datafile2   
 1374757125  (20) datafile3    1374757126  (20) datafile4   
 1374757127  (20) datafile5    1374757128  (20) datafile6   
 ...

--=-=-=
Content-Disposition: attachment; filename=create.ffsb
Content-Description: FFSB workload description file

# Large file creates
# Creating 1 GB files.

time=300
alignio=1

[filesystem0]
	location=/ffsb/disk1

	# All created files will be 1 GB.
	min_filesize=1073741824 
	max_filesize=1073741824
[end0]

[threadgroup0]
	num_threads=1

	create_weight=1

	write_blocksize=4096  # 4 kB

	[stats]
		enable_stats=1
		enable_range=1

		msec_range    0.00      0.01
		msec_range    0.01      0.02
		msec_range    0.02      0.05
		msec_range    0.05      0.10
		msec_range    0.10      0.20
		msec_range    0.20      0.50
		msec_range    0.50      1.00
		msec_range    1.00      2.00
		msec_range    2.00      5.00
		msec_range    5.00     10.00
		msec_range   10.00     20.00
		msec_range   20.00     50.00
		msec_range   50.00    100.00
		msec_range  100.00    200.00
		msec_range  200.00    500.00
		msec_range  500.00   1000.00
		msec_range 1000.00   2000.00
		msec_range 2000.00   5000.00
		msec_range 5000.00  10000.00
	[end]
[end0]

--=-=-=--
