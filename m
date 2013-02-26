From: Jeff Mahoney <jeffm@suse.com>
Subject: Re: [PATCH] ext4: cleanup sbi->s_kobj after quota initialization
 failure
Date: Mon, 25 Feb 2013 21:53:24 -0500
Message-ID: <512C23A4.9060705@suse.com>
References: <512BCFBB.30208@suse.com> <20130225233244.GA20992@quack.suse.cz> <CAGr1F2EjCa9Zm_TmMZtdXKO=GC5rrwusPJ4fwffHrtxVbpSyDA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Jan Kara <jack@suse.cz>, Theodore Ts'o <tytso@mit.edu>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Aditya Kali <adityakali@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:50394 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751577Ab3BZCxd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 25 Feb 2013 21:53:33 -0500
In-Reply-To: <CAGr1F2EjCa9Zm_TmMZtdXKO=GC5rrwusPJ4fwffHrtxVbpSyDA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 2/25/13 8:14 PM, Aditya Kali wrote:
> This seems to have been fixed in the ext4 master branch by commit 
> http://git.kernel.org/?p=linux/kernel/git/tytso/ext4.git;a=commitdiff;h=72ba74508b2857e71d65fc93f0d6b684492fc740

Yep.
> 
You're right. It's been a while since I worked with sysfs code
and I was still expecting the old kobject refcounting semantics. I
suppose it would follow that the completion stuff in ext4_put_super is
unnecessary now as well.

- -Jeff

> On Mon, Feb 25, 2013 at 3:32 PM, Jan Kara <jack@suse.cz> wrote:
>> On Mon 25-02-13 15:55:23, Jeff Mahoney wrote:
>>> If ext4_enable_quotas fails, it jumps to failed_mount7, which 
>>> doesn't tear down the kobj.
>> The patch looks good. You can add: Reviewed-by: Jan Kara 
>> <jack@suse.cz>
>> 
>> Honza
>> 
>>> Cc: Aditya Kali <adityakali@google.com> Cc: Jan Kara 
>>> <jack@suse.cz> Signed-off-by: Jeff Mahoney <jeffm@suse.com>
>>> --- fs/ext4/super.c |    6 +++++- 1 file changed, 5
>>> insertions(+), 1 deletion(-)
>>> 
>>> --- a/fs/ext4/super.c +++ b/fs/ext4/super.c @@ -3794,7 +3794,7
>>>  @@ no_journal: !(sb->s_flags & MS_RDONLY)) { err = 
>>> ext4_enable_quotas(sb); if (err) -                     goto 
>>> failed_mount7; +                     goto failed_mount8; } 
>>> #endif  /* CONFIG_QUOTA */
>>> 
>>> @@ -3813,6 +3813,10 @@ cantfind_ext4: ext4_msg(sb, KERN_ERR, 
>>> "VFS: Can't find ext4 filesystem"); goto failed_mount;
>>> 
>>> +failed_mount8: +     kobject_del(&sbi->s_kobj); + 
>>> kobject_put(&sbi->s_kobj); + 
>>> wait_for_completion(&sbi->s_kobj_unregister); failed_mount7: 
>>> ext4_unregister_li_request(sb); failed_mount6:
>>> 
>>> -- Jeff Mahoney SUSE Labs -- To unsubscribe from this list: 
>>> send the line "unsubscribe linux-ext4" in the body of a message
>>> to majordomo@vger.kernel.org More majordomo info at 
>>> http://vger.kernel.org/majordomo-info.html
>> -- Jan Kara <jack@suse.cz> SUSE Labs, CR
> 
> 
> 
> --
> 
> Aditya
> 


- -- 
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.18 (Darwin)
Comment: GPGTools - http://gpgtools.org

iQIcBAEBAgAGBQJRLCOjAAoJEB57S2MheeWypD8P/3B3IQsKkwagguu9qv2isfuC
Um4yDclKbHO54TexW8FV+JBS5gnivO/H6MOksN3n/q2EtvPH9phBP3i1W56P77A4
bgGIsYW5hdSWTGhcgQiNzmFgeOfF53dl+r8nZCxpOcEvvp4QQPI8WPd4IsNKmjGN
vmKhX8m1eY2TGV/dHubAmQ+EttIhn5tMnsM48reQoW3v/H3F70WNQrYEEFqja/tk
xjTn8tlBWvKmR9qP3XzRQHXOGUC56QXBtKyIGLqzkquhrCiG2CywxWnyhwPRujDc
QC26bf18jSThhnPic6GrDvgAwhkEUiuETTtz5hF3+eL5mLR3bFwDQlJsGOfNBWAe
cQAuDv/fapD072wHSEdQ200JoTLEYYr4pCeaU/FlqMlUqX3mxmPANP3lgEaTI/Yh
fmzYANO4eFgAYk9zklqWri57EB+JqFVejZVURE9HftrkWZCQfcHnyGiOdvA4RTSa
HsNQsGA3ta++0H3mdUGGa+SoB+FZa851Gqw/vfN5i87gcHcu+lUfjGnoaNx0RfaU
2qyQOxPODt0p+GDWhfDnCmZqha9wBiW0VPohMv9/Rnwl6QQEMbr6dgd1ZKR5ZWTf
xHxSoC0qNX3EX5dwGUBUSgNFvwJIh1E3cNUxghe2Li0rluia6cmgDouHFGAfDL/A
+vw2xYvvMqfvgUk63+yR
=Uh7A
-----END PGP SIGNATURE-----
