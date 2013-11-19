From: "Stephen Elliott" <techweb@ntlworld.com>
Subject: RE: Query FSCK Errors on ext4
Date: Tue, 19 Nov 2013 20:48:59 -0000
Message-ID: <002a01cee568$c588cf00$509a6d00$@ntlworld.com>
References: <008701cecc19$14734370$3d59ca50$@ntlworld.com> <F81EF3B4-CEBF-43FD-BD38-0AFFF56014C6@dilger.ca> <20131028063905.GA9017@gmail.com> <000e01ced3bc$2af03220$80d09660$@ntlworld.com> <13AE0AAC-F9F6-404F-B55E-F38C2015864B@dilger.ca> <001f01cee525$0be60e20$23b22a60$@ntlworld.com> <AB177EF8-199A-4A6D-A08F-2A6951F5F100@dilger.ca> <002901cee54d$b7d2efa0$2778cee0$@ntlworld.com> <93E08C0E-E398-4C7C-B7E7-C0591F6AA722@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: "'Zheng Liu'" <gnehzuil.liu@gmail.com>,
	"'David Jeffery'" <djeffery@redhat.com>,
	<linux-ext4@vger.kernel.org>,
	"'Bernd Schubert'" <bernd.schubert@itwm.fraunhofer.de>,
	"'Eric Whitney'" <enwlinux@gmail.com>
To: "'Andreas Dilger'" <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from know-smtprelay-omc-11.server.virginmedia.net ([80.0.253.75]:42029
	"EHLO know-smtprelay-omc-11.server.virginmedia.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752780Ab3KSUtE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 19 Nov 2013 15:49:04 -0500
In-Reply-To: <93E08C0E-E398-4C7C-B7E7-C0591F6AA722@dilger.ca>
Content-Language: en-gb
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Question is finding / decoding it...

If it were a test / lab system I could run whatever you want me to in order
to find root cause. Problem is that it's a customer server (ReadyNAS Pro 6)
running a large DB in excess of 800 Mb with multiple users accessing over
SMB. I  empirically discovered that closing the client connections to the MS
Access DB stops the file system corruption which happens on every reboot
otherwise. 

If you guys have the bandwidth and inclination to check this on a system
then I guess initial repro may be simple if it doesn't show up then it may
be something more specific.

(Linux despair 2.6.37.6.RNx86_64.2.4 #1 SMP Thu Jul 26 05:00:36 PDT 2012
x86_64 GNU/Linux)

It's hardly the end of the world for me / my customer, I just advise they
close connections prior to rebooting the server. 

-----Original Message-----
From: Andreas Dilger [mailto:adilger@dilger.ca] 
Sent: 19 November 2013 20:28
To: Stephen Elliott
Cc: Zheng Liu; David Jeffery; <linux-ext4@vger.kernel.org>; Bernd Schubert;
Eric Whitney
Subject: Re: Query FSCK Errors on ext4

It definitely shouldn't be possible for any application to corrupt the
filesystem, so regardless of what is being run this is a kernel bug. 

Cheers, Andreas

On 2013-11-19, at 10:35, "Stephen Elliott" <techweb@ntlworld.com> wrote:

> Hi Andreas,
> 
> I have read the replies given, I am just questioning some of the 
> analysis and have follow up questions.
> 
> You will notice that I previously mentioned in this mail thread that I 
> had this issue prior to running e2fsck 1.42.8 on e2fsck 1.42.3 too so 
> not entirely convinced that the aforementioned patch is applicable.
> 
> My main question is around why this issue seems to occur when the MS 
> access DB being  open (over Samba) on client workstations when the 
> server is reloaded. I would possibly expect DB corruption due to this 
> but not FS corruption.
> 
> Many Thanks
> Stephen Elliott
> 
> -----Original Message-----
> From: Andreas Dilger [mailto:adilger@dilger.ca]
> Sent: 19 November 2013 16:47
> To: Stephen Elliott
> Cc: Zheng Liu; David Jeffery; <linux-ext4@vger.kernel.org>; Bernd 
> Schubert; Eric Whitney
> Subject: Re: Query FSCK Errors on ext4
> 
> As previously written in earlier comments, the bug is likely in the 
> ext4 code of your appliance, and could possibly be fixed by the patch 
> that was pointed our at that time.
> 
> If you ask for help, you actually need to read the replies that are given.

> 
> Cheers, Andreas
> 
> On 2013-11-19, at 5:44, "Stephen Elliott" <techweb@ntlworld.com> wrote:
> 
>> Hi Guys,
>> 
>> Did you have any further feedback on this? It is purely curiosity for me:
>> 
>> I have theorised that the problem comes from the MS access DB being 
>> open (over Samba) on client workstations when the server is reloaded.
>> 
>> Since ensuring these are closed prior to reloading, I have not seen 
>> further FSCK errors on reload. Is there an explanation for this? I 
>> can see why this may corrupt DB but not the filesystem.
>> 
>> Many Thanks
>> Stephen Elliott
>> 
>> -----Original Message-----
>> From: Stephen Elliott [mailto:techweb@ntlworld.com]
>> Sent: 28 October 2013 21:18
>> To: 'Andreas Dilger'
>> Cc: 'Zheng Liu'; 'David Jeffery'; 'linux-ext4@vger.kernel.org List'; 
>> 'Bernd Schubert'; 'Eric Whitney'
>> Subject: RE: Query FSCK Errors on ext4
>> 
>> Ultimately I am not too worried about this problem (now I know the
>> cause) but I am intrigued to know what actually caused the issue in 
>> the first place. As you can see there is some history around the problem.
>> 
>> Also was that defect / bug actually confirmed?
>> 
>> -----Original Message-----
>> From: Andreas Dilger [mailto:adilger@dilger.ca]
>> Sent: 28 October 2013 20:54
>> To: Stephen Elliott
>> Cc: Zheng Liu; David Jeffery; linux-ext4@vger.kernel.org List; Bernd 
>> Schubert; Eric Whitney
>> Subject: Re: Query FSCK Errors on ext4
>> 
>> On Oct 28, 2013, at 3:00 AM, Stephen Elliott <techweb@ntlworld.com>
wrote:
>>> Thanks for the reply guys...
>>> 
>>> The device in question is a ReadyNAS Pro 6, which happens to be 
>>> running
>> Linux :) I actually saw some issues with e2fsck 1.42.3 earlier this year:
>> 
>> So it looks like your next course of action is to contact ReadyNAS to 
>> see if they have the patch that Zheng mentioned below in their kernel.
>> 
>> Cheers, Andreas
>> 
>>> ***** File system check forced at Fri Apr 26 20:08:38 WEST 2013 
>>> ***** fsck 1.41.14 (22-Dec-2010) e2fsck 1.42.3 (14-May-2012) Pass 1:
>>> Checking inodes, blocks, and sizes Inode 4195619, i_blocks is 
>>> 3135728, should be 3135904. Fix? yes
>>> 
>>> Running additional passes to resolve blocks claimed by more than one
>> inode...
>>> Pass 1B: Rescanning for multiply-claimed blocks Multiply-claimed
>>> block(s) in inode 4195619: 167904376 167904377 167904378 167904379
>>> 167904380 167904381 167904382 167904383 167904384 167904385 
>>> 167904386
>>> 167949296 167949297 167949298 167949299 167949300 167949301 
>>> 167949302
>>> 167949303 167949304 167949305 167949306 Pass 1C: Scanning 
>>> directories for inodes with multiply-claimed blocks Pass 1D: 
>>> Reconciling multiply-claimed blocks (There are 1 inodes containing 
>>> multiply-claimed blocks.)
>>> 
>>> File /PREMIER/Premier Automation Purchase OrdersApp V18.5.mdb (inode 
>>> #4195619, mod time Fri Apr 26 20:07:42 2013) has 22 multiply-claimed
>> block(s), shared with 0 file(s):
>>> Multiply-claimed blocks already reassigned or cloned.
>>> 
>>> Pass 2: Checking directory structure Pass 3: Checking directory 
>>> connectivity Pass 4: Checking reference counts Pass 5: Checking 
>>> group summary information
>>> 
>>> /dev/c/c: ***** FILE SYSTEM WAS MODIFIED *****
>>> /dev/c/c: 615898/30212096 files (13.6% non-contiguous),
>>> 62353456/483393536 blocks
>>> 
>>> After deleting the file (MS Access DB, and re-creating from backup, 
>>> the file system got mounted read only and the following errors were 
>>> logged:]
>>> 
>>> May 8 14:58:15 despair kernel: EXT4-fs error (device dm-0: 
>>> mb_free_blocks:1411: group 5124block 167904376:freeing already freed 
>>> block
>> (bit 1144 May 8 14:58:15 despair kernel: Aborting journal on device
> dm-0-8.
>>> May 8 14:58:15 despair kernel: EXT4-fs (dm-0: Remounting filesystem 
>>> read-only May 8 14:58:15 despair kernel: EXT4-fs error (device dm-0:
>>> mb_free_blocks:1411: group 5124block 167904377:freeing already freed 
>>> block (bit 1145 May 8 14:58:15 despair kernel: EXT4-fs error (device
>>> dm-0: mb_free_blocks:1411: group 5124block 167904378:freeing already 
>>> freed block (bit 1146 May 8 14:58:15 despair kernel: EXT4-fs error 
>>> (device dm-0: mb_free_blocks:1411: group 5124block 167904379:freeing 
>>> already freed block (bit 1147 May 8 14:58:15 despair kernel: EXT4-fs 
>>> error (device dm-0: mb_free_blocks:1411: group 5124block 
>>> 167904380:freeing already freed block (bit 1148 May 8 14:58:15 
>>> despair
>>> kernel: EXT4-fs error (device dm-0: mb_free_blocks:1411: group 
>>> 5124block 167904381:freeing already freed block (bit 1149 May 8
>>> 14:58:15 despair kernel: EXT4-fs error (device dm-0: 
>>> mb_free_blocks:1411: group 5124block 167904382:freeing already freed 
>>> block (bit 1150 May 8 14:58:16 despair kernel: EXT4-fs error (device
>>> dm-0: mb_free_blocks:1411: group 5124block 167904383:freeing already 
>>> freed block (bit 1151 May 8 14:58:16 despair kernel: EXT4-fs error 
>>> (device dm-0: mb_free_blocks:1411: group 5124block 167904384:freeing 
>>> already freed block (bit 1152 May 8 14:58:16 despair kernel: EXT4-fs 
>>> error (device dm-0: mb_free_blocks:1411: group 5124block 
>>> 167904385:freeing already freed block (bit 1153 May 8 14:58:16 
>>> despair
>>> kernel: EXT4-fs error (device dm-0: mb_free_blocks:1411: group 
>>> 5124block 167904386:freeing already freed block (bit 1154 May 8
>>> 14:58:16 despair kernel: EXT4-fs error (device dm-0: 
>>> mb_free_blocks:1411: group 5125block 167949296:freeing already freed 
>>> block (bit 13296 May 8 14:58:16 despair kernel: EXT4-fs error 
>>> (device
>>> dm-0: mb_free_blocks:1411: group 5125block 167949297:freeing already 
>>> freed block (bit 13297 May 8 14:58:16 despair kernel: EXT4-fs error 
>>> (device dm-0: mb_free_blocks:1411: group 5125block 167949298:freeing 
>>> already freed block (bit 13298 May 8 14:58:16 despair kernel: 
>>> EXT4-fs error (device dm-0: mb_free_blocks:1411: group 5125block 
>>> 167949299:freeing already freed block (bit 13299 May 8 14:58:17 
>>> despair kernel: EXT4-fs error (device dm-0: mb_free_blocks:1411:
>>> group 5125block 167949300:freeing already freed block (bit 13300 May
>>> 8
>>> 14:58:17 despair kernel: EXT4-fs error (device dm-0: 
>>> mb_free_blocks:1411: group 5125block 167949301:freeing already freed 
>>> block (bit 13301 May 8 14:58:17 despair kernel: EXT4-fs error 
>>> (device
>>> dm-0: mb_free_blocks:1411: group 5125block 167949302:freeing already 
>>> freed block (bit 13302 May 8 14:58:17 despair kernel: EXT4-fs error 
>>> (device dm-0: mb_free_blocks:1411: group 5125block 167949303:freeing 
>>> already freed block (bit 13303 May 8 14:58:17 despair kernel: 
>>> EXT4-fs error (device dm-0: mb_free_blocks:1411: group 5125block 
>>> 167949304:freeing already freed block (bit 13304 May 8 14:58:17 
>>> despair kernel: EXT4-fs error (device dm-0: mb_free_blocks:1411:
>>> group 5125block 167949305:freeing already freed block (bit 13305 May
>>> 8
>>> 14:58:17 despair kernel: EXT4-fs error (device dm-0: 
>>> mb_free_blocks:1411: group 5125block 167949306:freeing already freed 
>>> block (bit 13306
>>> 
>>> 
>>> These are the same blocks slated as multiply claimed
>>> 
>>> And then running an FSCK, we got the following:
>>> 
>>> ***** File system check forced at Wed May 8 15:16:50 WEST 2013 ***** 
>>> fsck 1.41.14 (22-Dec-2010 e2fsck 1.42.3 (14-May-2012
>>> /dev/c/c: recovering journal
>>> Pass 1: Checking inodes, blocks, and sizes Pass 2: Checking 
>>> directory
>> structure Pass 3: Checking directory connectivity Pass 4: Checking 
>> reference counts Pass 5: Checking group summary information Free 
>> blocks count wrong for group #5124 (28170, counted=28159.
>>> Fix? yes
>>> 
>>> Free blocks count wrong for group #5125 (25861, counted=25850.
>>> Fix? yes
>>> 
>>> Free blocks count wrong (420683133, counted=420644972.
>>> Fix? yes
>>> 
>>> Free inodes count wrong (29595347, counted=29595271.
>>> Fix? yes
>>> 
>>> 
>>> /dev/c/c: ***** FILE SYSTEM WAS MODIFIED *****
>>> /dev/c/c: 616825/30212096 files (13.6% non-contiguous,
>>> 62748564/483393536 blocks
>>> 
>>> Then later in the year I reloaded the server with the database open 
>>> from several client machines
>>> 
>>> ***** File system check forced at Tue Jul 23 21:02:13 WEST 2013 
>>> ***** fsck
>> 1.42.8 (20-Jun-2013) e2fsck 1.42.8 (20-Jun-2013) Pass 1: Checking 
>> inodes, blocks, and sizes Inode 4195619, end of extent exceeds 
>> allowed value
>>>              (logical block 64907, physical block 11435403, len 16) 
>>> Clear? yes
>>> 
>>> Inode 4195619, i_blocks is 1337216, should be 1337176.  Fix? yes
>>> 
>>> Pass 2: Checking directory structure Pass 3: Checking directory 
>>> connectivity Pass 4: Checking reference counts Pass 5: Checking 
>>> group summary information Block bitmap
>>> differences:  -(11435403--11435407) Fix? yes
>>> 
>>> Free blocks count wrong for group #348 (2130, counted=2135).
>>> Fix? yes
>>> 
>>> Free blocks count wrong (417470107, counted=417470112).
>>> Fix? yes
>>> 
>>> 
>>> /dev/c/c: ***** FILE SYSTEM WAS MODIFIED *****
>>> /dev/c/c: 625785/30212096 files (13.6% non-contiguous),
>>> 65923424/483393536 blocks
>>> 
>>> Again related to the same file, which is only an MS Access DB open 
>>> from
>> several client machines over SMB when the server is rebooted. Moving 
>> forward I ensure all instances are closed when reloading but even so 
>> I am surprised that a clean reload causes corruption at the 
>> filesystem
> level.
>>> 
>>> Since ensuring the DB is closed before reload, I have seen no 
>>> further
>> issues like this.
>>> 
>>> Many Thanks
>>> Stephen Elliott
>>> 
>>> -----Original Message-----
>>> From: Zheng Liu [mailto:gnehzuil.liu@gmail.com]
>>> Sent: 28 October 2013 06:39
>>> To: Andreas Dilger
>>> Cc: Stephen Elliott; David Jeffery; linux-ext4@vger.kernel.org List; 
>>> Bernd Schubert; Eric Whitney
>>> Subject: Re: Query FSCK Errors on ext4
>>> 
>>> [Cc Eric Whitney to confirm this problem]
>>> 
>>> Hi Andreas,
>>> 
>>> If I remember correctly, this patch might can fix this problem [1].
>>> 
>>> 1. http://www.spinics.net/lists/linux-ext4/msg39485.html
>>> 
>>> Regards,
>>>                                              - Zheng
>>> 
>>> On Mon, Oct 28, 2013 at 12:13:26AM -0600, Andreas Dilger wrote:
>>>> The error reported here is a relatively new one.  It only appeared 
>>>> in e2fsck 1.42.8, and wasn t in the code that I m using locally
>>>> (1.42.7) so I wasn t sure what it actually meant without looking at it.
>>>> 
>>>> It looks like some kind of overflow of the extent tree, which 
>>>> causes e2fsck to chop off the last 5 disk blocks (40 sectors), 
>>>> though I m not sure exactly why.  From your comments, this can be 
>>>> reproduced with your database usage?  Does it use fallocate() or 
>>>> any other strange IO operations that might be causing this?
>>>> 
>>>> Have you tried updating your kernel?  If there is repeated 
>>>> corruption appearing in the filesystem, then it is either a bug in 
>>>> the kernel or in e2fsck.  Not really sure which one to blame at 
>>>> this
> point.
>>>> 
>>>> Cheers, Andreas
>>>> 
>>>> On Oct 18, 2013, at 9:45 AM, Stephen Elliott <techweb@ntlworld.com>
>> wrote:
>>>> 
>>>>> Any feedback on this guys??? Would really appreciate somebody 
>>>>> taking a
>> look over this.
>>>>> 
>>>>> From: Stephen Elliott [mailto:techweb@ntlworld.com]
>>>>> Sent: 22 September 2013 20:13
>>>>> To: linux-ext4@vger.kernel.org; linux-fsdevel@vger.kernel.org; 
>>>>> Andreas
>> Dilger (adilger@dilger.ca); 'Bernd Schubert'
>>>>> Subject: Query FSCK Errors on ext4
>>>>> 
>>>>> Hi all,
>>>>> 
>>>>> I have theorised that the problem comes from the MS access DB 
>>>>> being open
>> (over Samba) on client workstations when the server is reloaded.
>>>>> 
>>>>> Since ensuring these are closed prior to reloading, I have not 
>>>>> seen
>> further FSCK errors on reload. Is there an explanation for this? I 
>> can see why this may corrupt DB but not the filesystem.
>>>>> 
>>>>> Just as a primer, I used a ReadyNAS NV+ for many years which was 
>>>>> running
>> ext3 and never had this issue. However, since using ext4 on a 
>> ReadyNAS Pro, I now see this issue.
>>>>> 
>>>>> Many Thanks
>>>>> Stephen Elliott
>>>>> 
>>>>> From: Stephen Elliott [mailto:techweb@ntlworld.com]
>>>>> Sent: 23 July 2013 22:02
>>>>> To: linux-ext4@vger.kernel.org; linux-fsdevel@vger.kernel.org; 
>>>>> Andreas
>> Dilger (adilger@dilger.ca); 'Bernd Schubert'
>>>>> Subject: RE: FSCK Errors on ext4
>>>>> 
>>>>> If it helps guys, the same file as before is causing the issue 
>>>>> with
>> inode 4195610, a very large MS access DB.
>>>>> 
>>>>> From: Stephen Elliott [mailto:techweb@ntlworld.com]
>>>>> Sent: 23 July 2013 21:52
>>>>> To: linux-ext4@vger.kernel.org; linux-fsdevel@vger.kernel.org; 
>>>>> Andreas
>> Dilger (adilger@dilger.ca); 'Bernd Schubert'
>>>>> Subject: FSCK Errors on ext4
>>>>> 
>>>>> Hi Andreas / Bernd / all,
>>>>> 
>>>>> You may recall advising me on another batch of FSCK errors a few 
>>>>> months
>> back.
>>>>> 
>>>>> The same device on an ext4 file system has produced the following 
>>>>> errors
>> after a clean reload. It seems to be fine now but wanted your input 
>> on
> this.
>> No bad blocks are reported on the devices etc.
>>>>> 
>>>>> ***** File system check forced at Tue Jul 23 21:02:13 WEST 2013
>>>>> *****
>> fsck 1.42.8 (20-Jun-2013) e2fsck 1.42.8 (20-Jun-2013) Pass 1: 
>> Checking inodes, blocks, and sizes Inode 4195619, end of extent 
>> exceeds allowed value
>>>>>              (logical block 64907, physical block 11435403, len
>>>>> 16) Clear? yes
>>>>> 
>>>>> Inode 4195619, i_blocks is 1337216, should be 1337176.  Fix? yes
>>>>> 
>>>>> Pass 2: Checking directory structure Pass 3: Checking directory 
>>>>> connectivity Pass 4: Checking reference counts Pass 5: Checking 
>>>>> group summary information Block bitmap differences:
>>>>> -(11435403--11435407) Fix? yes
>>>>> 
>>>>> Free blocks count wrong for group #348 (2130, counted=2135).
>>>>> Fix? yes
>>>>> 
>>>>> Free blocks count wrong (417470107, counted=417470112).
>>>>> Fix? yes
>>>>> 
>>>>> 
>>>>> /dev/c/c: ***** FILE SYSTEM WAS MODIFIED *****
>>>>> /dev/c/c: 625785/30212096 files (13.6% non-contiguous),
>>>>> 65923424/483393536 blocks
>>>>> 
>>>>> Many Thanks
>>>>> Stephen Elliott
>>>> 
>>>> 
>>>> Cheers, Andreas
>>>> 
>>>> 
>>>> 
>>>> 
>>>> 
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-ext4" 
>>>> in the body of a message to majordomo@vger.kernel.org More 
>>>> majordomo info at  http://vger.kernel.org/majordomo-info.html
>> 
>> 
>> Cheers, Andreas
> 
> 


