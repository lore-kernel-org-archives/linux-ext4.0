From: Andreas Dilger <adilger@sun.com>
Subject: Re: fsck.ext4: Group descriptors look bad... trying backup	blocks...
Date: Mon, 20 Apr 2009 14:45:34 -0600
Message-ID: <20090420204534.GF3209@webber.adilger.int>
References: <49E8B5AD.6030907@redhat.com> <gshfgl$o6m$1@ger.gmane.org>
 <20090420113534.GR19186@mit.edu>
 <alpine.LFD.2.00.0904201237500.17316@xpc17.ast.cam.ac.uk>
 <20090420124810.GT19186@mit.edu> <49EC8B97.6010308@redhat.com>
 <49EC9A11.1080105@redhat.com>
 <alpine.LFD.2.00.0904201652540.17316@xpc17.ast.cam.ac.uk>
 <20090420182800.GC3209@webber.adilger.int>
 <alpine.LFD.2.00.0904201953260.30497@xpc17.ast.cam.ac.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: Eric Sandeen <sandeen@redhat.com>, Theodore Tso <tytso@mit.edu>,
	linux-ext4@vger.kernel.org
To: Jeremy Sanders <jss@ast.cam.ac.uk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:44834 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753476AbZDTUpw (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 20 Apr 2009 16:45:52 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n3KKjlK3027233
	for <linux-ext4@vger.kernel.org>; Mon, 20 Apr 2009 13:45:47 -0700 (PDT)
Content-disposition: inline
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java(tm) System Messaging Server 7.0-5.01 64bit (built Feb 19 2009))
 id <0KIF00A002N0SW00@fe-sfbay-10.sun.com> for linux-ext4@vger.kernel.org; Mon,
 20 Apr 2009 13:45:47 -0700 (PDT)
In-reply-to: <alpine.LFD.2.00.0904201953260.30497@xpc17.ast.cam.ac.uk>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Apr 20, 2009  19:55 +0100, Jeremy Sanders wrote:
> On Mon, 20 Apr 2009, Andreas Dilger wrote:
>> On Apr 20, 2009  16:53 +0100, Jeremy Sanders wrote:
>>> On Mon, 20 Apr 2009, Eric Sandeen wrote:
>>>> One other question - do you make use of xattrs on this filesystem?
>>>
>>> No.
>>
>> If you use anything like SELinux or ACLs you would also (indirectly) be
>> using xattrs.
>
> SELinux is switched off and we haven't (knowingly) been using xattrs, but 
> I remember rsync might copy copy xattrs, so perhaps they get written in  
> some way...

You can check this with:

	debugfs -c -R "stat {path to file inside filesystem}" /dev/XXX

and check if the "File ACL" field is non-zero:

debugfs -c -R "stat etc/hosts" /dev/sda2
debugfs 1.40.11.sun1 (17-June-2008)
/dev/sda2: catastrophic mode - not reading inode or group bitmaps
Inode: 259128   Type: regular    Mode:  0644   Flags: 0x0   Generation:
2075236634
User:     0   Group:     0   Size: 2258
File ACL: 0    Directory ACL: 0
^^^^^^^^^^^ ##### this would be non-zero #####

Links: 2   Blockcount: 8
Fragment:  Address: 0    Number: 0    Size: 0
ctime: 0x49812ef4 -- Wed Jan 28 21:22:12 2009
atime: 0x49ebdce3 -- Sun Apr 19 20:24:35 2009
mtime: 0x49812ef4 -- Wed Jan 28 21:22:12 2009
Size of extra inode fields: 4
Inode version: 0
BLOCKS:
(0):534546
TOTAL: 1



Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

