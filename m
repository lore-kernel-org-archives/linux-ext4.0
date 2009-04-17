From: Jeremy Sanders <jss@ast.cam.ac.uk>
Subject: Re: fsck.ext4: Group descriptors look bad... trying backup
 blocks...
Date: Fri, 17 Apr 2009 19:51:21 +0100 (BST)
Message-ID: <alpine.LFD.2.00.0904171946030.26751@xpc17.ast.cam.ac.uk>
References: <gs9nm5$8m1$1@ger.gmane.org> <20090417115659.GB7117@mit.edu> <gs9rve$rid$1@ger.gmane.org> <49E8B7F4.6020608@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ppsw-6.csi.cam.ac.uk ([131.111.8.136]:57737 "EHLO
	ppsw-6.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751425AbZDQTOf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 17 Apr 2009 15:14:35 -0400
In-Reply-To: <49E8B7F4.6020608@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 17 Apr 2009, Eric Sandeen wrote:

> Jeremy Sanders wrote:
>> Theodore Tso wrote:
>
> ...
>
>>> I see from the dumpe2fs that you sent it had only been in use for a
>>> week.  How were you using the filesystem?  Did you try using the
>>> online resize feature at any time?
>>
>> No. The filesystem was used to store rsync snapshots of other file systems
>> (using the hard link feature). I had only rsynced the initial data and run a
>> couple of rsync backups on to it. The filesystem was created using:
>>
>> mkfs.ext4 -m0 -b 4096 -E stride=8,stripe-width=72  /dev/md0
>
> Can you show us exactly how you're using rsync?  is this with
> rdiff-backup or some similar tool?

No, plain rsync. We have a script which does something like

rsync -raHSx --stats --while-file --numeric-ids  \
--link-dest=/mnt/username/20090418/ host:/data/username/ \ 
/mnt/username/20090419/

for a set of users.

This command copies the files from /data/username on host to 
/mnt/username/20090419, but creates hard links to the previous copy 
(/mnt/username/20090418/) for unchanged files.

It worked fine on ext3, at least for a 2.4TB device.

Jeremy

-- 
Jeremy Sanders <jss@ast.cam.ac.uk>   http://www-xray.ast.cam.ac.uk/~jss/
X-Ray Group, Institute of Astronomy, University of Cambridge, UK.
Public Key Server PGP Key ID: E1AAE053
