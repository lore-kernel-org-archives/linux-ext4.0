From: Phillip Susi <phillsusi@gmail.com>
Subject: Re: getdents - ext4 vs btrfs performance
Date: Tue, 13 Mar 2012 15:05:59 -0400
Message-ID: <4F5F9A97.5060404@ubuntu.com>
References: <CADDYkjS5VJeYyHzqumazQ0qKg+HwA6GO+zYSJj7rkHNZFwjcoQ@mail.gmail.com> <alpine.LFD.2.00.1203091158430.4487@dhcp-27-109.brq.redhat.com> <BCAD47C1-B95A-4EDB-8EFB-3D4E325DE57D@whamcloud.com> <20120310044804.GB5652@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: Ted Ts'o <tytso@mit.edu>, Andreas Dilger <adilger@whamcloud.com>,
	Lukas Czerner <lczerner@redhat.com>,
	Jacek Luczak <difrost.kernel@gmail.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20120310044804.GB5652@thunk.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 3/9/2012 11:48 PM, Ted Ts'o wrote:
> I suspect the best optimization for now is probably something like
> this:
>
> 1) Since the vast majority of directories are less than (say) 256k
> (this would be a tunable value), for directories which are less than
> this threshold size, the entire directory is sucked in after the first
> readdir() after an opendir() or rewinddir().  The directory contents
> are then sorted by inode number (or loaded into an rbtree ordered by
> inode number), and returned back to userspace in the inode order via
> readdir().  The directory contents will be released on a closedir() or
> rewinddir().

Why not just separate the hash table from the conventional, mostly in 
inode order directory entries?  For instance, the first 200k of the 
directory could be the normal entries that would tend to be in inode 
order ( and e2fsck -D would reorder ), and the last 56k of the directory 
would contain the hash table.  Then readdir() just walks the directory 
like normal, and namei() can check the hash table.

