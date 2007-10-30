From: Coly Li <coyli@suse.de>
Subject: Re: [PATCH] e2fsprogs: directory inode reservation (V1) to mke2fs
Date: Tue, 30 Oct 2007 19:45:47 +0800
Message-ID: <4727196B.50201@suse.de>
References: <4726126A.3060303@suse.de> <20071029224407.GI21133@thunk.org>
Reply-To: coyli@suse.de
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:41741 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751958AbXJ3Low (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 30 Oct 2007 07:44:52 -0400
In-Reply-To: <20071029224407.GI21133@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Theodore Tso wrote:
> On Tue, Oct 30, 2007 at 01:03:38AM +0800, Coly Li wrote:
>> This patch adds directory inode reservation supporting to mke2fs. Ask for review.
> 
> So I had completely erased this from my memory, and had to do some
> google searching and some mail archive searching before I found this:
> 
> http://lkml.org/lkml/2007/3/26/180
> 
> ... and some initial kernel patches which no one ever really looked at
> because your mailer had converted all tab characters into a single
> space, making the patch compltely unreadable and unusuable to use as a
> patch.

Yes, the first patch was only for feasibility research, it was buggy and unstable. The reason I
released that patch was making others to know I working on it. Also thank to my previous email
client, all the format of patch messed up. The result was as I suggested in the first patch -- no
one wasted time on the review :-)

> 
>>  /*
>> + * Macro-instructions used to reserve inodes for directories
>> + */
>> +#define EXT4_DIR_IRESERVE_LOW		16
>> +#define EXT4_DIR_IRESERVE_NORMAL	64
>> +#define EXT4_DIR_IRESERVE_HIGH		128
> 
> Macro-instructions?  These are constants.  And exactly what do they
> signify, anyway.  I'll note that this patch only uses
> EEXT4_DIR_IRESERVE_NORMAL, and not IRESERVE_LOW or IRESERVE_HIGH.
> 

Yes, only EXT4_DIR_IRESERVE_NORMAL is used in e2fsprogs. Other two Macro are used in kerenl, not in
e2fsprogs. I putted them all in ext2_fs.h because I want everything synchronized.
I believe EXT4_DIR_IRESERVE_LOW and EXT4_DIR_IRESERVE_HIGH will not be used in future (other wise
on-disk format will be modified), therefore if in your opinion it is not a good idea to put all
three Macros in ext2_fs.h, I will remove useless ones :-)

>> +/*
>>   * ACL structures
>>   */
>>  struct ext2_acl_header	/* Header of Access Control Lists */
>> @@ -167,7 +174,7 @@ struct ext4_group_desc
>>  	__u16	bg_free_blocks_count_hi;/* Free blocks count MSB */
>>  	__u16	bg_free_inodes_count_hi;/* Free inodes count MSB */
>>  	__u16	bg_used_dirs_count_hi;	/* Directories count MSB */
>> -	__u16   bg_pad;
>> +	__u16	bg_itable_unused_hi;	/* Unused inodes count MSB */
>>  	__u32	bg_reserved2[3];
>>  };
> 
> This patch hunk has nothing to do with your patch.... 
> 
> Note that for 4k block filesystems, the maximum number of inodes we
> can have is 32768, so it would be highly unsusual and unreasonable for
> us to need more than 64k inodes per block group.  It only might make
> come up in real life for filesystems that are using, say, 64k block
> filesystems, and which needed a huge number of inodes.

Sure, I agree with you. The reason for adding bg_itable_unused_hi is my dir inode reservation patch
will work better on large inode tables (which is not implemented currently). I believe the size of
inodes bitmap will also increase as block bitmap soon, therefore exceeding 64K inodes limitation is
possible in future.
Do you think it's too early to add this ?

> 
> If we are triggering this, then mayne we should fix the ununitialized
> block group patches so that instead of enumerating the number of
> inodes, that it is denotes the number of unused inode table *blocks*.
> After all, if we are going to be initializing a new inode table block,
> it only makes sense to initialize all of the inodes in that block at
> once.
> 
>> @@ -100,7 +101,8 @@ static void usage(void)
>>  	"\t[-N number-of-inodes] [-m reserved-blocks-percentage] "
>>  	"[-o creator-os]\n\t[-g blocks-per-group] [-L volume-label] "
>>  	"[-M last-mounted-directory]\n\t[-O feature[,...]] "
>> -	"[-r fs-revision] [-R options] [-qvSV]\n\tdevice [blocks-count]\n"),
>> +	"[-r fs-revision] [-E extended-option[,...]] [-qvSV]\n"
>> +	"\tdevice [blocks-count]\n"),
>>  		program_name);
>>  	exit(1);
>>  }
> 
> This patch has nothing to do with your patch, and in fact is already
> in e2fsprogs.  How are you generating your patch?
> 
Oops, it seems I lost myself in the git versions again :-(  I will submit new patchs on proper
version very soon.
> 
>> @@ -575,6 +577,16 @@ static void reserve_inodes(ext2_filsys fs)
>>  	ext2fs_mark_ib_dirty(fs);
>>  }
>>
>> +static void setup_itable_unused(ext2_filsys fs)
>> +{
>> +	dgrp_t	i;
>> +	int inodes_pgroup = fs->super->s_inodes_per_group;
>> +	fs->group_desc[0].bg_itable_unused =
>> +		inodes_pgroup - EXT4_DIR_IRESERVE_NORMAL;
>> +	for (i = 1; i < fs->group_desc_count; i++)
>> +		fs->group_desc[i].bg_itable_unused = inodes_pgroup;
>> +}
>> +
>>  #define BSD_DISKMAGIC   (0x82564557UL)  /* The disk magic number */
>>  #define BSD_MAGICDISK   (0x57455682UL)  /* The disk magic number reversed */
>>  #define BSD_LABEL_OFFSET        64
> 
> Ok, so this is bad in many, many ways.  First of all, this shouldn't
> be in mke2fs.c, but in lib/ext2fs/initialize.c
> 
Thanks for point out this :-) I also thought it's bad, once you tell me how to improve, I will fix
it :-)

> Secondly, we really need to talk about the on-disk format.  This needs
> to be integrated with the uninit blockgroup patch, and even there,
> there needs to be some filesytem feature flag marker so we know we're
I want to avoid any on-disk format modification. Therefore dir inode reservation is a try-best
feature and enabled by mount option dir_ireserve=low|normal|high. ext4 can work well if next mount
disables dir_ireserve or use differnet inode reservation count. The only requirement for e2fsprogs
is initiating bg_itable_unused to zero during mke2fs, because my patch needs to know which inode can
be allocated to new directory fore inode reservation by help of bg_itable_unused.

> doing this wierd thing.  Why it makes sense to set the bg_table_unused
> field to the number of block groups minus 64 makes no sense to me (you
For the first group, because there are several inodes allocated for root directory, bad block file,
journal file, lost+found.... Therefore, if group 0 is selected to allocate inode for new creating
directory, the inode will allocate from 64th inode other than the one after lost+found. By this
method, if some files are putted into lost+found, inodes will not run into reserved inodes for that
new directory.
Anyway, I can remove "set the bg_table_unused field to the number of block groups minus 64" from
mke2fs and also make kernel do right things, but initiating bg_itable_unused is required for my patch.
Because my git version is commit eac91b35372c9affff6953165f34fe246272bef9. After I made some
modification to resolve pull conflict, I can not pull newer version any more. Maybe there is new
code to initiate bg_itable_unused, but in my local version, bg_itable_unused is not initiate. That
is why I add the initiation code in mke2fs.
I will re-clone the git tree again, and update the patch soon.

> need to explain the on-disk format very clearly, and the only
> explanation I've seen back in March never talked about using
> bg_itable_unused).  
Yes, because at that time, I used a magic inode per group to work as same effect as
bg_itable_unused, which was really an ugly idea :-)

> 
> More importantly, it's doing this unconditionally without any feature
> flag indicating whether or not the uninit blockgroup feature is even
> enabled, and if it is enabled, that EXT4_DIR_IRESERVE_NORMAL blocks
> have been initialized.  What the heck is going on here?
I suggest making bg_itable_group initiation independent from uninit block group feature.
I am not sure whether I understand you well, dir inode reservation only work on inode table, dose
not effect anything in data blocks. dir inode reservation patch in kernel suggests ext4 to allocate
file inodes from the reserved area in inode table, and to allocate directory inode by skipping the
previous reserved area in same inode table. The reservation of inodes for directory is only for
suggestion, which means the reserved inodes will not be marked in inode bitmap and ext4 only TRY
BEST to allocate file inodes from reserved itable area of parent directory. If inode can not be
allocate by this method, ext4 can continue to use traditional method to allocate inodes. If other
one uses inodes from the reserved area, it also dose not matter.

I will write a detailed document to explain the idea of dir inode reservation very soon.
> 
>> @@ -761,7 +773,7 @@ static void parse_extended_opts(struct ext2_super_block *param,
>>  	int	r_usage = 0;
>>
>>  	len = strlen(opts);
>> -	buf = malloc(len+1);
>> +	buf = (char *)malloc(len+1);
>>  	if (!buf) {
>>  		fprintf(stderr,
>>  			_("Couldn't allocate memory to parse options!\n"));
> 
> Unnecessary cast.  Why did you add it?
This is a paranoid habit of mine, because buf is (char*), and malloc return (void*). Maybe I should
remove it from this patch and submit another one for it :-)
> 
> 						- Ted

Really thank you for these helpful suggestions. I will update the patch and provide corresponded
document very soon :-)

Best regards.

-- 
Coly Li
SuSE PRC Labs
