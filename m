From: Coly Li <colyli@gmail.com>
Subject: Re: What is fragment in ext3/4 ?
Date: Fri, 03 Aug 2007 17:15:52 +0800
Message-ID: <46B2F248.2040101@gmail.com>
References: <46B1A9F9.3050901@gmail.com> <20070803000228.GO6142@schatzie.adilger.int>
Reply-To: colyli@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.187]:32764 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756805AbXHCJV3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 3 Aug 2007 05:21:29 -0400
Received: by fk-out-0910.google.com with SMTP id z23so648349fkz
        for <linux-ext4@vger.kernel.org>; Fri, 03 Aug 2007 02:21:28 -0700 (PDT)
In-Reply-To: <20070803000228.GO6142@schatzie.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

I read from manual and source code, it seems fragment size should be
same to filesystem block size. Therefore, can I say current ext3/4
filesystem still do not support fragment ?

Thanks.

Coly


Andreas Dilger wrote:
> On Aug 02, 2007  17:55 +0800, Coly Li wrote:
>> These days, when I read the source code of mke2fs, I found an option -f
>> to set the fragment size.
>>
>> But I can not find any explaining for ext3/4 framgment from google,
>> excepting someone saying ext2/3 does not support this feature.
>>
>> Can anyone tell me what is the function or purpose of fragment of ext
>> file system ?
> 
> This is an obsolete concept from BSD that was never used by ext[234].
> Consider a "fragment" in this context to be the same as a "tail" for
> reiserfs.  A very small file, or the end of a file that is less than
> a block.
> 
> Cheers, Andreas
> --
> Andreas Dilger
> Principal Software Engineer
> Cluster File Systems, Inc.
> 

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iD8DBQFGsvJIuTp8cyZ5lTERAltpAJ9BhpdjoKQUx001KSQP2oR8HNaXsQCZAbyJ
ASnxX0wXDEaU8q5Syvp83yk=
=IYRx
-----END PGP SIGNATURE-----
