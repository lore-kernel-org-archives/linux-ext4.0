From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: duplicate entries on ext3 when using readdir/readdir64
Date: Wed, 6 Aug 2008 10:07:23 -0400
Message-ID: <20080806140722.GA14109@mit.edu>
References: <1217583820.12454.20.camel@kannnix.a2x.lan.at> <20080801121658.GG8736@mit.edu> <1217933631.14552.45.camel@kannnix.a2x.lan.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>,
	ext3-users <ext3-users@redhat.com>, linux-ext4@vger.kernel.org
To: Thomas Trauner <tt@it-austria.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:58214 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756714AbYHFOLU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 6 Aug 2008 10:11:20 -0400
Content-Disposition: inline
In-Reply-To: <1217933631.14552.45.camel@kannnix.a2x.lan.at>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Aug 05, 2008 at 12:53:51PM +0200, Thomas Trauner wrote:
> On Fri, 2008-08-01 at 08:16 -0400, Theodore Tso wrote:
> > On Fri, Aug 01, 2008 at 11:43:40AM +0200, Thomas Trauner wrote:
> > > 
> > > I have a problem with directories that contain more than 10000 entries
> > > (Ubuntu 8.04.1) or with more than 70000 entries (RHEL 5.2). If you use
> > > readdir(3) or readdir64(3) you get one entry twice, with same name and
> > > inode.
> > > 
> I made new tests with the code under
> <http://www.unet.univie.ac.at/~a9100884/readdir.c> on a bunch of freshly
> generated and empty filesystems, every about 38GB large, of type fat
> (aborted after about 22000 entries because it took to long), ext2, xfs,
> jfs and again ext3....

OK, I have a workaroud for you.  It appears there's a kernel bug
hiding here, since there shouldn't be duplicates returned by readdir()
even if we have hash collisions.  

It turns out though that the TEA hash we are currently using as the
default is a really sucky hash.  I can't remember who suggested it; I
may go looking in the archives just out of curiosity.  My fault,
though, I should have tested it much more thoroughly, although it
*looked* good, and it was take from the core of an encryption
algorithm, so I thought it would be OK.

The claim was that it was just as good for our purposes as the
cut-down md4 hash we were using, but it was faster (so it would burn
less cpu cycles).  Unfortunately, (a) at least on modern hardware (I
tested on an X61s laptop) the TEA hash is in fact a little slower, and
(b) for small filenames with small hamming distances between them,,
such as what you are using in your test, it's generating lots of
collisions.

Anyway, the workaround is as follows:

debugfs -w /dev/sdXXX
debugfs: set_super_value def_hash_version half_md4
debugfs: quit

Then completely delete any directories where you were having problems,
and recreate them.  (You can do the "mkdir foo.new; mv foo/* foo.new;
rmdir foo; mv foo.new foo" trick if you want to preserve the files in
that directory.)

In any case, here's the test case which shows the hash collision
problem much more quickly.  You can also use it for benchmarks, like
so:

time tst_hash -q -a tea -n 3000000
time tst_hash -q -a half_md4 -n 3000000

With the following options, we can also see with the right filename
lengths, the tea algorithm doesn't create any hash collisions, so
maybe whoever tested the algorithm before they suggested it just got
unlucky with the set of filenames that he/she chose:

   tst_hash -p 0000 -a tea -n 3000000

In any case, unless someone comes up with a really good reason, I
probably will change the default hash algorithm for mke2fs to
half_md4, since it is both faster and a better hash function.


This doesn't change the fact that the kernel should do the right thing
with hash collisions, at least in the simple case without
telldir/seekdir.  When I merged the htree code I had tested it with
the Douglas Adams hash (always returns a hash value of
0x00000042:0000000 no matter what its inputs), and it did the right
thing, so we must have regressed somewhere along the line...

    	  	       	    	 	   - Ted

/*
 * tst_htree.c
 *
 * Copyright (C) 2008 by Theodore Ts'o.
 *
 * This file may be redistributed under the terms of the GNU Public
 * License, Version 2
 * 
 * Compile command:
 *	cc -g -O2 -o tst_hash tst_hash.c -lext2fs -lcom_err -luuid -le2p
 */

#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>
#include <time.h>
#include <errno.h>
#include <sys/types.h>
#include <getopt.h>

#include "ext2fs/ext2fs.h"
#include "uuid/uuid.h"
#include "et/com_err.h"

#define SEED "87fd5d61-4612-4147-8bf5-a21948e7e909"

struct hash {
	int num;
	ext2_dirhash_t hash, minor_hash;
};

static EXT2_QSORT_TYPE hash_cmp(const void *a, const void *b)
{
	const struct hash *db_a =
		(const struct hash *) a;
	const struct hash *db_b =
		(const struct hash *) b;

	if (db_a->hash != db_b->hash)
		return (int) (db_a->hash - db_b->hash);
	
	return (int) (db_a->minor_hash - db_b->minor_hash);
}

main(int argc, char **argv)
{
	errcode_t errcode;
	ext2_dirhash_t	hash, minor_hash;
	int hash_alg = EXT2_HASH_TEA;
	char name[200], *tmp, prefix[100];
	unsigned char uuid[16];
	int thislen, i, c, quiet = 0, num_hashes = 300000;
	struct hash *hash_array;

	uuid_parse(SEED, uuid);
	prefix[0] = 0;

	while ((c = getopt(argc, argv, "s:a:n:qp:")) != EOF)
		switch (c) {
		case 's':
			uuid_parse(optarg, uuid);
			break;
		case 'a':
			hash_alg = e2p_string2hash(optarg);
			if (hash_alg < 0) {
				fprintf(stderr, "Invalid hash algorithm: %s\n",
					optarg);
				exit(1);
			}
			break;
		case 'n':
			num_hashes = strtoul (optarg, &tmp, 0);
			if (*tmp) {
				com_err (argv[0], 0, "count - %s", optarg);
				exit(1);
			}
			break;
		case 'p':
			if (strlen(optarg)+1 > sizeof(prefix)) {
				fprintf(stderr, "%s: prefix too large!\n",
					argv[0]);
				exit(1);
			}
			strcpy(prefix, optarg);
			break;
		case 'q':
			quiet = 1;
			break;
		default:
			fprintf(stderr, "Usage: %s [-q] [-s hash_seed] "
				"[-a hash_alg] [-n num_hashes]\n", argv[0]);
			exit(1);
		}

	hash_array = malloc(num_hashes * sizeof(struct hash));
	if (hash_array == NULL) {
		fprintf(stderr, "Couldn't allocate hash_array\n");
		exit(1);
	}
	
	for (i=0; i < num_hashes; i++) {
		sprintf(name, "%s%d", prefix, i);
	
		errcode = ext2fs_dirhash(hash_alg, name, strlen(name),
					 (__u32 *) uuid, 
					 &hash_array[i].hash,
					 &hash_array[i].minor_hash);
		if (errcode) {
			com_err("ext2fs_dirhash", errcode, 
				"while trying to hash '%s'", name);
			exit(1);
		}
		hash_array[i].num = i;
	}

	qsort(hash_array, (size_t) num_hashes, sizeof(struct hash), hash_cmp);

	for (c=0,i=0; i < num_hashes-1; i++) {
		if ((hash_array[i].hash == hash_array[i+1].hash) &&
		    (hash_array[i].minor_hash == hash_array[i+1].minor_hash)) {
			c++;
			if (quiet)
				continue;
			printf("hash collision: %d, %d: %08x:%08x\n", 
			       hash_array[i].num, hash_array[i+1].num,
			       hash_array[i].hash, hash_array[i].minor_hash);
		}
	}
	printf("%d collisions\n", c);

	exit(0);
}




