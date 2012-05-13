From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH RESEND] implement uid and gid mount options for ext2,
 ext3 and ext4
Date: Sun, 13 May 2012 14:46:19 +0300
Message-ID: <4FAF9F0B.4010305@panasas.com>
References: <1336660924-9598-1-git-send-email-ludwig.nussel@suse.de> <20120511034945.GA15892@mobil.systemanalysen.net> <4FAD2161.3090108@landley.net> <20120511164605.GC6467@thunk.org> <4FAD49EB.5010804@panasas.com> <20120511192235.GE6467@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: "Ted Ts'o" <tytso@mit.edu>, Rob Landley <rob@landley.net>,
	Ludwig Nussel <ludwig.nussel@suse.de>,
	<linux-kernel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
	Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andreas Dilger <adilger.kernel@dilger.ca>, open list:
	EXT2 FILE SYSTEM <linux-ext4@vger.kernel.org>, ; open list:
	DOCUMENTATION <linux-doc@vger.kernel.org>, ;
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <20120511192235.GE6467@thunk.org>
Sender: linux-doc-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 05/11/2012 10:22 PM, Ted Ts'o wrote:

> On Fri, May 11, 2012 at 08:18:35PM +0300, Boaz Harrosh wrote:
>> How is that ext* special? You said "Unix systems" there are lots more
>> FSs more common to "Unix" systems
> 
> Well, because FreeBSD, NetBSD, and Hurd do support ext2/3*.  So if you
> want a file system which is higher performance than VFAT, and
> supported on Unix-like systems beyond Linux, ext* is the best choice
> in a number of cases.
> 


That was a rhetorical questions. I meant  ext* is not special. There
are plenty of other FFs that are common to unix systems.

> As far as NTFS is concerned, the *BSD's can only support NTFS via
> FUSE, and I've been suspicious about the quality of our ntfs support
> under Linux --- we don't have a full-featured fsck for it, for
> example.  I'm at least not comfortable using NTFS on my personal
> machines.  (Last I checked there were all sorts of asterisks about
> data corruption if the system crashed before Linux mounted it, since
> apparently NTFS's logging subsystem was never reverse-engineered.)
> 


No! on all modern Linux distro's ntfs (ntfs-3g) is supported with
that infamous FUSE driver. The Kernel driver is long dead. The same
FUSE driver is also used under *BSD and officially supported by
Apple in OSX. Last benchmarks I saw where Faster then ext2 and in-par
with ext3, MetaData faster, IO slower then ext3. Stability is very
good and I never had an issue, on any of the above systems.

There is also a very good fsck and a suit of other tools under the same
ntfs-3g project. To date I have fixed 10s of friends/family Windows
machines with a Linux rescue USB-stick, I mean machines that would even
boot.

>> As a maintainer of ext4 filesystem which is the official system for
>> Linux in many distrows, still. Please resists any such crap.
>> User "convenience-vs-security was never a geol of Unix.
> 
> Did you look at the proposal I made?  By making it something where the
> file system is explicitly marked as "for interchange", it avoids the
> security problem (as much as you can when you put your unencrypted
> data on removable, portable storage which could be lost or stolen).
> 
> Sure, if you don't need to operate on the data as a mounted file
> system, tar or cpio or zip is a good choice for maximal portability.
> But if you want to do something like rsync on a portable SSD, 


Again, for the last time, you are the maintainer, you do what you
understand, I hope Linus or someone can make it more clear than me.

There is nothing special about USB sticks and ext* filesystems it
is the same old "shared files" problem. If you are not under a single
NIS domain, then these are different users. If files need to be shared
they need to sit in the proper CHMODed directory and bits.

I have at home a bittorent network directory for the all family, So the
first time I set it up I had to ssh into the server and fix the permissions.
That was easy enough listen to learn.

For the last time and I'm off this for good:
	"Shared files" problem is not solved by mount options.

Been there done that


<snip>
