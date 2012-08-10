From: Andreas Dilger <aedilger@gmail.com>
Subject: Re: [PATCH] ext4: add max_dir_size_kb mount option
Date: Fri, 10 Aug 2012 17:14:12 -0600
Message-ID: <771B0C8F-33E3-4ACF-8873-8EA8177D1CB9@dilger.ca>
References: <1344626638-31548-1-git-send-email-tytso@mit.edu> <x49r4repkwj.fsf@segfault.boston.devel.redhat.com> <20120810215811.GA1137@thunk.org>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jeff Moyer <jmoyer@redhat.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:57697 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754862Ab2HJXOR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 10 Aug 2012 19:14:17 -0400
Received: by pbbrr13 with SMTP id rr13so3454785pbb.19
        for <linux-ext4@vger.kernel.org>; Fri, 10 Aug 2012 16:14:17 -0700 (PDT)
In-Reply-To: <20120810215811.GA1137@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2012-08-10, at 3:58 PM, Theodore Ts'o wrote:
> On Fri, Aug 10, 2012 at 04:11:24PM -0400, Jeff Moyer wrote:
>>=20
>> I have no idea what a reasonable number for this would be.  Can you
>> provide guidelines that would help admins understand what factors
>> influence performance degradation due to directory size?
>=20
> Well, for example, if you have a job which is a 512mb memory
> container, and the directory has grown to 176mb, an attempt to readdi=
r
> said directory will cause that job to thrash badly, and perhaps get
> killed by the OOM killer.  If you know that no sane directory should
> ever grow beyond a single megabyte, you might pick a max_dir_size_kb
> of 1024.

Actually, we've been carrying a very similar patch to this in Lustre
for a long time.  I didn't think this would be of interest to others
outside of Lustre, so I don't think I ever sent it upstream.

The reason we have this is that some HPC jobs might create 10k files
every hour in the same output directory, and if the user/job don't
pay attention to clean up the old files, then they might get many
millions of files in the same directory.  Simple operations like
"ls -l" in the directory will behave badly because GNU ls will read
and sort all of the entries first.  Even if "-U" is given to not sort
entries, ls will try to read (and by default stat for color) all the
entries before displaying them so that column widths can be made nice.
Similarly, "rm *" or other foolish things will break on large dirs for
na=EFve users (who are scientists and not sysadmins).

Operations may take many minutes on a huge directory, and users will
complain and call support when they think the filesystem has hung.
Instead, the admins limit the directory size and cause such application=
s
to fail early to alert the user that their application is behaving badl=
y.

Of course, other sites want huge directories (10 billion files in one
directory is the latest number I've seen), so this has to be tunable.
We have a patch to fix the 2-level htree and 2GB directory size limits
already, in case that is of interest to anyone.

Cheers, Andreas

>> Finally, I don't pretend to understand how your mount option parsing
>> routines work, but based on what I see in this patch it looks like t=
he
>> default will be set to and enforced as 0.  What am I missing?
>=20
> Sorry, I sent out the wrong version of the patch.  The limit was only
> supposed to be used if maximum directory size is greater than 0; that
> is, the default is that the directory size is unlimited, as before.
> I'll send out a revised v2 version of the patch.
>=20
> I view this as a very specialized option, but if you're running in a
> tightly constrained memory cgroup, or a tiny EC2 instance, or the
> equivalent Cloud Open VM, it might be a very useful thing to be able
> to cap.
>=20
> Regards,
>=20
> 						- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas





--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
