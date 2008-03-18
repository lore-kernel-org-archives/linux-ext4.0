From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [E2FSPROGS, RFC] New mke2fs types parsing
Date: Mon, 17 Mar 2008 22:23:56 -0500
Message-ID: <47DF35CC.7020604@redhat.com>
References: <E1JRpaN-0000Bs-4N@closure.thunk.org> <47BC76A9.307@redhat.com> <20080220222019.GG30305@mit.edu> <47DEE2AE.1050105@redhat.com> <20080318022053.GL8368@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:53973 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751558AbYCRDYT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 17 Mar 2008 23:24:19 -0400
In-Reply-To: <20080318022053.GL8368@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso wrote:
> On Mon, Mar 17, 2008 at 04:29:18PM -0500, Eric Sandeen wrote:
>>> #3) Once it has the list of types, i.e., "ext3,defaults,squid", or
>>> "ext2,floppy,rescue", "ext4,defaults,largefile", etc. it uses this as
>>> a search path when mke2fs needs to look up some parameter, such as
>>> "base_features", or "inode_size", etc.  
>> I started to look into updating the man page for this but it led to
>> several questions, and a suggestion....
>>
>> Is this intended to take exactly 1, 2, or 3 arguments?  If so is it
>> always "type," "size," "usepattern?"  (ext4,small,news for example)
> 
> No, not necessarily.  The user could specify something like
> 
> -T tpc-h,tweak1,tweak2
> 
> which would then cause mke2fs to look for the stanza's ext4, large,

Hm, where did "ext4" and "large" come from?  From being called as
mkfs.ext4 on a large block device?

> tpc-h, tweak1, tweak2.  What that means would be purely up to the user
> who sets up the configuration file.

ok... but I think *if* you are going to specify fs type and size, then
they must be in the 1st and 2nd positions right?  I'm just going by the
stuff like:

                if (state == 1) {
                        if (strcmp(cp, "ext2") &&
                            strcmp(cp, "ext3") &&
....

which looks like fs type is explicitly checked on the fist pass?

IOW if I do a (silly) -T string like ext3,floppy,largefile I get:

fs_types: 'ext3', 'floppy', 'largefile'

but if I do -T floppy,ext3,largefile I get:

fs_types: 'ext2', 'floppy', 'ext3', 'largefile'

so in this case I guess I have "ext2" overriding defaults before the
others, when in the first case I did not?  And depending on how [ext2]
is defined, this might matter.

>> Can I specify ext4,defaults,news as well as ext4,news,defaults or does
>> order matter - it seems that it does.
> 
> Order does matter, because in the example above, tunings in tpc-h
> override tunings made the ext4 and large stanza's, while configuration
> tunings in tweak1 will overide those in tpc-h and before, and tweak2
> will override tweak1 and before, etc.

Right, for the named various named stanzas, it does matter in terms of
what is more specific.  But, I meant "if I want to specify ext3 does it
have to be first," and I think it does, because otherwise the algorithm
picks ext2 for me...?

>> Should it bail out if a stanza is not found (-T foo,bar,baz?)  Today it
>> does not.
> 
> Hmm... good question.  That would be good if someone were to typo a
> type string.

I think so.  Otherwise it's silently dropped/ignored which is probably
not as planned.

>> From looking at & playing with the code it seems like it is supposed to
>> be explicitly type, size, usepattern, although sometimes it doesn't get
>> it right, for example this:
>>
>> misc/mke2fs -T ext5,floppy,news  fsfile
>>
>> leads to:
>>
>> fs_types: 'ext2', 'small', 'ext5', 'floppy', 'news'
>>
>> hmm...
> 
> Well, "ext5" isn't a valid filesystem type.

but it could be a valid name of a stanza, right.  :)  My point is that
there are a few things treated specially - type and size, I guess -
which need to be in the right positions, or they will get filled in with
default values, near as I can tell.

> Also, most of the time I don't expect users to actually specify the
> type and size all the time.  Normally they won't do that.  I would
> expect that most of the size will be automated added by mke2fs, based
> on the size of the of the partition.  The filesystem type will be
> added automatically if the user uses /sbin/mkfs.ext3 or
> /sbin/mkfs.ext4, or via defaults.fs_type type in the configuration
> file.

Sure, but if -T is an option to mke2fs it still has to work clearly &
consistently.

>> Also if these 3 positions have special meanings and orders, it's odd to
>> not have that reflected in the config file stanzas somehow...
> 
> I'm not sure what you mean by that.

I mean that we have a few "special" stanza names:

[ext2], [ext3], [ext4], [ext4dev]
[floppy], [small], [default]

which have some special meaning, (types and sizes), and will get filled
in for you if you don't specify them, right?

And for all the rest you can make [grandmas_cookies] or whatever you want.

But near as I can tell I have to specify type and size in the first two
slots or I get a different outcome.

>> It seems to me that perhaps instead of specifying that each
>> comma-delimited position has a specific meaning, perhaps it should just
>> be: "comma separated list which indicates profiles from least to most
>> specific, with values & features from more specific (later) profiles
>> trumping less specific (earlier) profiles" - would this be more clear &
>> flexible...?
> 
> I'd probably using "overridding" instead of "trumping", but yes.

Details. ;)

I guess what I'm driving at is this: should the "if state == 1" and "if
state == 2" tests go away, and just handle each comma-separated type
completely equally.  I'd thinkg that -T news,largefile,ext4 should work
- news should override all defaults, largefile should override anything
thus far, and ext4 should have the final say for anything it specifies;
but do not fill in "ext2, small" for me first as it does today:

mke2fs -T news,largefile,ext4  fsfile

yields:

fs_types: 'ext2', 'small', 'news', 'largefile', 'ext4'

the above is unclear/unexpected behavior, IMHO.  I'd expect simply:

fs_types: 'news', 'largefile', 'ext4'

because that is what I specified.

>> Oh, and encountering an unknown type should probably toss an error...
> 
> You mean, a type which doesn't have a profile stanza, as mentioned
> above?  Or did you mean something else?

right, any comma-delimited type which isn't actually found somewhere
should probably cause mkfs to stop with an error.

Thanks,
-Eric

> 					- Ted

