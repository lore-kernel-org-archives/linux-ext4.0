From: "George Spelvin" <linux@horizon.com>
Subject: Re: Exciting :-( adventures in metadata checksumming
Date: 3 Aug 2012 21:42:39 -0400
Message-ID: <20120804014239.14269.qmail@science.horizon.com>
References: <20120803234902.GA18757@thunk.org>
Cc: linux-ext4@vger.kernel.org
To: linux@horizon.com, tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from science.horizon.com ([71.41.210.146]:18470 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752676Ab2HDBmk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 3 Aug 2012 21:42:40 -0400
In-Reply-To: <20120803234902.GA18757@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> This is what I normally do when I build debian packages.  I normally
> will create a tarball using the gen-tarball script in the util
> directory (which is a generated file, so that means you need to run
> "configure ; sh -vx util/gen-tarball" if you are using a freshly
> checked out git tree.  In theory you should be able to do a debian
> build out of the git tree, but it's not what I normally do....

Thanks for the info.  That's what I tried.  I also used "git archive"
to make the tarball.

I'll try it your way.

Lesson 1: gen-tarball must be run from the "util" directory, because it
tars up ".."; if you run it from the git root as shown above, it tars
up entirely too much!

Anyway, it appeared to work, but halted with one of the same errors I
encountered before:

gcc -c -I. -I../lib -I/tmp/build/e2fsprogs-1.43/lib -D_FORTIFY_SOURCE=2 -g -O2 -fstack-protector --param=ssp-buffer-size=4 -Wformat -Wformat-security -D__NO_STRING_INLINES /tmp/build/e2fsprogs-1.43/e2fsck/sigcatcher.c -o sigcatcher.o
gcc -Wl,-Bsymbolic-functions -Wl,-z,relro -Wl,-rpath-link,../lib -rdynamic -o e2fsck dict.o unix.o e2fsck.o super.o pass1.o pass1b.o pass2.o pass3.o pass4.o pass5.o journal.o badblocks.o util.o dirinfo.o dx_dirinfo.o ehandler.o problem.o message.o quota.o recovery.o region.o revoke.o ea_refcount.o rehash.o profile.o prof_err.o logfile.o sigcatcher.o  ../lib/libquota.a ../lib/libext2fs.so ../lib/libcom_err.so  -lblkid    -luuid     ../lib/libe2p.so 
../lib/libcom_err.so: undefined reference to `sem_post'
../lib/libcom_err.so: undefined reference to `sem_wait'
../lib/libcom_err.so: undefined reference to `sem_init'
../lib/libcom_err.so: undefined reference to `sem_destroy'
collect2: error: ld returned 1 exit status
make[3]: *** [e2fsck] Error 1
make[3]: Leaving directory `/tmp/build/e2fsprogs-1.43/debian/BUILD-STD/e2fsck'
make[2]: *** [all-progs-recursive] Error 1
make[2]: Leaving directory `/tmp/build/e2fsprogs-1.43/debian/BUILD-STD'
make[1]: *** [all] Error 2
make[1]: Leaving directory `/tmp/build/e2fsprogs-1.43/debian/BUILD-STD'
make: *** [debian/stampdir/build-std-stamp] Error 2
dpkg-buildpackage: error: debian/rules build gave error exit status 2

> Hmm... I can't replicate the problem using a cleanly created file
> system, copying a huge number of files to it, and then enabling
> metadata_csum using tune2fs, and then running e2fsck -f on the device
> again.

The corruption was on a backuppc directory, so if you're so inclined,
do a lot of hard-linking with "cp -l" as well.

There are 3220155 names in the file system, but only 1.5M inodes:
Filesystem        Inodes   IUsed     IFree IUse% Mounted on
/dev/md0       152619008 1565807 151053201    2% /data

What I *now* just realized is that, had my brain been in gear,
I should have run e2image on the file system *before* repairing it
for real.  What would have been highly informative.

I'm very very sorry.

> The fact that you are were seeing multiple cases of file system
> corruption before you started using metadata_csum makes me very
> suspicious, though.  I'm not sure whether you have a hardware problem,
> or a bug in the md layer, or something else but the fact you were
> seeing what looks like metadata corruption problems even before
> turning on metadata_csum doesn't make it surprising that you might be
> having the checksum failures reported!

Yes, I'm not sure what's going on, either.  updatedb found the problems
as it traversed the FS, but it does that *every* night, and literally
Nothing Happened the night of the failure.

It's also an oddly patterned and elusive error, with bits being
cleared in the high byte of the magic number, and then reappearing
when e2fsck looks at them.

One part of me thinks it's *got* to be a RAM problem, but I'd think
parallel kernel compiles and "git fsck" would catch that.  I've alo been
running updatedb manually, since that's what triggered last time.
