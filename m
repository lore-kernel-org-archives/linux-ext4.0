From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: [E2FSPROGS, RFC] New mke2fs types parsing
Date: Mon, 17 Mar 2008 22:20:53 -0400
Message-ID: <20080318022053.GL8368@mit.edu>
References: <E1JRpaN-0000Bs-4N@closure.thunk.org> <47BC76A9.307@redhat.com> <20080220222019.GG30305@mit.edu> <47DEE2AE.1050105@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:35049 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753014AbYCRCVi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 17 Mar 2008 22:21:38 -0400
Content-Disposition: inline
In-Reply-To: <47DEE2AE.1050105@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 17, 2008 at 04:29:18PM -0500, Eric Sandeen wrote:
> > #3) Once it has the list of types, i.e., "ext3,defaults,squid", or
> > "ext2,floppy,rescue", "ext4,defaults,largefile", etc. it uses this as
> > a search path when mke2fs needs to look up some parameter, such as
> > "base_features", or "inode_size", etc.  
> 
> I started to look into updating the man page for this but it led to
> several questions, and a suggestion....
> 
> Is this intended to take exactly 1, 2, or 3 arguments?  If so is it
> always "type," "size," "usepattern?"  (ext4,small,news for example)

No, not necessarily.  The user could specify something like

-T tpc-h,tweak1,tweak2

which would then cause mke2fs to look for the stanza's ext4, large,
tpc-h, tweak1, tweak2.  What that means would be purely up to the user
who sets up the configuration file.

> Can I specify ext4,defaults,news as well as ext4,news,defaults or does
> order matter - it seems that it does.

Order does matter, because in the example above, tunings in tpc-h
override tunings made the ext4 and large stanza's, while configuration
tunings in tweak1 will overide those in tpc-h and before, and tweak2
will override tweak1 and before, etc.

> Should it bail out if a stanza is not found (-T foo,bar,baz?)  Today it
> does not.

Hmm... good question.  That would be good if someone were to typo a
type string.

> From looking at & playing with the code it seems like it is supposed to
> be explicitly type, size, usepattern, although sometimes it doesn't get
> it right, for example this:
> 
> misc/mke2fs -T ext5,floppy,news  fsfile
> 
> leads to:
> 
> fs_types: 'ext2', 'small', 'ext5', 'floppy', 'news'
> 
> hmm...

Well, "ext5" isn't a valid filesystem type.

Also, most of the time I don't expect users to actually specify the
type and size all the time.  Normally they won't do that.  I would
expect that most of the size will be automated added by mke2fs, based
on the size of the of the partition.  The filesystem type will be
added automatically if the user uses /sbin/mkfs.ext3 or
/sbin/mkfs.ext4, or via defaults.fs_type type in the configuration
file.

> Also if these 3 positions have special meanings and orders, it's odd to
> not have that reflected in the config file stanzas somehow...

I'm not sure what you mean by that.

> It seems to me that perhaps instead of specifying that each
> comma-delimited position has a specific meaning, perhaps it should just
> be: "comma separated list which indicates profiles from least to most
> specific, with values & features from more specific (later) profiles
> trumping less specific (earlier) profiles" - would this be more clear &
> flexible...?

I'd probably using "overridding" instead of "trumping", but yes.

> Oh, and encountering an unknown type should probably toss an error...

You mean, a type which doesn't have a profile stanza, as mentioned
above?  Or did you mean something else?

					- Ted
