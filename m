From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH] ext4: restart ext4_ext_remove_space() after transaction restart
Date: Wed, 26 May 2010 13:12:11 +0400
Message-ID: <87hblvqb6c.fsf@openvz.org>
References: <1271910671-16627-1-git-send-email-dmonakhov@openvz.org>
	<20100525133241.GF5556@thunk.org> <87632ckqcy.fsf@openvz.org>
	<20100525214447.GA14530@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, jack@suse.cz,
	aneesh.kumar@linux.vnet.ibm.com, tytso@mit.ed
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.157]:11695 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095Ab0EZJMR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 26 May 2010 05:12:17 -0400
Received: by fg-out-1718.google.com with SMTP id d23so2699777fga.1
        for <linux-ext4@vger.kernel.org>; Wed, 26 May 2010 02:12:15 -0700 (PDT)
In-Reply-To: <20100525214447.GA14530@thunk.org> (tytso@mit.edu's message of
	"Tue, 25 May 2010 17:44:47 -0400")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

tytso@mit.edu writes:

> On Tue, May 25, 2010 at 06:28:29PM +0400, Dmitry Monakhov wrote:
>> tytso@mit.edu writes:
>> 
>> > On Thu, Apr 22, 2010 at 08:31:11AM +0400, Dmitry Monakhov wrote:
>> >> @@ -2480,6 +2480,11 @@ static int ext4_ext_remove_space(struct inode *inode, ext4_lblk_t start)
>> >>  out:
>> >>  	ext4_ext_drop_refs(path);
>> >>  	kfree(path);
>> >> +	if (err == EAGAIN) {
>> >
>> > Surely this should be "err == -EAGAIN", no?  I'm curious how this
>> > patch worked for with this typo....
>> As usually it fix one thing, and broke another :(.
>> So in case of alloc/truncate restart truncate will be aborted,
>> so i_size != i_disk_size which must be caught by fsck (my test run
>> it every time) but this never happens which is very strange.
Ohh i ment to say blocks beyond i_disk_size due to aborted truncate.
> What test case are you using?  And does it require a system crash to
> show up, or are you seeing an fsck problem after the test completes
> and you unmount the file system?
crash is not required.
I use proposed xfsqa tests from the bug, may be i've changed some 
numbers, but core idea stays the same.
mount /dev/sdb1 /mnt
fsstress ..... &
sleep 300; killall -9 fsstress
umount /mnt
fsck -f /dev/sdb1
After you have spotted the mistypo i've add explicit fault injection 
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -98,9 +98,15 @@ static int ext4_ext_truncate_extend_restart(handle_t
>> > *handle,                                            int needed)
 {
        int err;
+       static int fault = 0;

        if (!ext4_handle_valid(handle))
                return 0;
+       if (inode->i_size % 1234 == 0 && fault++ % 2) {
+               printk("EXT4 TRUNC fault inject inode:%ld\n",inode->i_ino);
+               dump_stack();
+               return -EAGAIN;
+       }

And i've got complain from fsck about incorrect i_size which should be
increased due to block beyond i_disk_size as expected.
And when i've fixed the mistypo i've had different complain due to
bitmap  difference.
