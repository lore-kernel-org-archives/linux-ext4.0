From: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Subject: Re: EXT4-fs (dm-1): Couldn't remount RDWR because of unprocessed
 orphan inode list
Date: Thu, 06 Oct 2011 19:12:33 +0900
Message-ID: <4E8D7F11.8050309@jp.fujitsu.com>
References: <alpine.DEB.2.01.1109021346290.9183@trent.utfs.org> <4E66478E.90102@redhat.com> <alpine.DEB.2.01.1109060923340.9183@trent.utfs.org> <4E664DFD.80308@redhat.com> <20110908185139.GA2393@quack.suse.cz> <alpine.DEB.2.01.1109091809180.9183@trent.utfs.org> <20110910200414.GA6709@quack.suse.cz> <alpine.DEB.2.01.1109122150060.9183@trent.utfs.org> <alpine.DEB.2.01.1109152044090.5628@trent.utfs.org> <20111005180339.GG23467@quack.suse.cz> <alpine.DEB.2.01.1110051823380.8000@trent.utfs.org>
Reply-To: toshi.okajima@jp.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Christian Kujau <lists@nerdbynature.de>, Jan Kara <jack@suse.cz>,
	Eric Sandeen <sandeen@redhat.com>, mszeredi@suse.cz,
	Al Viro <viro@ZenIV.linux.org.uk>
To: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:55257 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754781Ab1JFKKq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 6 Oct 2011 06:10:46 -0400
In-Reply-To: <alpine.DEB.2.01.1110051823380.8000@trent.utfs.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

(2011/10/06 10:34), Christian Kujau wrote:
> On Wed, 5 Oct 2011 at 20:03, Jan Kara wrote:
>>> With Miklos' patches applied to -rc5, this happend again just now :-(
>>>
>> Thanks for careful testing! Hmm, since you are able to reproduce on ppc
>> but not on x86 there might be some memory ordering bug in Miklos' patches
>> or it's simply because of different timing. Miklos, care to debug this
>> further?
> 
> Just to be clear: I'm still not entirely sure how to reproduce this at 
> will. I *assumed* that the daily remount-rw-and-ro-again routine that left 
> some inodes in limbo and eventually lead to those "unprocessed orphan 
> inodes". With that in mind I tried to reproduce this with the help of a 
> test-script (test-remount.sh, [0]) - but the message did not occur while 
> the script was running.
> 
> I've ran the script again today on the said powerpc machine on a 
> loop-mounted 500MB ext4 partition. But even after 100 iterations no
> such message occured.
> 
> So maybe it's caused by something else or my test-script just doesn't get 
> the scenario right and there's something subtle to this whole 
> remounting-business I haven't figured out yet, leading to those orphan 
> inodes.
> 
> I'm at 3.1.0-rc9 now and will wait until the errors occur again.
> 
> Christian.
> 
> [0] nerdbynature.de/bits/3.1-rc4/ext4/

With Miklos' patches applies to -rc8, I could display
"Couldn't remount RDWR because of unprocessed orphan inode list".
on my x86_64 machine by my reproducer.

Because actual removal starts from over a range between mnt_want_write() and
mnt_drop_write() even if do_unlinkat() or do_rmdir() calls mnt_want_write()
and mnt_drop_write() to prevent a filesystem from re-mounting read-only.

My reproducer is as follows:
-----------------------------------------------------------------------------
[1] go.sh
#!/bin/sh

dd if=/dev/zero of=/tmp/img bs=1k count=1 seek=1000k > /dev/null 2>&1
/sbin/mkfs.ext4 -Fq /tmp/img
mount -o loop /tmp/img /mnt
./writer.sh /mnt &
LOOP=1000000000
for ((i=0; i<LOOP; i++));
do
	echo "[$i]"
	if ((i%2 == 0));
	then
		mount -o ro,remount,loop /mnt
	else
		mount -o rw,remount,loop /mnt
	fi
	sleep 1
done

[2] writer.sh
#!/bin/sh

dir=$1
for ((i=0;i<10000000;i++));
do
	for ((j=0;j<64;j++));
	do
		filename="$dir/file$((i*64 + j))"
		dd if=/dev/zero of=$filename bs=1k count=8 > /dev/null 2>&1 &
	done
	for ((j=0;j<64;j++));
	do
		filename="$dir/file$((i*64 + j))"
		rm -f $filename > /dev/null 2>&1 &
	done
	wait
	if ((i%100 == 0 && i > 0));
	then
		rm -f $dir/file*
	fi
done
exit

[step to run]
# ./go.sh
-----------------------------------------------------------------------------

Therefore, we need a mechanism to prevent a filesystem from re-mounting 
read-only until actual removal finishes.

------------------------------------------------------------------------
[example fix]
 do_unlinkat() {
   ...
   mnt_want_write()
   vfs_unlink()
   if (inode && inode->i_nlink == 0) {              //
      atomic_inc(&inode->i_sb->s_unlink_count);     //   
      inode->i_deleting++;                          // 
   }                                                // 
   mnt_drop_write()
   ...
   iput() // usually, an acutal removal starts
   ...
 }

destroy_inode() {
  ...
  if (inode->i_deleting)
    atomic_dec(&inode->i_sb->s_unlink_count);
  ...
}

do_remount_sb() {
  ...
  else if (!fs_may_remount_ro(sb) || atomic_read(&sb->s_unlink_count)
     return -EBUSY;
  ...
}
------------------------------------------------------------------------

Besides, my reproducer also detects the following message:
"Ext4-fs (xxx): ext4_da_writepages: jbd2_start: xxx pages, ino xx: err -30"

This is because ext4_remount() cannot guarantee to write all ext4 
filesystem data out due to the delayed allocation feature.
(ext4_da_writepages() fails after ext4_remount() sets MS_RDONLY with 
sb->s_flags)

Therefore, we must write all delayed allocation buffers out before 
ext4_remount() sets sb->s_flags with MS_RDONLY. 

------------------------------------------------------------------------
[example fix] // This requires Miklos' patches. 

ext4_remount() {
  ...
  if (*flags & MS_RDONLY) {
      err = dquot_suspend(sb, -1);
      if (err < 0) 
         goto restore_opts;

      sync_filesystem(sb);  // write all delayed buffers out
      sb->s_flags |= MS_RDONLY;
  ...
}      
------------------------------------------------------------------------

Best Regards,
Toshiyuki Okajima

