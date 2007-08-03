From: Coly Li <colyli@gmail.com>
Subject: Re: What is fragment in ext3/4 ?
Date: Sat, 04 Aug 2007 00:20:38 +0800
Message-ID: <46B355D6.8000007@gmail.com>
References: <46B1A9F9.3050901@gmail.com> <20070803000228.GO6142@schatzie.adilger.int> <46B35260.9000900@redhat.com>
Reply-To: colyli@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger@clusterfs.com>, linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.172]:56668 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752363AbXHCQ0R (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 3 Aug 2007 12:26:17 -0400
Received: by ug-out-1314.google.com with SMTP id j3so484059ugf
        for <linux-ext4@vger.kernel.org>; Fri, 03 Aug 2007 09:26:16 -0700 (PDT)
In-Reply-To: <46B35260.9000900@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Eric Sandeen wrote:
> Andreas Dilger wrote:
>> On Aug 02, 2007  17:55 +0800, Coly Li wrote:
>>> These days, when I read the source code of mke2fs, I found an option -f
>>> to set the fragment size.
>>>
>>> But I can not find any explaining for ext3/4 framgment from google,
>>> excepting someone saying ext2/3 does not support this feature.
>>>
>>> Can anyone tell me what is the function or purpose of fragment of ext
>>> file system ?
>> This is an obsolete concept from BSD that was never used by ext[234].
>> Consider a "fragment" in this context to be the same as a "tail" for
>> reiserfs.  A very small file, or the end of a file that is less than
>> a block.
> 
> There's a fair amount of code around this never-implemented concept;
> should it be removed?  :)

I agree with this idea. It seems we will never implement it in future,
once "fragment" packed into inode.

Coly

> 
> -Eric
> 
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iD8DBQFGs1XWuTp8cyZ5lTERAoFSAJsE4noHvOm77i0BKWiw5L1DDAnLKgCfXKcv
uL2ZZDiPJYUDWpKWwtIf1uo=
=bGt4
-----END PGP SIGNATURE-----
