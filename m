From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [E2FSPROGS, RFC] New mke2fs types parsing
Date: Thu, 20 Mar 2008 14:17:36 -0500
Message-ID: <47E2B850.2080801@redhat.com>
References: <E1JRpaN-0000Bs-4N@closure.thunk.org> <47BC76A9.307@redhat.com> <20080220222019.GG30305@mit.edu> <47DEE2AE.1050105@redhat.com> <20080318022053.GL8368@mit.edu> <47DF35CC.7020604@redhat.com> <20080318042339.GO8368@mit.edu> <47DF5045.1000108@redhat.com> <20080318110145.GQ8368@mit.edu> <47DFBF84.5070207@redhat.com> <20080318135254.GA27000@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:51230 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754458AbYCTTR7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 20 Mar 2008 15:17:59 -0400
In-Reply-To: <20080318135254.GA27000@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso wrote:
> On Tue, Mar 18, 2008 at 08:11:32AM -0500, Eric Sandeen wrote:
>> Theodore Tso wrote:
>>
>>> I rejected this approach originally because it would mean reusing the
>>> -t option right away.  But maybe this would be easier for users to
>>> understand, and easier to document in the man pages, and maybe that's
>>> an overriding consideration.
>> well, I doubt the man page should override much ;)
>>
>> I just wanted to air the concerns & my ideas... if, having considered
>> them, you're still happy with the original approach, that's fine with me.
> 
> Sure, but making things easier to understand is important.  So we
> trade off making "mke2fs -t" doing something different between 1.40
> and 1.41, with something that might be easier to understand.
> 
> So what do people think about this proposal as an alternative to
> what's been discussed?

So I was playing with another option here (sorry, can't stop beating
this dead horse...)

Rather than *looking* for extN and size type in the magic first and
second slots, what if we fill them in there internally, but they will be
overridden by any other -T options specified.

Internally, first an extN type is picked up from mkfs.FOO first, or
defaults fs type if not specified.  Seond, also internally, a size type
is chosen next from the default size breakpoints.

So in that case, ext type and size type can be specified anywhere by the
user, and there is no magic; it just follows the precedence from the
order, and the default internal types can be overridden.

So if for example you specify "mkfs.ext3 -T ext4" it's a little
nonsensical, but internally the types are "ext3,ext4" and it's just
normal precedence from then on; anything not specified in ext4 is picked
up from ext3, else defaults.

If we craft the default ext3 and ext4 types properly, then this all
makes good sense, IMHO.

Likewise, if you do "mkfs.ext3 -T floppy" on a filesystem that would
otherwise be "small", internally it's "ext3,small,floppy" but any
size-related types will be found in the last-specified option, "floppy"
and since floppy re-specifies everything found in "small" the small
values are completely overridden.

Does this seem sane?

The man page would be something like:

-T fs-type1,fs-type2,...fs-typeN

	Specify filesystem types in a comma-separated list,
	with later types taking precedence over earlier types.

	The types that can be supported are defined in the
	mke2fs configuration file /etc/mke2fs.conf(5), and
	are used to set the filesystem geometry and features.

	Internally, two fs-types will always be placed ahead
	of any types specified on the commandline.

	First, an extN fs-type will be placed on the list.
	If called as mkfs.ext2, mkfs.ext3, or mkfs.ext4,
	the corresponding fs-type (ext2, ext3, or ext4)
	will be chosen.  Otherwise, an extN fs-type will
	be taken from the fs_type parameter in the [defaults]
	section of the configuration file.  If no extN type
	is found anywhere, the default will be ext2.

	Second, a default size type of "floppy," "small," or
	"default" will be chosen based on the device size
	and placed next on the internal list.

	These two internally-added fs-types can be overridden
	by specifying a -T fs-type which will take precendence
	and override those internal types' parameters.

Is this any simpler/clearer?

-Eric
