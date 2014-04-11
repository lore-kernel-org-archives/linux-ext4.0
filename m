From: Trond Myklebust <trond.myklebust@primarydata.com>
Subject: Re: Pretty-printing file.f_mode and file.f_flags in trace points
Date: Fri, 11 Apr 2014 18:47:52 -0400
Message-ID: <FEAE2135-C0C3-409C-A162-9BC3D9ABDECA@primarydata.com>
References: <nsxa9brqyys.fsf@closure.thunk.org>
Mime-Version: 1.0 (Mac OS X Mail 7.2 \(1874\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	rostedt@goodmis.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ie0-f169.google.com ([209.85.223.169]:51221 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754645AbaDKWrz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 11 Apr 2014 18:47:55 -0400
Received: by mail-ie0-f169.google.com with SMTP id to1so6089529ieb.14
        for <linux-ext4@vger.kernel.org>; Fri, 11 Apr 2014 15:47:55 -0700 (PDT)
In-Reply-To: <nsxa9brqyys.fsf@closure.thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,

On Apr 11, 2014, at 18:32, Theodore Ts'o <tytso@mit.edu> wrote:

>=20
> I want to add some trace points which display f_mode and f_flags from
> struct file in a human way.   I found the following handy macros defi=
ned
> in fs/nfs/nfstrace.h:
>=20
> #define show_open_flags(flags) \
> 	__print_flags((unsigned long)flags, "|", \
> 		{ O_CREAT, "O_CREAT" }, \
> 		{ O_EXCL, "O_EXCL" }, \
> 		{ O_TRUNC, "O_TRUNC" }, \
> 		{ O_APPEND, "O_APPEND" }, \
> 		{ O_DSYNC, "O_DSYNC" }, \
> 		{ O_DIRECT, "O_DIRECT" }, \
> 		{ O_DIRECTORY, "O_DIRECTORY" })
>=20
> #define show_fmode_flags(mode) \
> 	__print_flags(mode, "|", \
> 		{ ((__force unsigned long)FMODE_READ), "READ" }, \
> 		{ ((__force unsigned long)FMODE_WRITE), "WRITE" }, \
> 		{ ((__force unsigned long)FMODE_EXEC), "EXEC" })
>=20
> I could just cut and paste these and drop them in
> include/trace/events/ext4.h, but it would probably be better to have =
a
> common header file.  The question is where to put them.  Does
> include/trace/fs.h make sense to everyone?   Or should put them
> somewhere else, such as linux/fs.h?

I=92d vote for creating a new file, rather than reusing include/linux/f=
s.h. The latter is included in way too many other headers...=20

include/trace/fs.h sounds just fine to me if Steven and the other trace=
point gurus are OK with it.

Cheers
  Trond
_________________________________
Trond Myklebust
Linux NFS client maintainer, PrimaryData
trond.myklebust@primarydata.com

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
