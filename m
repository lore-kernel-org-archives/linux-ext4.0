From: Eric Sandeen <sandeen@redhat.com>
Subject: what exactly is CONFIG_EXT4_USE_FOR_EXT23 for?
Date: Thu, 11 Mar 2010 10:38:25 -0600
Message-ID: <4B991C81.5040506@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:18152 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933240Ab0CKQi3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 11 Mar 2010 11:38:29 -0500
Received: from int-mx08.intmail.prod.int.phx2.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o2BGcSjr016732
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Thu, 11 Mar 2010 11:38:29 -0500
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx08.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id o2BGcPku007325
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Thu, 11 Mar 2010 11:38:28 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

commit 24b584240a0006ea7436cd35f5e8983eb76f1e6f
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Mon Dec 7 14:08:51 2009 -0500

    ext4: Use ext4 file system driver for ext2/ext3 file system mounts
    
    Add a new config option, CONFIG_EXT4_USE_FOR_EXT23 which if enabled,
    will cause ext4 to be used for either ext2 or ext3 file system mounts
    when ext2 or ext3 is not enabled in the configuration.
    
    This allows minimalist kernel fanatics to drop to file system drivers
    from their compiled kernel with out losing functionality.
    
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>


So now we have this thing, and people are using it, and running into trouble:

http://bugzilla.kernel.org/show_bug.cgi?id=15420
Bug 15420 -  EXT4_USE_FOR_EXT23 causes wrong free space calculation on ext2 and ext3

and now we propose turning off delalloc if we mount ext3 as ext4; however, migrated
ext3->ext4 filesystems, which initially may have no difference other than a
superblock feature flag, will not get this behavior, I guess.

Jan suggests that we not surprise users by having delalloc enabled when ext3
is mounted with the ext4 driver.  However there are other behavior differences
as well, mballoc behavior comes to mind at least.  What about the 32000 subdir
limit?  If we go back to ext3 is it ok with the subsecond timestamps and
creation time etc?  Maybe so... have we tested any of this?

At what point do we include the phase of the moon as worth considering when 
describing ext4.ko behavior?

I guess my point here is I think we have completely crossed the line of a
coherent story of what ext4 is and how it's supported and tested; things are
feeling so tuning-knob-option-happy and full of caveats that our matrix looks
infinite from where I stand.

This option won't be enabled on fedora or rhel, (and I don't mean to single out 
this particular commit, it just got me started on this train of thought)
but I just wanted to air a general concern that ext4 not try to be 10,000 different 
things to all people, and focus on something testable, documentable, and supportable.

For myself and the distros I work on, I strongly prefer to limit things to:

a) filesystems mkfs'd and mounted as ext4
b) ext3 filesystems migrated according to a very specific set of steps

All these other sub-cases and what-ifs and except-unless behaviors really
muddy the water, IMHO.

</vent>  ;)

Thanks,
-Eric
