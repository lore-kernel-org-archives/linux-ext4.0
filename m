From: "Duane Griffin" <duaneg@dghda.com>
Subject: Re: Correct EXT3_TOPDIR_FL behaviour
Date: Tue, 3 Jun 2008 22:31:43 +0100
Message-ID: <e9e943910806031431r46f6c56fn1974b28e9aefd6ce@mail.gmail.com>
References: <e9e943910806021727h111b0e57qeea0032d164e0ffb@mail.gmail.com>
	 <20080603205220.GG2961@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: "Andreas Dilger" <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.227]:37987 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751725AbYFCVbo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 3 Jun 2008 17:31:44 -0400
Received: by rv-out-0506.google.com with SMTP id l9so1779762rvb.1
        for <linux-ext4@vger.kernel.org>; Tue, 03 Jun 2008 14:31:44 -0700 (PDT)
In-Reply-To: <20080603205220.GG2961@webber.adilger.int>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2008/6/3 Andreas Dilger <adilger@sun.com>:
> On Jun 03, 2008  01:27 +0100, Duane Griffin wrote:
>> I'm looking at http://bugzilla.kernel.org/show_bug.cgi?id=9866, where
>> the reporter is claiming that EXT3_TOPDIR_FL (chattr +T) is behaving
>> incorrectly by being inherited from the parent. As mentioned in the
>> bug, it also only seems to only make sense for directories but
>> ext{2,3,4} is happy to set it on anything. It seems to me that the
>> reporter is correct and the behaviour should be changed to prevent the
>> flag being inherited and to limit it to directories only. If there is
>> no disagreement I'll follow-up with patches accordingly.
>
> Yes, this is a problem that was mentioned previously, and hasn't been
> fixed yet.  The TOPDIR_FL shouldn't be inherited, similar to the
> non-inheritance of INDEX_FL and EXTENTS_FL.
>
> It could be argued pretty easily that inheriting flags is usually wrong,
> and that we should instead specify which flags SHOULD be inherited,
> instead of repeatedly fixing bugs like this.

Right, I was wondering about the others.

> Flags that I would propose should be inherited from directories to
> regular files and subdirectories are: SECRM, UNRM, SYNC, APPEND, NODUMP,
> NOATIME, COMPR, NOCOMPR, JOURNAL_DATA, NOTAIL, and DIRSYNC, EXTENTS.
> I'm not sure what the semantics of IMMUTABLE on a directory are, whether
> it is even possible to create a new file in such a directory, but by
> principle of least surprise it should probably be inherited.
>
> Flags that definitely do not make sense to be inherited are: DIRTY, ECOMPR,
> INDEX, IMAGIC, TOPDIR, HUGE_FILE.
>
> Flags that don't make sense to be set on non-file/dir inodes are: DIRTY,
> ECOMPR, INDEX, SECRM, UNRM, SYNC, APPEND, COMPR, NOCOMPR, JOURNAL_DATA,
> NOTAIL, DIRSYNC, TOPDIR, EXTENTS, HUGE_FILE (used for files > 2TB).

OK, thanks. I'll fix these up at the same time then. At the moment,
for ext3, it seems INDEX is being cleared on everything, IMMUTABLE and
APPEND are being cleared on links, and DIRSYNC is cleared on
non-directories.

Cheers,
Duane.

-- 
"I never could learn to drink that blood and call it wine" - Bob Dylan
