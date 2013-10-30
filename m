From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Filesystem recovery - e2fsck seems to have caused my filesystem
 to get wiped
Date: Wed, 30 Oct 2013 10:44:59 -0500
Message-ID: <5271297B.7040101@redhat.com>
References: <1829785915.95.1383138487671.JavaMail.root@reganw.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
To: Regan Wallace <regan@reganw.com>, linux-ext4@vger.kernel.org,
	"Darrick J. Wong" <djwong@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51325 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751852Ab3J3PqR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 30 Oct 2013 11:46:17 -0400
In-Reply-To: <1829785915.95.1383138487671.JavaMail.root@reganw.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 10/30/13 8:08 AM, Regan Wallace wrote:
> Hi, 
> 
> Emailing this list as a last ditch effort to try and fix my ext4 filesystem. 
> If there is a better or more appropriate place to ask this question, I apologize for the inconvenience, I would greatly appreciate being pointed in the right direction. 
> 
> I have detailed everything on serverfault here: http://serverfault.com/q/548582/196218 
> 
> But long story short, I have an ext4 filesystem on luks on raid 5. I expanded my local storage as I've done many times before, by growing my raid volume, growing the luks container, and lastly resize2fs on the filesystem. 
> 
> However, before being able to run resize2fs I was informed to fsck. When I ran e2fsck -y on the unmounted filesystem (big mistake), it deleted several hundred possibly thousands of "unused inodes" before I killed it. It happened fast and under sleep deprivation Now I'm left with a partial filesystem after creating an image and using mkfs.ext4 -S to make it mountable somewhat. 
> I'm hoping there is a possible alternate method I haven't tried that may have better chance of recovery of more data. 
> 
> If I can be of any use in determining the cause of this to happen, that would at least give me a bit of solace to help prevent it happening to someone else. 
> 
> 
> Thanks in advance, 
> 
> -Regan 
> 
> 
> 
> Below is a copy from serverfault, if one prefers to read it here directly: 
> 
> ------------------------------------------------------------------------------
> 
> I have an ext4 filesystem on luks over software raid5. The filesystem was operating "just fine" for several years when I was beginning to run out of space. I had a 9T volume on 6x2T drives. I began upgrading to 3T drives by doing the mdadm fail, remove, add, rebuild, repeat process until I had a larger array. 
> I then grew the luks container, and then when I unmounted and tried to resize2fs I was given the message the filesystem was dirty and needed e2fsck. 
> 
> Without thinking I just did e2fsck -y /dev/mapper/candybox and it
> began spewing all kinds of inode being removed type messages (can't
> remember exactly) I killed e2fsck and tried to remount the filesystem
> to backup data I was concerned about. When trying to mount at this
> point I get:

Hm so you don't have the e2fsck output?  That's too bad.

What version of e2fsck are you using?

> 
>> # mount /dev/mapper/candybox /candybox 
>> mount: wrong fs type, bad option, bad superblock on /dev/mapper/candybox, 
>> missing codepage or helper program, or other error 
>> In some cases useful info is found in syslog - try 
>> dmesg | tail or so 
> 
> Looking back at my older logs I noticed the filesystem was giving this error each time the machine booted: 
> 
>> kernel: [79137.275531] EXT4-fs (dm-2): warning: mounting fs with errors, running e2fsck is recommended 

Can you look back through older messages & try to find out what the error was?

> So shame on me for not paying attention :( 
> 
> I then tried to mount using every backup superblock (one after another) and each attempt left this in my log: 
> 
>> EXT4-fs (dm-2): ext4_check_descriptors: Checksum for group 0 failed (26534!=65440) 
>> EXT4-fs (dm-2): ext4_check_descriptors: Checksum for group 1 failed (38021!=36729) 
>> EXT4-fs (dm-2): ext4_check_descriptors: Checksum for group 2 failed (18336!=39845) 
>> ... 
>> EXT4-fs (dm-2): ext4_check_descriptors: Checksum for group 11911 failed (28743!=44098) 

Ok, so you are using metadata checksums, that's useful info (not default...)

And every group checksum is wrong?  That's odd, but maybe induced by aborting
fsck, I'm not certain.  Maybe Darrick knows?

>> BUG: soft lockup - CPU#0 stuck for 23s! [mount:2939] 
> 
> 
> Attempts to restart e2fsck results in: 
> 
>> # e2fsck /dev/mapper/candybox 
>> e2fsck 1.41.14 (22-Dec-2010) 
>> e2fsck: Group descriptors look bad... trying backup blocks... 
>> candy: recovering journal 
>> e2fsck: unable to set superblock flags on candy 

Hmph thats a non-obvious error message:

        /*
         * Whoops, we attempted to run the
         * journal twice.  This should never
         * happen, unless the hardware or
         * device driver is being bogus.
         */
        com_err(ctx->program_name, 0,
                _("unable to set superblock flags on %s\n"), ctx->device_name);

seems like journal recovery (silently) failed on the first pass, and
the 2nd time around it spit this out.

> 
> At this point, I decided it best to order some more drives and make an image using `ddrescue`

good plan.

> Now two weeks later I have an image of the luks partition in a .img file. 
> 
>> # ls -lh 
>> total 14T 
>> -rw-r--r-- 1 root root 14T Oct 25 01:57 candybox.img 
>> -rw-r--r-- 1 root root 271 Oct 20 14:32 candybox.logfile 
> 
> 
> After numerous attempts using everything I could find online I could not coerce e2fsck to do anything on the image, so I used `mkfs.ext4 -L candy candybox.img -m 0 -S` and I was able to mount the dirty filesystem readonly without the journal and recover 960G of data. It gave all kinds of errors of various directories not existing and so forth but I was able to get *some* stuff. Which gave me some hope! 

FWIW, it'd be fairly quick to make an "e2image -r "of the disk, and do your experimentation on that (rather than the dd image)

You won't have file data, but you can quickly fiddle & re-fiddle with metadata hacks to get it online.

Once you have something that seems to give you decent metadata recovery you could have another go at it with the full dd image.

Anyway, it seems to be log recovery in fsck going badly, maybe just zapping the log (as a hack/test, on the image) might help, just a guess.

tune2fs can remove a log, but not sure it'll be willing to remove a dirty log.

# tune2fs -f -O ^has_journal sda1.img 
tune2fs 1.41.12 (17-May-2010)
The needs_recovery flag is set.  Please run e2fsck before clearing
the has_journal flag.

nope, not even with force.  Grr.

Maybe this will work; get the journal inode number & clear it:

# dumpe2fs -h sda1.img  | grep "Journal inode"
dumpe2fs 1.41.12 (17-May-2010)
Journal inode:            8

# debugfs -w -R "clri <8>" sda1.img

now e2fsck will think the journal is invalid & just zap it:

e2fsck 1.41.12 (17-May-2010)
Superblock has an invalid journal (inode 8).
Clear<y>?

*maybe* that will get your e2fsck past the journal recovery problem
w/o needing the mkfs.ext4 -S giant hammer.

Again, obviously, only do all that on the image, not the original fs.

It'd be really nice to know what the first e2fsck was finding, though.  :(

-Eric


