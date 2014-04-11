From: Trond Myklebust <trond.myklebust@primarydata.com>
Subject: Re: Pretty-printing file.f_mode and file.f_flags in trace points
Date: Fri, 11 Apr 2014 19:00:52 -0400
Message-ID: <2CAFAD45-D715-4FFF-BFDB-A6CA30230087@primarydata.com>
References: <nsxa9brqyys.fsf@closure.thunk.org> <FEAE2135-C0C3-409C-A162-9BC3D9ABDECA@primarydata.com> <20140411225704.GA30629@thunk.org>
Mime-Version: 1.0 (Mac OS X Mail 7.2 \(1874\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	rostedt@goodmis.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ie0-f172.google.com ([209.85.223.172]:65428 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755674AbaDKXA4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 11 Apr 2014 19:00:56 -0400
Received: by mail-ie0-f172.google.com with SMTP id as1so6114370iec.31
        for <linux-ext4@vger.kernel.org>; Fri, 11 Apr 2014 16:00:55 -0700 (PDT)
In-Reply-To: <20140411225704.GA30629@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


On Apr 11, 2014, at 18:57, Theodore Ts'o <tytso@mit.edu> wrote:

> On Fri, Apr 11, 2014 at 06:47:52PM -0400, Trond Myklebust wrote:
>>> I could just cut and paste these and drop them in
>>> include/trace/events/ext4.h, but it would probably be better to hav=
e a
>>> common header file.  The question is where to put them.  Does
>>> include/trace/fs.h make sense to everyone?   Or should put them
>>> somewhere else, such as linux/fs.h?
>>=20
>> I=92d vote for creating a new file, rather than reusing
>> include/linux/fs.h. The latter is included in way too many other
>> headers...
>=20
> That was my preference as well.  Assuming Steve is OK with
> include/trace/fs.h, any objections if I carry a patch in the ext4 tre=
e
> which moves these macros from fs/nfs/nfstrace.h into that new file?

That would be fine by me.

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
