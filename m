From: Nick Alcock <nick.alcock@esperi.org.uk>
Subject: Re: Trouble mounting metadata_csum ext4 filesystems with v4.7.x after c9274d891869880648c4ee9365df3ecc7ba2e285: not enough inode bytes checksummed?
Date: Thu, 05 Jan 2017 11:09:37 +0000
Message-ID: <87bmvliwzy.fsf@esperi.org.uk>
References: <87zin42crs.fsf@esperi.org.uk>
        <20160920055216.GD9309@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain
Cc: "Theodore Ts'o" <tytso@mit.edu>,
        Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
        daeho.jeong@samsung.com, linux-ext4 <linux-ext4@vger.kernel.org>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20160920055216.GD9309@birch.djwong.org> (Darrick J. Wong's
        message of "Mon, 19 Sep 2016 22:52:16 -0700")
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

[Aside: This got misfiltered into a mailbox with a typo in the name,
 more or less electronic oblivion. I just recovered it while preparing
 to migrate to notmuch. Sorry for the huge delay.]

On 20 Sep 2016, Darrick J. Wong stated:

> [cc Ted and the ext4 list]
>
> On Mon, Sep 19, 2016 at 03:19:03PM +0100, Nix wrote:
>> We are not checksumming enough bytes! We used to checksum the entire
>> 256-byte inode: now, we checksum only 130 bytes of it, which isn't even
>> enough to cover the 28-byte extra_isize on this filesystem and is more
>> or less guaranteed to give the wrong answer. I'd fix the problem, but I
>> frankly can't see how the new code is meant to be equivalent to the old
>> code in any sense -- most particularly what the stuff around dummy_csum
>> is meant to do -- so I thought it better to let the people who wrote it
>> fix it :)
[...]
> Sh*t, I missed this during the review.  So your filesystem image (thank
> you!) had this to say:

e2image is *such* a good program. :)

> debugfs> stats
> Inode size:               256
> debugfs> stat <8>
> Size of extra inode fields: 0
>
> Basically, a 128-byte inode inside a filesystem that allocated 256 bytes
> for each inode.

This was due to the change in mke2fs defaults catching me out, long ago:
I was assuming a 128-byte inode was the default, but it wasn't, or I'd
have changed things and avoided wasting the space...

I tried using inline data to save the space again (again, in the v4.7.x
period) and had a bit of a disaster a few weeks later: running dovecot's
configure with the srcdir and objdir on an inline data filesystem leads
to an oops shortly afterwards and massive data corruption on remount.
I'll whip up a replication case for this fairly soon. I suspect shared
writable mmap is being evil again.

> never bother to checksum anything after that.  This is of course wrong
> since we no longer checksum the xattr space and we've deviated from the
> pre-4.7.4 (documented) on-disk format.

... and of course that'll lead to checksum failures, and thanks to
metadata checksums this is instantly obvious! :)

> *FORTUNATELY* since the root inode fails the read verifier, the file (in
> this case the root dir) can't be modified and therefore nothing has been
> corrupted.  Especially fortunate for you, the fs won't mount, reducing
> the chances that any serious damage has occurred.

Even if it had, nothing too bad would result. There's a reason I do
hourly-and-daily backups, and keep new features switched well and truly
off on the backup filesystem!

> I /think/ the fix in this case is to hoist the last ext4_chksum call
> out of the EXT4_FITS_IN_INODE blob:

I'll give that a try this weekend. Sorry for the huge delay!

>> ... The mystery is why this isn't going wrong anywhere else: I have
>> metadata_csum working on every fs on a bunch of other ext4-using
>> systems, and indeed on every filesystem on this machine as well, as long
>> as c9274d8 is not applied. Many of them are similarly upgraded pre-csum
>> fses with the same inode size and extra_isize, but they work...
>
> Hard to say, but this bug only affects inodes with 0 < i_extra_size <= 4
> i.e. 128 < inode-core-size <= 130.  Maybe an old ext3 fs that was
> created with 256 bytes per inode but inode-core-size of 128?

It was ext4 from the start, created with -i 128, inode_size = 256.

> Uck.  Sorry about this mess.

Sorry I overlooked your rapid response for so long!

-- 
NULL && (void)
