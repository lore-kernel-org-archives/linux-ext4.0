From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [E2FSPROGS, RFC] New mke2fs types parsing
Date: Mon, 17 Mar 2008 16:29:18 -0500
Message-ID: <47DEE2AE.1050105@redhat.com>
References: <E1JRpaN-0000Bs-4N@closure.thunk.org> <47BC76A9.307@redhat.com> <20080220222019.GG30305@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:49845 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756601AbYCQV3V (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 17 Mar 2008 17:29:21 -0400
In-Reply-To: <20080220222019.GG30305@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso wrote:

> There are only three things which mke2fs will do, in my design:
> 
> #1) If the first type is not one of "ext2", "ext3", "ext4", or
> "ext4dev", mke2fs will determine a suitable default based on either
> argv[0] if it is of the form mke2fs.*, or via defaults.fs_type in
> /etc/mke2fs.conf.  If neither of these is available it will default to "ext2".
> 
> #2) If the second type is not one of "small", "floppy" or "default",
> mke2fs will create a default type by checking the size of the
> to-be-created filesystem.  If it is less than 3mb, it is "floppy", if
> it is less than 512mb, it is "small", otherwise it is default.
> 
> #3) Once it has the list of types, i.e., "ext3,defaults,squid", or
> "ext2,floppy,rescue", "ext4,defaults,largefile", etc. it uses this as
> a search path when mke2fs needs to look up some parameter, such as
> "base_features", or "inode_size", etc.  

I started to look into updating the man page for this but it led to
several questions, and a suggestion....

Is this intended to take exactly 1, 2, or 3 arguments?  If so is it
always "type," "size," "usepattern?"  (ext4,small,news for example)

Can I specify ext4,defaults,news as well as ext4,news,defaults or does
order matter - it seems that it does.

Should it bail out if a stanza is not found (-T foo,bar,baz?)  Today it
does not.

>From looking at & playing with the code it seems like it is supposed to
be explicitly type, size, usepattern, although sometimes it doesn't get
it right, for example this:

misc/mke2fs -T ext5,floppy,news  fsfile

leads to:

fs_types: 'ext2', 'small', 'ext5', 'floppy', 'news'

hmm...

Also if these 3 positions have special meanings and orders, it's odd to
not have that reflected in the config file stanzas somehow...

It seems to me that perhaps instead of specifying that each
comma-delimited position has a specific meaning, perhaps it should just
be: "comma separated list which indicates profiles from least to most
specific, with values & features from more specific (later) profiles
trumping less specific (earlier) profiles" - would this be more clear &
flexible...?

Oh, and encountering an unknown type should probably toss an error...

-Eric
