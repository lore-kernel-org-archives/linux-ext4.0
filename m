From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Ext4 slow on links
Date: Wed, 20 Jun 2012 23:05:59 -0500
Message-ID: <4FE29DA7.40405@redhat.com>
References: <20120620051844.GA7829@gamma.logic.tuwien.ac.at> <4FE1D993.8090307@redhat.com> <20120620002014.GA25471@gamma.logic.tuwien.ac.at> <4FE14034.6070800@redhat.com> <20120620002014.GA25471@gamma.logic.tuwien.ac.at> <20120620021912.GA26323@thunk.org> <20120620033831.GA2395@gamma.logic.tuwien.ac.at> <BA050E9A-2385-4FF9-B41A-3A25F3FF066A@redhat.com> <20120620051844.GA7829@gamma.logic.tuwien.ac.at> <4FE1D91B.8020707@redhat.com> <20120621022818.GD9669@gamma.logic.tuwien.ac.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Ted Ts'o" <tytso@mit.edu>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Norbert Preining <preining@logic.at>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34088 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751165Ab2FUEGL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 21 Jun 2012 00:06:11 -0400
In-Reply-To: <20120621022818.GD9669@gamma.logic.tuwien.ac.at>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 6/20/12 9:28 PM, Norbert Preining wrote:
> Hi Eric,
> 
> thanks a lot for looking into that.
> 
> On Mi, 20 Jun 2012, Eric Sandeen wrote:
>> so almost all reads, and no read merges; almost 35 megabytes read and every
>> one was a small 4k IO.
> 
> Ouch, that hurts.
> 
> On Mi, 20 Jun 2012, Eric Sandeen wrote:
>> Would you be willing to provide an "e2image -r" image of the filesystem?
> 
> Ok, it is running now since a few hours and I am far from finished
> I guess, since there are 350+G on the fs, and the compressed image
> is by now 200M.
> 
> Is it fine to do it on a running system, or do I have to boot
> from USB or so?

Well, don't bother, sorry.  See below.  Zach had it right.

> If it is not toooo big I will tr to upload it to some place were
> you can get access to.
> 
> On Mi, 20 Jun 2012, Eric Sandeen wrote:
>> Oh, but Zach Brown reminds me that if we stat the entries in getdents/hash
>> order, it's roughly random w.r.t. disk location.  Newer utils will sort into
>> inode order, I think(?)  Might be interesting to strace the ls -l and see
>> if it's doing it in inode order, or not.
> 
> Ok, is there a special option to strace, or -trace=all?

if you do 

# strace -v -o outfile ls -l 

you'll see things like:

getdents(3, {{d_ino=249052, d_off=186216735, d_reclen=32, d_name="file3"} {d_ino=245882, d_off=473549160, d_reclen=24, d_name="."} {d_ino=249051, d_off=516459536, d_reclen=32, d_name="file2"} {d_ino=249055, d_off=545762253, d_reclen=32, d_name="file6"} {d_ino=249049, d_off=550416647, d_reclen=32, d_name="file1"} ...

and from there see that the entries returned  are not in inode order (and therefore not in disk order).

and lstats after that, also out of order:

# grep lstat outfile
lstat("file3", {st_dev=makedev(8, 8), st_ino=249052, st_mode=S_IFLNK|0777, st_nlink=1, st_uid=0, st_gid=0, st_blksize=4096, st_blocks=8, st_size=13, st_atime=2012/06/20-22:13:08, st_mtime=2012/06/20-22:13:07, st_ctime=2012/06/20-22:13:07}) = 0
lstat("file2", {st_dev=makedev(8, 8), st_ino=249051, st_mode=S_IFLNK|0777, st_nlink=1, st_uid=0, st_gid=0, st_blksize=4096, st_blocks=8, st_size=13, st_atime=2012/06/20-22:13:08, st_mtime=2012/06/20-22:13:07, st_ctime=2012/06/20-22:13:07}) = 0
lstat("file6", {st_dev=makedev(8, 8), st_ino=249055, st_mode=S_IFLNK|0777, st_nlink=1, st_uid=0, st_gid=0, st_blksize=4096, st_blocks=8, st_size=13, st_atime=2012/06/20-22:13:08, st_mtime=2012/06/20-22:13:07, st_ctime=2012/06/20-22:13:07}) = 0
lstat("file1", {st_dev=makedev(8, 8), st_ino=249049, st_mode=S_IFLNK|0777, st_nlink=1, st_uid=0, st_gid=0, st_blksize=4096, st_blocks=8, st_size=13, st_atime=2012/06/20-22:13:08, st_mtime=2012/06/20-22:13:07, st_ctime=2012/06/20-22:13:07}) = 0
...

later on you'll see readlinks:

# grep readlink outfile
readlink("file3", "../dir2/file3", 14)  = 13
readlink("file2", "../dir2/file2", 14)  = 13
readlink("file6", "../dir2/file6", 14)  = 13
readlink("file1", "../dir2/file1", 14)  = 13
...

etc.

Hm.  Upstream coreutils fixed this for rm and some other ops:

http://git.savannah.gnu.org/cgit/coreutils.git/commit/?id=24412edeaf556a

# grep unlink /tmp/rm-strace 
unlink("file1")                         = 0
unlink("file10")                        = 0
unlink("file2")                         = 0
unlink("file3")                         = 0
unlink("file4")                         = 0
unlink("file5")                         = 0
unlink("file6")                         = 0
unlink("file7")                         = 0
unlink("file8")                         = 0
unlink("file9")                         = 0

but maybe not for ls -l

You could see if you could get this LD_PRELOAD working:

http://git.kernel.org/?p=fs/ext2/e2fsprogs.git;a=blob_plain;f=contrib/spd_readdir.c

build & enable with:

gcc -o spd_readdir.so -fPIC -shared spd_readdir.c -ldl
export LD_PRELOAD=`pwd`/spd_readdir.so

and see if that addresses the problem; 

here, it does for me:

# grep readlink outfile2 
readlink("file1", "../dir2/file1"..., 14) = 13
readlink("file10", "../dir2/file10"..., 15) = 14
readlink("file2", "../dir2/file2"..., 14) = 13
readlink("file3", "../dir2/file3"..., 14) = 13
readlink("file4", "../dir2/file4"..., 14) = 13
readlink("file5", "../dir2/file5"..., 14) = 13

I'm guessing that operating in inode order should help
you a bit, at least.  I tested on a dir w/ 10,000 long symlinks
with and without the sorting, and you can see the difference pretty
clearly.

sorted took 2.6s, unsorted took 52s.

And you can see why:

http://people.redhat.com/esandeen/sorted_unsorted.png

meanwhile I can ask Jim about coreutils & ls -l.

-Eric

> Best wishes
> 
> Norbert
