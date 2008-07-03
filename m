From: "Duane Griffin" <duaneg@dghda.com>
Subject: Re: [PATCH, v5] ext3: validate directory entry data before use
Date: Thu, 3 Jul 2008 13:21:39 +0100
Message-ID: <e9e943910807030521x8314b99l4aecf89bbb6f0a41@mail.gmail.com>
References: <20080630143427.GA5473@dastardly>
	 <1214863218-14828-1-git-send-email-duaneg@dghda.com>
	 <42526.1215071509@turing-police.cc.vt.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org, sct@redhat.com, adilger@clusterfs.com,
	"Sami Liedes" <sliedes@cc.hut.fi>, jochen.voss@googlemail.com,
	"Jan Kara" <jack@suse.cz>
To: Valdis.Kletnieks@vt.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.28]:24867 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754829AbYGCMVl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 3 Jul 2008 08:21:41 -0400
Received: by yx-out-2324.google.com with SMTP id 8so219709yxm.1
        for <linux-ext4@vger.kernel.org>; Thu, 03 Jul 2008 05:21:40 -0700 (PDT)
In-Reply-To: <42526.1215071509@turing-police.cc.vt.edu>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2008/7/3  <Valdis.Kletnieks@vt.edu>:
> This may or may not be related, but I've managed to hit another interesting
> piece of ext3 damage while running 26-rc8-mmotd-0701:
>
> % /bin/ls -l /usr/share/man/man5 | grep lvm
> /bin/ls: cannot access /usr/share/man/man5/lvm.conf.5.gz: Stale NFS file handle
> -????????? ? ?    ?        ?                ? lvm.conf.5.gz
>
> Yes, that *is* on an ext3 filesystem.

That is happening because links == 0...

> debugfs on /usr/share is interesting:
>
> debugfs:  stat  /man/man5/lvm.conf.5.gz
> Inode: 59918   Type: regular    Mode:  0644   Flags: 0x0
> Generation: 4228691378    Version: 0x00000000
> User:     0   Group:     0   Size: 0
> File ACL: 239201    Directory ACL: 0
> Links: 0   Blockcount: 0
> Fragment:  Address: 0    Number: 0    Size: 0
> ctime: 0x486c6c0b -- Thu Jul  3 02:04:59 2008
> atime: 0x47efcad7 -- Sun Mar 30 13:16:07 2008
> mtime: 0x486c6c0b -- Thu Jul  3 02:04:59 2008
> dtime: 0x486c6c0b -- Thu Jul  3 02:04:59 2008
> BLOCKS:
>
> Zero links, even though man/man5 references it.  and the ctime/mtime/dtime
> are suspicious as well - that file belongs to an RPM that was last updated
> back on June 20, and there's no obvious culprit processes in lastcomm that
> were running at 2:04AM, and none of the current ones look obvious either.

Size and blockcount of zero as well. Delete time matching atime and
mtime. It looks like something deleted the inode from underneath the
directory entry. The question, of course, is why...

> (system was booted at 00:21, so the failure happened about 1 hours 40 mins
> after the current kernel launched).
>
> Nothing in dmesg from around 2:04AM, and nothing around when the /bin/ls is run.
>
> An 'ls -lR /usr/share' shows that the *other* 127,619 files on the filesystem
> are all OK, it's just this one.
>
> Any brilliant ideas on how to track this down further?

Is it possible that the filesystem still had lingering corruption from
my earlier bad patch? I take it you ran fsck over the filesystem and
it didn't report any errors, but did you run it with -f to force the
check? Deletion of a spurious link to the inode (that wasn't properly
accounted for in the link count) would cause the problem you see.

BTW, apologies for that bad patch, and thanks for identifying it so quickly.

Cheers,
Duane.

-- 
"I never could learn to drink that blood and call it wine" - Bob Dylan
