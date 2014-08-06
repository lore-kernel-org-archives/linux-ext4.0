From: "Anthony G. Basile" <basile@opensource.dyc.edu>
Subject: Re: [PATCH] misc/e4defrag.c: use posix_fallocate64() if fallocate64()
 is unavailable
Date: Wed, 06 Aug 2014 09:56:43 -0400
Message-ID: <53E2341B.4000500@opensource.dyc.edu>
References: <1406830068-6485-1-git-send-email-basile@opensource.dyc.edu> <20140731232253.GF1566@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org,
	"Anthony G. Basile" <blueness@gentoo.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.virtual.dyc.edu ([67.222.116.22]:44845 "EHLO
	virtual.dyc.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751382AbaHFODQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 6 Aug 2014 10:03:16 -0400
In-Reply-To: <20140731232253.GF1566@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 07/31/14 19:22, Theodore Ts'o wrote:
> On Thu, Jul 31, 2014 at 02:07:48PM -0400, basile@opensource.dyc.edu wrote:
>> From: "Anthony G. Basile" <blueness@gentoo.org>
>>
>> Commit 58229aaf removed the broken fallback syscall for fallocate64() on systems
>> where the latter is unavailable.  However, it did not provide a substitute,
>> so the build fails on uClibc which does not have fallocate64(), but does have
>> posix_fallocate64().  Since fallocate64() is called with mode=0, we can make use
>> of posix_fallocate64() on such systems.
>
> The posix_fallocate[64]() is not the same as fallocate[64]().  Some
> libc's will implement posix_fallocate() by brute force writing zeros
> to the file.  Some will try calling the fallocate(2) system call if it
> is present, and then fall back to the brute force write.  With
> fallocate(2), if the file system returns ENOTSUPP, userspace gets told
> about it.
>
> So one question is how has uClibc actually implemented with
> posix_fallocate[64]()?  Does it implement fallocate()?  I'd be happier
> falling back to fallocate() and simply failing to support files which
> are larger than the maximum size supported by off_t.

Sorry for the dealy in responding.  uclibc does implement 
posix_fallocate using the fallocate syscall and it does report ENOTSUPP. 
[1] This is basically the way e4defrag.c was doing things before 
58229aaf, but without the problem that was there.  What does concern me 
if there are *other* libc's that try to brute force zero.  I could 
update the patch to check ifdef __UCLIBC__ since we know that 
implementation is safe.  Thoughts?

[1] See 
http://git.uclibc.org/uClibc/tree/libc/sysdeps/linux/common/posix_fallocate.c 
and posix_fallocate64.c

>
> Yet another possibility is simply changing the Makefile to simply skip
> building e4defrag if the C library doesn't support the fallocate
> system call.

I think we can do this if its not uclibc.  I don't know of any libc 
which does the brute forcing, but I'm only familiar with glibc, uclibc 
and musl, and only the linux kernel.  Both glibc and musl provide 
fallocate(2).  Only uclibc doesn't.  Maybe its time to implement it in 
uclibc.

>
> 						- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


-- 
Anthony G. Basile, Ph. D.
Chair of Information Technology
D'Youville College
Buffalo, NY 14201
(716) 829-8197
