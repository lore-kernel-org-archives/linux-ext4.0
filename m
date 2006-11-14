From: Eric Sandeen <sandeen@redhat.com>
Subject: ext2 readdir/lookup/check_page behavior
Date: Tue, 14 Nov 2006 09:25:19 -0600
Message-ID: <4559DFDF.30504@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:31636 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S965939AbWKNPZV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 14 Nov 2006 10:25:21 -0500
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.12.11.20060308/8.12.11) with ESMTP id kAEFPL9v028748
	for <linux-ext4@vger.kernel.org>; Tue, 14 Nov 2006 10:25:21 -0500
Received: from pobox-2.corp.redhat.com (pobox-2.corp.redhat.com [10.11.255.15])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id kAEFPKcp000530
	for <linux-ext4@vger.kernel.org>; Tue, 14 Nov 2006 10:25:20 -0500
Received: from [127.0.0.1] (sebastian-int.corp.redhat.com [172.16.52.221])
	by pobox-2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id kAEFPJvi026905
	for <linux-ext4@vger.kernel.org>; Tue, 14 Nov 2006 10:25:20 -0500
To: ext4 development <linux-ext4@vger.kernel.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

the fsfuzzer has been keeping me busy lately ;-)

http://kernelfun.blogspot.com/2006/11/mokb-09-11-2006-linux-26x-ext2checkpage.html

has an image with a corrupt directory inode - despite having only 4 blocks, it 
has an extremely large i_size.

readdir & lookup seem to behave differently when ext2_check_page fails for the 
bogus high-index pages.

an "ls" immediately fails with "EIO" because:

ext2_readdir
   ext2_get_page
     ext2_check_page

and if ext2_check_page fails,

                 if (IS_ERR(page)) {
                         ext2_error(sb, __FUNCTION__,
                                    "bad page in #%lu",
                                    inode->i_ino);
                         filp->f_pos += PAGE_CACHE_SIZE - offset;
                         return -EIO;
                 }

however, if you try to "cat *" it spews errors over and over because it gets 
into lookup:

ext2_lookup
   ext2_inode_by_name
     ext2_find_entry
       loop over all pages within i_size calling ext2_get_page

and ext2_find_entry does not break out of the loop when a bad page is found, it 
keeps trying the -next- page, causing a storm of printks as it churns through 
all these bogus pages/offsets.

It seems odd to me that readdir bails out with an error on the first bad page, 
while lookup keeps trying.  Shouldn't these be consistent?  And if so, which is 
the desired behavior?

If we truly wish to keep trying after an error, perhaps adding a "bad page 
count" to the inode_info struct, so that we can stop after a predetermined 
number of errors, might be an option.

Or, perhaps a check high up that says if i_size doesn't correlate to i_blocks, 
this inode is corrupt, and bail out early.

Thoughts?

Thanks,

-Eric
