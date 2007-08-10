From: Coly Li <coyli@suse.de>
Subject: Re: [PATCH] e2fsprogs: remove fragment support which will never be
 implemented [modified format]
Date: Fri, 10 Aug 2007 21:19:44 +0800
Message-ID: <46BC65F0.5070107@suse.de>
References: <46BBDD5C.6020600@suse.de> <20070810092829.GN6689@schatzie.adilger.int>
Reply-To: coyli@suse.de
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:49565 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936234AbXHJNTD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 10 Aug 2007 09:19:03 -0400
In-Reply-To: <20070810092829.GN6689@schatzie.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Andreas Dilger wrote:
> On Aug 10, 2007  11:37 +0800, Coly Li wrote:
>> - --- a/e2fsck/problem.h
>> +++ b/e2fsck/problem.h
>> @@ -558,8 +558,8 @@ struct problem_context {
>> +/* Duplicate directory entry found */
>> +#define PR_2_REPORT_DUP_DIRENT	0x02000D
>>
>> - -/* i_frag should be zero */
>> - -#define PR_2_FRAG_ZERO		0x020010
>> +/* Non-unique filename found */
>> +#define PR_2_NON_UNIQUE_FILE	0x020010
>>
>> - -/* i_fsize should be zero */
>> - -#define PR_2_FSIZE_ZERO		0x020011
>> +/* i_blocks_hi should be zero */
>> +#define PR_2_BLOCKS_HI_ZERO	0x020011
> 
> Please don't do this.  This makes other patches fail to apply, and I don't
> think we need to have sequential error numbers?
Yes, I should only remove the obsoleted macro. BTW, why not use enum type to declare the error number ?



>>  		struct {
>> - -			__u8	m_i_frag;	/* Fragment number */
>> - -			__u8	m_i_fsize;	/* Fragment size */
>> - -			__u16	m_pad1;
>> - -			__u32	m_i_reserved2[2];
>> +			__u32	m_i_reserved2[3];
> 
> It is a bad idea to declare on-disk fields "reserved[{num}]", because
> if some code is ever using e.g. "reserved[0]" for something and then
> one of the fields is "unreserved" then the other code will silently
> continue to work, but it will be using some other field on disk...
> 
> That said, while we are removing junk you could also remove the "masix"
> parts of the code, because I don't think they have been used for 10 years.

Sure, it seems that it will be better to remove all this structure. Isn't it ?

> 
> Cheers, Andreas
> --
> Andreas Dilger
> Principal Software Engineer
> Cluster File Systems, Inc.
> 

Andreas, thanks for your comments.


- --
Coly Li
SuSE PRC Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iD8DBQFGvGXwuTp8cyZ5lTERAqu9AJwIkWMO/2OjxD2teOh76d6wQ3M6nACeN1rU
sy8hm6ugCJTB4z+D/0foTsU=
=/ZXl
-----END PGP SIGNATURE-----
