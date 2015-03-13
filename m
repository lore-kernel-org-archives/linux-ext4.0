From: "Dilger, Andreas" <andreas.dilger@intel.com>
Subject: Re: Ext4 Encryption design document
Date: Fri, 13 Mar 2015 23:43:56 +0000
Message-ID: <D127E653.E5541%andreas.dilger@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:55631 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751826AbbCMXn6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 13 Mar 2015 19:43:58 -0400
Content-Language: en-US
Content-ID: <C780A140EE21DA4882DE8A97B6E99D78@intel.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 12 Mar 14:42 2015, Theodore Ts'o <tytso@mit.edu> wrote:
> Per our discussions this morning, here is the ext4 encryption design
>document
> 
> 
>https://docs.google.com/document/d/1ft26lUQyuSpiu6VleP70_npaWdRfXFoNnB8JYn
>ykNTg/edit?usp=sharing


A few comments on this design:

Protector Format
> Format			Currently 0
> Contents Encryption mode	0 = AES-256-XTS
> Name encryption mode		0 = AES-256-CBC

It would be better to keep "0" for "unused" or "invalid", and make the
first assigned
value be 1 for all of these fields.  That avoids the problem if this
structure is used
uninitialized for some reason (software bug, bad read from disk, memory
clobbered, etc)
and it picks the wrong encryption algorithm.

Is there enough room to add another 4 bytes of padding before the master
key descriptor,
so that it and the following nonce are aligned on an 8-byte boundary and
the struct size
is a nice power-of-two value, and there is a bit more room for future
expansion (e.g.
number of key descriptors)?

In the future, if there are multiple keys attached to a file, how will
they be stored?
Will there be an array of key descriptors in this xattr?  Using multiple
xattrs seems
wasteful.  Even if this is not being implemented in the first version, it
makes sense
to understand what needs to be done to avoid the need for on-disk format
change later.

Encryption Policy
> struct ext4_encryption_policy {
>       char version;
>       char contents_encryption_mode;
>       char filenames_encryption_mode;
>       char master_key_descriptor[8];
> } __attribute__((__packed__));

One byte of padding in there?  The xattr itself will be stored 4-byte
aligned on disk,
so leaving out the one byte in the middle of the struct is not saving any
space.

Background on EXT4 Directories
> A filename consists of a string of one or more ASCII characters.

That isn't really true.  A filename is a string of one or more characters
in some
user-defined encoding, with the only restriction that the characters '/'
and '\0' are
not permissible.  Many users use ext4 with non-ASCII character sets w/o
problems.

It is great if the output is only ASCII printable characters, but that may
be difficult
to do if the filename length is required to be the same as the input name
length
(e.g. there are ~253 possible single-character non-ASCII filenames, but
only about 96
printable ASCII characters, so these would always result in collisions if
the filename
length needs to stay the same).  Is my assumption about the output name
length wrong?

In further reading, it seems like the encoded output filename would be
expanded,
and could be as long as 255 * 4/3 = 340 characters, which will exceed
f_namelen.
I'd imagine that the dcache can handle that, but are there problems if
f_namelen
is shorter than the returned name, or conversely if f_namelen is increased
but it
isn't possible to create a filename that long?

Cheers, Andreas
-- 
Andreas Dilger

Lustre Software Architect
Intel High Performance Data Division


