From: Jeff Liu <jeff.liu@oracle.com>
Subject: Add SEEK_DATA/SEEK_HOLE support V2
Date: Wed, 28 Sep 2011 14:32:27 +0800
Message-ID: <4E82BF7B.7000403@oracle.com>
Reply-To: jeff.liu@oracle.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Yongqiang Yang <xiaoqiangnk@gmail.com>,
	Sunil Mushran <sunil.mushran@oracle.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:49815 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192Ab1I1Gcl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 28 Sep 2011 02:32:41 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello all,

This is the V2 for add SEEK_DATA/SEEK_HOLE support to ext4.
In V1, I copied all the codes regarding fetching delayed-extents out to
my seek callback function, it's stupid to duplicate the code blocks.

Now the idea is, since the delayed-extents is the main concern to search
extents for both fiemap and seek, so IMHO, it's better to consolidate
this procedure into a new function(get_delayed_extent() in my patch),
and call it in fiemap and seek call-back functions if necessary.  In
this way, when yongqiang's delayed-extents tree is ready, we only need
to modify the code block at get_delayed_extent() accordingly.

In addition, yongqiang has pointed out there might be a deadlock, but
per my understood, as the target inode already locked via i_mutex in
ext4_llseek() before, this lock can prevent any modification to the
file, and we call find_get_pages_tag() when trying to fetch the dirty
pages, this function using rcu read lock, it also safe to read.  So I
have no idea what's wrong, could anyone please kindly point me out in
this case?  I'm definitely a newbie to this list, sorry for my ignorant.

Anyway, I'd like to post the revised for your guys review first.
In have split the modification to two patches this time, since I hope to
make it looks more convenient for the review purpose.

The 1st patch, remove the delayed-extents fetching procedure to a
function named as get_delayed_extent(), and modify the
ext4_ext_fiemap_cb() accordingly.

The 2nd path add the ext4_ext_seek_cb() to implement the
SEEK_HOLE/SEEK_DATA stuff based on previous code change.

Testing:
========
In addition to the test cases mentioned in V1, I also done another tests
through sunil's seek test program, please refer to:
http://oss.oracle.com/~smushran/seek_data/seek_test.c

To ensure the 1st patch does not cause regression issue on fiemap, I
have done some tests via cp(1) with fiemap copy support, the sparse file
used for this test is produced by:
python -c "f=open('./sptest', 'w'); [(f.seek(x) or f.write(str(x))) for
x in range(1, 1000000000, 99999)]; f.close()


Any feedback are appreciated!


Thanks,
-Jeff
