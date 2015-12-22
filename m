From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Subject: Re: Ideas on unified real-ro mount option across all filesystems
Date: Tue, 22 Dec 2015 07:41:04 -0500
Message-ID: <567944E0.6040908@gmail.com>
References: <567212DA.8050808@cn.fujitsu.com> <567228EF.80007@redhat.com>
 <5673616C.1040706@cn.fujitsu.com> <1450404066.6498.70.camel@scientia.net>
 <20151222023221.56a89345@jupiter.sol.kaishome.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Kai Krakow <hurikhan77@gmail.com>, linux-btrfs@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20151222023221.56a89345@jupiter.sol.kaishome.de>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 2015-12-21 20:32, Kai Krakow wrote:
> Am Fri, 18 Dec 2015 03:01:06 +0100
> schrieb Christoph Anton Mitterer <calestyo@scientia.net>:
>
>> The manpage says:
>>> ro     Mount the filesystem read-only.
>>> rw     Mount the filesystem read-write.
>
> That means: the filesystem... Not the block device...
No, that means: That particular instantiation of the VFS layer to access 
the filesystem.
Not the filesystem (the filesystem is the data and metadata on disk), 
not the block device (which is an abstraction used as a container for 
the filesystem).
>
> Sorry, it's kinda nitpicking. But actually, the file system IS
> read-only: You cannot modify files from user's view.
 From a non technical view point, yes, that is correct; until you have 
undetected corruption in the journal or log or whatever other structure 
is used for consistency, at which point it isn't read-only because the 
filesystem just changed by virtue of you mounting it (and even without 
that type of corruption, stuff gets changed on a 'read-only' mount 
regardless in many filesystems, many of them track when the filesystem 
was last mounted, how many times it's been mounted, and other similar 
things).
>
> What you actually want is not modifying the underlying storage which is
> the block device and includes stuff like meta and journal data (which
> is only indirectly visible to users at best).
No, the metadata and journal are a integral part of the filesystem 
itself.  Without those, there is no filesystem.  That and the metadata 
_is_ directly visible to the user, in the form of directory structure, 
stat(), output from lsattr, and even stuff like FIEMAP and filefrag.

The filesystem _is_ the data and metadata on disk, as such, the 
filesystem being read-only means that none of that data or metadata 
should change.
>
> You can argue that man pages are not particularly end-user friendly.
> But for an admin this makes sense without being an fs developer.
That really depends.  I'm not a FS developer, but I still expect when I 
see 'read-only' that it means the same as 'immutable for everything 
managed by that particular object that has been made read-only, for all 
access methods through that object'.  And while I bet most 
administrators wouldn't use quite the same terminology, I would be 
willing to bet that many of them have essentially the same expectation 
unless specifically told otherwise on a case-by-case basis.
