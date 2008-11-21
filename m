From: Theodore Tso <tytso@mit.edu>
Subject: Re: Maximum filename length
Date: Fri, 21 Nov 2008 17:32:48 -0500
Message-ID: <20081121223248.GA22671@mit.edu>
References: <87a8dc10811210451p3ec1e3dar371a3ebffcedcdc@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Alexey Salmin <alexey.salmin@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:49039 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751395AbYKUWdG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 21 Nov 2008 17:33:06 -0500
Content-Disposition: inline
In-Reply-To: <87a8dc10811210451p3ec1e3dar371a3ebffcedcdc@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Nov 21, 2008 at 06:51:23PM +0600, Alexey Salmin wrote:
> But there is one limitation looking tiny against these Tera-
> and Exbi-bytes: maximum filename length is 255 bytes. Is 255
> characters enough? I think it's enough for the vast majority of users.
> But there is one problem: 255 bytes and 255 characters are no longer
> equal. Multibyte encodings are spreading fast and it should be taken
> into account. For a long time I was using the simple koi8-r encoding
> and it was enough. Even when my favorite debian distribution moved to
> utf8 I was still keeping it.

Yeah, unfortunately Unicode and UTF-8 is unfortunate for the Cyrillic
and Greek alphabets, since they are non-Latin alphabets where multiple
characters form a word.  For most writing systems, they either use a
single glyph to represent a word (such as the CJK, or
Chinese-Japanese-Korean characters), or they are based on the Latin
alphabet, so in those writing systems, only a few characters in
practice require glyphs that are encoded using two bytes, and most
require only one byte.

> Actually I'm lucky having only two bytes per character,
> utf8-character can contain up to 4 bytes which reduces the limit to 63
> characters. Really I see no reasons for keeping such a terrible

In practice the bulk of the characters which require 3 bytes to encode
are used to denote a word (which in most other languages might be
encoded in 3 to 20 letters).  There are a few writing systems that
have letters encoded above U+0800, and so require 3 bytes per letter,
but they tend to be "niche" languages that are rarely used in
computing.  For example, the Buhid script, which is spoken by the
indigenous people Mangyans, which lives in the province of Mindoro in
the Phillipines, and which has about 8,000 speakers in the world,
utilize Unicode characters U+1740 through U+175F, and so require 3
bytes per character.  The Native American Cherokee language, which has
about 10,000 speakers in the world, uses Unicode symbols U+13A0
through U+13F4, and similarly needs 3 bytes per character.

Characters that require 4 bytes to encode are needed to encode Unicode
symbols above U+10000, which are used primarily by dead languages
(i.e., no one alive speaks it as their primary language --- and in
some cases, no one alive has any idea how to speak it).  For example
the Linear B script, which was used in Mycenaean civilization sometime
around the 13th and 14th century BC (i.e., over 3 millennia ago) is
assigned Unicode characters U+10000 through U+100FF, and so would
require 4 bytes per Linear B glyph to encode.  However, aside from
researchers in ancient languages, it is doubtful anyone would actually
be using it, and it's even less likely anyone would be trying to
catalog books or mp3 filenames using Linear B glyphs.  :-)


So in practice, in terms of the common languages that are likely to be
used in computing that are based on phomemes (i.e., such as most
European, Russian, Greeek writing systems) as opposed to ideographs
(i.e., the CJK writing systems) Russian, Greek, Hewbrew, and Arabic
are the unlucky ones that are not based on a Latin-1 alphabet, and
have this problem where 2 bytes are required.  Curiously enough, its
generally people using the Cyrillic alphabet that tend to complain; I
suspect that it has the largest number of users who are likely to use
those letters in computing.  (In practice, not many people complain
about Hewbrew writing systems, and I suspect that it's partially
because of the relative difference in the number of people using the
Hewbrew writing system as compared to the Cyrillic, and also that most
Israeli computer folk I know tend to do most of the computing work in
English, and not in Hewbrew.)

> Really I see no reasons for keeping such a terrible
> limitation. Ext4 branch was created because there were to many things
> to change compared to ext3. And it's very sad that such a simple
> improvement was forgotten :(

It wouldn't be _that_ hard to add an extension to ext4 to support
longer filenames (it would mean a new directory entry format, and a
way of marking a directory inode as to whether the old or new
directory format was being used).  Unfortunately, the 255 byte limit
is encoded not only in the filesystem, but also in the kernel.
Changing it in the kernel is not just a matter of a #define constant,
but also fixing places which put filename[NAME_MAX] on the stack, and
where increasing NAME_MAX might cause kernel functions to blow the
limited stack space available to kernel code.  In addition, there are
numerous userspace and in some cases, protocol limitations which
assume that the total overall length of a pathname is no more than
1024 bytes.  (I suspect there is at least userspace code that also
would blow up if an individual pathname exceeded NAME_MAX, or 256
bytes.)

So the problem is that even if we were to add that enhancement to
ext4, there are lots of other things, both in and outside of the
kernel, that would likely need to be changed in order to support this.
I will say personally that its rare for me to use filenames longer
than 50-60 characters, just because they are a pain in the *ss to
type.  However, I can see how someone using a graphical interface
might be happy with filenames in the 100-120 character range.  The
question though is whether it is worth trying to fix this by
increasing the filename length beyond 255 bytes or not, given the
amount of effort that would be required in the kernel, libc,
userspace, etc.

					- Ted
