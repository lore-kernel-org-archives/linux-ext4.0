From: Kevin Shanahan <kmshanah@ucwb.org.au>
Subject: Re: Possible ext4 corruption - ACL related?
Date: Tue, 10 Mar 2009 15:32:51 +1030
Message-ID: <1236661371.30280.33.camel@kulgan.wumi.org.au>
References: <1236642197.30280.18.camel@kulgan.wumi.org.au>
	 <49B5D71D.1030802@redhat.com>
	 <1236655451.30280.29.camel@kulgan.wumi.org.au>
	 <49B5EDFE.8060405@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bowden.ucwb.org.au ([203.122.237.119]:54448 "EHLO
	mail.ucwb.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751624AbZCJFDA (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 10 Mar 2009 01:03:00 -0400
In-Reply-To: <49B5EDFE.8060405@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 2009-03-09 at 23:35 -0500, Eric Sandeen wrote:
> Kevin Shanahan wrote:
> > On Mon, 2009-03-09 at 21:57 -0500, Eric Sandeen wrote:
> >> Kevin Shanahan wrote:
> ...
> >> If you try a manual getfacl of the above files do you still get the error?
> > 
> > Yeah, same thing:
> > 
> > hermes:/srv/samba/local# getfacl apps/Gestalt.Net/SetupCD/program\ files/Business\ Objects/Common/3.5/bin/Cdo32sv.dll 
> > getfacl: apps/Gestalt.Net/SetupCD/program\040files/Business\040Objects/Common/3.5/bin/Cdo32sv.dll: Input/output error
> > 
> > Nothing extra showing up in dmesg after doing that, so it's possible the
> > two are unrelated - although, the coincidence would surprise me.
> 
> Can you try debugfs /dev/whatever, and then do:
> 
> debugfs> stat
> apps/Gestalt.Net/SetupCD/program\040files/Business\040Objects/Common/3.5/bin/Cdo32sv.dll
> 
> (all one line there, and this is assuming that apps/ is the root dir on
> that filesystem, if not adjust accordingly...)

hermes:~# debugfs /dev/dm-0 
debugfs 1.41.3 (12-Oct-2008)
debugfs:  stat "local/apps/Gestalt.Net/SetupCD/program files/Business Objects/Common/3.5/bin/Cdo32sv.dll"

Gives the following output:

  Inode: 867   Type: bad type    Mode:  0404   Flags: 0x802a61af
  Generation: 2483046020    Version: 0xb9286359:17a7fdfd
  User: 1455931783   Group: -798021131   Size: -1808719531
  File ACL: 141934744    Directory ACL: 0
  Links: 15681   Blockcount: 171984001880781
  Fragment:  Address: 956780679    Number: 0    Size: 0
   ctime: 0xdca60244:006c5b08 -- Wed Apr 23 01:54:36 2087
   atime: 0x5c9e956c:777587a4 -- Sat Mar 30 08:30:12 2019
   mtime: 0x2ce44e11:286138f8 -- Sat Nov 13 13:31:37 1993
  crtime: 0x737781cb:5661f351 -- Thu May 22 19:54:11 2031
  dtime: 0xf19c4882 -- Sat Jun 14 11:57:14 2098
  Size of extra inode fields: 3625
  BLOCKS:

And when I exit the pager and return to the prompt I also see:

  invalid inode->i_extra_isize (3625)
  debugfs: 

Cheers,
Kevin.


