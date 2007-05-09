From: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Subject: Re: 2.6.21-ext4-1
Date: Wed, 9 May 2007 20:06:13 +0530
Message-ID: <20070509143613.GA13375@amitarora.in.ibm.com>
References: <E1HiXab-0001QX-Sk@candygram.thunk.org> <1178571383.3933.8.camel@dyn9047017103.beaverton.ibm.com> <20070508025048.GC32602149@melbourne.sgi.com> <1178661957.4135.66.camel@dyn9047017103.beaverton.ibm.com> <20070508232449.GG85884050@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Mingming Cao <cmm@us.ibm.com>, "Theodore Ts'o" <tytso@mit.edu>,
	linux-ext4@vger.kernel.org,
	Johann Lombardi <johann.lombardi@bull.net>,
	linux-kernel@vger.kernel.org
To: David Chinner <dgc@sgi.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:38798 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755032AbXEIOgP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 9 May 2007 10:36:15 -0400
Content-Disposition: inline
In-Reply-To: <20070508232449.GG85884050@sgi.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, May 09, 2007 at 09:24:49AM +1000, David Chinner wrote:
> On Tue, May 08, 2007 at 03:05:56PM -0700, Mingming Cao wrote:
> > On Tue, 2007-05-08 at 12:50 +1000, David Chinner wrote:
> > > BTW, have you guys tested mmap writes into unwritten extents? ;)
> > > 
> > I am not sure, Amit, have you done some mmap write test into
> > uninitialized extents?
> > 
> > Sorry, I still not quite clear what's the mapped problem you are worry
> > about. Could you explain to me a bit more? thanks!
> 
> XFS needs a ->page_mkwrite() callout to correctly map pages that
> have been dirtied by mmap that span unwritten extents. mmap reads
> (i.e. when the fault first occurred) treat unwritten extents like
> holes and so we need to remap them when they are dirtied to set all
> the unwritten state in the bufferheads correctly for writeback.
> 
> See test 166 here:
> 
> http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfstests/
> http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfstests/src/unwritten_mmap.c

Hi David,

I updated the above testcase to use fallocate() and ran it on the
ext4 (with the fallocate patches applied).
It threw following message on console :

# ./a.out 2000 /home/test/mnt/testfile
BUG: at fs/buffer.c:1640 __block_write_full_page()
08c6fcd0:  [<080572a7>] dump_stack+0x1b/0x1d
08c6fce8:  [<080c0d07>] __block_write_full_page+0xc4/0x24a
08c6fd10:  [<080c21e0>] block_write_full_page+0xb0/0xb8
08c6fd40:  [<0810c6a3>] ext4_ordered_writepage+0xcb/0x139
08c6fd80:  [<08091ba8>] generic_writepages+0x178/0x2a0
08c6fdfc:  [<08091cfd>] do_writepages+0x2d/0x38
08c6fe10:  [<0808cea2>] __filemap_fdatawrite_range+0x62/0x6d
08c6fe88:  [<0808cec5>] filemap_fdatawrite+0x18/0x1d
08c6fea8:  [<080bf4bf>] do_fsync+0x26/0x67
08c6fec0:  [<080bf521>] __do_fsync+0x21/0x35
08c6fed8:  [<080bf542>] sys_fsync+0xd/0xf
08c6fee8:  [<08058cac>] handle_syscall+0x8c/0xa4
08c6ff64:  [<0806728a>] handle_trap+0xc1/0xc9
08c6ff80:  [<08067683>] userspace+0x123/0x166
08c6ffd8:  [<080589db>] fork_handler+0xa0/0xa2
08c6fffc:  [<a55a5a5a>] 0xa55a5a5a

This is coming from:
fs/buffer.c
   1628		if (block > last_block) {
   1629			..........
   ...			.........
   1639		} else if (!buffer_mapped(bh) && buffer_dirty(bh)) {
=> 1640			WARN_ON(bh->b_size != blocksize);
   1641			err = get_block(inode, block, bh, 1);
   1642			..........
   ...			.........
   1649		}

Thus, I think in ext4 also we may need to have ->page_mkwrite
implemented.

I came across a patch you had submitted couple of months back which
implemented a generic block_page_mkwrite() function, to which any file
system could hook easily. Here is the link:
http://lkml.org/lkml/2007/3/18/198

Any idea when is it going to be in the mainline ? Not sure if it is
already part of some -mm kernel, but I did not find it in 2.6.21.
Or, since there was a talk of ->fault() replacing ->page_mkwrite() the
patch is not in the pipeline now ?

And, how does XFS behave now if we write to mmapped preallocated blocks,
since XFS also doesn't have ->page_mkwrite() implemented as of date ?

Thanks!
--
Regards,
Amit Arora

> 
> The same behaviour is needed for delalloc extents to prevent ENOSPC
> errors on writeback - the mmap write needs to do the freespace
> accounting at the time the page is dirtied and that can only be done
> through the ->page_mkwrite callout. Otherwise ENOSPC will occur in
> the writeback path and that is a major pain....
> 
> This may not be a problem for ext4, but I thought I better point
> out a couple of the more subtle problems mmap can introduce....
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> Principal Engineer
> SGI Australian Software Group
> 
> 
> ---
>  xfstests/src/Makefile |    7 
>  xfstests/src/falloc.c |  376 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 381 insertions(+), 2 deletions(-)
> 
> Index: xfs-cmds/xfstests/src/falloc.c
> ===================================================================
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ xfs-cmds/xfstests/src/falloc.c	2007-04-30 12:41:13.862302450 +1000
> @@ -0,0 +1,376 @@
> +/*
> + * Copyright (c) 2000-2003,2007 Silicon Graphics, Inc.
> + * All Rights Reserved.
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it would be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write the Free Software Foundation,
> + * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> + */
> +
> +#include "global.h"
> +
> +/* should end up include somewhere */
> +#define FA_ALLOCATE	0x1
> +#define FA_DEALLOCATE	0x2
> +#define FA_PREALLOCATE	0x3
> +
> +/* ia64 */
> +#define __NR_fallocate 1305
> +/*
> + * Block I/O parameterization.  A basic block (BB) is the lowest size of
> + * filesystem allocation, and must equal 512.  Length units given to bio
> + * routines are in BB's.
> + */
> +
> +/* Assume that if we have BTOBB, then we have the rest */
> +#ifndef BTOBB
> +#define BBSHIFT         9
> +#define BBSIZE          (1<<BBSHIFT)
> +#define BBMASK          (BBSIZE-1)
> +#define BTOBB(bytes)    (((__u64)(bytes) + BBSIZE - 1) >> BBSHIFT)
> +#define BTOBBT(bytes)   ((__u64)(bytes) >> BBSHIFT)
> +#define BBTOB(bbs)      ((bbs) << BBSHIFT)
> +#define OFFTOBBT(bytes) ((__u64)(bytes) >> BBSHIFT)
> +
> +#define SEEKLIMIT32     0x7fffffff
> +#define BBSEEKLIMIT32   BTOBBT(SEEKLIMIT32)
> +#define SEEKLIMIT       0x7fffffffffffffffLL
> +#define BBSEEKLIMIT     OFFTOBBT(SEEKLIMIT)
> +#endif
> +
> +#ifndef OFFTOBB
> +#define OFFTOBB(bytes)  (((__u64)(bytes) + BBSIZE - 1) >> BBSHIFT)
> +#define BBTOOFF(bbs)    ((__u64)(bbs) << BBSHIFT)
> +#endif
> +
> +#define	FSBTOBB(f)	(OFFTOBBT(FSBTOOFF(f)))
> +#define	BBTOFSB(b)	(OFFTOFSB(BBTOOFF(b)))
> +#define	OFFTOFSB(o)	((o) / blocksize)
> +#define	FSBTOOFF(f)	((f) * blocksize)
> +
> +void usage(void)
> +{
> +    printf("usage: alloc [-b blocksize] [-d dir] [-f file] [-n] [-r] [-t]\n"
> +           "flags:\n"
> +           "    -n - non-interractive mode\n"
> +           "    -r - real time file\n"
> +           "    -t - truncate on open\n"
> +           "\n"
> +           "commands:\n"
> +           "    a   [offset] [length] - alloc\n"
> +           "    p   [offset] [length] - prealloc\n"
> +           "    f   [offset] [length] - free\n"
> +           "    m   [offset] [length] - print map\n"
> +           "    s                     - sync file\n"
> +           "    t   [offset]          - truncate\n"
> +           "    q                     - quit\n"
> +           "    h/?                   - this help\n");
> +
> +}
> +
> +int		fd = -1;
> +int		blocksize;
> +char		*filename;
> +
> +/* params are in bytes */
> +void map(off64_t off, off64_t len)
> +{
> +    struct getbmap	bm[2];
> +
> +    bzero(bm, sizeof(bm));
> +
> +    bm[0].bmv_count = 2;
> +    bm[0].bmv_offset = OFFTOBB(off);
> +    if (len==(off64_t)-1) { /* unsigned... */
> +        bm[0].bmv_length = -1;
> +        printf("    MAP off=%lld, len=%lld [%lld-]\n",
> +                (long long)off, (long long)len,
> +                (long long)BBTOFSB(bm[0].bmv_offset));
> +    } else {
> +        bm[0].bmv_length = OFFTOBB(len);
> +        printf("    MAP off=%lld, len=%lld [%lld,%lld]\n",
> +                (long long)off, (long long)len,
> +                (long long)BBTOFSB(bm[0].bmv_offset),
> +                (long long)BBTOFSB(bm[0].bmv_length));
> +    }
> +
> +    printf("        [ofs,count]: start..end\n");
> +    for (;;) {
> +#ifdef XFS_IOC_GETBMAP
> +	    if (xfsctl(filename, fd, XFS_IOC_GETBMAP, bm) < 0) {
> +#else
> +#ifdef F_GETBMAP
> +	    if (fcntl(fd, F_GETBMAP, bm) < 0) {
> +#else
> +bozo!
> +#endif
> +#endif
> +		    perror("getbmap");
> +		    break;
> +	    }
> +
> +	    if (bm[0].bmv_entries == 0)
> +		    break;
> +
> +	    printf("        [%lld,%lld]: ",
> +		    (long long)BBTOFSB(bm[1].bmv_offset),
> +		    (long long)BBTOFSB(bm[1].bmv_length));
> +
> +	    if (bm[1].bmv_block == -1)
> +		    printf("hole");
> +	    else
> +		    printf("%lld..%lld",
> +			    (long long)BBTOFSB(bm[1].bmv_block),
> +			    (long long)BBTOFSB(bm[1].bmv_block +
> +				    bm[1].bmv_length - 1));
> +	    printf("\n");
> +    }
> +}
> +
> +int
> +main(int argc, char **argv)
> +{
> +	int		c;
> +	char		*dirname = NULL;
> +	int		done = 0;
> +	int		status = 0;
> +	struct flock64	f;
> +	off64_t		len;
> +	char		line[1024];
> +	off64_t		off;
> +	int		oflags;
> +	static char	*opnames[] = { "alloc",
> +				       "prealloc",
> +				       "free" };
> +	int		opno;
> +	static int	optab[] = { FA_ALLOCATE,
> +				    FA_PREALLOCATE,
> +				    FA_DEALLOCATE };
> +	int		rflag = 0;
> +	struct statvfs64	svfs;
> +	int		tflag = 0;
> +        int             nflag = 0;
> +	int		unlinkit = 0;
> +	__int64_t	v;
> +
> +	while ((c = getopt(argc, argv, "b:d:f:rtn")) != -1) {
> +		switch (c) {
> +		case 'b':
> +			blocksize = atoi(optarg);
> +			break;
> +		case 'd':
> +			if (filename) {
> +				printf("can't specify both -d and -f\n");
> +				exit(1);
> +			}
> +			dirname = optarg;
> +			break;
> +		case 'f':
> +			if (dirname) {
> +				printf("can't specify both -d and -f\n");
> +				exit(1);
> +			}
> +			filename = optarg;
> +			break;
> +		case 'r':
> +			rflag = 1;
> +			break;
> +		case 't':
> +			tflag = 1;
> +			break;
> +		case 'n':
> +                        nflag++;
> +                        break;
> +		default:
> +			printf("unknown option\n");
> +                        usage();
> +			exit(1);
> +		}
> +	}
> +	if (!dirname && !filename)
> +		dirname = ".";
> +	if (!filename) {
> +		static char	tmpfile[] = "allocXXXXXX";
> +
> +		mkstemp(tmpfile);
> +		filename = malloc(strlen(tmpfile) + strlen(dirname) + 2);
> +		sprintf(filename, "%s/%s", dirname, tmpfile);
> +		unlinkit = 1;
> +	}
> +	oflags = O_RDWR | O_CREAT | (tflag ? O_TRUNC : 0);
> +	fd = open(filename, oflags, 0666);
> +        if (!nflag) {
> +            printf("alloc:\n");
> +	    printf("    filename %s\n", filename);
> +        }
> +	if (fd < 0) {
> +		perror(filename);
> +		exit(1);
> +	}
> +	if (!blocksize) {
> +		if (fstatvfs64(fd, &svfs) < 0) {
> +			perror(filename);
> +			status = 1;
> +			goto done;
> +		}
> +		blocksize = (int)svfs.f_bsize;
> +	}
> +	if (blocksize<0) {
> +		fprintf(stderr,"illegal blocksize %d\n", blocksize);
> +		status = 1;
> +		goto done;
> +	}
> +	printf("    blocksize %d\n", blocksize);
> +	if (rflag) {
> +		struct fsxattr a;
> +
> +#ifdef XFS_IOC_FSGETXATTR
> +		if (xfsctl(filename, fd, XFS_IOC_FSGETXATTR, &a) < 0) {
> +			perror("XFS_IOC_FSGETXATTR");
> +			status = 1;
> +			goto done;
> +		}
> +#else
> +#ifdef F_FSGETXATTR
> +		if (fcntl(fd, F_FSGETXATTR, &a) < 0) {
> +			perror("F_FSGETXATTR");
> +			status = 1;
> +			goto done;
> +		}
> +#else
> +bozo!
> +#endif
> +#endif
> +
> +		a.fsx_xflags |= XFS_XFLAG_REALTIME;
> +
> +#ifdef XFS_IOC_FSSETXATTR
> +		if (xfsctl(filename, fd, XFS_IOC_FSSETXATTR, &a) < 0) {
> +			perror("XFS_IOC_FSSETXATTR");
> +			status = 1;
> +			goto done;
> +		}
> +#else
> +#ifdef F_FSSETXATTR
> +		if (fcntl(fd, F_FSSETXATTR, &a) < 0) {
> +			perror("F_FSSETXATTR");
> +			status = 1;
> +			goto done;
> +		}
> +#else
> +bozo!
> +#endif
> +#endif
> +	}
> +	while (!done) {
> +                char *p;
> +
> +                if (!nflag) printf("alloc> ");
> +                fflush(stdout);
> +                if (!fgets(line, 1024, stdin)) break;
> +
> +                p=line+strlen(line);
> +                if (p!=line&&p[-1]=='\n') p[-1]=0;
> +
> +		opno = 0;
> +		switch (line[0]) {
> +		case 'f':
> +			opno++;
> +		case 'p':
> +			opno++;
> +		case 'a':
> +			v = strtoll(&line[2], &p, 0);
> +			if (*p == 'b') {
> +				off = FSBTOOFF(v);
> +				p++;
> +			} else
> +				off = v;
> +			if (*p == '\0')
> +				v = -1;
> +			else
> +				v = strtoll(p, &p, 0);
> +			if (*p == 'b') {
> +				len = FSBTOOFF(v);
> +				p++;
> +			} else
> +				len = v;
> +
> +                        printf("    CMD %s, off=%lld, len=%lld\n",
> +                                opnames[opno], (long long)off, (long long)len);
> +
> +			c = syscall(__NR_fallocate, fd, optab[opno], off, len);
> +
> +			if (c < 0) {
> +				perror(opnames[opno]);
> +				break;
> +			}
> +
> +                        map(off,len);
> +			break;
> +		case 'm':
> +			p = &line[1];
> +			v = strtoll(p, &p, 0);
> +			if (*p == 'b') {
> +				off = FSBTOOFF(v);
> +				p++;
> +			} else
> +				off = v;
> +			if (*p == '\0')
> +				len = -1;
> +			else {
> +				v = strtoll(p, &p, 0);
> +				if (*p == 'b')
> +					len = FSBTOOFF(v);
> +				else
> +					len = v;
> +			}
> +                        map(off,len);
> +			break;
> +		case 't':
> +			p = &line[1];
> +			v = strtoll(p, &p, 0);
> +			if (*p == 'b')
> +				off = FSBTOOFF(v);
> +			else
> +				off = v;
> +                        printf("    TRUNCATE off=%lld\n", (long long)off);
> +			if (ftruncate64(fd, off) < 0) {
> +				perror("ftruncate");
> +				break;
> +			}
> +			break;
> +                case 's':
> +                        printf("    SYNC\n");
> +                        fsync(fd);
> +                        break;
> +		case 'q':
> +                        printf("    QUIT\n");
> +			done = 1;
> +			break;
> +                case '?':
> +                case 'h':
> +                        usage();
> +                        break;
> +		default:
> +			printf("unknown command '%s'\n", line);
> +			break;
> +		}
> +	}
> +	if (!nflag) printf("\n");
> +done:
> +	if (fd != -1)
> +		close(fd);
> +	if (unlinkit)
> +		unlink(filename);
> +	exit(status);
> +	/* NOTREACHED */
> +}
> Index: xfs-cmds/xfstests/src/Makefile
> ===================================================================
> --- xfs-cmds.orig/xfstests/src/Makefile	2007-04-23 16:22:06.000000000 +1000
> +++ xfs-cmds/xfstests/src/Makefile	2007-04-30 12:18:42.126750949 +1000
> @@ -14,7 +14,7 @@ TARGETS = dirstress fill fill2 getpagesi
> 
>  LINUX_TARGETS = loggen xfsctl bstat t_mtab getdevicesize \
>  	preallo_rw_pattern_reader preallo_rw_pattern_writer ftrunc trunc \
> -	fs_perms testx looptest locktest unwritten_mmap
> +	fs_perms testx looptest locktest unwritten_mmap falloc
> 
>  IRIX_TARGETS = open_unlink
> 
> @@ -98,7 +98,10 @@ trunc: trunc.o
> 
>  fs_perms: fs_perms.o
>  	$(LINKTEST)
> -	
> +
> +falloc: falloc.o
> +	$(LINKTEST)
> +
>  testx: testx.o
>  	$(LINKTEST)
