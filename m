From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH] jbd2: don't write superblock when unmounting an ro
 filesystem
Date: Thu, 26 Jul 2012 11:24:01 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1207261110230.27130@localhost>
References: <500F1C28.8010800@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Jan Kara <jack@suse.cz>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54670 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751236Ab2GZJYG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 26 Jul 2012 05:24:06 -0400
In-Reply-To: <500F1C28.8010800@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 24 Jul 2012, Eric Sandeen wrote:

> Date: Tue, 24 Jul 2012 17:05:28 -0500
> From: Eric Sandeen <sandeen@redhat.com>
> To: ext4 development <linux-ext4@vger.kernel.org>
> Cc: Jan Kara <jack@suse.cz>
> Subject: [PATCH] jbd2: don't write superblock when unmounting an ro filesystem
> 
> This sequence:
> 
> # truncate --size=65536 fsfile
> # losetup --offset 65536 /dev/loop0 fsfile 
> # mkfs.ext4 /dev/loop0 
> # losetup -d /dev/loop0
> # mount -o loop,ro,offset=65536 fsfile  mnt/
> # umount mnt
> # dmesg | tail

Hi Eric,

I am having hard time understanding what the sequence should be
doing. I actually can not reproduce it, because I can not create the
file system on such loop device because it seems like the size of
/dev/loop0 is zero, which makes sense considering that you set
offset to 65536 in the 65536 sized file.

Also, is the use of lo device really needed ? We can create the file
system on the file itself right ? Moreover, when I do that I can see
that the journal is not created because the device (file) is too
small, maybe it have something to do with the problem ?

Anyway, maybe I am missing something, but I do not understand what
kind of problem are you reproducing there.

-Lukas

> 
> results in an IO error when unmounting the RO filesystem:
> 
> [  312.386074] SELinux: initialized (dev loop1, type ext4), uses xattr
> [  318.020828] Buffer I/O error on device loop1, logical block 196608
> [  318.027024] lost page write due to I/O error on loop1
> [  318.032088] JBD2: Error -5 detected when updating journal superblock for loop1-8.
> 
> This behavior changed with:
> 
> commit 24bcc89c7e7c64982e6192b4952a0a92379fc341
> Author: Jan Kara <jack@suse.cz>
> Date:   Tue Mar 13 15:41:04 2012 -0400
> 
>     jbd2: split updating of journal superblock and marking journal empty
> 
> which lost some of the magic in jbd2_journal_update_superblock() which
> used to test for a journal with no outstanding transactions.
> 
> I'm not sure if the following is quite the right approach, but it fixes
> it for me.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> p.s. no idea why this only happens if I use a loop device with an offset!
> 
> diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
> index e9a3c4c..987ec76 100644
> --- a/fs/jbd2/journal.c
> +++ b/fs/jbd2/journal.c
> @@ -1354,6 +1354,11 @@ static void jbd2_mark_journal_empty(journal_t *journal)
>  
>  	BUG_ON(!mutex_is_locked(&journal->j_checkpoint_mutex));
>  	read_lock(&journal->j_state_lock);
> +	/* Is it already empty? */
> +	if (sb->s_start == 0) {
> +		read_unlock(&journal->j_state_lock);
> +		return;
> +	}
>  	jbd_debug(1, "JBD2: Marking journal as empty (seq %d)\n",
>  		  journal->j_tail_sequence);
>  
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
